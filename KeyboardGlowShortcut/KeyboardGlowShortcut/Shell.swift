//
//  Shell.swift
//  KeyboardGlowShortcut
//
//  Created by Rashad Rafa on 2025-09-02.
//


import Foundation

enum Shell {
    @discardableResult
    static func run(_ launchPath: String, _ args: [String]) -> (code: Int32, out: String, err: String) {
        let task = Process()
        task.launchPath = launchPath
        task.arguments = args

        let outPipe = Pipe(), errPipe = Pipe()
        task.standardOutput = outPipe
        task.standardError  = errPipe

        do { try task.run() } catch {
            return (-1, "", "Failed to run \(launchPath): \(error)")
        }
        task.waitUntilExit()

        let out = String(data: outPipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) ?? ""
        let err = String(data: errPipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) ?? ""
        return (task.terminationStatus, out, err)
    }
}
