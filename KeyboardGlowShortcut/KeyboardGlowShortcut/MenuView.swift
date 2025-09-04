//
//  MenuView.swift
//  KeyboardGlowShortcut
//
//  Created by Rashad Rafa on 2025-09-02.
//
import SwiftUI

struct MenuView: View {
    @State private var status = "Ready"

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title
            Text("Keyboard Backlight Mapping")
                .font(.headline)

            // ===== Actions =====
            sectionHeader("Actions")
            fullWidthButton("Apply Now (fn + F1 → Dim, fn + F2 → Bright)", kind: .secondary) {
                status = HidUtilService.applyNow(json: Config.mappingJSON())
            }
            fullWidthButton("Reset Mapping", kind: .secondary) {
                status = HidUtilService.applyNow(json: Config.resetJSON())
            }

            // ===== Startup =====
            sectionHeader("Startup")
            fullWidthButton("Install Login Agent", kind: .secondary) {
                do {
                    try LaunchAgentManager.install(mappingJSON: Config.mappingJSON())
                    status = LaunchAgentManager.load()
                } catch {
                    status = "Write agent failed: \(error)"
                }
            }
            fullWidthButton("Remove Agent", kind: .secondary) {
                let a = LaunchAgentManager.unload()
                let b = LaunchAgentManager.remove()
                status = "\(a) \(b)"
            }

            // ===== Status =====
            sectionHeader("Status")
            statusChip(icon: "folder", text: "Agent path: \(LaunchAgentManager.agentPath)")
            statusChip(icon: "checkmark.circle", text: status)

            Divider().padding(.top, 4)

            // Footer / About
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("KB Light").font(.caption).bold()
                    Text("Created by Rashad Rafa • MIT")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Button(action: {
                    if let url = URL(string: "https://paypal.me/reeshy") {
                        NSWorkspace.shared.open(url)
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "heart.fill")
                        Text("Donate")
                    }
                }
                .buttonStyle(FullWidthButtonStyle(kind: .secondary))
                .frame(maxWidth: 120) 
            }
            fullWidthButton("Quit", kind: .secondary) {
                    NSApplication.shared.terminate(nil)
                
                }
        }

        .padding(14)
        .frame(width: 320)
    }
}

// MARK: - Building blocks

private extension MenuView {
    func sectionHeader(_ title: String) -> some View {
        Text(title.uppercased())
            .font(.caption2.weight(.semibold))
            .foregroundColor(.secondary)
            .padding(.top, 2)
    }

    @ViewBuilder
    func fullWidthButton(_ title: String, kind: FullWidthButtonStyle.Kind, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(title).multilineTextAlignment(.leading)
                Spacer(minLength: 0)
            }
        }
        .buttonStyle(FullWidthButtonStyle(kind: kind))
    }

    func statusChip(icon: String, text: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
            Text(text).lineLimit(2)
        }
        .font(.caption)
        .foregroundColor(.secondary)
        .padding(.vertical, 6)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.14))
        )
    }
}

// MARK: - Custom full-width button style (SDK-safe)

struct FullWidthButtonStyle: ButtonStyle {
    enum Kind { case primary, secondary, destructive }

    var kind: Kind = .secondary

    func makeBody(configuration: Configuration) -> some View {
        let pressed = configuration.isPressed

        // Colors per kind
        let bg: Color
        let fg: Color
        let border: Color
        switch kind {
        case .primary:
            bg = pressed ? Color.accentColor.opacity(0.85) : Color.accentColor
            fg = .white
            border = Color.accentColor.opacity(0.9)
        case .secondary:
            bg = pressed ? Color.gray.opacity(0.22) : Color.gray.opacity(0.14)
            fg = .primary
            border = Color.gray.opacity(0.25)
        case .destructive:
            bg = pressed ? Color.red.opacity(0.85) : Color.red.opacity(0.9)
            fg = .white
            border = Color.red.opacity(0.95)
        }

        return HStack {
            configuration.label
                .foregroundColor(fg)
            Spacer(minLength: 0)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity, minHeight: 30, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 8).fill(bg)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8).stroke(border, lineWidth: kind == .secondary ? 1 : 0)
        )
        .animation(.easeInOut(duration: 0.08), value: pressed)
    }
}
