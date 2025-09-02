import SwiftUI

// MARK: - Konfiguration
fileprivate let SRC_F2:  String = "0x70000003A" // F1
fileprivate let SRC_F1:  String = "0x70000003B" // F2
fileprivate let DST_DIM: String = "0xFF00000008" // illumination_decrement
fileprivate let DST_BRT: String = "0xFF00000009" // illumination_increment

// LaunchAgent
fileprivate let agentLabel   = "com.local.KeyBacklightMapping"
fileprivate let agentDir     = ("~/Library/LaunchAgents" as NSString).expandingTildeInPath
fileprivate let agentPath    = (agentDir as NSString).appendingPathComponent("\(agentLabel).plist")

// JSON for hidutil (UserKeyMapping)
fileprivate func mappingJSON() -> String {
    // F1 -> DIM, F2 -> BRIGHT
    return """
    {"UserKeyMapping":[
        {"HIDKeyboardModifierMappingSrc": \(SRC_F1), "HIDKeyboardModifierMappingDst": \(DST_DIM)},
        {"HIDKeyboardModifierMappingSrc": \(SRC_F2), "HIDKeyboardModifierMappingDst": \(DST_BRT)}
    ]}
    """
}

// Empty mapping = reset
fileprivate func resetJSON() -> String {
    return "{\"UserKeyMapping\":[]}"
}

// Helper: run commando and return (exitCode, stdout, stderr)
@discardableResult
fileprivate func run(_ launchPath: String, _ args: [String]) -> (Int32, String, String) {
    let task = Process()
    task.launchPath = launchPath
    task.arguments = args

    let outPipe = Pipe(); task.standardOutput = outPipe
    let errPipe = Pipe(); task.standardError = errPipe

    do { try task.run() } catch {
        return (-1, "", "Failed to run \(launchPath): \(error)")
    }
    task.waitUntilExit()

    let out = String(data: outPipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) ?? ""
    let err = String(data: errPipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) ?? ""
    return (task.terminationStatus, out, err)
}

// Apply mapping now (omedelbar effekt)
fileprivate func applyNow(json: String) -> String {
    let (code, out, err) = run("/usr/bin/hidutil", ["property", "--set", json])
    if code == 0 {
        return "Applied mapping (hidutil)."
    } else {
        return "hidutil failed (\(code)): \(err.isEmpty ? out : err)"
    }
}

// Create LaunchAgent-plist
fileprivate func makeAgentPlist(json: String) -> String {
    let plist = """
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>Label</key>
        <string>\(agentLabel)</string>
        <key>ProgramArguments</key>
        <array>
            <string>/usr/bin/hidutil</string>
            <string>property</string>
            <string>--set</string>
            <string>\(json.replacingOccurrences(of: "\"", with: "\\\""))</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
    </dict>
    </plist>
    """
    return plist
}

// Write file
fileprivate func write(_ content: String, to path: String) throws {
    try FileManager.default.createDirectory(atPath: (path as NSString).deletingLastPathComponent, withIntermediateDirectories: true)
    try content.data(using: .utf8)!.write(to: URL(fileURLWithPath: path), options: .atomic)
}

// launchctl load
fileprivate func loadAgent() -> String {
    let (code, out, err) = run("/bin/launchctl", ["load", agentPath])
    if code == 0 { return "Agent loaded." }
    return "launchctl load failed (\(code)): \(err.isEmpty ? out : err)"
}

// launchctl unload
fileprivate func unloadAgent() -> String {
    let (code, out, err) = run("/bin/launchctl", ["unload", agentPath])
    if code == 0 { return "Agent unloaded." }
    return "launchctl unload: \(err.isEmpty ? out : err)"
}

// Remove agentfile
fileprivate func removeAgentFile() -> String {
    if FileManager.default.fileExists(atPath: agentPath) {
        do { try FileManager.default.removeItem(atPath: agentPath); return "Agent plist removed." }
        catch { return "Failed to remove agent plist: \(error)" }
    }
    return "No agent plist to remove."
}

// MARK: - UI

@main
struct KeyboardBacklightMapperApp: App {
    var body: some Scene {
        MenuBarExtra("KB Light", systemImage: "keyboard") {
            MenuView()
        }
        .menuBarExtraStyle(.window)
    }
}

struct MenuView: View {
    @State private var status = "Ready"

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Keyboard Backlight Mapping").font(.headline)

            Group {
                Button("Apply Now (F1 → Dim, F2 → Bright)") {
                    status = applyNow(json: mappingJSON())
                }
                Button("Reset Now (clear mapping)") {
                    status = applyNow(json: resetJSON())
                }
            }

            Divider()

            Group {
                Button("Install Login Agent") {
                    do {
                        let plist = makeAgentPlist(json: mappingJSON())
                        try write(plist, to: agentPath)
                        status = loadAgent()
                    } catch {
                        status = "Write agent failed: \(error)"
                    }
                }
                Button("Remove Agent") {
                    let a = unloadAgent()
                    let b = removeAgentFile()
                    status = "\(a) \(b)"
                }
            }

            Divider()
            Text("Agent path: \(agentPath)").font(.caption).foregroundStyle(.secondary)
            Text("Status: \(status)").font(.caption).foregroundStyle(.secondary)

            Divider()
            Button("Quit") { NSApplication.shared.terminate(nil) }
        }
        .padding(12)
        .frame(width: 320)
    }
}
