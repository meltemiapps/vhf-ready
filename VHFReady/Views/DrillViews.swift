import SwiftUI
import AVFoundation

struct DrillsView: View {
    var body: some View {
        List {
            NavigationLink { MaydayBuilderView() } label: {
                Label("Build a practice Mayday", systemImage: "exclamationmark.bubble")
                    .frame(minHeight: 44)
            }
            NavigationLink { FlashcardsView() } label: {
                Label("Phonetic cards", systemImage: "rectangle.on.rectangle")
                    .frame(minHeight: 44)
            }
        }
        .readableListWidth()
        .navigationTitle("Radio drills")
    }
}

// MARK: - Flashcards

struct FlashcardsView: View {
    @Environment(ProgressStore.self) private var progress
    @State private var deck: Flashcard.Deck = .letters
    @State private var index = 0
    @State private var flipped = false

    private var cards: [Flashcard] { Phonetics.cards.filter { $0.deck == deck } }

    var body: some View {
        // Same layout as before when it fits; scrolls at large accessibility text sizes.
        ViewThatFits(in: .vertical) {
            content
            ScrollView { content }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Theme.background)
        .navigationTitle("Phonetic cards")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: deck) { index = 0; flipped = false }
    }

    private var content: some View {
        VStack(spacing: 20) {
            Picker("Deck", selection: $deck) {
                Text("Letters").tag(Flashcard.Deck.letters)
                Text("Numbers").tag(Flashcard.Deck.numbers)
                Text("Prowords").tag(Flashcard.Deck.prowords)
            }
            .pickerStyle(.segmented)

            Text("\(progress.masteredCount(in: cards)) of \(cards.count) mastered")
                .font(.footnote)
                .foregroundStyle(Theme.secondaryText)

            if index < cards.count {
                card(cards[index])
                Text("Tap card to flip").font(.footnote).foregroundStyle(Theme.secondaryText)
                HStack(spacing: 12) {
                    Button("Still learning") { rate(false) }.buttonStyle(SecondaryButtonStyle())
                    Button("Got it") { rate(true) }.buttonStyle(PrimaryButtonStyle())
                }
            } else {
                Spacer()
                Image(systemName: "checkmark.seal").font(.system(size: 56)).foregroundStyle(Theme.success)
                    .accessibilityHidden(true)
                Text("All cards reviewed").font(.title3.weight(.semibold)).foregroundStyle(Theme.navy)
                Button("Start again") { index = 0; flipped = false }.buttonStyle(PrimaryButtonStyle())
                Spacer()
            }
        }
        .readableWidth()
        .padding(20)
    }

    private func card(_ card: Flashcard) -> some View {
        Button { withAnimation(.easeInOut(duration: 0.25)) { flipped.toggle() } } label: {
            VStack(spacing: 12) {
                Text(verbatim: card.front)
                    .font(.system(size: card.deck == .prowords ? 34 : 96, weight: .bold, design: .rounded))
                    .foregroundStyle(Theme.navy)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.5)
                if flipped {
                    Divider().frame(width: 48)
                    Text(verbatim: card.back)
                        .font(card.deck == .prowords ? .body : .system(size: 34, weight: .semibold, design: .rounded))
                        .foregroundStyle(Theme.accent)
                        .multilineTextAlignment(.center)
                    if !card.hint.isEmpty {
                        Text(verbatim: card.hint).font(.subheadline).foregroundStyle(Theme.secondaryText)
                    }
                }
            }
            .contentDirection(.procedure)
            .padding(24)
            .frame(maxWidth: .infinity, minHeight: 340)
            .background(Theme.card, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
            .shadow(color: .black.opacity(0.12), radius: 16, y: 8)
        }
        .buttonStyle(.plain)
        .accessibilityHint(Text("Tap card to flip"))
    }

    private func rate(_ mastered: Bool) {
        progress.setMastered(cards[index], mastered)
        flipped = false
        index += 1
    }
}

// MARK: - Mayday builder

struct MaydayBuilderView: View {
    @State private var script = MaydayScript()
    @State private var speaker = Speaker()

    var body: some View {
        Form {
            Section {
                Label("Practice only. Never transmit a test Mayday.", systemImage: "exclamationmark.triangle")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.warningText)
                    .listRowBackground(Theme.warningFill)
            }
            Section {
                TextField("Vessel name", text: $script.vesselName)
                    .textInputAutocapitalization(.characters)
                TextField("Call sign", text: $script.callSign)
                    .textInputAutocapitalization(.characters)
                    .autocorrectionDisabled()
                TextField("MMSI", text: $script.mmsi)
                    .keyboardType(.numberPad)
                TextField("Position", text: $script.position, prompt: Text(verbatim: "50°45'N 001°18'W"))
                    .autocorrectionDisabled()
                Picker("Nature of distress", selection: $script.nature) {
                    ForEach(MaydayScript.Nature.allCases) { nature in
                        Text(LocalizedStringKey(nature.labelKey)).tag(nature)
                    }
                }
                Stepper(value: $script.personsOnBoard, in: 1...99) {
                    LabeledContent("Persons on board") { Text(script.personsOnBoard, format: .number) }
                }
                TextField("Other information", text: $script.otherInfo, axis: .vertical)
            }
            Section("Your script") {
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(Array(script.lines.enumerated()), id: \.offset) { _, line in
                        ProcedureText(text: line)
                    }
                }
                .padding(.vertical, 6)
                Button {
                    speaker.toggle(script.text)
                } label: {
                    Label(speaker.isSpeaking ? LocalizedStringKey("Stop") : LocalizedStringKey("Hear it read aloud"),
                          systemImage: speaker.isSpeaking ? "stop.circle" : "speaker.wave.2")
                }
            }
        }
        .readableListWidth()
        .navigationTitle("Build a practice Mayday")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear { speaker.stop() }
    }
}

/// Reads procedure aloud with an English voice, whatever the interface language.
@MainActor @Observable
final class Speaker: NSObject, AVSpeechSynthesizerDelegate {
    private let synth = AVSpeechSynthesizer()
    var isSpeaking = false

    override init() {
        super.init()
        synth.delegate = self
    }

    func toggle(_ text: String) {
        if synth.isSpeaking { stop(); return }
        let utterance = AVSpeechUtterance(string: text.replacingOccurrences(of: "\n", with: ". "))
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB") ?? AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 0.9
        isSpeaking = true
        synth.speak(utterance)
    }

    func stop() {
        synth.stopSpeaking(at: .immediate)
        isSpeaking = false
    }

    // The delegate protocol is Sendable and may be called off the main thread,
    // so hop back to the main actor before touching UI state.
    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        Task { @MainActor in self.isSpeaking = false }
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        Task { @MainActor in self.isSpeaking = false }
    }
}
