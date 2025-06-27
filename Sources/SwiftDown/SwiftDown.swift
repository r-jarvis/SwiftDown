//
//  SwiftDown.swift
//
//
//  Created by Quentin Eude on 16/03/2021.
//

// MARK: - Shared Types
public enum MarkdownAction {
    case heading(Int)
    case bold
    case italic
    case unorderedList
    case orderedList
    case blockQuote
    case link
    case codeBlock
}

#if os(iOS)
import UIKit

// MARK: - SwiftDown iOS
public class SwiftDown: UITextView, UITextViewDelegate {
    var storage: Storage = Storage()
    var highlighter: SwiftDownHighlighter?

    convenience init(frame: CGRect, theme: Theme) {
        self.init(frame: frame, textContainer: nil)
        self.storage.theme = theme
        self.backgroundColor = theme.backgroundColor
        self.tintColor = theme.tintColor
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        let layoutManager = NSLayoutManager()
        let containerSize = CGSize(width: frame.size.width, height: frame.size.height)
        let container = NSTextContainer(size: containerSize)
        container.widthTracksTextView = true

        layoutManager.addTextContainer(container)
        storage.addLayoutManager(layoutManager)
        super.init(frame: frame, textContainer: container)
        self.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let layoutManager = NSLayoutManager()
        let containerSize = CGSize(width: frame.size.width, height: CGFloat.greatestFiniteMagnitude)
        let container = NSTextContainer(size: containerSize)
        container.widthTracksTextView = true
        layoutManager.addTextContainer(container)
        storage.addLayoutManager(layoutManager)
        self.delegate = self
    }

    public override func willMove(toSuperview newSuperview: UIView?) {
        Task { @MainActor in
            self.highlighter = SwiftDownHighlighter(textView: self)
        }
    }

    // MARK: - Public Markdown Actions for SwiftUI Integration
    public func performMarkdownAction(_ action: MarkdownAction) {
        switch action {
        case .heading(1):
            h1Action()
        case .heading(2):
            h2Action()
        case .heading(3):
            h3Action()
        case .heading:
            break // Only support H1-H3
        case .bold:
            boldAction()
        case .italic:
            italicizeAction()
        case .unorderedList:
            unorderedListAction()
        case .orderedList:
            orderedListAction()
        case .blockQuote:
            blockQuoteAction()
        case .link:
            linkAction()
        case .codeBlock:
            codeBlockAction()
        }
    }
    
    // MARK: - Markdown Action Methods
    /// Moves the cursor position after the inserted characters
    @objc internal func h1Action() {
        let selectedStart = self.selectedStart
        self.text.insert(contentsOf: "# ", at: self.text.index(self.text.startIndex, offsetBy: selectedStart))
        self.moveCursor(selectedStart + 2)
        self.highlighter?.applyStyles()
    }

    /// Moves the cursor position after the inserted characters
    @objc internal func h2Action() {
        let selectedStart = self.selectedStart
        self.text.insert(contentsOf: "## ", at: self.text.index(self.text.startIndex, offsetBy: selectedStart))
        self.moveCursor(selectedStart + 3)
        self.highlighter?.applyStyles()
    }

    /// Moves the cursor position after the inserted characters
    @objc internal func h3Action() {
        let selectedStart = self.selectedStart
        self.text.insert(contentsOf: "### ", at: self.text.index(self.text.startIndex, offsetBy: selectedStart))
        self.moveCursor(selectedStart + 4)
        self.highlighter?.applyStyles()
    }

    /// If text is selected, surrounds the selected text with the bold tags
    /// Moves the cursor to the end of the selected text, if applicable
    @objc internal func boldAction() {
        let selectedStart = self.selectedStart
        let selectedEnd = self.selectedEnd
        self.text.insert(contentsOf: "**", at: self.text.index(self.text.startIndex, offsetBy: selectedStart))
        self.text.insert(contentsOf: "**", at: self.text.index(self.text.startIndex, offsetBy: selectedEnd + 2))
        self.moveCursor(selectedEnd + 2)
        self.highlighter?.applyStyles()
    }

