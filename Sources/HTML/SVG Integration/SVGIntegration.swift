import Byte
import Byte_Standard_Library_Integration
import RFC_4648
import SVG
import SVG_Rendering
import SVG_Standard
import WHATWG_Form_URL_Encoded
import WHATWG_HTML_Elements
import WHATWG_HTML_MediaAttributes

public struct InlineSVG: HTML.View {

    private let content: any SVG.View

    public init<Content: SVG.View>(@SVG.Builder _ content: () -> Content) {
        self.content = content()
    }

    public init<Content: SVG.View>(_ content: Content) {
        self.content = content
    }
}

extension InlineSVG {

    public var body: some HTML.View {
        HTML.Raw([UInt8](content))
    }
}

public func svg(_ svgString: String) -> some HTML.View {
    HTML.Raw(svgString)
}

extension HTML.Image.Element {
    public init<Content: SVG.View>(
        svg: Content,
        alt: HTML.Alt.Attribute?,
        base64: Bool = true,
        loading: HTML.Loading.Attribute? = .eager
    ) {
        var src: HTML.Src.Attribute {
            if base64 {
                return "data:image/svg+xml;base64,\([Byte]([UInt8](svg)).base64.encoded())"
            } else {

                return
                    "data:image/svg+xml;charset=utf-8,\(String(svg).formURL.encoded(space: .percentEscaped))"
            }
        }

        self = .init(
            src: src,
            alt: alt,
            loading: loading
        )
    }
}
