import SwiftUI

@main
struct KeyboardBacklightMapperApp: App {
    var body: some Scene {
        MenuBarExtra("KB Light", systemImage: "light.max") {
            MenuView()
        }
        .menuBarExtraStyle(.window)
    }
}
