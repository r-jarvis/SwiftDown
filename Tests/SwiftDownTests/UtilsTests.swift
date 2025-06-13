import Testing
import Foundation

@testable import SwiftDown

@Suite("Utils Tests")
struct UtilsTests {
    @Test("Color from 12-bit hex")
    func colorFrom12bitsHexa() {
        let color = UniversalColor(hexString: "#E0D")
        #expect(color == UniversalColor(red: 238/255, green: 0, blue: 221/255, alpha: 1))
    }
    
    @Test("Color from 24-bit hex")
    func colorFrom24bitsHexa() {
        let color = UniversalColor(hexString: "#F703EC")
        #expect(color == UniversalColor(red: 247/255, green: 3/255, blue: 236/255, alpha: 1))
    }
    
    @Test("Color from 32-bit hex")
    func colorFrom32bitsHexa() {
        let color = UniversalColor(hexString: "#FF8D73AD")
        #expect(color == UniversalColor(red: 141/255, green: 115/255, blue: 173/255, alpha: 1))
    }
    
    @Test("Color from hex fallback")
    func colorFromHexaFallback() {
        let color = UniversalColor(hexString: "#F3")
        #expect(color == UniversalColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1))
    }
    
    @Test("NSRange from Range")
    func nsRangeFromRange() {
        let string = "Test string"
        let range = string.range(of: "str")
        let nsRange = string.nsRange(from: range!)
        #expect(nsRange == NSRange(location: 5, length: 3))
    }
    
    @Test("Range from NSRange")
    func rangeFromNSRange() {
        let string = "Test string"
        let nsRange = NSRange(location: 5, length: 3)
        let range = string.range(from: nsRange)
        let expectedRange = string.range(of: "str")
        #expect(range == expectedRange)
    }
    
    @Test("Get paragraph")
    func getParagraph() {
        let string = "Test string \n\n Test string second line \n\n Test string third line"
        let range = NSRange(location: 29, length: 6)
        let paragraphRange = string.paragraph(for: range)
        #expect(paragraphRange == NSRange(location: 14, length: 25))
    }
    
    @Test("Get first paragraph")
    func getParagraphFirstParagraph() {
        let string = "Test string \n\n Test string second line \n\n Test string third line"
        let range = NSRange(location: 5, length: 6)
        let paragraphRange = string.paragraph(for: range)
        #expect(paragraphRange == NSRange(location: 0, length: 12))
    }
    
    @Test("Get last paragraph")
    func getParagraphLastParagraph() {
        let string = "Test string \n\n Test string second line \n\n Test string third line"
        let range = NSRange(location: 51, length: 6)
        let paragraphRange = string.paragraph(for: range)
        #expect(paragraphRange == NSRange(location: 41, length: 23))
    }
    
    @Test("Get paragraph with nil range")
    func getParagraphRangeNil() {
        let string = "Test string \n\n Test string second line \n\n Test string third line"
        let range = string.paragraph(for: nil)
        #expect(range == NSRange(location: 0, length: string.utf16.count))
    }
    
    @Test("Font from traits and size")
    func fontFromTraitsAndSize() {
        let font = UniversalFont.systemFont(ofSize: 14)
        let updatedFont = font.with(traits: "bold", size: 16)
        #expect(updatedFont?.fontDescriptor.pointSize == 16)
        #expect(updatedFont?.fontDescriptor.symbolicTraits.rawValue == font.fontDescriptor.symbolicTraits.rawValue + UniversalFontDescriptor.SymbolicTraits.bold.rawValue)
    }
    
    @Test("Font from traits and size with unknown traits")
    func fontFromTraitsAndSizeWithUnknownTraits() {
        let font = UniversalFont.systemFont(ofSize: 14)
        let updatedFont = font.with(traits: "test", size: 16)
        #expect(updatedFont?.fontDescriptor.pointSize == 16)
        #expect(updatedFont?.fontDescriptor.symbolicTraits.rawValue == font.fontDescriptor.symbolicTraits.rawValue)
    }
}