    /// If text is selected, surrounds the selected text with the italic tags
    /// Moves the cursor to the end of the selected text, if applicable
    @objc internal func italicizeAction() {
        let selectedStart = self.selectedStart
        let selectedEnd = self.selectedEnd
        self.text.insert(contentsOf: "*", at: self.text.index(self.text.startIndex, offsetBy: selectedStart))
        self.text.insert(contentsOf: "*", at: self.text.index(self.text.startIndex, offsetBy: selectedEnd + 1))
        self.moveCursor(selectedEnd + 1)
        self.highlighter?.applyStyles()
    }

    /// Adds 1 leading line break
    @objc internal func unorderedListAction() {
        let selectedStart = self.selectedStart
        self.text.insert(contentsOf: "\n- ", at: self.text.index(self.text.startIndex, offsetBy: selectedStart))
        self.moveCursor(selectedStart + 3)
        self.highlighter?.applyStyles()
    }

    /// Adds 1 leading line break
    @objc internal func orderedListAction() {
        let selectedStart = self.selectedStart
        self.text.insert(contentsOf: "\n1. ", at: self.text.index(self.text.startIndex, offsetBy: selectedStart))
        self.moveCursor(selectedStart + 3)
        self.highlighter?.applyStyles()
    }

    @objc internal func blockQuoteAction() {
        let selectedStart = self.selectedStart
        self.text.insert(contentsOf: "> ", at: self.text.index(self.text.startIndex, offsetBy: selectedStart))
        self.highlighter?.applyStyles()
    }

    /// If text is selected, it is checked if it contains a link
    ///   If a link is detected, the selected text is placed inside the braces
    ///   If a link is not detected, the selected text is placed inside the parenthesis
    /// Moves the cursor into the text bracket or parenthesis as applicable
    @objc internal func linkAction() {
        let selectedStart = self.selectedStart
        let selectedEnd = self.selectedEnd
        if self.containsLink {
            self.text.insert(
                contentsOf: "[](",
                at: self.text.index(self.text.startIndex, offsetBy: selectedStart)
            )
            self.text.insert(
                contentsOf: ")",
                at: self.text.index(self.text.startIndex, offsetBy: selectedEnd + 3)
            )
            self.moveCursor(selectedStart + 1)
        } else {
            self.text.insert(
                contentsOf: "[",
                at: self.text.index(self.text.startIndex, offsetBy: selectedStart)
            )
            self.text.insert(
                contentsOf: "]()",
                at: self.text.index(self.text.startIndex, offsetBy: selectedEnd + 1)
            )
            self.moveCursor(selectedEnd + 3)
        }
        self.highlighter?.applyStyles()
    }

    /// If text is selected, moves the selected text inside the code block
    /// Moves the cursor into the code block at the end of the selected text, if applicable
    @objc internal func codeBlockAction() {
        let selectedStart = self.selectedStart
        let selectedEnd = self.selectedEnd
        self.text.insert(
            contentsOf: "```\n",
            at: self.text.index(self.text.startIndex, offsetBy: selectedStart)
        )
        self.text.insert(
            contentsOf: "\n```",
            at: self.text.index(self.text.startIndex, offsetBy: selectedEnd + 4)
        )
        self.moveCursor(selectedEnd + 4)
        self.highlighter?.applyStyles()
    }
}

/// Extends UITextView to provide cursor helper methods
extension UITextView {
    /// Get selected text range start position
    var selectedStart: Int {
        guard let selectedRange = self.selectedTextRange else {
            return 0
        }
        return self.offset(from: self.beginningOfDocument, to: selectedRange.start)
    }

    /// Get selected text range end position
    var selectedEnd: Int {
        guard let selectedRange = self.selectedTextRange else {
            return 0
        }
        return self.offset(from: self.beginningOfDocument, to: selectedRange.end)
    }

    /// Move cursor by the given offset
    func moveCursor(_ offset: Int = 1) {
        guard let newPosition = self.position(from: self.beginningOfDocument, offset: offset) else {
            return
        }
        self.selectedTextRange = self.textRange(from: newPosition, to: newPosition)
    }

    /// Validate if the selected text range contains a link
    var containsLink: Bool {
        guard let selectedTextRange = self.selectedTextRange,
            let selectedText = self.text(in: selectedTextRange) else {
            return false
        }
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let matches = detector.matches(
                in: selectedText, options: [],
                range: NSRange(location: 0, length: selectedText.utf16.count)
            )
            return !matches.isEmpty
        } catch {
            return false
        }
    }
}
#else
import AppKit

