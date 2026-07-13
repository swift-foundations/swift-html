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

    extension TranslatedString: @retroactive Renderable {
        public typealias Context = HTML.Context
        public typealias RenderOutput = UInt8
    }

    extension TranslatedString: @retroactive HTML.View {
        public var body: some HTML.View {
            HTML.Text("\(self)")
        }
    }

    extension HTML.Text {
        public init(_ translatedString: TranslatedString) {
            self = .init("\(translatedString)")
        }
    }
#endif
