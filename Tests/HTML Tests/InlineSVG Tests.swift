//
//  InlineSVG Tests.swift
//  swift-html
//
//  Tests for SVG integration with HTML
//

import Foundation
import HTML
import HTML_Rendering_TestSupport
import SVG
import SVG_Standard
import StandardsTestSupport
import Testing

extension InlineSVG {
    #TestSuites
}

// MARK: - Unit Tests

extension InlineSVG.Test.Unit {
    @Test("InlineSVG renders correctly in HTML")
    func inlineSVGRendering() throws {
        let html = div {
            h1 { "SVG Test" }

            InlineSVG {
                svg(width: 100, height: 100) {
                    circle(
                        cx: 50,
                        cy: 50,
                        r: 40
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

    @Test("Mixed HTML and SVG content")
    func mixedContent() throws {
        let html = div {
            p { "Before SVG" }

            InlineSVG {
                svg(
                    viewBox: .init(
                        minX: 0,
                        minY: 0,
                        width: 100,
                        height: 100
                    )
                ) {
                    rect(x: 10, y: 10, width: 80, height: 80)
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

    @Test("svgRaw function works")
    func svgRawFunction() throws {
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

    @Test("img with SVG content as data URI")
    func imgWithSVGDataURI() throws {
        let svgContent = svg(width: 20, height: 20) {
            circle(cx: 10, cy: 10, r: 8)
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

    @Test("img with SVG content as base64")
    func imgWithSVGBase64() throws {
        let svgContent = svg(width: 20, height: 20) {
            circle(cx: 10, cy: 10, r: 8)
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

    @Test("img with raw SVG string as data URI")
    func imgWithSVGStringDataURI() throws {
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

    @Test("img with raw SVG string as base64")
    func imgWithSVGStringBase64() throws {
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
