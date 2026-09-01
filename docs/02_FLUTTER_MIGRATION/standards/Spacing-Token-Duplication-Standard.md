# Spacing Token Duplication Standard

**Authority:** Derived from `flutter_app/tool/spacing_token_duplication_audit.dart` — no new policy invented, this doc documents what the tool checks.
**Scope:** both surfaces — the audit scans Phone/core module spacing namespaces; Tablet has a separate closed role scale governed by [Tablet-Spacing-Gutter-Standard.md](./Tablet-Spacing-Gutter-Standard.md). See [UI-Rule-Layer-Map.md](./UI-Rule-Layer-Map.md).
**Enforcement:** `dart run tool/spacing_token_duplication_audit.dart --check` · `test/quality/spacing_token_duplication_guardrail_test.dart`
**Reference report:** [VitTrade-Spacing-Token-Duplication-Audit.md](../audits/VitTrade-Spacing-Token-Duplication-Audit.md) / [.csv](../audits/VitTrade-Spacing-Token-Duplication-Audit.csv) — regenerated 2026-09-01; it scans 24 Phone/core token files and intentionally excludes `tablet_spacing_tokens.dart`.

There are now 25 `<module>_spacing_tokens.dart` files. The
`shared_spacing_tokens.dart` (`SharedSpacingTokens`) file holds
tokens genuinely consumed outside their origin module — see
`Flutter-Module-Identity-Standard.md`'s Token Growth Policy. This audit
scans it exactly like any other Phone/core module file (module name `shared`);
it is currently at `0`. The `tablet` module is a deliberate exception because
its 4/8/12/16/24/32/56 role values must remain independent from Phone.

## Rule

Each of the 24 scanned `lib/app/theme/spacing/<module>_spacing_tokens.dart` files may
define one-off, genuinely module-specific sizes (an exact chart height, a
hero block width). What it must **not** do is restate one of the 7 core
`AppSpacing` scale steps as a bare numeric literal under a new
module-specific name:

| Core token | Value |
| --- | --- |
| `AppSpacing.x1` | 3 |
| `AppSpacing.x2` | 5 |
| `AppSpacing.x3` | 8 |
| `AppSpacing.x4` | 13 |
| `AppSpacing.x5` | 21 |
| `AppSpacing.x6` | 34 |
| `AppSpacing.x7` | 55 |

If a module token's value is exactly `3`/`5`/`8`/`13`/`21`/`34`/`55`, it
should read `static const double myGap = AppSpacing.x3;` (or whichever step
matches), not `static const double myGap = 8;`. Same value, but the second
form breaks the ability to find every place that uses "the x3 step" and
invites the same value being re-derived slightly differently later.

**Deliberately out of scope**: `app_spacing.dart` also holds ~200 other
named, purpose-specific tokens (`serviceTileIconContainer = 26`,
`bottomNavBadgeMinWidth = 16`, etc.). This audit does **not** check against
those — a module token coincidentally sharing one of those values is not
evidence of duplication the way sharing a core scale step is. Checking
against the full ~200-token surface would produce mostly coincidental,
low-signal matches.

## How it's detected

The tool scans every `lib/app/theme/spacing/*_spacing_tokens.dart` file for
lines matching `static const double <name> = <bare numeric literal>;` —
only a literal RHS counts (`AppSpacing.x4`, arithmetic expressions, and
references to other constants are correctly ignored, since the regex
requires digits only between `=` and `;`). `int` constants (counts, not
sizes) are not scanned. Compound literals passed inline to `EdgeInsets.*`
constructors are **not** scanned either — only standalone `static const
double` declarations. See Limitations.

## Module Gate (frozen baseline)

Per-module current count vs. a frozen baseline (regression-only ratchet,
same mechanism as `home_reference_consistency_audit.dart` — a module at or
below its baseline passes; only an *increase* fails `--check`):

| Module | Current | Baseline |
| --- | ---: | ---: |
| admin, arena, auth, cross_module, dca, earn, enterprise_states, home, launchpad, markets, news, notifications, onboarding, p2p, predictions, profile, referral, shared, support, trade, trade_bots, trade_compliance, trade_copy, wallet | 0 | 0 |

