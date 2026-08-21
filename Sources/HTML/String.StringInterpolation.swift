import HTML_Rendering

extension String.StringInterpolation {
    public mutating func appendInterpolation(html value: some HTML.View) {
        let bytes = ContiguousArray(value)
        let htmlString: String = String(decoding: bytes, as: UTF8.self)

        let escapedString =
            htmlString
            .replacing("\\", with: "\\\\")
            .replacing("`", with: "\\`")
            .replacing("${", with: "\\${")
            .replacing("\u{2028}", with: "\\u2028")
            .replacing("\u{2029}", with: "\\u2029")

        appendLiteral("`\(escapedString)`")
    }
}
