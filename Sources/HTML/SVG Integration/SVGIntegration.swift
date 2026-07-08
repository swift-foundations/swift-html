//
//  SVGIntegration.swift
//  swift-html
//
//  Bridge to integrate swift-svg with swift-html
//

import Byte_Primitives
import Byte_Primitives_Standard_Library_Integration
import RFC_4648
// Import SVG module but we need to be careful about naming
import SVG
import SVG_Rendering
import SVG_Standard
import WHATWG_Form_URL_Encoded
import WHATWG_HTML_Elements
import WHATWG_HTML_MediaAttributes

/// Bridge to embed type-safe SVG content in HTML documents.
///
/// `InlineSVG` allows you to use the swift-svg library's type-safe DSL
/// within HTML documents, providing compile-time validation and better
/// developer experience compared to raw SVG strings.
///
/// Example:
/// ```swift
/// div {
///     h1 { "My Page" }
///
///     InlineSVG {
///         svg(width: 100, height: 100) {
///             circle(cx: 50, cy: 50, r: 40) {
///                 fill("red")
///                 stroke("black", width: 3)
///             }
///         }
///     }
/// }
/// ```
public struct InlineSVG: HTML.View {
    // `any SVG.View` stores type-erased SVG content (existential-by-design).
    // swiftlint:disable no_any_protocol_existential
    /// The SVG content to embed
    private let content: any SVG.View
    // swiftlint:enable no_any_protocol_existential

    /// Creates a new inline SVG element from SVG content.
    ///
    /// - Parameter content: A closure that returns SVG content using the SVG DSL.
    public init<Content: SVG.View>(@SVG.Builder _ content: () -> Content) {
        self.content = content()
    }

    /// Creates a new inline SVG element from already created SVG content.
    ///
    /// - Parameter content: SVG content
    public init<Content: SVG.View>(_ content: Content) {
        self.content = content
    }
}

extension InlineSVG {
    /// Renders the SVG content as HTML.
    public var body: some HTML.View {
        HTML.Raw([UInt8](content))
    }
}

// MARK: - Convenience Functions

/// Creates an inline SVG element from a pre-rendered SVG string.
///
/// This function provides a migration path for existing raw SVG strings
/// while encouraging the use of type-safe SVG where possible.
///
/// - Parameter svgString: A string containing valid SVG markup.
/// - Returns: An HTML element containing the SVG.
public func svg(_ svgString: String) -> some HTML.View {
    HTML.Raw(svgString)
}

// MARK: - Image Extensions for SVG

//
//
// func img<Content: SVG>(
//    svg content: Content,
//    alt: String,
//    base64: Bool = false
// ) -> some HTML.View {
//    let svgString = content.render()
//
//    let src: String
//    if base64 {
//        // let data = Data(svgString.utf8)
//        let base64String = String(base64Encoding: Array(svgString.utf8))
//        src = "data:image/svg+xml;base64,\(base64String)"
//    } else {
//        // URL encode the SVG for direct embedding
//        let encoded = percentEncodeSVG()
//        src = "data:image/svg+xml;charset=utf-8,\(encoded)"
//    }
//
//    return HTML_Standard_Elements.Image(src: Src(src), alt: Alt(alt))
// }
//

extension WHATWG_HTML_Elements.Image {
    public init<Content: SVG.View>(
        svg: Content,
        alt: WHATWG_HTML_MediaAttributes.Alt?,
        base64: Bool = true,
        loading: WHATWG_HTML_MediaAttributes.Loading? = .eager
    ) {
        var src: WHATWG_HTML_MediaAttributes.Src {
            if base64 {
                return "data:image/svg+xml;base64,\([Byte]([UInt8](svg)).base64.encoded())"
            } else {
                // Percent-encode for data URI using WHATWG standard
                // This properly encodes < > and other special characters
                //                let encoded = WHATWG_Form_URL_Encoded.PercentEncoding.encode(String.init([UInt8](svg)), spaceAsPlus: false)

                return
                    "data:image/svg+xml;charset=utf-8,\(String(svg).formURL.encoded(spaceAsPlus: false))"
            }
        }

        self = .init(
            src: src,
            alt: alt,
            loading: loading
        )
    }
}
