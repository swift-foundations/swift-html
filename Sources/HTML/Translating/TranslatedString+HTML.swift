//
//  TranslatedString+HTML.swift
//  swift-html
//
//  TranslatedString integration for HTML (requires Translating trait)
//

import HTML_Rendering

#if TRANSLATING
    public import Translating
    import Translating_Dependencies

    /// Makes `TranslatedString` (`Translated<String>`) usable directly inside HTML builders.
    ///
    /// This mirrors the `String: HTML.View` leaf conformance: the view renders as escaped
    /// text, resolved for the current `@Dependency(\.language)` via the `CustomStringConvertible`
    /// conformance vended by `Translating Dependencies`.
    ///
    /// `Render.View` must be restated here: `HTML.View` refines it, and a *conditional*
    /// conformance does not imply conformance to inherited protocols.
    extension Translated: @retroactive Render.View, @retroactive HTML.View where A == String {
        public var body: HTML.Text {
            HTML.Text("\(self)")
        }
    }

    extension HTML.Text {
        public init(_ translatedString: TranslatedString) {
            self = .init("\(translatedString)")
        }
    }
#endif
