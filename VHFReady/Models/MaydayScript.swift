import Foundation

/// Builds a practice Mayday voice call in the standard order.
/// Output is always English: radio procedure is international and English is the
/// language used in the assessment.
struct MaydayScript {
    enum Nature: String, CaseIterable, Identifiable {
        case fire, sinking, takingWater, manOverboard, collision, aground, medical, disabled
        var id: String { rawValue }

        /// Localised label for the picker.
        var labelKey: String {
            switch self {
            case .fire: "Fire"
            case .sinking: "Sinking"
            case .takingWater: "Taking on water"
            case .manOverboard: "Person overboard"
            case .collision: "Collision"
            case .aground: "Aground"
            case .medical: "Medical emergency"
            case .disabled: "Disabled and drifting into danger"
            }
        }

        /// English text spoken on the radio.
        var spoken: String {
            switch self {
            case .fire: "FIRE ON BOARD, OUT OF CONTROL"
            case .sinking: "SINKING"
            case .takingWater: "TAKING ON WATER, PUMPS NOT COPING"
            case .manOverboard: "PERSON OVERBOARD, NOT RECOVERED"
            case .collision: "COLLISION, HOLED AND TAKING ON WATER"
            case .aground: "AGROUND AND BREAKING UP"
            case .medical: "CREW MEMBER UNCONSCIOUS, NOT BREATHING NORMALLY"
            case .disabled: "ENGINE FAILURE, DRIFTING ONTO ROCKS"
            }
        }
    }

    var vesselName = ""
    var callSign = ""
    var mmsi = ""
    var position = ""
    var nature: Nature = .fire
    var personsOnBoard = 2
    var otherInfo = ""

    private var name: String {
        let n = vesselName.trimmingCharacters(in: .whitespaces).uppercased()
        return n.isEmpty ? "[VESSEL NAME]" : n
    }

    private var callSignSpoken: String {
        let cs = callSign.trimmingCharacters(in: .whitespaces)
        return cs.isEmpty ? "[CALL SIGN]" : Phonetics.spell(cs)
    }

    private var mmsiSpoken: String {
        let digits = mmsi.filter(\.isNumber)
        return digits.isEmpty ? "[MMSI]" : "MMSI " + Phonetics.spell(digits)
    }

    private var positionSpoken: String {
        let p = position.trimmingCharacters(in: .whitespaces).uppercased()
        return p.isEmpty ? "[POSITION]" : p
    }

    var lines: [String] {
        var out = [
            "MAYDAY MAYDAY MAYDAY",
            "THIS IS \(name) \(name) \(name)",
            "\(callSignSpoken), \(mmsiSpoken)",
            "MAYDAY \(name), \(callSignSpoken), \(mmsiSpoken)",
            "MY POSITION IS \(positionSpoken)",
            nature.spoken,
            "I REQUIRE IMMEDIATE ASSISTANCE",
            "\(personsOnBoard) PERSONS ON BOARD"
        ]
        let extra = otherInfo.trimmingCharacters(in: .whitespaces).uppercased()
        if !extra.isEmpty { out.append(extra) }
        out.append("OVER")
        return out
    }

    var text: String { lines.joined(separator: "\n") }
}
