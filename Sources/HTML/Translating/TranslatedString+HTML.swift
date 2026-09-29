import HTML_Rendering

#if TRANSLATING
    public import Translating
    import Translating_Dependencies

    extension Translated: @retroactive Renderer.Document.View, @retroactive HTML.View where A == String {
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
