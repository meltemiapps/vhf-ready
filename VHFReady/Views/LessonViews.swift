import SwiftUI

struct ModuleView: View {
    @Environment(ProgressStore.self) private var progress
    let module: Module

    var body: some View {
        List {
            Section {
                ForEach(module.lessons) { lesson in
                    NavigationLink(value: lesson) {
                        HStack(spacing: 12) {
                            Image(systemName: progress.isComplete(lesson) ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(progress.isComplete(lesson) ? Theme.success : Theme.secondaryText)
                                .accessibilityHidden(true)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(verbatim: lesson.title).font(.body.weight(.medium))
                                Text("\(lesson.minutes) min").font(.caption).foregroundStyle(Theme.secondaryText)
                            }
                        }
                        .frame(minHeight: 44)
                    }
                    .accessibilityValue(progress.isComplete(lesson) ? Text("Completed") : Text(verbatim: ""))
                }
            }
            Section {
                NavigationLink {
                    QuizView(moduleID: module.id, title: LocalizedStringKey(module.titleKey), count: 10)
                } label: {
                    Label("Practise this module", systemImage: "checkmark.square")
                }
            }
        }
        .navigationTitle(LocalizedStringKey(module.titleKey))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LessonView: View {
    @Environment(ContentStore.self) private var content
    @Environment(ProgressStore.self) private var progress
    @Environment(\.dismiss) private var dismiss
    let lesson: Lesson

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let module = content.module(for: lesson) {
                    Text(LocalizedStringKey(module.titleKey))
                        .font(.footnote.weight(.semibold))
                        .textCase(.uppercase)
                        .foregroundStyle(Theme.secondaryText)
                }
                Text(verbatim: lesson.title)
                    .font(.system(.title, design: .rounded, weight: .bold))
                    .foregroundStyle(Theme.navy)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentDirection()

                if !content.isContentTranslated && (Bundle.main.preferredLocalizations.first ?? "en") != "en" {
                    ContentLanguageNote()
                }

                ForEach(Array(lesson.blocks.enumerated()), id: \.offset) { _, block in
                    BlockView(block: block)
                }

                actions.padding(.top, 8)
            }
            .padding(20)
        }
        .background(Theme.background)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { progress.markOpened(lesson) }
    }

    @ViewBuilder private var actions: some View {
        VStack(spacing: 10) {
            if progress.isComplete(lesson) {
                Label("Completed", systemImage: "checkmark.seal.fill")
                    .font(.headline)
                    .foregroundStyle(Theme.success)
                    .frame(maxWidth: .infinity, minHeight: 50)
            } else {
                Button("Mark as complete") { progress.markComplete(lesson) }
                    .buttonStyle(PrimaryButtonStyle())
            }
            if let next = content.nextLesson(after: lesson) {
                NavigationLink(value: next) {
                    Text("Next lesson")
                }
                .buttonStyle(SecondaryButtonStyle())
            }
        }
    }
}

struct ContentLanguageNote: View {
    var body: some View {
        Label {
            Text("Lessons and questions are in English in this version. Radio procedure words stay in English, as they are used internationally and in the assessment.")
                .font(.footnote)
        } icon: {
            Image(systemName: "globe")
        }
        .foregroundStyle(Theme.secondaryText)
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.card, in: RoundedRectangle(cornerRadius: 12))
    }
}

struct BlockView: View {
    let block: Block

    var body: some View {
        blockContent
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentDirection()
    }

    @ViewBuilder private var blockContent: some View {
        switch block {
        case .heading(let text):
            Text(verbatim: text)
                .font(.title3.weight(.bold))
                .foregroundStyle(Theme.navy)
                .padding(.top, 6)
                .accessibilityAddTraits(.isHeader)
        case .text(let text):
            Text(verbatim: text)
                .font(.body)
                .lineSpacing(3)
                .foregroundStyle(Theme.navy)
        case .list(let items):
            VStack(alignment: .leading, spacing: 8) {
                ForEach(items, id: \.self) { item in
                    HStack(alignment: .firstTextBaseline, spacing: 10) {
                        Circle().fill(Theme.accent).frame(width: 6, height: 6).accessibilityHidden(true)
                        Text(verbatim: item).foregroundStyle(Theme.navy)
                    }
                }
            }
        case .fact(let title, let body):
            VStack(alignment: .leading, spacing: 4) {
                Text(verbatim: title)
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundStyle(Theme.accent)
                Text(verbatim: body).font(.subheadline).foregroundStyle(Theme.navy)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
            .background(Theme.warningFill, in: RoundedRectangle(cornerRadius: 14))
        case .tip(let text):
            Label {
                Text(verbatim: text).font(.subheadline)
            } icon: {
                Image(systemName: "lightbulb").foregroundStyle(Theme.link)
            }
            .foregroundStyle(Theme.navy)
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Theme.card, in: RoundedRectangle(cornerRadius: 14))
        case .warning(let text):
            Label {
                Text(verbatim: text).font(.subheadline)
            } icon: {
                Image(systemName: "exclamationmark.triangle").foregroundStyle(Theme.accent)
            }
            .foregroundStyle(Theme.warningText)
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Theme.warningFill, in: RoundedRectangle(cornerRadius: 14))
        case .script(let lines):
            VStack(alignment: .leading, spacing: 6) {
                ForEach(Array(lines.enumerated()), id: \.offset) { _, line in
                    ProcedureText(text: line)
                }
            }
            .foregroundStyle(Color(hex: 0xE8F0F8))
            .padding(16)
            .background(Color(hex: 0x0B2540), in: RoundedRectangle(cornerRadius: 16))
        }
    }
}
