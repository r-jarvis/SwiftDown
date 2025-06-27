//
//  TopToolbarExample.swift
//  SwiftDown Example with Top Toolbar
//
//
//  Created by Claude on SwiftDown UIKit to SwiftUI conversion.
//

import SwiftUI
import SwiftDown

struct SwiftDownExample: View {
    @State private var text = """
# Welcome to SwiftDown!

This is a **markdown** editor with an always-visible toolbar.

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
                SwiftDownEditor(text: $text)
                    .theme(Theme.BuiltIn.defaultDark.theme())
                    .padding()
            }
            .navigationTitle("SwiftDown Editor")
        }
    }
}

struct SwiftDownLightExample: View {
    @State private var text = "# Light Theme Example\n\nThis demonstrates the light theme with the always-visible toolbar."
    
    var body: some View {
        NavigationView {
            VStack {
                SwiftDownEditor(text: $text)
                    .theme(Theme.BuiltIn.defaultLight.theme())
                    .padding()
            }
            .navigationTitle("SwiftDown Light Theme")
        }
    }
}

#Preview("Dark Theme") {
    SwiftDownExample()
}

#Preview("Light Theme") {
    SwiftDownLightExample()
}