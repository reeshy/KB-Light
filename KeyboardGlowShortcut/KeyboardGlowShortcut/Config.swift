//
//  Config.swift
//  KeyboardGlowShortcut
//
//  Created by Rashad Rafa on 2025-09-02.
//


import Foundation

enum Config {
   
    static let SRC_F2 = "0x70000003A" // F2
    static let SRC_F1 = "0x70000003B" // F1

    static let DST_DIM = "0xFF00000008" // illumination_decrement
    static let DST_BRT = "0xFF00000009" // illumination_increment

    // LaunchAgent
    static let agentLabel = "com.local.KeyBacklightMapping"
    static let agentDir: String = ("~/Library/LaunchAgents" as NSString).expandingTildeInPath
    static let agentPath: String = (agentDir as NSString).appendingPathComponent("\(agentLabel).plist")

    static func mappingJSON() -> String {
        """
        {"UserKeyMapping":[
            {"HIDKeyboardModifierMappingSrc": \(SRC_F1), "HIDKeyboardModifierMappingDst": \(DST_DIM)},
            {"HIDKeyboardModifierMappingSrc": \(SRC_F2), "HIDKeyboardModifierMappingDst": \(DST_BRT)}
        ]}
        """
    }

    static func resetJSON() -> String { #"{"UserKeyMapping":[]}"# }
}