All 24 scanned Phone/core modules are currently at zero. The `tablet` module
is intentionally absent from this table and the generated report; it is
validated by the separate Tablet role-scale guardrails.

The generated report is the source of truth for the current count. The Tablet
namespace does not appear in the report or module gate: matching values there
are expected role-scale values, not duplication debt. Phone/core entries at or
below their frozen baselines pass; new entries fail the ratchet.

## Do / Don't

| Do | Don't |
| --- | --- |
| `static const double cardGap = AppSpacing.x3;` | `static const double cardGap = 8;` |
| Add a new module-specific size that has no core-scale equivalent (e.g. `chartHeight = 122`) | Add a new module-specific size that happens to equal 3/5/8/13/21/34/55 without checking against `AppSpacing` first |
| Treat a `--strict` step tightening (see Upgrade path) as a signal to fix newly-introduced duplication immediately | Let new PRs add more literal-matches-core-scale debt on top of the frozen baseline |

## Limitations (state plainly, not papered over)

- **EdgeInsets/compound literals are not scanned.** `EdgeInsets.symmetric(horizontal: 8)` inside a module file is invisible to this audit even though `8` duplicates `AppSpacing.x3` — only bare `static const double` declarations are checked. A future version could extend the regex to catch named-argument literals inside `EdgeInsets.*` constructors.
- **Same name, different module ≠ same value.** This audit only flags duplication against the 7 *core* scale steps — it does **not** flag same-named-shape constants across modules with different values (e.g. `walletBuyAmountCardGap = 19` vs. `tradeBotCardGap = 12`, both a "`*CardGap`" shape but legitimately different numbers). That is a real, separate readability concern (documented in `Flutter-Module-Identity-Standard.md`'s Token Growth Policy) but not something this tool checks — never assume two modules' similarly-named constants share a value; always check the actual number.
- No guardrail waiver/exception-comment mechanism exists (unlike `card-tile: allow-start`) — a flagged constant is cleared only by pointing it at `AppSpacing.xN`, or by the module baseline being explicitly raised (with justification) if the value is coincidental rather than a true duplication.

### Tablet exception

`tablet_spacing_tokens.dart` is intentionally excluded from this audit. Tablet
uses `TabletSpacingTokens` as a separate surface namespace, with role values
`4/8/12/16/24/32/56`. Pointing those tokens back to Phone `AppSpacing` would
break surface independence and could silently reintroduce the old 13dp rhythm.
Tablet spacing is enforced instead by `tablet_base8_role_scale_guardrail_test.dart`,
`tablet_spacing_audit.dart --check`, and the Tablet spacing standard.

## Upgrade path

Baseline-ratchet (today) tolerates existing debt and only blocks new
regressions. Once a module's count reaches 0, consider adding it to a
future `--strict` mode (mirroring `card_tile_audit.dart --strict-full`) that
refuses to reintroduce even a single duplication in that module going
forward, rather than only gating on the aggregate baseline.

## Verify

```bash
cd flutter_app
dart run tool/spacing_token_duplication_audit.dart          # regenerate MD + CSV report
dart run tool/spacing_token_duplication_audit.dart --check  # CI: artifacts current AND no module regressed past baseline
flutter test test/quality/spacing_token_duplication_guardrail_test.dart --reporter=compact
```

## Related

- [Flutter-Design-System-Reference.md](../Flutter-Design-System-Reference.md) — §2 audit-domain map
- [Flutter-Module-Identity-Standard.md](./Flutter-Module-Identity-Standard.md) — Token Growth Policy (per-module spacing file convention this audit enforces against, including `shared_spacing_tokens.dart` for genuinely cross-module tokens)
- [Page-Rhythm-Standard.md](./Page-Rhythm-Standard.md) — the section/inner-gap tier tokens (`pageRhythm*Gap`) that sit one layer above the raw `AppSpacing.xN` scale this audit protects
