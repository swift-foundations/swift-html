//
//  HTML.Document Tests.swift
//  swift-html
//
//  Snapshot tests for HTML.Document type
//

import CSS
import CSS_Standard
import HTML
import HTML_Rendering_Core_Test_Support
import Testing

@Suite(.snapshots(record: .missing))
struct HTMLDocumentSnapshotTests {
    @Test
    func `full document example`() {
        snapshot(as: .html) {
            HTML.Document {
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
                        "Get Started"
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
        } matches: {
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
                  </p><a class="text-decoration-8 border-radius-9 color-10 background-color-11 padding-12" href="https://github.com/coenttb/swift-html">Get Started</a>
                </div>
              </body>
            </html>
            """
        }
    }

    @Test
    func `button submit example`() {
        snapshot(as: .html) {
            HTML_Standard.Button.submit { "Submit Form" }
        } matches: {
            """
            <button type="submit">Submit Form</button>
            """
        }
    }
}
