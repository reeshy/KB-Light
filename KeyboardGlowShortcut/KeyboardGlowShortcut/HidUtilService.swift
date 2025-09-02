//
//  HidUtilService.swift
//  KeyboardGlowShortcut
//
//  Created by Rashad Rafa on 2025-09-02.
//


import Foundation

enum HidUtilService {
    static func applyNow(json: String) -> String {
        let r = Shell.run("/usr/bin/hidutil", ["property", "--set", json])
        return r.code == 0 ? "Applied mapping (hidutil)." : "hidutil failed (\(r.code)): \(r.err.isEmpty ? r.out : r.err)"
    }
}
