#!/usr/bin/env python3
"""Export VitTrade screen redesign checklist (CSV + Markdown)."""

from __future__ import annotations

import csv
import os
import re
from collections import defaultdict
from datetime import date
from pathlib import Path


def find_app_root() -> Path:
    here = Path(__file__).resolve().parent.parent
    if (here / "lib/app/router/route_groups").is_dir():
        return here
    raise SystemExit("Run from flutter_app/ context")


def module_for_sc(sc_name: str) -> str:
    m = re.match(r"sc(\d+)", sc_name)
    num = int(m.group(1)) if m else 0
    if num <= 6:
        return "auth"
    if num == 7:
        return "home"
    if 8 <= num <= 26:
        return "markets"
    if 27 <= num <= 43:
        return "predictions"
    if num in (44, 45, 46):
        return "markets"
    if num == 47:
        return "news"
    if 48 <= num <= 134:
        return "trade"
    if 135 <= num <= 155:
        return "wallet"
    if 156 <= num <= 168:
        return "profile"
    if 169 <= num <= 179 or num in (408, 409):
        return "dca"
    if num in (180, 181, 182, 183, 410):
        return "admin"
    if 184 <= num <= 209:
        return "arena"
    if 210 <= num <= 282 or num in (402, 403, 404, 407):
        return "p2p"
    if 283 <= num <= 285:
        return "discovery"
    if 286 <= num <= 290:
        return "referral"
    if num == 291:
        return "notifications"
    if 292 <= num <= 294:
        return "support"
    if 295 <= num <= 318:
        return "launchpad"
    if num == 319:
        return "rewards"
    if num == 320:
        return "enterprise_states"
    if 321 <= num <= 324:
        return "cross_module"
    if num in (325, 326, 398, 399, 400, 401):
        return "dev"
    if num == 397:
        return "onboarding"
    if 327 <= num <= 396:
        return "earn"
    if num in (405, 406, 413):
        return "profile"
    if num in (411, 412, 414, 415, 416):
        return "trade"
    return "other"


def sc_sort_key(sc_name: str) -> int:
    m = re.match(r"sc(\d+)", sc_name)
    return int(m.group(1)) if m else 9999


def build_widget_to_page(app_root: Path) -> dict[str, str]:
    widget_to_file: dict[str, str] = {}
    features = app_root / "lib/features"
    for mod_dir in features.iterdir():
        if not mod_dir.is_dir():
            continue
        pages_dir = mod_dir / "presentation/pages"
        if not pages_dir.is_dir():
            continue
        for dart_file in pages_dir.glob("*.dart"):
            rel = dart_file.relative_to(app_root).as_posix()
            text = dart_file.read_text(encoding="utf-8", errors="ignore")
            for pattern in (
                r"class\s+(\w+)\s+extends\s+(?:Stateless|Stateful)Widget",
                r"class\s+(\w+)\s+extends\s+ConsumerWidget",
                r"class\s+(\w+)\s+extends\s+ConsumerStatefulWidget",
            ):
                for match in re.finditer(pattern, text):
                    widget_to_file.setdefault(match.group(1), rel)
    return widget_to_file


def find_balanced_end(text: str, open_paren_index: int) -> int:
    depth = 0
    in_single = False
    in_double = False
    escaping = False
    for i in range(open_paren_index, len(text)):
        char = text[i]
        if escaping:
            escaping = False
            continue
        if (in_single or in_double) and char == "\\":
            escaping = True
            continue
        if not in_double and char == "'":
            in_single = not in_single
            continue
        if not in_single and char == '"':
            in_double = not in_double
            continue
        if in_single or in_double:
            continue
        if char == "(":
            depth += 1
        elif char == ")":
            depth -= 1
            if depth == 0:
                return i
    return -1


def classify_route(block: str) -> str:
    if "redirect:" in block:
        return "redirect_alias"
    if "_BottomNavRouteSkeleton" in block:
        return "skeleton"
    if "_UnportedRoutePlaceholder" in block:
        return "placeholder"
    return "real_page"


def extract_widget(block: str) -> str:
    child_match = re.search(
        r"child:\s*(?:const\s+)?([A-Za-z_]\w*)\s*\(", block
    )
    if child_match:
        return child_match.group(1)
    match = re.search(r"=>\s*(?:const\s+)?([A-Za-z_]\w*)\s*\(", block)
    if match:
        return match.group(1)
    match = re.search(r"return\s+([A-Za-z_]\w*)\s*\(", block)
    return match.group(1) if match else ""


