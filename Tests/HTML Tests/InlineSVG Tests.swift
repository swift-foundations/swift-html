//
//  InlineSVG Tests.swift
//  swift-html
//
//  Tests for SVG integration with HTML
//

import Foundation
import HTML
import HTML_Rendering_Core_Test_Support
import SVG
import SVG_Standard
import Testing

extension InlineSVG {
    @Suite enum Test {
        @Suite struct Unit {}
        @Suite struct EdgeCase {}
    }
}

// MARK: - Unit Tests

extension InlineSVG.Test.Unit {
    @Test
    func `InlineSVG renders correctly in HTML`() throws {
        let html = div {
            h1 { "SVG Test" }

            InlineSVG {
                svg(
                    width: 100,
                    height: 100
                ) {
                    circle(
                        cx: .init(50),
                        cy: .init(50),
                        r: .init(40)
                    )
                    .fill("red")
                    .stroke("black")
                    .strokeWidth(3)
                }
            }
        }

        let renderedString = try String(html)

        #expect(renderedString.contains(#"<div>"#))
        #expect(renderedString.contains(#"<h1>SVG Test</h1>"#))
        #expect(renderedString.contains(#"<svg"#))
        #expect(renderedString.contains(#"width="100""#))
        #expect(renderedString.contains(#"height="100""#))
        #expect(renderedString.contains(#"<circle"#))
        #expect(renderedString.contains(#"cx="50""#))
        #expect(renderedString.contains(#"cy="50""#))
        #expect(renderedString.contains(#"r="40""#))
        #expect(renderedString.contains(#"fill="red""#))
        #expect(renderedString.contains(#"stroke="black""#))
        #expect(renderedString.contains(#"stroke-width="3""#))
        #expect(renderedString.contains(#"</svg>"#))
        #expect(renderedString.contains(#"</div>"#))
    }

    @Test
    func `Mixed HTML and SVG content`() throws {
        let html = div {
            p { "Before SVG" }

            InlineSVG {
                svg(
                    viewBox: .init(
                        minX: .init(0),
                        minY: .init(0),
                        width: .init(100),
                        height: .init(100)
                    )
                ) {
                    rect(x: .init(10), y: .init(10), width: .init(80), height: .init(80))
                        .fill("green")
                }
            }

            p { "After SVG" }
        }

        let renderedString = try String(html)

        #expect(renderedString.contains("<p>Before SVG</p>"))
        #expect(renderedString.contains("<svg"))
        #expect(renderedString.contains("<rect"))
        #expect(renderedString.contains("</svg>"))
        #expect(renderedString.contains("<p>After SVG</p>"))
    }

    @Test
    func `svgRaw function works`() throws {
        let html = div {
            p { "Using raw SVG" }
            svg(
                """
                <svg width="50" height="50">
                    <circle cx="25" cy="25" r="20" fill="blue"/>
                </svg>
                """
            )
        }

        let renderedString = try String(html)

        #expect(renderedString.contains("<p>Using raw SVG</p>"))
        #expect(renderedString.contains("<svg width=\"50\" height=\"50\">"))
        #expect(renderedString.contains("<circle cx=\"25\" cy=\"25\" r=\"20\" fill=\"blue\"/>"))
    }

    @Test
    func `img with SVG content as data URI`() throws {
        let svgContent = svg(width: 20, height: 20) {
            circle(cx: .init(10), cy: .init(10), r: .init(8))
                .fill("orange")
        }

        let html = div {
            img(svg: svgContent, alt: "Orange circle", base64: false)
        }

        let renderedString = try String(html)

        #expect(renderedString.contains("<img"))
        #expect(renderedString.contains("alt=\"Orange circle\""))
        #expect(renderedString.contains("data:image/svg+xml;charset=utf-8,"))
        #expect(renderedString.contains("%3Csvg"))
        #expect(renderedString.contains("%3Ccircle"))
    }

    @Test
    func `img with SVG content as base64`() throws {
        let svgContent = svg(width: 20, height: 20) {
            circle(cx: .init(10), cy: .init(10), r: .init(8))
                .fill("purple")
        }

        let html = div {
            img(svg: svgContent, alt: "Purple circle", base64: true)
        }

        let renderedString = try String(html)

        #expect(renderedString.contains("<img"))
        #expect(renderedString.contains("alt=\"Purple circle\""))
        #expect(renderedString.contains("data:image/svg+xml;base64,"))
        #expect(!renderedString.contains("<svg"))
        #expect(!renderedString.contains("<circle"))
    }

