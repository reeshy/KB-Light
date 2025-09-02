import SwiftUI

@main
struct KeyboardBacklightMapperApp: App {
    var body: some Scene {
        MenuBarExtra("KB Light", systemImage: "keyboard") {
            MenuView()
        }
        .menuBarExtraStyle(.window)
    }
}
