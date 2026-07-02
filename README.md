# swift-html

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

The Swift HTML library built on [swift-standards](https://github.com/swift-standards).

## Table of Contents

- [Overview](#overview)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Usage Examples](#usage-examples)
- [Architecture](#architecture)
- [Features](#features)
- [Requirements](#requirements)
- [License](#license)

## Overview

swift-html is a unified import for type-safe HTML generation. It re-exports [swift-html-render](https://github.com/swift-foundations/swift-html-render), [swift-css](https://github.com/swift-foundations/swift-css), [swift-svg](https://github.com/swift-foundations/swift-svg), and related packages—all grounded in [swift-standards](https://github.com/swift-standards) for domain-accurate representations of WHATWG and W3C specifications.

## Installation

Add swift-html to your Package.swift:

```swift
dependencies: [
    .package(url: "https://github.com/swift-foundations/swift-html", from: "0.1.0")
]
```

Add to your target:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "HTML", package: "swift-html"),
    ]
)
```

### Requirements

- Swift 6.2+
- macOS 26.0+, iOS 26.0+
- Xcode 26.0+ (for Apple platforms)

## Quick Start

```swift
import HTML

let page = HTML.Document {
    div {
        h1 { "Welcome" }
            .css
            .color(.blue)
            .fontSize(.px(24))

        p { "Type-safe HTML with CSS" }
            .css.color(light: .gray900, dark: .gray100)
    }
}

let html = try String(page)
```

## Usage Examples

### Basic Elements

```swift
div { "Content" }
h1 { "Heading" }
p { "Paragraph" }
a(href: "/path") { "Link" }
button { "Click me" }
```

### CSS Styling (Fluent API)

```swift
div { "Styled" }
    .css
    .display(.flex)
    .padding(.px(16))
    .backgroundColor(.white)
    .borderRadius(.px(8))
```

### Dark Mode

```swift
// Automatic light/dark variants
div { "Adaptive" }
    .css
    .color(light: .gray900, dark: .gray100)
    .backgroundColor(light: .white, dark: .hex("1a1a1a"))

// Theme colors (auto-adaptive)
div { "Themed" }
    .css.color(.blue)  // DarkModeColor with light/dark variants
```

### Layout Components

```swift
HStack(alignment: .top, spacing: .px(16)) {
    div { "Left" }
    Spacer()
    div { "Right" }
}

VStack(alignment: .start, spacing: .px(12)) {
    h2 { "Title" }
    p { "Content" }
}

LazyVGrid(columns: [1, 2, 1]) {
    div { "A" }
    div { "B" }
    div { "C" }
}
```

### Custom Components

```swift
struct Card: HTML.View {
    let title: String
    let content: String

    var body: some HTML.View {
        div {
            h3 { title }
            p { content }
        }
        .css
        .padding(.px(24))
        .backgroundColor(.white)
        .borderRadius(.px(8))
    }
}

// Usage
Card(title: "Hello", content: "World")
```

### Media Queries

```swift
div { "Responsive" }
    .css
    .display(.block)
    .media(.minWidth(.px(768))) {
        $0.display(.flex)
    }
```

### Inline SVG

```swift
InlineSVG {
    svg(width: 100, height: 100) {
        circle(cx: 50, cy: 50, r: 40)
            .fill("red")
            .stroke("black")
            .strokeWidth(3)
    }
}

// Raw SVG string
svg("<svg width=\"50\" height=\"50\"><circle cx=\"25\" cy=\"25\" r=\"20\" fill=\"blue\"/></svg>")

// SVG as data URI in img tag
img(svg: svgContent, alt: "Icon", base64: false)
```

### Rendering

```swift
// To string (minified by default)
let html = try String(document)

// Pretty-printed
try HTML.Context.Configuration.$current.withValue(.pretty) {
    let pretty = try String(document)
}

// To bytes
let bytes = [UInt8](document)
```

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        swift-html                            │
│                    (unified re-export)                       │
├─────────────────────────────────────────────────────────────┤
│  swift-html-render     │  swift-css  │  swift-svg  │  ...   │
│  (HTML.View, Document) │  (.css API) │  (SVG DSL)  │        │
├─────────────────────────────────────────────────────────────┤
│         swift-standards (CSS Standard, Color, etc.)          │
└─────────────────────────────────────────────────────────────┘
```

**Re-exported modules:**

| Module | Purpose |
|--------|---------|
| `HTML_Rendering` | Core HTML.View protocol and rendering |
| `CSS` | Fluent CSS API with dark mode |
| `CSS_Theming` | Theme system with semantic colors |
| `SVG` | Type-safe SVG generation |
| `Markdown_HTML_Rendering` | Markdown to HTML |
| `Standards` | Layout, geometry types |

## Features

| Feature | Description |
|---------|-------------|
| **Type-safe HTML** | HTML5 elements with compile-time validation |
| **Fluent CSS** | `.css.display(.flex).padding(.px(16))` chaining |
| **Dark mode** | `DarkModeColor(light:dark:)` with automatic media queries |
| **Theming** | Semantic color system (`.text.primary`, `.background.elevated`) |
| **Layout** | HStack, VStack, Spacer, LazyVGrid components |
| **SVG** | Inline SVG with type-safe elements |
| **Media queries** | `.media(.minWidth(.px(768))) { ... }` |
| **Rendering** | Single-pass byte rendering, pretty-print option |
| **i18n (optional)** | TranslatedString support via "Translating" trait |

### Optional: Translating Trait

Enable internationalization support:

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/swift-foundations/swift-html", from: "0.1.0",
             traits: ["Translating"])
]
```

Usage:

```swift
import HTML
import Translating

let greeting = TranslatedString(
    dutch: "Welkom",
    english: "Welcome"
)

h1 { greeting }
```

## Requirements

- Swift 6.2+
- macOS 26.0+, iOS 26.0+, tvOS 26.0+, watchOS 26.0+
- Xcode 26.0+ (for Apple platforms)

## License

Apache 2.0 - See [LICENSE](LICENSE) for details.
