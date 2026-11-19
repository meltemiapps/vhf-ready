import SwiftUI
import UIKit

enum Links {
    // Public repository and website. Forks should point these at their own.
    static let repository = URL(string: "https://github.com/meltemiapps/vhf-ready")!
    static let privacy = URL(string: "https://meltemiapps.co.uk/vhf-ready/privacy/")!
    static let support = URL(string: "https://meltemiapps.co.uk/vhf-ready/support/")!
    static let disclaimer = URL(string: "https://github.com/meltemiapps/vhf-ready/blob/main/DISCLAIMER.md")!
}

struct DisclaimerText: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("VHF Ready is an independent, unofficial revision app. It is not affiliated with, endorsed by, sponsored by or connected to any training organisation, examining body, regulator, government agency or equipment manufacturer.")
            Text("It is not a training course, does not award any certificate or licence, and is no substitute for an approved course and assessment. The developer is not a certified instructor. Always follow current official guidance.")
            Text("In a real emergency, follow the instructions of the coastguard and your radio's manual.")
        }
        .font(.subheadline)
        .foregroundStyle(Theme.warningText)
    }
}

struct AboutView: View {
    @Environment(ProgressStore.self) private var progress
    @Environment(\.openURL) private var openURL
    @State private var confirmReset = false

    private var version: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
    }

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 10) {
                    Label("Unofficial study aid", systemImage: "exclamationmark.triangle")
                        .font(.headline)
                        .foregroundStyle(Theme.warningText)
                    DisclaimerText()
                }
                .padding(.vertical, 6)
                .listRowBackground(Theme.warningFill)
            }

            Section("Your privacy") {
                privacyRow("No account, sign-in or personal details required")
                privacyRow("Your progress stays on this device only")
                privacyRow("No advertising, analytics or third-party tracking")
                privacyRow("Delete the app and all your data goes with it")
            }

            Section("Language") {
                Text("Change the app language in iOS Settings.")
                    .font(.subheadline)
                Button("Open Settings") {
                    if let url = URL(string: UIApplication.openSettingsURLString) { openURL(url) }
                }
                ContentLanguageNote()
                    .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
            }

            Section("Open source") {
                Link(destination: Links.repository) { Label("Source code and licences", systemImage: "chevron.left.forwardslash.chevron.right") }
                Link(destination: Links.privacy) { Label("Privacy policy", systemImage: "hand.raised") }
                Link(destination: Links.support) { Label("Support", systemImage: "questionmark.bubble") }
                Link(destination: Links.disclaimer) { Label("Disclaimer", systemImage: "doc.text") }
            }

            Section {
                Button("Reset progress", role: .destructive) { confirmReset = true }
            }

            Section {
                Text("Version \(version)")
                    .font(.footnote)
                    .foregroundStyle(Theme.secondaryText)
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.clear)
            }
        }
        .navigationTitle("About & privacy")
        .confirmationDialog("Reset progress", isPresented: $confirmReset) {
            Button("Reset progress", role: .destructive) { progress.resetProgress() }
        } message: {
            Text("This clears completed lessons, quiz scores and flashcards on this device.")
        }
    }

    private func privacyRow(_ key: LocalizedStringKey) -> some View {
        Label {
            Text(key).font(.subheadline)
        } icon: {
            Image(systemName: "checkmark").foregroundStyle(Theme.success)
        }
    }
}

struct DisclaimerSheet: View {
    @Environment(ProgressStore.self) private var progress

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(Theme.accent)
                    .accessibilityHidden(true)
                Text("Before you start")
                    .font(.system(.title, design: .rounded, weight: .bold))
                    .foregroundStyle(Theme.navy)
                DisclaimerText()
                    .padding(16)
                    .background(Theme.warningFill, in: RoundedRectangle(cornerRadius: 16))
                Text("No account, sign-in or personal details required")
                    .font(.footnote)
                    .foregroundStyle(Theme.secondaryText)
                Button("I understand") { progress.acceptDisclaimer() }
                    .buttonStyle(PrimaryButtonStyle())
            }
            .padding(24)
        }
        .background(Theme.background)
    }
}
