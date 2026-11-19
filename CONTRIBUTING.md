# Contributing

Thanks for helping. A few ground rules keep the project safe to publish.

## Content rules

1. **Original wording only.** Do not copy text, questions, diagrams or images from course books, exam papers, training providers or other apps. Write in your own words from general knowledge.
2. **No third-party branding.** Do not add logos, names or styling of any training organisation, examining body, regulator or manufacturer. Factual mentions of a country's rules are fine when needed for accuracy.
3. **Radio procedure stays in English.** Mayday/Pan-Pan/Sécurité scripts, prowords and the phonetic alphabet are used in English internationally, so keep them in English in every language pack.
4. **Accuracy first.** If you correct a fact, say where it can be checked in the pull request.

## Translating the interface

Interface strings live in `VHFReady/Resources/Localizable.xcstrings`. Open it in Xcode, pick your language and edit. Native-speaker review of existing translations, especially the disclaimer, is very welcome.

## Adding a translated content pack

1. Copy `VHFReady/Resources/Content/en/` to `VHFReady/Resources/Content/<code>/` (for example `el`, `es`, `ar`).
2. Translate the `title`, `text`, `items`, `body`, `prompt`, `options` and `explanation` fields.
3. Do **not** translate `id`, `module`, `type`, `answer`, `titleKey`, `symbol`, or any `script` lines.
4. Run the tests (`⌘U`). The app picks up the pack automatically for users whose interface language matches.

## Code

SwiftUI, iOS 17+, no third-party dependencies. Keep it that way unless there's a strong reason.
