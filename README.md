# VitTrade Flutter Enterprise Mono-Repo

VitTrade is maintained as a Flutter-first mobile trading app. The former
React/Vite app, root npm tooling, and web screenshot baseline were retired on
2026-05-26. The Flutter package under `flutter_app/` is the app source of truth.

## Repo Layout

```text
.
├── .agents/              # Agent skills and local AI tooling
├── docs/                # Product, design, engineering, QA, and legal docs
├── flutter_app/         # Flutter app package
├── AGENTS.md            # Coding rules for AI agents
├── README.md            # This file
└── .gitignore
```

Generated artifacts, logs, IDE state, and emulator captures do not belong in
Git. Use `flutter_app/run-artifacts/` for temporary QA output.

## Flutter App Structure

```text
flutter_app/lib/
├── app/                 # Bootstrap, router facade, theme
├── core/                # Config, network boundaries, errors, utilities
├── features/            # Feature modules
│   └── <feature>/
│       ├── domain/      # Entities, repository contracts, use cases
│       ├── data/        # Data sources, implementations, providers
│       └── presentation/
│           ├── pages/
│           ├── widgets/
│           └── controllers/
└── shared/              # Reusable layout and design-system widgets
```

`flutter_app/lib/app/router/app_router.dart` remains the public router import
and delegates to part files for paths, route groups, helpers, and visual QA
metadata.

## Commands

Run commands from `flutter_app/`:

```bash
flutter pub get
dart format .
flutter analyze
flutter test --reporter=compact
flutter run
```

## Docs

- Start here for agent work: `docs/00_START_HERE.md`
- Coding constraints: `AGENTS.md`
- Design rules: `docs/03_DESIGN_SYSTEM/Guidelines.md`
- Architecture reference: `docs/05_ARCHITECTURE/VitTrade-Enterprise-Architecture-Report.md`
- Flutter coverage and QA docs: `docs/02_FLUTTER_MIGRATION/`
