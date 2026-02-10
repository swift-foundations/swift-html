//
//  DarkModeColor Tests.swift
//  swift-html
//
//  Tests for DarkModeColor type
//

import CSS
import HTML
import HTML_Rendering_TestSupport
import StandardsTestSupport
import Testing

extension DarkModeColor {
    #TestSuites
}

extension DarkModeColor.Test {
    @Suite(.snapshots(record: .failed))
    public struct Snapshot {}
}

// MARK: - Unit Tests

extension DarkModeColor.Test.Unit {
    @Test("Color initializes with standard color")
    func colorInitializesWithStandardColor() {
        let color = DarkModeColor(light: .hex("FF0000"))
        #expect(color.light.description == "#FF0000")
    }

    @Test("Color initializes with light and dark colors")
    func colorInitializesWithLightAndDarkColors() {
        let color = DarkModeColor(
            light: .hex("FF0000"),
            dark: .hex("00FF00")
        )
        #expect(color.light.description == "#FF0000")
        #expect(color.dark.description == "#00FF00")
    }

    @Test("Color falls back to darker version when dark is omitted")
    func colorFallsBackToDarker() {
        let color = DarkModeColor(light: .hex("FF0000"))
        #expect(color.dark != color.light)
    }

    @Test("Color description includes media queries")
    func colorDescriptionIncludesMediaQueries() {
        let color = DarkModeColor(
            light: .hex("FF0000"),
            dark: .hex("00FF00")
        )
        let description = color.description
        #expect(description.contains("@media (prefers-color-scheme: light)"))
        #expect(description.contains("#FF0000"))
        #expect(description.contains("@media (prefers-color-scheme: dark)"))
        #expect(description.contains("#00FF00"))
    }

    @Test("Color description includes dark mode even when not explicitly provided")
    func colorDescriptionIncludesDarkModeWhenNotExplicit() {
        let color = DarkModeColor(light: .hex("FF0000"), dark: nil)
        let description = color.description
        #expect(description.contains("@media (prefers-color-scheme: light)"))
        #expect(description.contains("#FF0000"))
        #expect(description.contains("@media (prefers-color-scheme: dark)"))
        #expect(description.contains("rgb") || description.contains("#"))
    }

    @Test("Map transforms both light and dark colors")
    func mapTransformsBothColors() {
        let color = DarkModeColor(
            light: .hex("FF0000"),
            dark: .hex("00FF00")
        )
        let transformed = color.map { _ in .hex("0000FF") }
        #expect(transformed.light.description == "#0000FF")
        #expect(transformed.dark.description == "#0000FF")
    }

    @Test("FlatMap transforms colors more complexly")
    func flatMapTransformsColorsComplexly() {
        let color = DarkModeColor(
            light: .hex("FF0000"),
            dark: .hex("00FF00")
        )
        let transformed = color.flatMap { _ in
            DarkModeColor(
                light: .hex("0000FF"),
                dark: .hex("FF00FF")
            )
        }
        #expect(transformed.light.description == "#0000FF")
        #expect(transformed.dark.description == "#FF00FF")
    }

    @Test("AdjustBrightness changes color brightness")
    func adjustBrightnessChangesColorBrightness() {
        let color = DarkModeColor(
            light: .hex("FF0000"),
            dark: .hex("00FF00")
        )
        let brightened = color.adjustBrightness(by: 0.2)
        #expect(brightened.light != color.light)
        #expect(brightened.dark != color.dark)
    }

    @Test("Darker makes colors darker")
    func darkerMakesColorsDarker() {
        let color = DarkModeColor(
            light: .hex("FF0000"),
            dark: .hex("00FF00")
        )
        let darkened = color.darker(by: 0.3)
        #expect(darkened.light != color.light)
        #expect(darkened.dark != color.dark)
    }

