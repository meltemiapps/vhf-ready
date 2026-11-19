import Foundation

struct Course: Decodable {
    let version: Int
    let modules: [Module]
}

struct Module: Decodable, Identifiable, Hashable {
    let id: String
    /// Key into Localizable.xcstrings so module titles follow the interface language.
    let titleKey: String
    let symbol: String
    let lessons: [Lesson]
}

struct Lesson: Decodable, Identifiable, Hashable {
    let id: String
    let title: String
    let minutes: Int
    let blocks: [Block]
}

enum Block: Decodable, Hashable {
    case heading(String)
    case text(String)
    case list([String])
    case fact(title: String, body: String)
    case tip(String)
    case warning(String)
    /// Spoken radio procedure, rendered verbatim, monospaced and left-to-right.
    case script([String])

    private enum CodingKeys: String, CodingKey { case type, text, items, title, body, lines }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        let type = try c.decode(String.self, forKey: .type)
        switch type {
        case "heading": self = .heading(try c.decode(String.self, forKey: .text))
        case "text": self = .text(try c.decode(String.self, forKey: .text))
        case "list": self = .list(try c.decode([String].self, forKey: .items))
        case "fact": self = .fact(title: try c.decode(String.self, forKey: .title),
                                  body: try c.decode(String.self, forKey: .body))
        case "tip": self = .tip(try c.decode(String.self, forKey: .text))
        case "warning": self = .warning(try c.decode(String.self, forKey: .text))
        case "script": self = .script(try c.decode([String].self, forKey: .lines))
        default:
            throw DecodingError.dataCorruptedError(forKey: .type, in: c,
                                                   debugDescription: "Unknown block type \(type)")
        }
    }
}

struct QuestionBank: Decodable {
    let version: Int
    let questions: [Question]
}

struct Question: Decodable, Identifiable, Hashable {
    let id: String
    let module: String
    let prompt: String
    let options: [String]
    let answer: Int
    let explanation: String

    /// Returns a copy with the options in random order, so the correct answer
    /// is not always in the same position.
    func withShuffledOptions() -> Question {
        let order = options.indices.shuffled()
        return Question(id: id, module: module, prompt: prompt,
                        options: order.map { options[$0] },
                        answer: order.firstIndex(of: answer) ?? answer,
                        explanation: explanation)
    }
}

struct Flashcard: Identifiable, Hashable {
    enum Deck: String, CaseIterable, Identifiable {
        case letters, numbers, prowords
        var id: String { rawValue }
    }
    let id: String
    let deck: Deck
    let front: String
    let back: String
    let hint: String
}
