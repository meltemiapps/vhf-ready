import SwiftUI

struct RootView: View {
    @Environment(ProgressStore.self) private var progress
    @State private var selection: Tab = .learn

    enum Tab: Hashable { case learn, practise, drills, about }

    var body: some View {
        TabView(selection: $selection) {
            NavigationStack { HomeView(selection: $selection) }
                .tabItem { Label("Learn", systemImage: "house") }
                .tag(Tab.learn)

            NavigationStack { QuizHomeView() }
                .tabItem { Label("Practise", systemImage: "questionmark.circle") }
                .tag(Tab.practise)

            NavigationStack { DrillsView() }
                .tabItem { Label("Radio drills", systemImage: "radio") }
                .tag(Tab.drills)

            NavigationStack { AboutView() }
                .tabItem { Label("About", systemImage: "info.circle") }
                .tag(Tab.about)
        }
        .glassTabBar()
        .sheet(isPresented: Binding(
            get: { !progress.hasAcceptedDisclaimer },
            set: { _ in }
        )) {
            DisclaimerSheet()
                .interactiveDismissDisabled()
        }
    }
}
