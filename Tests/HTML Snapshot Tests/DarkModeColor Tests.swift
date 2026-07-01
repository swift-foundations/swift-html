//
//  DarkModeColor Tests.swift
//  swift-html
//
//  Snapshot tests for DarkModeColor type
//

import CSS
import HTML
import HTML_Rendering_Core_Test_Support
import Testing

@Suite(.snapshots(record: .missing))
struct DarkModeColorSnapshotTests {
    @Test
    func `HTMLColor with light only auto-darkens`() {
        snapshot(as: .html) {
            HTML.Document {
                div { "Auto-darkened" }
                    .css.color(DarkModeColor(light: .hex("ff0000")))
            }
        }  matches: {
            """
            <!doctype html>
            <html>
              <head>
                <style>
                  .color-1{color:#ff0000}
                  @media (prefers-color-scheme: dark){
                    .color-0{color:rgb(204, 0, 0)}
                  }
                </style>
              </head>
              <body>
                <div class="color-0 color-1">Auto-darkened
                </div>
              </body>
            </html>
            """
        }
    }

    @Test
    func `AccentColor with light and dark renders properly`() {
        snapshot(as: .html) {
            HTML.Document {
                div {}
                    .css.accentColor(light: .hex("FF0000"), dark: .hex("00FF00"))
            }
        } matches: {
            """
            <!doctype html>
            <html>
              <head>
                <style>
                  .accent-color-1{accent-color:#FF0000}
                  @media (prefers-color-scheme: dark){
                    .accent-color-0{accent-color:#00FF00}
                  }
                </style>
              </head>
              <body>
                <div class="accent-color-0 accent-color-1">
                </div>
              </body>
            </html>
            """
        }
    }

    @Test
    func `BackgroundColor with light and dark renders properly`() {
        snapshot(as: .html) {
            HTML.Document {
                div {}
                    .css
                    .backgroundColor(light: .hex("FF0000"), dark: .hex("00FF00"))
            }
        } matches: {
            """
            <!doctype html>
            <html>
              <head>
                <style>
                  .background-color-1{background-color:#FF0000}
                  @media (prefers-color-scheme: dark){
                    .background-color-0{background-color:#00FF00}
                  }
                </style>
              </head>
              <body>
                <div class="background-color-0 background-color-1">
                </div>
              </body>
            </html>
            """
        }
    }

    @Test
    func `BorderColor with light and dark renders properly`() {
        snapshot(as: .html) {
            HTML.Document {
                div {}
                    .css.borderColor(light: .hex("FF0000"), dark: .hex("00FF00"))
            }
        } matches: {
            """
            <!doctype html>
            <html>
              <head>
                <style>
                  .border-color-1{border-color:#FF0000}
                  @media (prefers-color-scheme: dark){
                    .border-color-0{border-color:#00FF00}
                  }
                </style>
              </head>
              <body>
                <div class="border-color-0 border-color-1">
                </div>
              </body>
            </html>
            """
        }
    }

    @Test
    func `Color with light and dark renders properly`() {
        snapshot(as: .html) {
            HTML.Document {
                div {}
                    .css.color(light: .hex("FF0000"), dark: .hex("00FF00"))
            }
        } matches: {
            """
            <!doctype html>
            <html>
              <head>
                <style>
                  .color-1{color:#FF0000}
                  @media (prefers-color-scheme: dark){
                    .color-0{color:#00FF00}
                  }
                </style>
              </head>
              <body>
                <div class="color-0 color-1">
                </div>
              </body>
            </html>
            """
        }
    }

    @Test
    func `OutlineColor with light and dark renders properly`() {
        snapshot(as: .html) {
            HTML.Document {
                div {}
                    .css.outlineColor(light: .hex("FF0000"), dark: .hex("00FF00"))
            }
        } matches: {
            """
            <!doctype html>
            <html>
              <head>
                <style>
                  .outline-color-1{outline-color:#FF0000}
                  @media (prefers-color-scheme: dark){
                    .outline-color-0{outline-color:#00FF00}
                  }
                </style>
              </head>
              <body>
                <div class="outline-color-0 outline-color-1">
                </div>
              </body>
            </html>
            """
        }
    }

    @Test
    func `Fill with light and dark renders properly`() {
        snapshot(as: .html) {
            HTML.Document {
                div {}
                    .css.fill(light: .hex("FF0000"), dark: .hex("00FF00"))
            }
        } matches: {
            """
            <!doctype html>
            <html>
              <head>
                <style>
                  .fill-1{fill:#FF0000}
                  @media (prefers-color-scheme: dark){
                    .fill-0{fill:#00FF00}
                  }
                </style>
              </head>
              <body>
                <div class="fill-0 fill-1">
                </div>
              </body>
            </html>
            """
        }
    }

    @Test
    func `Stroke with light and dark renders properly`() {
        snapshot(as: .html) {
            HTML.Document {
                div {}
                    .css.stroke(light: .hex("FF0000"), dark: .hex("00FF00"))
            }
        } matches: {
            """
            <!doctype html>
            <html>
              <head>
                <style>
                  .stroke-1{stroke:#FF0000}
                  @media (prefers-color-scheme: dark){
                    .stroke-0{stroke:#00FF00}
                  }
                </style>
              </head>
              <body>
                <div class="stroke-0 stroke-1">
                </div>
              </body>
            </html>
            """
        }
    }
}
