//
//  HTML.Document Tests.swift
//  swift-html
//
//  Tests for HTML.Document type and README verification
//

import CSS
import CSS_Standard
import HTML
import HTML_Rendering_TestSupport
import Layout
import StandardsTestSupport
import Testing

enum HTMLDocumentTests {
    #TestSuites
}

extension HTMLDocumentTests.Test {
    @Suite(.snapshots(record: .failed))
    public struct Snapshot {}
}

// MARK: - Unit Tests

extension HTMLDocumentTests.Test.Unit {
    @Test("Basic HTML Generation")
    func basicHtmlGeneration() throws {
        let page = div {
            h1 { "Welcome to swift-html" }
                .css
                .color(.red)
                .fontSize(.rem(2.5))

            p { "Build type-safe web pages with Swift" }
                .css
                .color(.gray800)
                .lineHeight(1.6)
        }

        let bytes: ContiguousArray<UInt8> = .init(page)
        let string: String = String(decoding: bytes, as: UTF8.self)

        #expect(!string.isEmpty)
        #expect(string.contains("Welcome to swift-html"))
        #expect(string.contains("Build type-safe web pages with Swift"))
    }

    @Test("Horizontal Stack")
    func horizontalStack() throws {
        let header = HStack {
            div { "Logo" }
            Spacer()
            div { "Menu" }
        }

        let string = try String(header)

        #expect(!string.isEmpty)
        #expect(string.contains("Logo"))
        #expect(string.contains("Menu"))
    }

    @Test("Vertical Stack")
    func verticalStack() throws {
        let content = VStack {
            div { "Section 1" }
            div { "Section 2" }
        }

        let string = try String(content)

        #expect(!string.isEmpty)
        #expect(string.contains("Section 1"))
        #expect(string.contains("Section 2"))
    }

    @Test("Grid Layout")
    func gridLayout() throws {
        let grid = LazyVGrid(columns: .fractions([1, 2, 1])) {
            div { "Item 1" }
            div { "Item 2" }
            div { "Item 3" }
        }

        let string = try String(grid)

        #expect(!string.isEmpty)
        #expect(string.contains("Item 1"))
        #expect(string.contains("Item 2"))
        #expect(string.contains("Item 3"))
    }

    @Test("Dark Mode Support")
    func darkModeSupport() throws {
        let adaptiveContent = p { "Adaptive text" }
            .css.color(.gray900)
            .css.backgroundColor(DarkModeColor(light: .white, dark: .gray900))

        let string = try String(adaptiveContent)

        #expect(!string.isEmpty)
        #expect(string.contains("Adaptive text"))
    }

    @Test("Reusable Components")
    func reusableComponents() throws {
        let button = _CustomButton(title: "Learn More", href: "/docs")
        let string = try String(button)

        #expect(!string.isEmpty)
        #expect(string.contains("Learn More"))
        #expect(string.contains("/docs"))
    }
}

// Helper type for reusable components test
private struct _CustomButton: HTML.View {
    let title: String
    let href: String

    var body: some HTML.View {
        a(href: .init(rawValue: href)) { title }
            .css
            .display(.inlineBlock)
            .padding(vertical: .rem(0.5), horizontal: .rem(1))
            .css
            .backgroundColor(.blue)
            .color(.white)
            .borderRadius(.px(6))
            .textDecoration(TextDecoration.none)
    }
}

// MARK: - Snapshot Tests

#if canImport(Darwin)
    extension HTMLDocumentTests.Test.Snapshot {
        @Test("Full document example")
        func fullDocumentExample() {
            let page = HTML.Document {
                div {
                    h1 { "Welcome to swift-html" }
                        .css
                        .color(DarkModeColor(light: .red, dark: .red))
                        .fontSize(.rem(2.5))

                    p { "Build beautiful, type-safe web pages with Swift" }
                        .css
                        .color(.gray800)
                        .lineHeight(1.6)

                    a(href: "https://github.com/coenttb/swift-html") {
                        "Get Started →"
                    }
                    .css
                    .padding(.rem(1))
                    .css.backgroundColor(DarkModeColor(light: .yellow, dark: .yellow))
                    .color(.white)
                    .borderRadius(.px(8))
                    .textDecoration(TextDecoration.none)
                }
                .css
                .padding(.rem(2))
                .maxWidth(.px(800))
                .margin(.auto)
            } head: {
                title { "swift-html - Type-safe HTML in Swift" }
                meta(charset: .utf8)
                meta(name: .viewport, content: "width=device-width, initial-scale=1")
            }

            assertInlineSnapshot(
                of: page,
                as: .html
            ) {
                """
                <!doctype html>
                <html>
                  <head>
                    <title>swift-html - Type-safe HTML in Swift
                    </title>
                    <meta charset="utf-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1">
                    <style>
                      .margin-0{margin:auto}
                      .max-width-1{max-width:800px}
                      .padding-2{padding:2rem}
                      .font-size-3{font-size:2.5rem}
                      .color-4{color:#cc3333}
                      .line-height-5{line-height:1.6}
                      .color-7{color:#d0d0d0}
                      .text-decoration-8{text-decoration:none}
                      .border-radius-9{border-radius:8px}
                      .color-10{color:#fff}
                      .background-color-11{background-color:#cccc33}
                      .padding-12{padding:1rem}
                      @media (prefers-color-scheme: dark){
                        .color-6{color:#303030}
                      }
                    </style>
                  </head>
                  <body>
                    <div class="margin-0 max-width-1 padding-2">
                      <h1 class="font-size-3 color-4">Welcome to swift-html
                      </h1>
                      <p class="line-height-5 color-6 color-7">Build beautiful, type-safe web pages with Swift
                      </p><a class="text-decoration-8 border-radius-9 color-10 background-color-11 padding-12" href="https://github.com/coenttb/swift-html">Get Started →</a>
                    </div>
                  </body>
                </html>
                """
            }
        }

        @Test("Button submit example")
        func buttonSubmitExample() {
            assertInlineSnapshot(
                of: HTML_Standard.Button.submit { "Submit Form" },
                as: .html
            ) {
                """
                <button type="submit">Submit Form</button>
                """
            }
        }
    }
#endif
