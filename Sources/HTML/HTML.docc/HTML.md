# ``HTML``

@Metadata {
    @DisplayName("HTML")
    @TitleHeading("Swift Foundations")
}

Lowercase, HTML-like element syntax — `a(href:)`, `div`, `abbr`, and the
rest of the element set — as typealiases over `swift-html-render`'s typed
`HTML_Standard` elements, with CSS (`swift-css`), SVG (`swift-svg`), and
Markdown (`swift-markdown-html-render`) integration re-exported together, so
a view can mix HTML, inline styling, embedded SVG, and rendered Markdown in
one builder tree.

## When to use this

Reach for this package when code composes HTML views in Swift and wants
markup that reads like the HTML elements it produces (`div { ... }`,
`a(href: "…")`) with typed CSS styling and SVG embedding available directly,
rather than assembling the typed element, styling, and rendering packages by
hand. It contributes no rendering behavior of its own: the element types
come from `swift-html-render`, CSS support from `swift-css`, and SVG support
from `swift-svg`. Depend on those packages directly when the lowercase
convenience syntax or the bundled cross-domain integration is not needed.

## Topics

### Related packages

- [swift-html-render](https://github.com/swift-foundations/swift-html-render) —
  the typed HTML element and rendering vocabulary this package aliases.
- [swift-css](https://github.com/swift-foundations/swift-css) — the typed
  CSS styling this package integrates.
- [swift-svg](https://github.com/swift-foundations/swift-svg) — the SVG
  element syntax this package integrates for embedded SVG.
