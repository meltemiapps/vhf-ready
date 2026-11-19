import XCTest
@testable import VHFReady

final class VHFReadyTests: XCTestCase {

    func testPhoneticSpelling() {
        XCTAssertEqual(Phonetics.spell("MXYZ9"), "MIKE X-RAY YANKEE ZULU NINER")
        XCTAssertEqual(Phonetics.spell("2a4"), "TOO ALFA FOWER")
    }

    func testAlphabetIsComplete() {
        XCTAssertEqual(Phonetics.letters.count, 26)
        XCTAssertEqual(Phonetics.figures.count, 10)
    }

    func testMaydayScriptOrder() {
        var s = MaydayScript()
        s.vesselName = "Sea Otter"
        s.callSign = "MXYZ9"
        s.mmsi = "235000000"
        s.position = "50°45'N 001°18'W"
        s.nature = .fire
        s.personsOnBoard = 3
        let lines = s.lines
        XCTAssertEqual(lines.first, "MAYDAY MAYDAY MAYDAY")
        XCTAssertEqual(lines[1], "THIS IS SEA OTTER SEA OTTER SEA OTTER")
        XCTAssertTrue(lines.contains("MY POSITION IS 50°45'N 001°18'W"))
        XCTAssertEqual(lines.last, "OVER")
    }

    func testContentLoadsAndIsConsistent() {
        let store = ContentStore(bundle: Bundle(for: ContentStore.self))
        XCTAssertEqual(store.course.modules.count, 6)
        XCTAssertFalse(store.questions.isEmpty)
        let moduleIDs = Set(store.course.modules.map(\.id))
        for q in store.questions {
            XCTAssertTrue(moduleIDs.contains(q.module), "Unknown module \(q.module) in \(q.id)")
            XCTAssertTrue(q.options.indices.contains(q.answer), "Bad answer index in \(q.id)")
        }
        let lessonIDs = store.allLessons.map(\.id)
        XCTAssertEqual(lessonIDs.count, Set(lessonIDs).count, "Duplicate lesson IDs")
    }

    func testShuffledOptionsKeepCorrectAnswer() {
        let q = Question(id: "t", module: "m", prompt: "?", options: ["a", "b", "c", "d"], answer: 1, explanation: "")
        for _ in 0..<20 {
            let s = q.withShuffledOptions()
            XCTAssertEqual(s.options[s.answer], "b")
            XCTAssertEqual(Set(s.options), Set(q.options))
        }
    }

    func testProgressPersists() {
        let defaults = UserDefaults(suiteName: "test.\(UUID().uuidString)")!
        let lesson = Lesson(id: "x", title: "X", minutes: 1, blocks: [])
        ProgressStore(defaults: defaults).markComplete(lesson)
        XCTAssertTrue(ProgressStore(defaults: defaults).isComplete(lesson))
    }
}
