# KB Light

A lightweight macOS menu bar utility to control your MacBook keyboard backlight brightness using **fn + F1/F2** (dim/bright) and manage a persistent mapping via a login agent.

---

## ✨ Features

- **One-click mapping** of `fn + F1` to **Dim** and `fn + F2` to **Bright**
- **Install Login Agent** to make mapping persist after restart
- **Reset Mapping** to restore default keys
- **Status display** showing current mapping and agent installation
- **Lightweight** SwiftUI app – no kernel extensions or background daemons
- **Donate** button to support development

---

## 📦 Installation

### Download prebuilt `.dmg`
1. Go to the [Latest Release](https://github.com/reeshy/KeyboardGlowShortcut/releases/latest).
2. Download the `.dmg` file.
3. Drag **KB Light.app** to your `Applications` folder.
4. Launch it from Applications or Spotlight.

> **Note:** If macOS says "App can't be opened", go to  
> `System Settings → Privacy & Security → Security` and click **Allow Anyway**.

---

## 🛠 Build from source

1. Clone this repository:
   ```bash
   git clone https://github.com/reeshy/KeyboardGlowShortcut.git
   cd KeyboardGlowShortcut
Open KB Light.xcodeproj in Xcode.
Build & run (⌘R).
📖 Usage
Apply Now – Apply the key mapping immediately.
Reset Mapping – Remove all custom mappings.
Install Login Agent – Make the mapping load automatically at login.
Remove Agent – Remove the login agent.
💻 System Requirements
macOS Monterey (12) or newer
MacBook with a backlit keyboard
🤝 Contributing
Pull requests and feature suggestions are welcome!
For major changes, please open an issue first to discuss.
☕ Support Development
If you find KB Light useful, you can support development here:
📜 License
This project is licensed under the MIT License – see LICENSE for details.
