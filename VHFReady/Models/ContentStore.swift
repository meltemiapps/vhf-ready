import Foundation
import Observation

/// Loads study content bundled with the app. Content lives in
/// `Content/<language>/course.json` and `questions.json`. When a language pack
/// is missing the store falls back to English, so translated packs can be added
/// later without code changes.
@Observable
final class ContentStore {
    private(set) var course: Course
    private(set) var questions: [Question]
    private(set) var contentLanguage: String

    init(bundle: Bundle = .main) {
        let preferred = bundle.preferredLocalizations.first ?? "en"
        let lang = Self.availableLanguage(preferred, bundle: bundle)
        contentLanguage = lang
        course = Self.load(Course.self, file: "course", lang: lang, bundle: bundle)
            ?? Course(version: 0, modules: [])
        questions = Self.load(QuestionBank.self, file: "questions", lang: lang, bundle: bundle)?.questions ?? []
    }

    var allLessons: [Lesson] { course.modules.flatMap(\.lessons) }

    func module(for lesson: Lesson) -> Module? {
        course.modules.first { $0.lessons.contains(lesson) }
    }

    func nextLesson(after lesson: Lesson) -> Lesson? {
        let all = allLessons
        guard let i = all.firstIndex(of: lesson), i + 1 < all.count else { return nil }
        return all[i + 1]
    }

    func questions(for moduleID: String?) -> [Question] {
        guard let moduleID else { return questions }
        return questions.filter { $0.module == moduleID }
    }

    var isContentTranslated: Bool { contentLanguage != "en" }

    // MARK: - Loading

    private static func availableLanguage(_ preferred: String, bundle: Bundle) -> String {
        let candidates = [preferred, String(preferred.prefix(2)), "en"]
        for lang in candidates where bundle.url(forResource: "course", withExtension: "json",
                                                 subdirectory: "Content/\(lang)") != nil {
            return lang
        }
        return "en"
    }

    private static func load<T: Decodable>(_ type: T.Type, file: String, lang: String, bundle: Bundle) -> T? {
        guard let url = bundle.url(forResource: file, withExtension: "json", subdirectory: "Content/\(lang)")
                ?? bundle.url(forResource: file, withExtension: "json", subdirectory: "Content/en")
        else {
            assertionFailure("Missing content file \(file).json")
            return nil
        }
        do {
            return try JSONDecoder().decode(T.self, from: Data(contentsOf: url))
        } catch {
            assertionFailure("Could not decode \(file).json: \(error)")
            return nil
        }
    }
}