MANUAL_OVERRIDES: dict[str, dict[str, str]] = {
    "sc003Otp": {
        "page_file": "lib/features/auth/presentation/phone/pages/otp_page.dart",
        "widget_class": "OtpPage",
    },
    "sc196ArenaPoints": {
        "page_file": "lib/features/arena/presentation/pages/arena_points_page.dart",
        "route_path": "/rewards?tab=arena (embedded; no standalone GoRoute)",
        "widget_class": "ArenaPointsPage",
        "classification": "embedded_bridge",
        "route_file": "lib/app/feature_bridges/rewards_arena_points_bridge.dart",
    },
    "sc412TradeCopyRegulatoryDisclosuresAlias": {
        "page_file": "lib/features/trade/presentation/pages/regulatory_disclosures_page.dart",
        "route_path": "/trade/copy-trading/regulatory-disclosures-alias → /trade/copy-trading/regulatory-disclosures",
        "widget_class": "RegulatoryDisclosuresPage",
        "classification": "redirect_alias",
    },
}


def parse_route_groups(app_root: Path) -> list[dict[str, str]]:
    route_dir = app_root / "lib/app/router/route_groups"
    routes: list[dict[str, str]] = []
    for dart_file in sorted(route_dir.glob("*.dart")):
        text = dart_file.read_text(encoding="utf-8")
        rel_file = dart_file.relative_to(app_root).as_posix()
        index = 0
        while True:
            start = text.find("GoRoute(", index)
            if start == -1:
                break
            end = find_balanced_end(text, start + len("GoRoute"))
            if end == -1:
                break
            block = text[start : end + 1]
            index = end + 1
            if re.search(r"path:\s*path\b", block):
                continue
            name_match = re.search(r"name:\s*AppRouteNames\.(\w+)", block)
            if not name_match:
                continue
            path_match = re.search(r"path:\s*([^,\n]+)", block)
            routes.append(
                {
                    "sc_id": name_match.group(1),
                    "route_path": path_match.group(1).strip() if path_match else "-",
                    "widget_class": extract_widget(block),
                    "route_file": rel_file,
                    "classification": classify_route(block),
                }
            )
    return routes


def _route_path_sources(app_root: Path) -> str:
    # ARCH-A3: literal path song trong route_groups/<feature>_route_ids.dart;
    # facade app_route_paths.dart chi con alias (khong quoted). Doc concat
    # facade + moi id file, sort theo POSIX path de on dinh cross-OS.
    parts = [(app_root / "lib/app/router/app_route_paths.dart").read_text(encoding="utf-8")]
    groups = app_root / "lib/app/router/route_groups"
    id_files = sorted(
        (f for f in groups.glob("*_route_ids.dart")),
        key=lambda f: f.as_posix(),
    )
    parts.extend(f.read_text(encoding="utf-8") for f in id_files)
    return "\n".join(parts)


def resolve_path(route_path: str, app_root: Path) -> str:
    if route_path.startswith("AppRoutePaths."):
        const_name = route_path.removeprefix("AppRoutePaths.")
        text = _route_path_sources(app_root)
        match = re.search(
            rf"static const String {re.escape(const_name)}\s*=\s*'([^']*)'",
            text,
        )
        if match:
            return match.group(1)
        match = re.search(
            rf"static String {re.escape(const_name)}\(",
            text,
        )
        if match:
            return f"AppRoutePaths.{const_name}(...)"
        return route_path
    return route_path.strip("'\"")


def load_all_sc_ids(app_root: Path) -> list[str]:
    # ARCH-A3: scNNN name gio song trong route_groups/<feature>_route_ids.dart;
    # facade van giu alias cung ten nen doc facade la du — nhung doc ca id
    # files de khong phu thuoc facade ton tai mai. Dedup giu thu tu.
    text = (app_root / "lib/app/router/app_route_names.dart").read_text(encoding="utf-8")
    groups = app_root / "lib/app/router/route_groups"
    for f in sorted(groups.glob("*_route_ids.dart"), key=lambda f: f.as_posix()):
        text += "\n" + f.read_text(encoding="utf-8")
    seen: set[str] = set()
    out: list[str] = []
    for name in re.findall(r"static const String (sc\d+\w+)", text):
        if name not in seen:
            seen.add(name)
            out.append(name)
    return out


