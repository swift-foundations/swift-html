//
//  CSS Tests.swift
//  swift-html
//
//  Snapshot tests for CSS fluent chaining pattern and CSS properties
//

import CSS
import CSS_Standard
import HTML
import HTML_Rendering_Core_Test_Support
import Testing

@Suite(.snapshots(record: .missing))
struct CSSSnapshotTests {
    @Test
    func `fluent chaining without repeated css calls`() {
        snapshot(as: .html) {
            HTML.Document {
                div {
                    "Styled content"
                }
                .css
                .display(.flex)
                .padding(.px(16))
                .margin(.px(8))
            }
        }  matches: {
            """
            <!doctype html>
            <html>
              <head>
                <style>
                  .margin-0{margin:8px}
                  .padding-1{padding:16px}
                  .display-2{display:flex}
                </style>
              </head>
              <body>
                <div class="margin-0 padding-1 display-2">Styled content
                </div>
              </body>
            </html>
            """
        }
    }

    @Test
    func `multiple CSS properties chained fluently`() {
        snapshot(as: .html) {
            HTML.Document {
                div {
                    "Card"
                }
                .css
                .display(.flex)
                .flexDirection(.column)
                .alignItems(.center)
                .justifyContent(.center)
                .padding(.px(24))
                .borderRadius(.px(8))
                .css.backgroundColor(DarkModeColor(light: .white, dark: .hex("1a1a1a")))
            }
        } matches: {
            """
            <!doctype html>
            <html>
              <head>
                <style>
                  .background-color-1{background-color:#FFFFFF}
                  .border-radius-2{border-radius:8px}
                  .padding-3{padding:24px}
                  .justify-content-4{justify-content:center}
                  .align-items-5{align-items:center}
                  .flex-direction-6{flex-direction:column}
                  .display-7{display:flex}
                  @media (prefers-color-scheme: dark){
                    .background-color-0{background-color:#1a1a1a}
                  }
                </style>
              </head>
              <body>
                <div class="background-color-0 background-color-1 border-radius-2 padding-3 justify-content-4 align-items-5 flex-direction-6 display-7">Card
                </div>
              </body>
            </html>
            """
        }
    }

    @Test
    func `CSS namespace with media queries`() {
        snapshot(as: .html) {
            HTML.Document {
                div {
                    "Responsive"
                }
                .css
                .display(.block)
                .padding(.px(8))
                .media(.minWidth(.px(768))) {
                    $0.display(.flex)
                        .padding(.px(16))
                }
            }
        } matches: {
            """
            <!doctype html>
            <html>
              <head>
                <style>
                  .padding-2{padding:8px}
                  .display-3{display:block}
                  @media (min-width: 768px){
                    .padding-0{padding:16px}
                    .display-1{display:flex}
                  }
                </style>
              </head>
              <body>
                <div class="padding-0 display-1 padding-2 display-3">Responsive
                </div>
              </body>
            </html>
            """
        }
    }

    @Test
    func `position properties via CSS namespace`() {
        snapshot(as: .html) {
            HTML.Document {
                div {
                    "Positioned"
                }
                .css
                .position(.absolute)
                .top(.px(0))
                .right(.px(0))
                .bottom(.auto)
                .left(.auto)
                .zIndex(.init(10))
            }
        } matches: {
            """
            <!doctype html>
            <html>
              <head>
                <style>
                  .z-index-0{z-index:10}
                  .left-1{left:auto}
                  .bottom-2{bottom:auto}
                  .right-3{right:0px}
                  .top-4{top:0px}
                  .position-5{position:absolute}
                </style>
              </head>
              <body>
                <div class="z-index-0 left-1 bottom-2 right-3 top-4 position-5">Positioned
                </div>
              </body>
            </html>
            """
        }
    }

    @Test
    func `typography properties via CSS namespace`() {
        snapshot(as: .html) {
            HTML.Document {
                p {
                    "Styled text"
                }
                .css
                .fontSize(.px(16))
                .fontWeight(.bold)
                .lineHeight(1.5)
                .textAlign(.center)
                .textDecoration(.underline)
            }
        } matches: {
            """
            <!doctype html>
            <html>
              <head>
                <style>
                  .text-decoration-0{text-decoration:underline}
                  .text-align-1{text-align:center}
                  .line-height-2{line-height:1.5}
                  .font-weight-3{font-weight:bold}
                  .font-size-4{font-size:16px}
                </style>
              </head>
              <body>
                <p class="text-decoration-0 text-align-1 line-height-2 font-weight-3 font-size-4">Styled text
                </p>
              </body>
            </html>
            """
        }
    }

