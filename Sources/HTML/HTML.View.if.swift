//
//  File.swift
//  swift-html
//
//  Created by Coen ten Thije Boonkkamp on 09/10/2024.
//

import HTML_Rendering

extension HTML.View {
    @discardableResult
    @HTML.Builder
    public func `if`<T: HTML.View>(
        _ condition: Bool,
        @HTML.Builder then modification: (Self) -> T
    ) -> some HTML.View {
        if condition {
            modification(self)
        } else {
            self
        }
    }
}

extension HTML.View {
    @HTML.Builder
    public func `if`<X>(
        `let` value: X?,
        @HTML.Builder _ then: (Self, X) -> some HTML.View
    ) -> some HTML.View {
        if let value {
            then(self, value)
        } else {
            self
        }
    }
}
