import Testing
import Foundation

@testable import SwiftDown

@Suite("Theme Tests")
struct ThemeTests {
  @Test("Parse theme colors")
  func parsingTheme() {
    let theme = Theme.BuiltIn.defaultDark.theme()
    #expect(theme.backgroundColor == UniversalColor(hexString: "#1D1F21"))
    #expect(theme.tintColor == UniversalColor(hexString: "#A1A8B5"))
    #expect(theme.cursorColor == UniversalColor(hexString: "#A1A8B5"))
  }
  
  @Test("Parse theme styles")
  func parsingThemeStyles() {
    let theme = Theme.BuiltIn.defaultDark.theme()
    #expect(theme.styles.count == 15)
  }

  #if arch(x86_64)
  @Test("Initialize with non-existing file throws")
  func initNonExistingFile() {
    #expect(throws: (any Error).self) {
      _ = Theme("non_existing_file")
    }
  }
  #endif
}