    @Test("Lighter makes colors lighter")
    func lighterMakesColorsLighter() {
        let color = DarkModeColor(
            light: .hex("FF0000"),
            dark: .hex("00FF00")
        )
        let lightened = color.lighter(by: 0.3)
        #expect(lightened.light != color.light)
        #expect(lightened.dark != color.dark)
    }
}

// MARK: - Snapshot Tests

#if canImport(Darwin)
    extension DarkModeColor.Test.Snapshot {
        @Test("HTMLColor with light only auto-darkens")
        func htmlColorAutoDarken() {
            assertInlineSnapshot(
                of: HTML.Document {
                    div { "Auto-darkened" }
                        .css.color(DarkModeColor(light: .hex("ff0000")))
                },
                as: .html
            ) {
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

        @Test("AccentColor with light/dark renders properly")
        func accentColorLightDarkRendersCorrectly() {
            assertInlineSnapshot(
                of: HTML.Document {
                    div {}
                        .css.accentColor(light: .hex("FF0000"), dark: .hex("00FF00"))
                },
                as: .html
            ) {
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

        @Test("AccentColor with HTMLColor renders properly")
        func accentColorHTMLColorRendersCorrectly() {
            assertInlineSnapshot(
                of: HTML.Document {
                    div {}
                        .css.accentColor(.red)
                },
                as: .html
            ) {
                """
                <!doctype html>
                <html>
                  <head>
                    <style>
                      .accent-color-1{accent-color:#cc3333}
                      @media (prefers-color-scheme: dark){
                        .accent-color-0{accent-color:#ff1a1a}
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

        @Test("BackgroundColor with light/dark renders properly")
        func backgroundColorLightDarkRendersCorrectly() {
            assertInlineSnapshot(
                of: HTML.Document {
                    div {}
                        .css
                        .backgroundColor(light: .hex("FF0000"), dark: .hex("00FF00"))
                },
                as: .html
            ) {
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

        @Test("BackgroundColor with HTMLColor renders properly")
        func backgroundColorHTMLColorRendersCorrectly() {
            assertInlineSnapshot(
                of: HTML.Document {
                    div {}
                        .css.backgroundColor(.yellow)
                },
                as: .html
            ) {
                """
                <!doctype html>
                <html>
                  <head>
                    <style>
                      .background-color-1{background-color:#cccc33}
                      @media (prefers-color-scheme: dark){
                        .background-color-0{background-color:#ffff1a}
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

        @Test("BorderBlockColor with light/dark renders properly")
        func borderBlockColorLightDarkRendersCorrectly() {
            assertInlineSnapshot(
                of: HTML.Document {
                    div {}
                        .css.borderBlockColor(light: .hex("FF0000"), dark: .hex("00FF00"))
                },
                as: .html
            ) {
                """
                <!doctype html>
                <html>
                  <head>
                    <style>
                      .border-block-color-1{border-block-color:#FF0000}
                      @media (prefers-color-scheme: dark){
                        .border-block-color-0{border-block-color:#00FF00}
                      }
                    </style>
                  </head>
                  <body>
                    <div class="border-block-color-0 border-block-color-1">
                    </div>
                  </body>
                </html>
                """
            }
        }

        @Test("BorderBlockEndColor with light/dark renders properly")
        func borderBlockEndColorLightDarkRendersCorrectly() {
            assertInlineSnapshot(
                of: HTML.Document {
                    div {}
                        .css.borderBlockEndColor(light: .hex("FF0000"), dark: .hex("00FF00"))
                },
                as: .html
            ) {
                """
                <!doctype html>
                <html>
                  <head>
                    <style>
                      .border-block-end-color-1{border-block-end-color:#FF0000}
                      @media (prefers-color-scheme: dark){
                        .border-block-end-color-0{border-block-end-color:#00FF00}
                      }
                    </style>
                  </head>
                  <body>
                    <div class="border-block-end-color-0 border-block-end-color-1">
                    </div>
                  </body>
                </html>
                """
            }
        }

        @Test("BorderBlockStartColor with light/dark renders properly")
        func borderBlockStartColorLightDarkRendersCorrectly() {
            assertInlineSnapshot(
                of: HTML.Document {
                    div {}
                        .css.borderBlockStartColor(light: .hex("FF0000"), dark: .hex("00FF00"))
                },
                as: .html
            ) {
                """
                <!doctype html>
                <html>
                  <head>
                    <style>
                      .border-block-start-color-1{border-block-start-color:#FF0000}
                      @media (prefers-color-scheme: dark){
                        .border-block-start-color-0{border-block-start-color:#00FF00}
                      }
                    </style>
                  </head>
                  <body>
                    <div class="border-block-start-color-0 border-block-start-color-1">
                    </div>
                  </body>
                </html>
                """
            }
        }

        @Test("BorderBottomColor with light/dark renders properly")
        func borderBottomColorLightDarkRendersCorrectly() {
            assertInlineSnapshot(
                of: HTML.Document {
                    div {}
                        .css.borderBottomColor(light: .hex("FF0000"), dark: .hex("00FF00"))
                },
                as: .html
            ) {
                """
                <!doctype html>
                <html>
                  <head>
                    <style>
                      .border-bottom-color-1{border-bottom-color:#FF0000}
                      @media (prefers-color-scheme: dark){
                        .border-bottom-color-0{border-bottom-color:#00FF00}
                      }
                    </style>
                  </head>
                  <body>
                    <div class="border-bottom-color-0 border-bottom-color-1">
                    </div>
                  </body>
                </html>
                """
            }
        }

        @Test("BorderColor with light/dark renders properly")
        func borderColorLightDarkRendersCorrectly() {
            assertInlineSnapshot(
                of: HTML.Document {
                    div {}
                        .css.borderColor(light: .hex("FF0000"), dark: .hex("00FF00"))
                },
                as: .html
            ) {
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

        @Test("BorderInlineColor with light/dark renders properly")
        func borderInlineColorLightDarkRendersCorrectly() {
            assertInlineSnapshot(
                of: HTML.Document {
                    div {}
                        .css.borderInlineColor(light: .hex("FF0000"), dark: .hex("00FF00"))
                },
                as: .html
            ) {
                """
                <!doctype html>
                <html>
                  <head>
                    <style>
                      .border-inline-color-1{border-inline-color:#FF0000}
                      @media (prefers-color-scheme: dark){
                        .border-inline-color-0{border-inline-color:#00FF00}
                      }
                    </style>
                  </head>
                  <body>
                    <div class="border-inline-color-0 border-inline-color-1">
                    </div>
                  </body>
                </html>
                """
            }
        }

        @Test("BorderInlineEndColor with light/dark renders properly")
        func borderInlineEndColorLightDarkRendersCorrectly() {
            assertInlineSnapshot(
                of: HTML.Document {
                    div {}
                        .css.borderInlineEndColor(light: .hex("FF0000"), dark: .hex("00FF00"))
                },
                as: .html
            ) {
                """
                <!doctype html>
                <html>
                  <head>
                    <style>
                      .border-inline-end-color-1{border-inline-end-color:#FF0000}
                      @media (prefers-color-scheme: dark){
                        .border-inline-end-color-0{border-inline-end-color:#00FF00}
                      }
                    </style>
                  </head>
                  <body>
                    <div class="border-inline-end-color-0 border-inline-end-color-1">
                    </div>
                  </body>
                </html>
                """
            }
        }

        @Test("BorderInlineStartColor with light/dark renders properly")
        func borderInlineStartColorLightDarkRendersCorrectly() {
            assertInlineSnapshot(
                of: HTML.Document {
                    div {}
                        .css.borderInlineStartColor(light: .hex("FF0000"), dark: .hex("00FF00"))
                },
                as: .html
            ) {
                """
                <!doctype html>
                <html>
                  <head>
                    <style>
                      .border-inline-start-color-1{border-inline-start-color:#FF0000}
                      @media (prefers-color-scheme: dark){
                        .border-inline-start-color-0{border-inline-start-color:#00FF00}
                      }
                    </style>
                  </head>
                  <body>
                    <div class="border-inline-start-color-0 border-inline-start-color-1">
                    </div>
                  </body>
                </html>
                """
            }
        }

        @Test("BorderLeftColor with light/dark renders properly")
        func borderLeftColorLightDarkRendersCorrectly() {
            assertInlineSnapshot(
                of: HTML.Document {
                    div {}
                        .css.borderLeftColor(light: .hex("FF0000"), dark: .hex("00FF00"))
                },
                as: .html
            ) {
                """
                <!doctype html>
                <html>
                  <head>
                    <style>
                      .border-left-color-1{border-left-color:#FF0000}
                      @media (prefers-color-scheme: dark){
                        .border-left-color-0{border-left-color:#00FF00}
                      }
                    </style>
                  </head>
                  <body>
                    <div class="border-left-color-0 border-left-color-1">
                    </div>
                  </body>
                </html>
                """
            }
        }

        @Test("BorderRightColor with light/dark renders properly")
        func borderRightColorLightDarkRendersCorrectly() {
            assertInlineSnapshot(
                of: HTML.Document {
                    div {}
                        .css.borderRightColor(light: .hex("FF0000"), dark: .hex("00FF00"))
                },
                as: .html
            ) {
                """
                <!doctype html>
                <html>
                  <head>
                    <style>
                      .border-right-color-1{border-right-color:#FF0000}
                      @media (prefers-color-scheme: dark){
                        .border-right-color-0{border-right-color:#00FF00}
                      }
                    </style>
                  </head>
                  <body>
                    <div class="border-right-color-0 border-right-color-1">
                    </div>
                  </body>
                </html>
                """
            }
        }

        @Test("BorderTopColor with light/dark renders properly")
        func borderTopColorLightDarkRendersCorrectly() {
            assertInlineSnapshot(
                of: HTML.Document {
                    div {}
                        .css.borderTopColor(light: .hex("FF0000"), dark: .hex("00FF00"))
                },
                as: .html
            ) {
                """
                <!doctype html>
                <html>
                  <head>
                    <style>
                      .border-top-color-1{border-top-color:#FF0000}
                      @media (prefers-color-scheme: dark){
                        .border-top-color-0{border-top-color:#00FF00}
                      }
                    </style>
                  </head>
                  <body>
                    <div class="border-top-color-0 border-top-color-1">
                    </div>
                  </body>
                </html>
                """
            }
        }

        @Test("CaretColor with light/dark renders properly")
        func caretColorLightDarkRendersCorrectly() {
            assertInlineSnapshot(
                of: HTML.Document {
                    div {}
                        .css.caretColor(light: .hex("FF0000"), dark: .hex("00FF00"))
                },
                as: .html
            ) {
                """
                <!doctype html>
                <html>
                  <head>
                    <style>
                      .caret-color-1{caret-color:#FF0000}
                      @media (prefers-color-scheme: dark){
                        .caret-color-0{caret-color:#00FF00}
                      }
                    </style>
                  </head>
                  <body>
                    <div class="caret-color-0 caret-color-1">
                    </div>
                  </body>
                </html>
                """
            }
        }

        @Test("ColumnRuleColor with light/dark renders properly")
        func columnRuleColorLightDarkRendersCorrectly() {
            assertInlineSnapshot(
                of: HTML.Document {
                    div {}
                        .css.columnRuleColor(light: .hex("FF0000"), dark: .hex("00FF00"))
                },
                as: .html
            ) {
                """
                <!doctype html>
                <html>
                  <head>
                    <style>
                      .column-rule-color-1{column-rule-color:#FF0000}
                      @media (prefers-color-scheme: dark){
                        .column-rule-color-0{column-rule-color:#00FF00}
                      }
                    </style>
                  </head>
                  <body>
                    <div class="column-rule-color-0 column-rule-color-1">
                    </div>
                  </body>
                </html>
                """
            }
        }

        @Test("FloodColor with light/dark renders properly")
        func floodColorLightDarkRendersCorrectly() {
            assertInlineSnapshot(
                of: HTML.Document {
                    div {}
                        .css.floodColor(light: .hex("FF0000"), dark: .hex("00FF00"))
                },
                as: .html
            ) {
                """
                <!doctype html>
                <html>
                  <head>
                    <style>
                      .flood-color-1{flood-color:#FF0000}
                      @media (prefers-color-scheme: dark){
                        .flood-color-0{flood-color:#00FF00}
                      }
                    </style>
                  </head>
                  <body>
                    <div class="flood-color-0 flood-color-1">
                    </div>
                  </body>
                </html>
                """
            }
        }

        @Test("Fill with light/dark renders properly")
        func fillLightDarkRendersCorrectly() {
            assertInlineSnapshot(
                of: HTML.Document {
                    div {}
                        .css.fill(light: .hex("FF0000"), dark: .hex("00FF00"))
                },
                as: .html
            ) {
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

        @Test("Fill with HTMLColor renders properly")
        func fillHTMLColorRendersCorrectly() {
            assertInlineSnapshot(
                of: HTML.Document {
                    div {}
                        .css.fill(.red)
                },
                as: .html
            ) {
                """
                <!doctype html>
                <html>
                  <head>
                    <style>
                      .fill-1{fill:#cc3333}
                      @media (prefers-color-scheme: dark){
                        .fill-0{fill:#ff1a1a}
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

        @Test("LightingColor with light/dark renders properly")
        func lightingColorLightDarkRendersCorrectly() {
            assertInlineSnapshot(
                of: HTML.Document {
                    div {}
                        .css.lightingColor(light: .hex("FF0000"), dark: .hex("00FF00"))
                },
                as: .html
            ) {
                """
                <!doctype html>
                <html>
                  <head>
                    <style>
                      .lighting-color-1{lighting-color:#FF0000}
                      @media (prefers-color-scheme: dark){
                        .lighting-color-0{lighting-color:#00FF00}
                      }
                    </style>
                  </head>
                  <body>
                    <div class="lighting-color-0 lighting-color-1">
                    </div>
                  </body>
                </html>
                """
            }
        }

        @Test("OutlineColor with light/dark renders properly")
        func outlineColorLightDarkRendersCorrectly() {
            assertInlineSnapshot(
                of: HTML.Document {
                    div {}
                        .css.outlineColor(light: .hex("FF0000"), dark: .hex("00FF00"))
                },
                as: .html
            ) {
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

        @Test("StopColor with light/dark renders properly")
        func stopColorLightDarkRendersCorrectly() {
            assertInlineSnapshot(
                of: HTML.Document {
                    div {}
                        .css.stopColor(light: .hex("FF0000"), dark: .hex("00FF00"))
                },
                as: .html
            ) {
                """
                <!doctype html>
                <html>
                  <head>
                    <style>
                      .stop-color-1{stop-color:#FF0000}
                      @media (prefers-color-scheme: dark){
                        .stop-color-0{stop-color:#00FF00}
                      }
                    </style>
                  </head>
                  <body>
                    <div class="stop-color-0 stop-color-1">
                    </div>
                  </body>
                </html>
                """
            }
        }

        @Test("Stroke with light/dark renders properly")
        func strokeLightDarkRendersCorrectly() {
            assertInlineSnapshot(
                of: HTML.Document {
                    div {}
                        .css.stroke(light: .hex("FF0000"), dark: .hex("00FF00"))
                },
                as: .html
            ) {
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

        @Test("TextDecorationColor with light/dark renders properly")
        func textDecorationColorLightDarkRendersCorrectly() {
            assertInlineSnapshot(
                of: HTML.Document {
                    div {}
                        .css.textDecorationColor(light: .hex("FF0000"), dark: .hex("00FF00"))
                },
                as: .html
            ) {
                """
                <!doctype html>
                <html>
                  <head>
                    <style>
                      .text-decoration-color-1{text-decoration-color:#FF0000}
                      @media (prefers-color-scheme: dark){
                        .text-decoration-color-0{text-decoration-color:#00FF00}
                      }
                    </style>
                  </head>
                  <body>
                    <div class="text-decoration-color-0 text-decoration-color-1">
                    </div>
                  </body>
                </html>
                """
            }
        }

        @Test("TextEmphasisColor with light/dark renders properly")
        func textEmphasisColorLightDarkRendersCorrectly() {
            assertInlineSnapshot(
                of: HTML.Document {
                    div {}
                        .css.textEmphasisColor(light: .hex("FF0000"), dark: .hex("00FF00"))
                },
                as: .html
            ) {
                """
                <!doctype html>
                <html>
                  <head>
                    <style>
                      .text-emphasis-color-1{text-emphasis-color:#FF0000}
                      @media (prefers-color-scheme: dark){
                        .text-emphasis-color-0{text-emphasis-color:#00FF00}
                      }
                    </style>
                  </head>
                  <body>
                    <div class="text-emphasis-color-0 text-emphasis-color-1">
                    </div>
                  </body>
                </html>
                """
            }
        }

        @Test("Fill with pseudo class renders properly")
        func fillWithPseudoClassRendersCorrectly() {
            assertInlineSnapshot(
                of: HTML.Document {
                    div {}
                        .css.hover { $0.fill(light: .hex("FF0000"), dark: .hex("00FF00")) }
                },
                as: .html
            ) {
                """
                <!doctype html>
                <html>
                  <head>
                    <style>
                      .fill-1:hover{fill:#FF0000}
                      @media (prefers-color-scheme: dark){
                        .fill-0:hover{fill:#00FF00}
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

        @Test("Stroke with selector renders properly")
        func strokeWithSelectorRendersCorrectly() {
            assertInlineSnapshot(
                of: HTML.Document {
                    div {}
                        .css.selector("child:span") {
                            $0.stroke(light: .hex("FF0000"), dark: .hex("00FF00"))
                        }
                },
                as: .html
            ) {
                """
                <!doctype html>
                <html>
                  <head>
                    <style>
                      child:span .stroke-1{stroke:#FF0000}
                      @media (prefers-color-scheme: dark){
                        child:span .stroke-0{stroke:#00FF00}
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

        @Test("OutlineColor with media query renders properly")
        func outlineColorWithMediaQueryRendersCorrectly() {
            assertInlineSnapshot(
                of: HTML.Document {
                    div {}
                        .css.print {
                            $0.outlineColor(light: .hex("FF0000"), dark: .hex("00FF00"))
                        }
                },
                as: .html
            ) {
                """
                <!doctype html>
                <html>
                  <head>
                    <style>
                      @media (prefers-color-scheme: dark){
                        .outline-color-0{outline-color:#00FF00}
                      }
                      @media print{
                        .outline-color-1{outline-color:#FF0000}
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

        @Test("Fill with nil HTMLColor renders nothing")
        func fillWithNilHTMLColorRendersNothing() {
            assertInlineSnapshot(
                of: HTML.Document {
                    div {}
                        .css.fill(W3C_CSS_Images.Fill?.none)
                },
                as: .html
            ) {
                """
                <!doctype html>
                <html>
                  <head>
                  </head>
                  <body>
                    <div>
                    </div>
                  </body>
                </html>
                """
            }
        }

        @Test("TextDecorationColor with nil HTMLColor renders nothing")
        func textDecorationColorWithNilHTMLColorRendersNothing() {
            assertInlineSnapshot(
                of: HTML.Document {
                    div {}
                        .css.textDecorationColor(
                            W3C_CSS_TextDecoration.TextDecorationColor?.none
                        )
                },
                as: .html
            ) {
                """
                <!doctype html>
                <html>
                  <head>
                  </head>
                  <body>
                    <div>
                    </div>
                  </body>
                </html>
                """
            }
        }
    }
#endif
