# VHF Ready: notes for Claude Code

Unofficial, open-source iOS study guide for the marine VHF Short Range Certificate (SRC).
**Not** related to any first-aid app. Do not mix content or code from other projects into this repo.

## Status

- iOS: 1.1 (4) Liquid Glass UI refresh, submitted to App Review; next is Android
- App Store ID `6836980342`: https://apps.apple.com/app/vhf-ready/id6836980342
- Git tags mark the commit that built each release: `v1.0.0` = 1.0 (3), `v1.1.0` = 1.1 (4).

## Hard constraints

- Unofficial. Never add names, logos, colours or styling of any training organisation, examining body, regulator or manufacturer. Never imply affiliation. The disclaimer sheet on first launch and the About screen must stay.
- All lesson/question wording must be original. Do not paste text from course books, exam papers or other apps.
- Radio procedure text (Mayday scripts, prowords, phonetics) stays English and left-to-right in every locale. Use `ProcedureText` for it.
- No network calls, analytics, ads or third-party SDKs. Progress stays in `UserDefaults` on device. `PrivacyInfo.xcprivacy` must match.
- SwiftUI, iOS 17+, Swift 5 language mode, no dependencies.

## Build and test

```bash
brew install xcodegen      # once
xcodegen generate          # regenerates VHFReady.xcodeproj from project.yml (the .xcodeproj is git-ignored)
# Simulator: iPhone 16 Pro (or the newest available iPhone simulator)
xcodebuild -scheme VHFReady -destination 'platform=iOS Simulator,name=iPhone 16 Pro' build
xcodebuild -scheme VHFReady -destination 'platform=iOS Simulator,name=iPhone 16 Pro' test
```

This code was written without access to a Mac, so it has not been compiled yet. On the first build, fix any compiler errors before changing behaviour, then:

1. Run the tests.
2. Launch in the simulator in English, Arabic (check right-to-left layout and that scripts stay left-to-right) and one long-string language such as German or Finnish (check truncation).
3. Check Dynamic Type at the largest accessibility size and dark mode.

## Where things live

- `project.yml`: XcodeGen spec. Bundle ID is `com.meltemiapps.vhfready` (tests: `com.meltemiapps.vhfready.tests`).
- `VHFReady/Resources/Content/en/*.json`: study content. Generated from `tools/make_content.py`. Edit the script, then rerun `python3 tools/make_content.py VHFReady/Resources/Content/en`.
- `VHFReady/Resources/Localizable.xcstrings`: 93 interface strings × 16 languages. Generated from `tools/make_strings.py`. After the first Xcode build, Xcode owns this file; edit it in Xcode from then on.
- Module titles and distress-nature labels are dynamic keys (`extractionState: manual`), so Xcode won't flag them as stale.

## Open items before App Store submission

- Bundle ID and Development Team: done (`com.meltemiapps.vhfready`, team set in `project.yml`).
- GitHub links in `Views/AboutViews.swift`: done (https://github.com/meltemiapps/vhf-ready).
- Native-speaker review of translations, especially the disclaimer.
- App Store privacy label: "Data Not Collected".
- Re-check that the name is still free in App Store Connect (the trademark search notes are kept privately, outside the repo).
- v1.1: translated content packs (`Content/<lang>/`), see CONTRIBUTING.md.