// MARK: - CustomTextView
class CustomTextView: NSTextView {
    var storage: Storage = Storage()

    convenience init(frame: CGRect, theme: Theme) {
        self.init(frame: frame, textContainer: nil)
        self.storage.theme = theme
        self.backgroundColor = theme.backgroundColor
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        let layoutManager = NSLayoutManager()
        let containerSize = CGSize(width: frame.size.width, height: CGFloat.greatestFiniteMagnitude)
        let container = NSTextContainer(size: containerSize)
        container.widthTracksTextView = true

        layoutManager.addTextContainer(container)
        storage.addLayoutManager(layoutManager)
        super.init(frame: frame, textContainer: container)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SwiftDown macOS
class TransparentBackgroundScroller: NSScroller {
    override func draw(_ dirtyRect: NSRect) {
        self.drawKnob()
    }
}

public class SwiftDown: NSView {
    var theme: Theme
    private var isEditable: Bool
    private var insetsSize: CGFloat

    weak var delegate: NSTextViewDelegate? {
        didSet {
            textView.delegate = delegate
        }
    }

    let engine = MarkdownEngine()
    var highlighter: SwiftDownHighlighter!

    var text: String {
        didSet {
            textView.string = text
        }
    }

    var selectedRanges: [NSValue] {
        get {
            textView.selectedRanges
        }
        set(value) {
            textView.selectedRanges = value
        }
    }

    // MARK: - ScrollView setup
    private lazy var scrollView: NSScrollView = {
        let scrollView = NSScrollView()
        scrollView.drawsBackground = true
        scrollView.borderType = .noBorder
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalRuler = false
        scrollView.autoresizingMask = [.width, .height]
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.autohidesScrollers = true
        scrollView.borderType = .noBorder
        scrollView.verticalScroller = TransparentBackgroundScroller()
        return scrollView
    }()

    // MARK: - TextView setup
    private lazy var textView: NSTextView = {
        let contentSize = scrollView.contentSize
        let textView = CustomTextView(frame: scrollView.frame, theme: theme)
        textView.delegate = self.delegate
        textView.string = text
        textView.storage.markdowner = { self.engine.render($0, offset: $1) }
        textView.storage.applyMarkdown = { m in Theme.applyMarkdown(markdown: m, with: self.theme) }
        textView.storage.applyBody = { Theme.applyBody(with: self.theme) }
        textView.storage.theme = theme
        textView.autoresizingMask = .width
        textView.drawsBackground = true
        textView.isEditable = self.isEditable
        textView.isHorizontallyResizable = false
        textView.isVerticallyResizable = true
        textView.maxSize = NSSize(
            width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        textView.minSize = NSSize(width: 0, height: contentSize.height)
        textView.textContainerInset = NSSize(width: self.insetsSize, height: self.insetsSize)
        textView.allowsUndo = true
        textView.allowsDocumentBackgroundColorChange = true
        textView.backgroundColor = theme.backgroundColor
        textView.insertionPointColor = theme.cursorColor
        textView.textColor = theme.tintColor
        return textView
    }()

    init(
        theme: Theme, isEditable: Bool, insetsSize: CGFloat = 0
    ) {
        self.isEditable = isEditable
        self.text = ""
        self.theme = theme
        self.insetsSize = insetsSize

        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewWillDraw() {
        super.viewWillDraw()

        setupScrollViewConstraints()
        setupTextView()
    }

    func setupScrollViewConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }

    @MainActor
    func setupTextView() {
        scrollView.documentView = textView
        highlighter = SwiftDownHighlighter(textView: textView)
    }

    @MainActor
    func applyStyles() {
        assert(highlighter != nil)
        highlighter.applyStyles()
    }

    // MARK: - Markdown Actions Stub (macOS doesn't have toolbar)
    public func performMarkdownAction(_ action: MarkdownAction) {
        // No-op for macOS - this is primarily for iOS SwiftUI toolbar integration
        // macOS uses standard keyboard shortcuts and menu items
    }
}
#endif
