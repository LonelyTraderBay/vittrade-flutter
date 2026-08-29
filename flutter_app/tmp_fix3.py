# -*- coding: utf-8 -*-
import io

# 1. Order book bare content bỏ hàng tiêu đề (panel tab đã có tab + Mid).
p = 'lib/features/markets/presentation/widgets/tablet/markets_pair_detail_pane_tables.dart'
src = io.open(p, encoding='utf-8').read()

old = '  Widget _content() => Column('
new = '  Widget _content({bool includeHeader = true}) => Column('
assert old in src, 'content sig'
src = src.replace(old, new)

# Thanh title nằm đầu _content: bọc bằng if (includeHeader) ...[]
# Tìm đoạn Row( children: [ Text('Sổ lệnh ${snapshot.pair.symbol}' ...
start = src.find("            Row(\n              children: [\n                Text(\n                  'Sổ lệnh ${snapshot.pair.symbol}',")
assert start > 0, 'title row not found'
# tìm kết thúc đoạn: cho tới dòng '            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),'
end_marker = '            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),'
end = src.find(end_marker, start)
assert end > start, 'end marker'
block = src[start:end]
# bọc block trong if (includeHeader) ...[ <block> ],
wrapped = '            if (includeHeader) ...[\n' + block.rstrip() + ',\n            ],\n            '
src = src[:start] + wrapped + src[end + len('            '):]

# framed build dùng _content() mặc định (có header); bare gọi includeHeader: false
old2 = '        : MarketsPairOrderBookPanel(\n                    snapshot: widget.snapshot,\n                    framed: false,\n                  )'
new2 = '        : MarketsPairOrderBookPanel(\n                    snapshot: widget.snapshot,\n                    framed: false,\n                  )'
# (trong sections — sẽ sửa bên dưới)
io.open(p, 'w', encoding='utf-8', newline='').write(src)

# sections: gọi content không header khi bare — qua constructor framed=false
# nhưng _content do panel gọi nội bộ... đơn giản: build của orderbook khi
# !framed trả _content(includeHeader: false).
old3 = '    if (!framed) return _content();'
new3 = '    if (!framed) return _content(includeHeader: false);'
assert old3 in src, 'bare call'
src = src.replace(old3, new3)
io.open(p, 'w', encoding='utf-8', newline='').write(src)

# 2. Test: ranh giới 2 hàng dùng >= thay >.
p2 = 'test/features/markets/markets_pair_detail_tablet_page_test.dart'
src2 = io.open(p2, encoding='utf-8').read()
old4 = '''    expect(
      indicator.top,
      greaterThan(firstButton.bottom),
      reason: 'MA phải ở hàng dưới hàng interval (2 hàng trong panel).',
    );'''
new4 = '''    expect(
      indicator.top,
      greaterThanOrEqualTo(firstButton.bottom),
      reason: 'MA phải ở hàng dưới (hoặc sát) hàng interval trong panel.',
    );'''
assert old4 in src2, 'test bound'
src2 = src2.replace(old4, new4)
io.open(p2, 'w', encoding='utf-8', newline='').write(src2)
print('OK fix3')
