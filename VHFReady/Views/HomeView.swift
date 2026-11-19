import SwiftUI

struct HomeView: View {
    @Environment(ContentStore.self) private var content
    @Environment(ProgressStore.self) private var progress
    @Binding var selection: RootView.Tab

    private var continueLesson: Lesson? {
        if let id = progress.lastLessonID,
           let last = content.allLessons.first(where: { $0.id == id }) {
            return progress.isComplete(last) ? (content.nextLesson(after: last) ?? last) : last
        }
        return content.allLessons.first
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                header
                continueCard
                quickTiles
                modules
            }
            .padding(20)
        }
        .background(Theme.background)
        .toolbar(.hidden, for: .navigationBar)
        .navigationDestination(for: Module.self) { ModuleView(module: $0) }
        .navigationDestination(for: Lesson.self) { LessonView(lesson: $0) }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Unofficial study guide")
                .font(.footnote.weight(.semibold))
                .textCase(.uppercase)
                .foregroundStyle(Theme.secondaryText)
            Text(verbatim: "VHF Ready")
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                .foregroundStyle(Theme.navy)
        }
        .padding(.top, 8)
    }

    private var continueCard: some View {
        let fraction = progress.overallFraction(of: content.course)
        return HStack(spacing: 18) {
            ProgressRing(fraction: fraction)
                .frame(width: 84, height: 84)
                .accessibilityLabel(Text("Overall progress"))
                .accessibilityValue(Text(fraction, format: .percent.precision(.fractionLength(0))))
            VStack(alignment: .leading, spacing: 6) {
                Text(progress.lastLessonID == nil ? LocalizedStringKey("Start learning") : LocalizedStringKey("Continue where you left off"))
                    .font(.subheadline)
                    .foregroundStyle(Color(hex: 0xB9CCE0))
                if let lesson = continueLesson {
                    Text(verbatim: lesson.title)
                        .font(.headline)
                        .foregroundStyle(.white)
                    NavigationLink(value: lesson) {
                        Text(progress.lastLessonID == nil ? LocalizedStringKey("Start learning") : LocalizedStringKey("Resume lesson"))
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 16)
                            .frame(minHeight: 44)
                            .background(Color(hex: 0xC2410C), in: RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
            Spacer(minLength: 0)
        }
        .padding(20)
        .background(Color(hex: 0x0B2540), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private var quickTiles: some View {
        let cards = Phonetics.cards.filter { $0.deck == .letters }
        return HStack(spacing: 12) {
            Button { selection = .practise } label: {
                tile(symbol: "checkmark.square", title: "Quick quiz",
                     subtitle: Text("\(10) questions"))
            }
            NavigationLink { FlashcardsView() } label: {
                tile(symbol: "rectangle.on.rectangle", title: "Phonetic cards",
                     subtitle: Text("\(progress.masteredCount(in: cards)) of \(cards.count) mastered"))
            }
        }
        .buttonStyle(.plain)
    }

    private func tile(symbol: String, title: LocalizedStringKey, subtitle: Text) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: symbol).font(.title3).foregroundStyle(Theme.link)
            Text(title).font(.headline).foregroundStyle(Theme.navy)
            subtitle.font(.footnote).foregroundStyle(Theme.secondaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .card()
    }

    private var modules: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Modules").font(.headline).foregroundStyle(Theme.navy)
            ForEach(Array(content.course.modules.enumerated()), id: \.element.id) { index, module in
                NavigationLink(value: module) {
                    ModuleRow(index: index + 1, module: module)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct ModuleRow: View {
    @Environment(ProgressStore.self) private var progress
    let index: Int
    let module: Module

    var body: some View {
        let done = progress.completedCount(in: module)
        let total = module.lessons.count
        let fraction = total == 0 ? 0 : Double(done) / Double(total)
        HStack(spacing: 12) {
            Text(index, format: .number)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(Theme.navy)
                .frame(width: 34, height: 34)
                .background(Theme.border.opacity(0.6), in: RoundedRectangle(cornerRadius: 10))
            VStack(alignment: .leading, spacing: 6) {
                Text(LocalizedStringKey(module.titleKey))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.navy)
                ProgressView(value: fraction)
                    .tint(done == total && total > 0 ? Theme.success : Theme.link)
                Text("\(done) of \(total) lessons")
                    .font(.caption)
                    .foregroundStyle(Theme.secondaryText)
            }
            Image(systemName: "chevron.forward")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(Theme.secondaryText)
        }
        .padding(14)
        .background(Theme.card, in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.border))
        .accessibilityElement(children: .combine)
    }
}

struct ProgressRing: View {
    let fraction: Double
    var body: some View {
        ZStack {
            Circle().stroke(Color(hex: 0x21476E), lineWidth: 10)
            Circle()
                .trim(from: 0, to: max(0.001, fraction))
                .stroke(Theme.accentBright, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .rotationEffect(.degrees(-90))
            Text(fraction, format: .percent.precision(.fractionLength(0)))
                .font(.system(.title3, design: .rounded, weight: .bold))
                .foregroundStyle(.white)
                // The ring has a fixed size, so shrink the label rather than truncate it at large text sizes.
                .lineLimit(1)
                .minimumScaleFactor(0.4)
                .padding(.horizontal, 12)
        }
    }
}
