# Page Rhythm Compliance Report

Generated: 2026-09-01

Source: `VitTrade-Page-Rhythm-Screen-Compliance.csv`

## Summary

Screen rollup: 409 real_page routes, L1 pass 399, L2 pass 399 warn 0, unknown 10, documented exceptions 10.
| Level | Meaning |
| --- | --- |
| L1 | Wiring: rhythm, orphan gaps, nested VPC |
| L2 | Structural: direct children, tab-root tier |
| L3 | Visual parity (tab-root + representative QA) |

## Tab roots

| Screen | Route | L1 | L2 | L3 |
| --- | --- | --- | --- | --- |
| AppRouteNames.sc049TradePair | `'/trade/:pairId'` | pass | pass | pass |
| AppRouteNames.sc156Profile | `AppRoutePaths.profile` | pass | pass | pass |
| AppRouteNames.sc048Trade | `AppRoutePaths.trade` | pass | pass | pass |
| AppRouteNames.sc135Wallet | `AppRoutePaths.wallet` | pass | pass | pass |

## L2 warn routes

| Screen | Page | Notes |
| --- | --- | --- |

## Unknown / unmapped routes

| Screen | Page | Pattern |
| --- | --- | --- |
| AppRouteNames.sc161ActivityLog | `ActivityLogPage` | shared_shell |
| AppRouteNames.sc163ApiManagement | `ApiManagementPage` | shared_shell |
| AppRouteNames.sc162ApiKeyCreate | `ApiKeyCreatePage` | shared_shell |
| AppRouteNames.sc165DeviceManagement | `DeviceManagementPage` | shared_shell |
| AppRouteNames.sc157EditProfile | `EditProfilePage` | shared_shell |
| AppRouteNames.sc159Kyc | `KYCPage` | shared_shell |
| AppRouteNames.sc158Security | `SecurityPage` | shared_shell |
| AppRouteNames.sc160Settings | `SettingsPage` | shared_shell |
| AppRouteNames.sc166SubAccount | `SubAccountPage` | shared_shell |
| AppRouteNames.sc164Vip | `VIPPage` | shared_shell |

## By module

### app (279 routes, L2 warn 0, unknown 0)

### auth (6 routes, L2 warn 0, unknown 0)

### home (1 routes, L2 warn 0, unknown 0)

### markets (1 routes, L2 warn 0, unknown 0)

### p2p_core (75 routes, L2 warn 0, unknown 0)

### p2p_security (1 routes, L2 warn 0, unknown 0)

### profile (11 routes, L2 warn 0, unknown 10)

### trade (13 routes, L2 warn 0, unknown 0)

### trade_compliance (1 routes, L2 warn 0, unknown 0)

### wallet (21 routes, L2 warn 0, unknown 0)

