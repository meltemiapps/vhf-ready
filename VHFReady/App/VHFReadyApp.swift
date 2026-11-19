import SwiftUI

@main
struct VHFReadyApp: App {
    @State private var content = ContentStore()
    @State private var progress = ProgressStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(content)
                .environment(progress)
                .tint(Theme.accent)
        }
    }
}
