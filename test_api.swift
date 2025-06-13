import SwiftUI
import SwiftDown

// Test the API works
struct TestView: View {
    @State private var text = "# Test"
    
    var body: some View {
        SwiftDownEditor(text: $text)
            .hasTopToolbar(true)
    }
}