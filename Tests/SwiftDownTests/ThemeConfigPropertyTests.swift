import Testing
import Foundation

@testable import SwiftDown

@Suite("Theme Config Property Tests")
struct ThemeConfigPropertyTests {
    @Test("Unknown config property")
    func unknownConfigProperty() {
        #expect(ConfigProperty.from(rawValue: "test") == .unknown)
    }
    
    @Test("Unknown editor config property")
    func unknownEditorConfigProperty() {
        #expect(EditorConfigProperty.from(rawValue: "test") == .unknown)
    }
    
    @Test("Unknown style config property")
    func unknownStyleConfigProperty() {
        #expect(StyleConfigProperty.from(rawValue: "test") == .unknown)
    }
    
    @Test("Unknown trait config property")
    func unknownTraitConfigProperty() {
        #expect(TraitConfigProperty.from(rawValue: "test") == .unknown)
    }
}
