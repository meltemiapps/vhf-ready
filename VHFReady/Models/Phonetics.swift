import Foundation

/// ITU phonetic alphabet and figure pronunciation used in maritime radio.
enum Phonetics {
    static let letters: [(Character, String, String)] = [
        ("A", "ALFA", "AL-fah"), ("B", "BRAVO", "BRAH-voh"), ("C", "CHARLIE", "CHAR-lee"),
        ("D", "DELTA", "DELL-tah"), ("E", "ECHO", "ECK-oh"), ("F", "FOXTROT", "FOKS-trot"),
        ("G", "GOLF", "GOLF"), ("H", "HOTEL", "hoh-TELL"), ("I", "INDIA", "IN-dee-ah"),
        ("J", "JULIETT", "JEW-lee-ett"), ("K", "KILO", "KEY-loh"), ("L", "LIMA", "LEE-mah"),
        ("M", "MIKE", "MIKE"), ("N", "NOVEMBER", "no-VEM-ber"), ("O", "OSCAR", "OSS-cah"),
        ("P", "PAPA", "pah-PAH"), ("Q", "QUEBEC", "keh-BECK"), ("R", "ROMEO", "ROW-me-oh"),
        ("S", "SIERRA", "see-AIR-rah"), ("T", "TANGO", "TANG-go"), ("U", "UNIFORM", "YOU-nee-form"),
        ("V", "VICTOR", "VIK-tah"), ("W", "WHISKEY", "WISS-key"), ("X", "X-RAY", "ECKS-ray"),
        ("Y", "YANKEE", "YANG-key"), ("Z", "ZULU", "ZOO-loo")
    ]

    static let figures: [(Character, String)] = [
        ("0", "ZERO"), ("1", "WUN"), ("2", "TOO"), ("3", "TREE"), ("4", "FOW-ER"),
        ("5", "FIFE"), ("6", "SIX"), ("7", "SEV-EN"), ("8", "AIT"), ("9", "NIN-ER")
    ]

    static let prowords: [(String, String)] = [
        ("MAYDAY", "Distress: grave and imminent danger, immediate assistance required."),
        ("PAN-PAN", "Urgency: an urgent message about the safety of a vessel or person."),
        ("SECURITE", "Safety: an important navigational or weather warning follows."),
        ("OVER", "My transmission has ended and I expect a reply."),
        ("OUT", "This is the end of working. No reply expected."),
        ("RECEIVED", "I have received your last transmission."),
        ("SAY AGAIN", "Repeat your last transmission, or the part indicated."),
        ("I SAY AGAIN", "I am repeating my transmission, or the part indicated."),
        ("CORRECTION", "An error has been made. The correct version follows."),
        ("I SPELL", "I shall spell the next word phonetically."),
        ("WAIT", "Pause for a few seconds before I continue."),
        ("RADIO CHECK", "Please report the strength and clarity of my signal."),
        ("ALL AFTER", "The part of the message after the word that follows."),
        ("ALL BEFORE", "The part of the message before the word that follows."),
        ("STATION CALLING", "Used when you heard a call but not the caller's name."),
        ("SEELONCE MAYDAY", "Imposes radio silence. Used by the station controlling distress traffic."),
        ("SEELONCE DISTRESS", "Imposes radio silence. Used by a station other than the one in control."),
        ("PRUDONCE", "Restricted working may resume during distress traffic."),
        ("SEELONCE FEENEE", "Distress traffic has ended. Normal working may resume.")
    ]

    static var cards: [Flashcard] {
        letters.map { Flashcard(id: "L-\($0.0)", deck: .letters, front: String($0.0), back: $0.1, hint: $0.2) }
        + figures.map { Flashcard(id: "N-\($0.0)", deck: .numbers, front: String($0.0), back: $0.1, hint: "") }
        + prowords.map { Flashcard(id: "P-\($0.0)", deck: .prowords, front: $0.0, back: $0.1, hint: "") }
    }

    /// "MXYZ9" → "MIKE X-RAY YANKEE ZULU NINER"
    static func spell(_ text: String) -> String {
        text.uppercased().compactMap { ch -> String? in
            if let l = letters.first(where: { $0.0 == ch }) { return l.1 }
            if let f = figures.first(where: { $0.0 == ch }) { return f.1 == "NIN-ER" ? "NINER" : f.1.replacingOccurrences(of: "-", with: "") }
            return nil
        }.joined(separator: " ")
    }
}