def main() -> None:
    app_root = find_app_root()
    repo_root = app_root.parent
    out_dir = repo_root / "docs/_archive/2026-redesign-v2.5/redesign"
    out_dir.mkdir(parents=True, exist_ok=True)
    csv_path = out_dir / "VitTrade-Screen-Redesign-Checklist.csv"
    md_path = out_dir / "VitTrade-Screen-Redesign-Checklist.md"

    widget_to_page = build_widget_to_page(app_root)
    parsed_routes = parse_route_groups(app_root)
    by_sc = {r["sc_id"]: r for r in parsed_routes}
    all_sc_ids = load_all_sc_ids(app_root)

    rows: list[dict[str, str]] = []
    for sc_id in sorted(all_sc_ids, key=sc_sort_key):
        route = by_sc.get(sc_id, {})
        module = module_for_sc(sc_id)
        widget = route.get("widget_class", "")
        page_file = widget_to_page.get(widget, "")
        if not page_file and widget:
            # fallback: search by class name anywhere under features
            for dart_file in (app_root / "lib/features").rglob("*.dart"):
                if widget in dart_file.read_text(encoding="utf-8", errors="ignore"):
                    page_file = dart_file.relative_to(app_root).as_posix()
                    break
        route_path = resolve_path(route.get("route_path", "-"), app_root)
        row = {
            "sc_id": sc_id,
            "module": module,
            "page_file": page_file or "-",
            "route_path": route_path,
            "widget_class": widget or "-",
            "classification": route.get("classification", "missing_route"),
            "route_file": route.get("route_file", "-"),
        }
        override = MANUAL_OVERRIDES.get(sc_id)
        if override:
            row.update(override)
        rows.append(row)

    today = date.today().isoformat()
    with csv_path.open("w", newline="", encoding="utf-8-sig") as handle:
        writer = csv.DictWriter(
            handle,
            fieldnames=[
                "sc_id",
                "module",
                "page_file",
                "route_path",
                "widget_class",
                "classification",
                "route_file",
            ],
        )
        writer.writeheader()
        writer.writerows(rows)

    by_module: dict[str, list[dict[str, str]]] = defaultdict(list)
    for row in rows:
        by_module[row["module"]].append(row)

    lines = [
        "# VitTrade Screen Redesign Checklist",
        "",
        f"Generated: {today}",
        "",
        "Full inventory of registered screens for UI redesign tracking.",
        "",
        "| Metric | Value |",
        "| --- | ---: |",
        f"| Total screens (`sc*`) | {len(rows)} |",
        f"| Modules | {len(by_module)} |",
        f"| With page file mapped | {sum(1 for r in rows if r['page_file'] != '-')} |",
        f"| Missing router entry | {sum(1 for r in rows if r['classification'] == 'missing_route')} |",
        "",
        "Sources:",
        "- `flutter_app/lib/app/router/app_route_names.dart`",
        "- `flutter_app/lib/app/router/route_groups/*.dart`",
        "- `flutter_app/lib/features/*/presentation/pages/*.dart`",
        "",
        "CSV companion: [`VitTrade-Screen-Redesign-Checklist.csv`](VitTrade-Screen-Redesign-Checklist.csv)",
        "",
    ]

    module_order = [
        "auth",
        "onboarding",
        "home",
        "discovery",
        "news",
        "notifications",
        "markets",
        "predictions",
        "trade",
        "wallet",
        "p2p",
        "earn",
        "dca",
        "launchpad",
        "arena",
        "profile",
        "referral",
        "support",
        "rewards",
        "cross_module",
        "enterprise_states",
        "admin",
        "dev",
        "other",
    ]

    for module in module_order:
        module_rows = by_module.get(module, [])
        if not module_rows:
            continue
        lines.extend(
            [
                f"## {module} ({len(module_rows)})",
                "",
                "| sc_id | route_path | page_file | widget_class | classification |",
                "| --- | --- | --- | --- | --- |",
            ]
        )
        for row in sorted(module_rows, key=lambda item: sc_sort_key(item["sc_id"])):
            lines.append(
                f"| `{row['sc_id']}` | `{row['route_path']}` | "
                f"`{row['page_file']}` | `{row['widget_class']}` | "
                f"`{row['classification']}` |"
            )
        lines.append("")

    md_path.write_text("\n".join(lines), encoding="utf-8")
    print(f"Wrote {csv_path}")
    print(f"Wrote {md_path}")
    print(f"Rows: {len(rows)}")


if __name__ == "__main__":
    main()
