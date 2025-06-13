//
//  MarkdownToolbar.swift
//
//
//  Created by Claude on SwiftDown UIKit to SwiftUI conversion.
//

import SwiftUI

public struct MarkdownToolbar: View {
    let onAction: (MarkdownAction) -> Void

    public init(onAction: @escaping (MarkdownAction) -> Void) {
        self.onAction = onAction
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                MarkdownButton("H1") {
                    onAction(.heading(1))
                }

                MarkdownButton("H2") {
                    onAction(.heading(2))
                }

                MarkdownButton("H3") {
                    onAction(.heading(3))
                }

                MarkdownButton(systemImage: "bold") {
                    onAction(.bold)
                }

                MarkdownButton(systemImage: "italic") {
                    onAction(.italic)
                }

                MarkdownButton(systemImage: "list.bullet") {
                    onAction(.unorderedList)
                }

                MarkdownButton(systemImage: "list.number") {
                    onAction(.orderedList)
                }

                MarkdownButton(systemImage: "quote.closing") {
                    onAction(.blockQuote)
                }

                MarkdownButton(systemImage: "link") {
                    onAction(.link)
                }

                MarkdownButton(systemImage: "curlybraces") {
                    onAction(.codeBlock)
                }
            }
            .padding(.horizontal, 16)
        }
        .frame(height: 44)
        .background(.regularMaterial)
    }
}

struct MarkdownButton: View {
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
                        .font(.system(size: 16, weight: .medium))
                } else if let systemImage = systemImage {
                    Image(systemName: systemImage)
                        .font(.system(size: 16, weight: .medium))
                }
            }
            .foregroundColor(.primary)
            .frame(minWidth: 32, minHeight: 32)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#if os(iOS)
#Preview {
    MarkdownToolbar { action in
        print("Action: \(action)")
    }
}
#endif
