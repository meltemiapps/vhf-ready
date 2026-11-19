import Foundation
import Observation

/// All progress is stored on the device in UserDefaults. Nothing leaves the phone.
@Observable
final class ProgressStore {
    private struct Snapshot: Codable {
        var completedLessons: Set<String> = []
        var masteredCards: Set<String> = []
        var bestScores: [String: Int] = [:]   // quiz key -> best percentage
        var lastLessonID: String?
        var acceptedDisclaimerVersion: Int = 0
    }

    static let disclaimerVersion = 1
    private static let key = "progress.v1"

    private let defaults: UserDefaults
    private var snapshot: Snapshot { didSet { save() } }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        if let data = defaults.data(forKey: Self.key),
           let decoded = try? JSONDecoder().decode(Snapshot.self, from: data) {
            snapshot = decoded
        } else {
            snapshot = Snapshot()
        }
    }

    // MARK: Disclaimer

    var hasAcceptedDisclaimer: Bool { snapshot.acceptedDisclaimerVersion >= Self.disclaimerVersion }
    func acceptDisclaimer() { snapshot.acceptedDisclaimerVersion = Self.disclaimerVersion }

    // MARK: Lessons

    func isComplete(_ lesson: Lesson) -> Bool { snapshot.completedLessons.contains(lesson.id) }

    func markComplete(_ lesson: Lesson) {
        snapshot.completedLessons.insert(lesson.id)
        snapshot.lastLessonID = lesson.id
    }

    func markOpened(_ lesson: Lesson) { snapshot.lastLessonID = lesson.id }

    var lastLessonID: String? { snapshot.lastLessonID }

    func completedCount(in module: Module) -> Int {
        module.lessons.filter { snapshot.completedLessons.contains($0.id) }.count
    }

    func overallFraction(of course: Course) -> Double {
        let total = course.modules.reduce(0) { $0 + $1.lessons.count }
        guard total > 0 else { return 0 }
        let done = course.modules.reduce(0) { $0 + completedCount(in: $1) }
        return Double(done) / Double(total)
    }

    // MARK: Flashcards

    func isMastered(_ card: Flashcard) -> Bool { snapshot.masteredCards.contains(card.id) }
    func setMastered(_ card: Flashcard, _ mastered: Bool) {
        if mastered { snapshot.masteredCards.insert(card.id) } else { snapshot.masteredCards.remove(card.id) }
    }
    func masteredCount(in cards: [Flashcard]) -> Int {
        cards.filter { snapshot.masteredCards.contains($0.id) }.count
    }

    // MARK: Quizzes

    func bestScore(for key: String) -> Int? { snapshot.bestScores[key] }
    func record(score percent: Int, for key: String) {
        snapshot.bestScores[key] = max(percent, snapshot.bestScores[key] ?? 0)
    }

    // MARK: Reset

    func resetProgress() {
        let accepted = snapshot.acceptedDisclaimerVersion
        snapshot = Snapshot()
        snapshot.acceptedDisclaimerVersion = accepted
    }

    private func save() {
        if let data = try? JSONEncoder().encode(snapshot) {
            defaults.set(data, forKey: Self.key)
        }
    }
}
