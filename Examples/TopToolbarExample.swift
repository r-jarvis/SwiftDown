//
//  TopToolbarExample.swift
//  SwiftDown Example with Top Toolbar
//
//
//  Created by Claude on SwiftDown UIKit to SwiftUI conversion.
//

import SwiftUI
import SwiftDown

struct TopToolbarExample: View {
    @State private var text = """
# Welcome to SwiftDown!

This is a **markdown** editor with a SwiftUI toolbar at the top.

- List item 1
- List item 2

> This is a blockquote

```swift
let code = "syntax highlighting works too!"
```

Try the toolbar buttons above to format your text!
"""
    
    var body: some View {
        NavigationView {
            VStack {
                // New way: SwiftUI toolbar at top
                SwiftDownEditor(text: $text)
                    .hasTopToolbar(true)
                    .theme(Theme.BuiltIn.defaultDark.theme())
                    .padding()
            }
            .navigationTitle("SwiftDown with Top Toolbar")
        }
    }
}

struct KeyboardToolbarExample: View {
    @State private var text = "# Traditional Editor\n\nThis uses the keyboard toolbar like before."
    
    var body: some View {
        NavigationView {
            VStack {
                // Original way: keyboard toolbar
                SwiftDownEditor(text: $text)
                    .hasKeyboardToolbar(true)
                    .theme(Theme.BuiltIn.defaultLight.theme())
                    .padding()
            }
            .navigationTitle("SwiftDown with Keyboard Toolbar")
        }
    }
}

#Preview("Top Toolbar") {
    TopToolbarExample()
}

#Preview("Keyboard Toolbar") {
    KeyboardToolbarExample()
}