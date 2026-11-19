import SwiftUI

struct QuizHomeView: View {
    @Environment(ContentStore.self) private var content
    @Environment(ProgressStore.self) private var progress

    var body: some View {
        List {
            Section {
                NavigationLink {
                    QuizView(moduleID: nil, title: "Mixed quiz", count: 10)
                } label: {
                    row(title: "Mixed quiz",
                        subtitle: Text("10 random questions from every module"),
                        best: progress.bestScore(for: QuizView.key(for: nil)))
                }
            }
            Section("Modules") {
                ForEach(content.course.modules) { module in
                    let count = content.questions(for: module.id).count
                    NavigationLink {
                        QuizView(moduleID: module.id, title: LocalizedStringKey(module.titleKey), count: 10)
                    } label: {
                        row(title: LocalizedStringKey(module.titleKey),
                            subtitle: Text("\(count) questions"),
                            best: progress.bestScore(for: QuizView.key(for: module.id)))
                    }
                    .disabled(count == 0)
                }
            }
        }
        .navigationTitle("Choose a quiz")
    }

    private func row(title: LocalizedStringKey, subtitle: Text, best: Int?) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.body.weight(.medium))
                subtitle.font(.caption).foregroundStyle(Theme.secondaryText)
            }
            Spacer()
            if let best {
                Text("Best: \(best)%")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.success)
            }
        }
        .frame(minHeight: 44)
    }
}

struct QuizView: View {
    @Environment(ContentStore.self) private var content
    @Environment(ProgressStore.self) private var progress
    @Environment(\.dismiss) private var dismiss

    let moduleID: String?
    let title: LocalizedStringKey
    let count: Int

    @State private var questions: [Question] = []
    @State private var index = 0
    @State private var selected: Int?
    @State private var checked = false
    @State private var correctCount = 0
    @State private var finished = false

    static func key(for moduleID: String?) -> String { "quiz." + (moduleID ?? "mixed") }

    var body: some View {
        Group {
            if questions.isEmpty {
                ProgressView()
            } else if finished {
                results
            } else {
                questionView(questions[index])
            }
        }
        .background(Theme.background)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { if questions.isEmpty { start() } }
    }

    private func start() {
        questions = content.questions(for: moduleID).shuffled().prefix(count).map { $0.withShuffledOptions() }
        index = 0; selected = nil; checked = false; correctCount = 0; finished = false
    }

    private func questionView(_ q: Question) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Question \(index + 1) of \(questions.count)")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(Theme.secondaryText)
                    ProgressView(value: Double(index + 1), total: Double(questions.count))
                }
                Text(verbatim: q.prompt)
                    .font(.system(.title3, design: .rounded, weight: .semibold))
                    .foregroundStyle(Theme.navy)
                    .fixedSize(horizontal: false, vertical: true)

                VStack(spacing: 10) {
                    ForEach(Array(q.options.enumerated()), id: \.offset) { i, option in
                        AnswerButton(text: option, letter: ["A", "B", "C", "D", "E"][min(i, 4)],
                                     state: state(for: i, q: q)) {
                            if !checked { selected = i }
                        }
                    }
                }

                if checked {
                    let right = selected == q.answer
                    VStack(alignment: .leading, spacing: 6) {
                        Text(right ? LocalizedStringKey("Correct") : LocalizedStringKey("Not quite"))
                            .font(.headline)
                            .foregroundStyle(right ? Theme.success : Theme.error)
                        Text(verbatim: q.explanation)
                            .font(.subheadline)
                            .foregroundStyle(Theme.navy)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .card()
                }

                Button {
                    advance(q)
                } label: {
                    Text(!checked ? LocalizedStringKey("Check answer")
                         : index + 1 == questions.count ? LocalizedStringKey("See results")
                         : LocalizedStringKey("Next question"))
                }
                .buttonStyle(PrimaryButtonStyle(fill: Color(hex: 0x0B2540)))
                .disabled(selected == nil)
                .opacity(selected == nil ? 0.5 : 1)
            }
            .padding(20)
        }
    }

    private func state(for i: Int, q: Question) -> AnswerButton.AnswerState {
        guard checked else { return selected == i ? .selected : .idle }
        if i == q.answer { return .correct }
        if i == selected { return .wrong }
        return .idle
    }

    private func advance(_ q: Question) {
        if !checked {
            checked = true
            if selected == q.answer { correctCount += 1 }
            return
        }
        if index + 1 < questions.count {
            index += 1; selected = nil; checked = false
        } else {
            let percent = Int((Double(correctCount) / Double(questions.count) * 100).rounded())
            progress.record(score: percent, for: Self.key(for: moduleID))
            finished = true
        }
    }

    private var results: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: correctCount * 10 >= questions.count * 8 ? "rosette" : "book")
                .font(.system(size: 56))
                .foregroundStyle(Theme.accent)
                .accessibilityHidden(true)
            Text("You scored \(correctCount) of \(questions.count)")
                .font(.system(.title2, design: .rounded, weight: .bold))
                .foregroundStyle(Theme.navy)
            Text("Review the lessons for any topic you found tricky.")
                .multilineTextAlignment(.center)
                .foregroundStyle(Theme.secondaryText)
            Spacer()
            Button("Try again") { start() }.buttonStyle(PrimaryButtonStyle())
            Button("Done") { dismiss() }.buttonStyle(SecondaryButtonStyle())
        }
        .padding(20)
    }
}

struct AnswerButton: View {
    enum AnswerState { case idle, selected, correct, wrong }
    let text: String
    let letter: String
    let state: AnswerState
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8).fill(badgeFill).frame(width: 30, height: 30)
                    switch state {
                    case .correct: Image(systemName: "checkmark").font(.footnote.bold()).foregroundStyle(.white)
                    case .wrong: Image(systemName: "xmark").font(.footnote.bold()).foregroundStyle(.white)
                    default: Text(verbatim: letter).font(.footnote.bold()).foregroundStyle(badgeText)
                    }
                }
                .accessibilityHidden(true)
                Text(verbatim: text)
                    .font(.body.weight(state == .idle ? .regular : .semibold))
                    .foregroundStyle(Theme.navy)
                    .multilineTextAlignment(.leading)
                Spacer(minLength: 0)
            }
            .padding(14)
            .frame(minHeight: 56)
            .background(fill, in: RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(stroke, lineWidth: state == .idle ? 1 : 2))
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(state == .selected ? .isSelected : [])
    }

    private var fill: Color {
        switch state {
        case .correct: Theme.successFill
        case .wrong: Theme.errorFill
        default: Theme.card
        }
    }
    private var stroke: Color {
        switch state {
        case .idle: Theme.border
        case .selected: Theme.link
        case .correct: Theme.success
        case .wrong: Theme.error
        }
    }
    private var badgeFill: Color {
        switch state {
        case .idle: Theme.border.opacity(0.5)
        case .selected: Theme.link
        case .correct: Theme.success
        case .wrong: Theme.error
        }
    }
    private var badgeText: Color { state == .selected ? .white : Theme.navy }
}
