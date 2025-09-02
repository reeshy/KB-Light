//
//  LaunchAgentManager.swift
//  KeyboardGlowShortcut
//
//  Created by Rashad Rafa on 2025-09-02.
//


import Foundation

enum LaunchAgentManager {
    static var agentPath: String { Config.agentPath }

    static func makePlist(mappingJSON: String) -> String {
        """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0"><dict>
            <key>Label</key><string>\(Config.agentLabel)</string>
            <key>ProgramArguments</key>
            <array>
                <string>/usr/bin/hidutil</string>
                <string>property</string>
                <string>--set</string>
                <string>\(mappingJSON.replacingOccurrences(of: "\"", with: "\\\""))</string>
            </array>
            <key>RunAtLoad</key><true/>
        </dict></plist>
        """
    }

    static func write(_ content: String, to path: String) throws {
        try FileManager.default.createDirectory(
            atPath: (path as NSString).deletingLastPathComponent,
            withIntermediateDirectories: true
        )
        try content.data(using: .utf8)!.write(to: URL(fileURLWithPath: path), options: .atomic)
    }

    static func install(mappingJSON: String) throws {
        try write(makePlist(mappingJSON: mappingJSON), to: Config.agentPath)
    }

    @discardableResult
    static func load() -> String {
        let r = Shell.run("/bin/launchctl", ["load", Config.agentPath])
        return r.code == 0 ? "Agent loaded." : "launchctl load failed (\(r.code)): \(r.err.isEmpty ? r.out : r.err)"
    }

    @discardableResult
    static func unload() -> String {
        let r = Shell.run("/bin/launchctl", ["unload", Config.agentPath])
        return r.code == 0 ? "Agent unloaded." : "launchctl unload: \(r.err.isEmpty ? r.out : r.err)"
    }

    @discardableResult
    static func remove() -> String {
        if FileManager.default.fileExists(atPath: Config.agentPath) {
            do { try FileManager.default.removeItem(atPath: Config.agentPath); return "Agent plist removed." }
            catch { return "Failed to remove agent plist: \(error)" }
        }
        return "No agent plist to remove."
    }
}
