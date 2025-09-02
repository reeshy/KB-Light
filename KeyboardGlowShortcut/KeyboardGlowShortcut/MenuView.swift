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
        VStack(alignment: .leading, spacing: 10) {
            Text("Keyboard Backlight Mapping").font(.headline)

            Group {
                Button("Apply Now (fn + F1 → Dim, fn + F2 → Bright)") {
                    status = HidUtilService.applyNow(json: Config.mappingJSON())
                }
                Button("Reset Now (clear mapping)") {
                    status = HidUtilService.applyNow(json: Config.resetJSON())
                }
            }

            Divider()

            Group {
                Button("Install Login Agent") {
                    do {
                        try LaunchAgentManager.install(mappingJSON: Config.mappingJSON())
                        status = LaunchAgentManager.load()
                    } catch {
                        status = "Write agent failed: \(error)"
                    }
                }
                Button("Remove Agent") {
                    let a = LaunchAgentManager.unload()
                    let b = LaunchAgentManager.remove()
                    status = "\(a) \(b)"
                }
            }

            Divider()
            Text("Agent path: \(LaunchAgentManager.agentPath)").font(.caption).foregroundStyle(.secondary)
            Text("Status: \(status)").font(.caption).foregroundStyle(.secondary)

            Divider()
            Button("Quit") { NSApplication.shared.terminate(nil) }
        }
        .padding(12)
        .frame(width: 320)
    }
}

