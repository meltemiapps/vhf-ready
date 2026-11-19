# VHF Ready

**An unofficial, open-source study guide for the marine VHF Short Range Certificate (SRC), for iPhone and iPad.**

> VHF Ready is an independent revision aid. It is not affiliated with, endorsed by, sponsored by or connected to any training organisation, examining body, regulator, government agency or equipment manufacturer. It does not award any certificate or licence and is no substitute for an approved course and assessment. See [DISCLAIMER.md](DISCLAIMER.md).

## What it does

- **Learn:** 6 modules and 19 short lessons: radio basics and licensing, channels and calling, DSC, distress/urgency/safety, GMDSS/EPIRB/SART, phonetics and prowords.
- **Practise:** a bank of 47 multiple-choice questions with explanations, by module or mixed, with best scores saved.
- **Radio drills:** a practice Mayday builder (with read-aloud) and flashcards for the phonetic alphabet, figures and prowords.
- **Private by design:** no account, no network calls, no analytics, no ads. Progress is stored on the device only.

## Languages

The interface is localised into 16 languages: English, Greek, Spanish, Italian, French, Portuguese, German, Dutch, Polish, Russian, Serbian (Cyrillic), Danish, Swedish, Norwegian Bokmål, Finnish and Arabic (right-to-left).

Lessons and questions are in English in v1.0. Radio procedure (Mayday calls, prowords, phonetics) stays in English in every language because that is how it is used on air and in the assessment. The content loader already supports per-language packs (`Content/<lang>/course.json`), so translated lessons can be added without code changes. See [CONTRIBUTING.md](CONTRIBUTING.md).

The interface translations were produced without native-speaker review. Corrections are welcome, especially for the disclaimer text.

## Units

Marine radio uses nautical miles, knots, degrees true and UTC worldwide, so the app uses them too, with metric equivalents in the lessons where helpful (1 nautical mile = 1,852 m). The SRC syllabus doesn't involve temperature or barometric pressure, so there are no unit settings.

## Build

Requirements: macOS with Xcode 16 or later, iOS 17 SDK, [XcodeGen](https://github.com/yonaskolb/XcodeGen).

```bash
brew install xcodegen
xcodegen generate
open VHFReady.xcodeproj
```

Before running on a device or submitting:

1. In `project.yml`, change `bundleIdPrefix` and `PRODUCT_BUNDLE_IDENTIFIER` from `com.example...` to your own.
2. Set your Development Team in Xcode (Signing & Capabilities).
3. Replace `YOUR-GITHUB-USERNAME` in `VHFReady/Views/AboutViews.swift` with your repository URL.

Run tests with `⌘U` or:

```bash
# Simulator: iPhone 16 Pro (or the newest available iPhone simulator)
xcodebuild test -scheme VHFReady -destination 'platform=iOS Simulator,name=iPhone 16 Pro'
```

## Project layout

```
VHFReady/
  App/          App entry and tab structure
  Models/       Content, progress, phonetics, Mayday script builder
  Views/        SwiftUI screens
  Theme/        Colours and shared styles
  Resources/
    Content/en/ course.json, questions.json (study content)
    Localizable.xcstrings   interface strings, 16 languages
    Assets.xcassets         app icon and accent colour
VHFReadyTests/  Unit tests
```

## Licence

- Code: [MIT](LICENSE)
- Study content (`VHFReady/Resources/Content`): [CC BY 4.0](LICENSE-CONTENT.md)

All lesson and question wording is original to this project and written from general knowledge of international maritime radio procedure. It isn't copied from any course book, exam paper or training provider's material.
