---
name: vittrade-ui-checklists
description: Flutter-safe adapter for selected external ui-skills checklists. Use when building, reviewing, polishing, or fixing VitTrade Flutter UI screens, shared components, home/shared-component standards, accessibility, motion performance, visual hierarchy, loading/empty/error states, or mobile responsive behavior while preserving AGENTS.md, VitTrade design tokens, shared widgets, financial-safety copy, and Prediction Markets/Open Arena boundaries.
---

# VitTrade UI Checklists

## Overview

Use this skill to borrow the best parts of external `ui-skills` without importing web/React/Tailwind assumptions into VitTrade. Treat external skills as advisory checklists; project docs, Flutter source, `ui-ux-pro-max`, and VitTrade shared components remain authoritative.

## Source Priority

Apply this order every time:

1. `AGENTS.md`
2. `docs/00_START_HERE.md` and relevant Flutter/design docs
3. Current Flutter code, theme tokens, and shared widgets
4. `.codex/skills/ui-ux-pro-max`
5. Selected external `ui-skills` checklist from the allowlist below

For detailed VitTrade visual contracts, also read
`references/ui-visual-standards.md` and the matching standard document before
editing presentation code.

External checklist rules must be translated to Flutter. Drop any rule that conflicts with VitTrade architecture, financial safety, product boundaries, or shared component standards.

## Allowlist

Use at most one external checklist by default. Use two only when the task clearly touches both accessibility and animation.

- `ibelick/fixing-accessibility`: use for semantics, labels, focus, forms, dialogs, validation, disabled states, keyboard navigation, or critical flow accessibility.
- `ibelick/fixing-motion-performance`: use for page transitions, micro-interactions, scroll performance, janky animations, shimmer/skeleton behavior, or expensive visual effects.
- `ibelick/baseline-ui`: use only as a lightweight polish checklist for spacing, hierarchy, typography, empty states, loading/error/success states, and action clarity.

Do not use broad web, Next.js, React, Tailwind, Radix, Base UI, shadcn, metadata, or Three.js skills for normal VitTrade Flutter screens unless the user explicitly asks for that stack.

## Safe Retrieval

Prefer pinned, read-only CLI calls:

```powershell
npx ui-skills@0.2.2 get ibelick/fixing-accessibility
npx ui-skills@0.2.2 get ibelick/fixing-motion-performance
npx ui-skills@0.2.2 get ibelick/baseline-ui
```

Never run an external install script such as `curl ... | sh` for VitTrade UI work. Never install all registry skills into the repo. If the network is unavailable, use the translation rules in this skill and continue.

## Workflow

1. Read the project contract first: `AGENTS.md`, `docs/00_START_HERE.md`, and any screen/design plan the task mentions.
2. Use `ui-ux-pro-max` for design-system direction when visual design choices are being made.
3. Pick the smallest external checklist from the allowlist. Skip external retrieval when the task is already covered by project docs.
4. Translate checklist items into Flutter and VitTrade shared-component terms.
5. Implement using `VitAppShell`, `VitPageLayout`, `VitPageContent`, `VitHeader`, `VitBottomNav`, `VitCard`, `VitCtaButton`, `VitInput`, `VitTabBar`, and theme tokens before local scaffolds.
6. Preserve product boundaries: Arena remains points-only; Prediction Markets keeps trading/probability/PnL language separate.
7. Verify with focused Flutter tests and `flutter analyze` for touched UI; broaden checks when shared layout, router, financial flows, or semantics change.

## Flutter Translation

| External web idea | VitTrade Flutter translation |
| --- | --- |
| `aria-label` on icon-only controls | `IconButton.tooltip`, `Semantics(label: ...)`, meaningful `semanticLabel` |
| Native button/link semantics | Flutter `TextButton`, `FilledButton`, `IconButton`, `InkWell`/`GestureDetector` with `Semantics` when needed |
| Focus visible and keyboard access | `FocusTraversalGroup`, `FocusNode`, `Shortcuts`, `Actions`, visible focused state |
| Field error association | Inline validation near `VitInput`, error text in widget tree, semantics for critical errors |
| Dialog focus and close behavior | Flutter dialog/bottom-sheet patterns, confirm high-risk actions, restore safe navigation |
| Loading status | Structural skeletons, progress indicators, `Semantics(liveRegion: true)` for critical status when appropriate |
| Transform/opacity animations | `FadeTransition`, `SlideTransition`, `ScaleTransition`, `Transform`, `AnimatedOpacity` |
| Avoid layout animation | Avoid animating large relayouts, expensive `BackdropFilter`, large blur/filter surfaces, or rebuild-heavy lists |
| Responsive web breakpoints | Phone-first Flutter constraints at 360 px and up with `LayoutBuilder`, flexible widgets, and no fixed 375 px layout |
| Tailwind tokens/classes | VitTrade theme tokens from `flutter_app/lib/app/theme/` and shared primitives |

## What To Ignore

- Ignore Tailwind, CSS, Radix, Base UI, shadcn, `motion/react`, `cn`, HTML metadata, DOM, and browser-only implementation rules unless the current task explicitly targets Flutter web metadata or a web artifact.
- Ignore advice that creates new visual systems instead of using VitTrade tokens and shared components.
- Ignore broad redesign suggestions when the request is a focused fix.
- Ignore copy that weakens financial safety, hides fees/limits/risk, or mixes Arena points with wallet/profit/stake language.

## Delivery Checklist

- Shared primitives used before local scaffolds.
- Dark baseline preserved and phone-first layout works at 360 px.
- Loading, empty, error, offline, submitting, and success states included when the flow needs them.
- Icon-only and high-risk controls have accessible labels/tooltips.
- Animation is purposeful, short, and avoids expensive relayout or large blur/filter surfaces.
- Financial actions preview fees, risks, limits, and next steps before confirmation.
- Arena and Prediction Markets copy remain separated.
- Focused tests and analysis commands are reported in the final answer.

## Recommended Selection

For VitTrade, the optimal external set is deliberately small: accessibility, motion performance, and baseline polish. This gives the agent useful UI checklists while avoiding registry sprawl and web-stack drift.
