# Page Rhythm Compliance Report

Generated: 2026-08-31

Source: `VitTrade-Page-Rhythm-Screen-Compliance.csv`

## Summary

Screen rollup: 409 real_page routes, L1 pass 399, L2 pass 399 warn 0, unknown 10, documented exceptions 8.
| Level | Meaning |
| --- | --- |
| L1 | Wiring: rhythm, orphan gaps, nested VPC |
| L2 | Structural: direct children, tab-root tier |
| L3 | Visual parity (tab-root + representative QA) |

## Tab roots

| Screen | Route | L1 | L2 | L3 |
| --- | --- | --- | --- | --- |
| AppRouteNames.sc048Trade | `AppRoutePaths.trade` | pass | pass | pass |

## L2 warn routes

| Screen | Page | Notes |
| --- | --- | --- |

## Unknown / unmapped routes

| Screen | Page | Pattern |
| --- | --- | --- |
| AppRouteNames.sc161ActivityLog | `switch` | shared_shell |
| AppRouteNames.sc163ApiManagement | `switch` | shared_shell |
| AppRouteNames.sc162ApiKeyCreate | `switch` | shared_shell |
| AppRouteNames.sc165DeviceManagement | `switch` | shared_shell |
| AppRouteNames.sc157EditProfile | `switch` | shared_shell |
| AppRouteNames.sc159Kyc | `switch` | shared_shell |
| AppRouteNames.sc158Security | `switch` | shared_shell |
| AppRouteNames.sc160Settings | `switch` | shared_shell |
| AppRouteNames.sc166SubAccount | `switch` | shared_shell |
| AppRouteNames.sc164Vip | `switch` | shared_shell |

## By module

### app (279 routes, L2 warn 0, unknown 0)

### auth (6 routes, L2 warn 0, unknown 0)

### home (1 routes, L2 warn 0, unknown 0)

### markets (1 routes, L2 warn 0, unknown 0)

### p2p_core (76 routes, L2 warn 0, unknown 0)

### profile (11 routes, L2 warn 0, unknown 10)

### trade (13 routes, L2 warn 0, unknown 0)

### trade_compliance (1 routes, L2 warn 0, unknown 0)

### wallet (21 routes, L2 warn 0, unknown 0)