    @Test
    func `margin vertical horizontal`() {
        snapshot(as: .html) {
            HTML.Document {
                div {}
                    .css.margin(vertical: .px(10), horizontal: .px(20))
            }
        } matches: {
            """
            <!doctype html>
            <html>
              <head>
                <style>
                  .margin-0{margin:10px 20px}
                </style>
              </head>
              <body>
                <div class="margin-0">
                </div>
              </body>
            </html>
            """
        }
    }

    @Test
    func `margin set variant`() {
        snapshot(as: .html) {
            HTML.Document {
                div {}
                    .css.margin(
                        top: .px(10),
                        right: .px(20),
                        bottom: .px(15),
                        left: .px(25)
                    )
            }
        } matches: {
            """
            <!doctype html>
            <html>
              <head>
                <style>
                  .margin-0{margin:10px 20px 15px 25px}
                </style>
              </head>
              <body>
                <div class="margin-0">
                </div>
              </body>
            </html>
            """
        }
    }

    @Test
    func `margin single side`() {
        snapshot(as: .html) {
            HTML.Document {
                div {}
                    .css.margin(top: .px(8))
            }
        } matches: {
            """
            <!doctype html>
            <html>
              <head>
                <style>
                  .margin-top-0{margin-top:8px}
                </style>
              </head>
              <body>
                <div class="margin-top-0">
                </div>
              </body>
            </html>
            """
        }
    }

    @Test
    func `padding vertical horizontal`() {
        snapshot(as: .html) {
            HTML.Document {
                div {}
                    .css.padding(
                        vertical: .px(10),
                        horizontal: .px(20)
                    )
            }
        } matches: {
            """
            <!doctype html>
            <html>
              <head>
                <style>
                  .padding-0{padding:10px 20px}
                </style>
              </head>
              <body>
                <div class="padding-0">
                </div>
              </body>
            </html>
            """
        }
    }

    @Test
    func `border with light and darkmode color for all sides`() {
        snapshot(as: .html) {
            HTML.Document {
                HTML.Empty()
                    .css.border(
                        Border.Side.all,
                        width: .px(1),
                        style: .solid,
                        color: .init(light: .red, dark: .blue)
                    )
            }
        } matches: {
            """
            <!doctype html>
            <html>
              <head>
                <style>
                  .border-1{border:1px solid #cc3333}
                  @media (prefers-color-scheme: dark){
                    .border-0{border:1px solid #3399ff}
                  }
                </style>
              </head>
              <body>
              </body>
            </html>
            """
        }
    }

    @Test
    func `general color styling`() {
        snapshot(as: .html) {
            HTML.Document {
                ContentDivision {
                    H1 { "Type-safe HTML" }
                        .css.color(light: .named(.blue), dark: .named(.red))
                        .fontSize(.px(24))

                    Paragraph { "With type-safe CSS!" }
                        .css.marginTop(.px(10))
                }
            }
        } matches: {
            """
            <!doctype html>
            <html>
              <head>
                <style>
                  .font-size-0{font-size:24px}
                  .color-2{color:blue}
                  .margin-top-3{margin-top:10px}
                  @media (prefers-color-scheme: dark){
                    .color-1{color:red}
                  }
                </style>
              </head>
              <body>
                <div>
                  <h1 class="font-size-0 color-1 color-2">Type-safe HTML
                  </h1>
                  <p class="margin-top-3">With type-safe CSS!
                  </p>
                </div>
              </body>
            </html>
            """
        }
    }

    @Test
    func `simple color styling`() {
        snapshot(as: .html) {
            HTML.Document {
                p { "Hello World" }
                    .css.color(DarkModeColor(light: .red, dark: .blue))
            }
        } matches: {
            """
            <!doctype html>
            <html>
              <head>
                <style>
                  .color-1{color:#cc3333}
                  @media (prefers-color-scheme: dark){
                    .color-0{color:#3399ff}
                  }
                </style>
              </head>
              <body>
                <p class="color-0 color-1">Hello World
                </p>
              </body>
            </html>
            """
        }
    }
}
