//
//  MarkdownKeyboardToolbarSwiftUI.swift
//
//
//  Created by Claude on SwiftUI keyboard toolbar implementation.
//

import SwiftUI

/// SwiftUI implementation of markdown keyboard toolbar
/// Replaces the UIKit-based MarkdownKeyboardToolbar for a unified SwiftUI experience
@available(iOS 15.0, *)
public struct MarkdownKeyboardToolbarSwiftUI: ToolbarContent {
    let onAction: (MarkdownAction) -> Void
    
    public init(onAction: @escaping (MarkdownAction) -> Void) {
        self.onAction = onAction
    }
    
    public var body: some ToolbarContent {
        ToolbarItemGroup(placement: .keyboard) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    KeyboardToolbarButton("H1") {
                        onAction(.heading(1))
                    }
                    
                    KeyboardToolbarButton("H2") {
                        onAction(.heading(2))
                    }
                    
                    KeyboardToolbarButton("H3") {
                        onAction(.heading(3))
                    }
                    
                    KeyboardToolbarButton(systemImage: "bold") {
                        onAction(.bold)
                    }
                    
                    KeyboardToolbarButton(systemImage: "italic") {
                        onAction(.italic)
                    }
                    
                    KeyboardToolbarButton(systemImage: "list.bullet") {
                        onAction(.unorderedList)
                    }
                    
                    KeyboardToolbarButton(systemImage: "list.number") {
                        onAction(.orderedList)
                    }
                    
                    KeyboardToolbarButton(systemImage: "quote.closing") {
                        onAction(.blockQuote)
                    }
                    
                    KeyboardToolbarButton(systemImage: "link") {
                        onAction(.link)
                    }
                    
                    KeyboardToolbarButton(systemImage: "curlybraces") {
                        onAction(.codeBlock)
                    }
                }
                .padding(.horizontal, 12)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

/// Specialized button for keyboard toolbar with compact design
struct KeyboardToolbarButton: View {
    let title: String?
    let systemImage: String?
    let action: () -> Void
    
    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.systemImage = nil
        self.action = action
    }
    
    init(systemImage: String, action: @escaping () -> Void) {
        self.title = nil
        self.systemImage = systemImage
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Group {
                if let title = title {
                    Text(title)
                        .font(.system(size: 14, weight: .medium))
                } else if let systemImage = systemImage {
                    Image(systemName: systemImage)
                        .font(.system(size: 14, weight: .medium))
                }
            }
            .foregroundColor(.primary)
            .frame(minWidth: 28, minHeight: 28)
            .background(Color(UIColor.tertiarySystemFill))
            .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#if os(iOS)
@available(iOS 15.0, *)
#Preview {
    NavigationView {
        VStack {
            TextEditor(text: .constant("# Sample Markdown\n\nEdit with keyboard toolbar below"))
                .padding()
        }
        .toolbar {
            MarkdownKeyboardToolbarSwiftUI { action in
                print("Keyboard action: \(action)")
            }
        }
    }
}
#endif