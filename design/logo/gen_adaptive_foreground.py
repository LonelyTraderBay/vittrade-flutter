"""Generate adaptive-icon foreground PNG cho VitTrade (concept C — Chart V).

Vẽ lại mark cùng tọa độ với `vittrade_adaptive_foreground.svg`:
transform T(p) = 0.62*p + (178.4, 214.4) — thu mark về safe-zone 66dp/108dp
của Android adaptive icon, nền trong suốt, bỏ glow (vô hình ở size launcher).
Chống alias bằng supersample 4x rồi xuống mẫu LANCZOS.

Chạy:  python design/logo/gen_adaptive_foreground.py
Ra:    flutter_app/assets/brand/app_icon_foreground.png (1024x1024 RGBA)
"""
from PIL import Image, ImageDraw

SS = 4  # supersample
OUT_SIZE = 1024
SCALE = 0.62
DX, DY = 178.4, 214.4

AMBER = (0xE5, 0x8A, 0x00, 0xFF)
AMBER_SOFT = (0xF5, 0xA5, 0x24, 0xFF)
GREEN = (0x10, 0xB9, 0x81, 0xFF)
BASELINE = (0x66, 0x70, 0x85, 140)  # opacity 55%


def tx(p):
    return ((p[0] * SCALE + DX) * SS, (p[1] * SCALE + DY) * SS)


def stroke_w(w):
    return max(1, round(w * SCALE * SS))


def draw_round_line(draw, a, b, width, fill):
    a, b = tx(a), tx(b)
    draw.line([a, b], fill=fill, width=width)
    r = width / 2
    for p in (a, b):
        draw.ellipse([p[0] - r, p[1] - r, p[0] + r, p[1] + r], fill=fill)


def main():
    img = Image.new("RGBA", (OUT_SIZE * SS, OUT_SIZE * SS), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)

    draw_round_line(d, (736, 350), (824, 350), stroke_w(10), BASELINE)
    draw_round_line(d, (512, 610), (512, 838), stroke_w(34), AMBER)
    draw_round_line(d, (268, 350), (512, 720), stroke_w(98), AMBER)
    draw_round_line(d, (512, 720), (756, 256), stroke_w(98), AMBER_SOFT)

    cx, cy = tx((811, 151))
    r = 46 * SCALE * SS
    d.ellipse([cx - r, cy - r, cx + r, cy + r], fill=GREEN)

    img = img.resize((OUT_SIZE, OUT_SIZE), Image.LANCZOS)
    img.save("../../flutter_app/assets/brand/app_icon_foreground.png")

    # Spot-check vài pixel đặc trưng.
    checks = {
        "dot": ((681, 308), GREEN[:3]),
        "up_stroke": ((571, 517), AMBER_SOFT[:3]),
        "wick": ((495, 710), AMBER[:3]),
        "corner_transparent": ((10, 10), (0, 0, 0)),
    }
    for name, ((x, y), expect) in checks.items():
        px = img.getpixel((x, y))
        alpha_zero = name == "corner_transparent"
        ok = px[3] == 0 if alpha_zero else px[:3] == expect
        print(f"{name:20s} px={px} expect~{expect} -> {'OK' if ok else 'SAI'}")


if __name__ == "__main__":
    main()