    @Test
    func `img with raw SVG string as data URI`() throws {
        let svgString = """
            <svg width="30" height="30">
                <rect x="5" y="5" width="20" height="20" fill="green"/>
            </svg>
            """

        let html = div {
            img(svg: SVG.Raw(svgString), alt: "Green square", base64: false)
        }

        let renderedString = try String(html)

        #expect(renderedString.contains("<img"))
        #expect(renderedString.contains("alt=\"Green square\""))
        #expect(renderedString.contains("data:image/svg+xml;charset=utf-8,"))
        #expect(renderedString.contains("%3Csvg"))
        #expect(renderedString.contains("%3Crect"))
    }

    @Test
    func `img with raw SVG string as base64`() throws {
        let svgString = """
            <svg width="30" height="30">
                <rect x="5" y="5" width="20" height="20" fill="blue"/>
            </svg>
            """

        let html = div {
            img(svg: SVG.Raw(svgString), alt: "Blue square", base64: true)
        }

        let renderedString = try String(html)

        #expect(renderedString.contains("<img"))
        #expect(renderedString.contains("alt=\"Blue square\""))
        #expect(renderedString.contains("data:image/svg+xml;base64,"))
        #expect(!renderedString.contains("<svg"))
        #expect(!renderedString.contains("<rect"))

        if let range = renderedString.range(of: "data:image/svg+xml;base64,") {
            let base64Part = renderedString[range.upperBound...]
            if let endRange = base64Part.range(of: "\"") {
                let base64String = String(base64Part[..<endRange.lowerBound])
                if let data = Data(base64Encoded: base64String) {
                    let decoded = String(data: data, encoding: .utf8) ?? ""
                    #expect(decoded.contains("<svg"))
                    #expect(decoded.contains("<rect"))
                    #expect(decoded.contains("blue"))
                }
            }
        }
    }
}

// MARK: - Integration Tests

extension InlineSVG.Test {
    @Suite struct Integration {}
}

extension InlineSVG.Test.Integration {
    @Test
    func `InlineSVG within styled HTML document renders complete output`() throws {
        let document = HTML.Document {
            div {
                h1 { "SVG Integration" }
                    .css
                    .fontSize(.px(24))
                    .color(DarkModeColor(light: .hex("333333"), dark: .hex("cccccc")))

                InlineSVG {
                    svg(width: 200, height: 200) {
                        circle(
                            cx: .init(100),
                            cy: .init(100),
                            r: .init(80)
                        )
                        .fill("blue")
                        .stroke("navy")
                        .strokeWidth(2)
                    }
                }

                p { "Caption below SVG" }
                    .css
                    .textAlign(.center)
                    .marginTop(.px(8))
            }
            .css
            .padding(.rem(2))
            .maxWidth(.px(600))
            .margin(.auto)
        } head: {
            title { "SVG Integration Test" }
            meta(charset: .utf8)
        }

        let rendered = try String(document)

        // Verify document structure
        #expect(rendered.contains("<!doctype html>"))
        #expect(rendered.contains("<html>"))
        #expect(rendered.contains("<head>"))
        #expect(rendered.contains("<body>"))

        // Verify CSS was collected into <style>
        #expect(rendered.contains("<style>"))
        #expect(rendered.contains("font-size"))
        #expect(rendered.contains("text-align"))

        // Verify SVG content is embedded inline
        #expect(rendered.contains("<svg"))
        #expect(rendered.contains("<circle"))
        #expect(rendered.contains("</svg>"))

        // Verify surrounding HTML elements
        #expect(rendered.contains("<h1"))
        #expect(rendered.contains("SVG Integration"))
        #expect(rendered.contains("Caption below SVG"))
    }

    @Test
    func `multiple SVG elements coexist in a single document`() throws {
        let document = HTML.Document {
            div {
                InlineSVG {
                    svg(width: 50, height: 50) {
                        circle(cx: .init(25), cy: .init(25), r: .init(20))
                            .fill("red")
                    }
                }

                InlineSVG {
                    svg(width: 50, height: 50) {
                        rect(x: .init(5), y: .init(5), width: .init(40), height: .init(40))
                            .fill("green")
                    }
                }

                img(
                    svg: svg(width: 30, height: 30) {
                        circle(cx: .init(15), cy: .init(15), r: .init(10))
                            .fill("blue")
                    },
                    alt: "Blue dot",
                    base64: true
                )
            }
        }

        let rendered = try String(document)

        // Both inline SVGs should appear
        #expect(rendered.contains("fill=\"red\""))
        #expect(rendered.contains("fill=\"green\""))

        // The img-based SVG should be base64-encoded, not inline
        #expect(rendered.contains("data:image/svg+xml;base64,"))
        #expect(rendered.contains("alt=\"Blue dot\""))
    }
}
