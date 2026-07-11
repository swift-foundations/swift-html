// swift-tools-version: 6.3.3

import PackageDescription

extension String {
    static let html: Self = "HTML"
}

extension Target.Dependency {
    static var html: Self { .target(name: .html) }
}

extension Target.Dependency {
    static var htmlRendering: Self { .product(name: "HTML Rendering", package: "swift-html-render") }
    static var htmlRenderingCoreTestSupport: Self { .product(name: "HTML Rendering Core Test Support", package: "swift-html-render") }
    static var markdownHtmlRendering: Self { .product(name: "Markdown HTML Rendering", package: "swift-markdown-html-render") }
    static var css: Self { .product(name: "CSS", package: "swift-css") }
    static var cssTheming: Self { .product(name: "CSS Theming", package: "swift-css") }
    static var color: Self { .product(name: "Color", package: "swift-color") }
    static var rfc4648: Self { .product(name: "RFC 4648", package: "swift-rfc-4648") }
    static var whatwgFormURLEncoded: Self { .product(name: "WHATWG Form URL Encoded", package: "swift-whatwg-url") }
    static var bytePrimitives: Self { .product(name: "Byte Primitives", package: "swift-byte-primitives") }
    static var bytePrimitivesStandardLibraryIntegration: Self { .product(name: "Byte Primitives Standard Library Integration", package: "swift-byte-primitives") }
}

let package = Package(
    name: "swift-html",
    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .macCatalyst(.v26)
    ],
    products: [
        .library(name: .html, targets: [.html]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-foundations/swift-html-render.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-markdown-html-render.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-css.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-svg.git", branch: "main"),
        .package(url: "https://github.com/swift-ietf/swift-rfc-4648.git", branch: "main"),
        .package(url: "https://github.com/swift-whatwg/swift-whatwg-url.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-color.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-byte-primitives.git", branch: "main"),
    ],
    targets: [
        .target(
            name: .html,
            dependencies: [
                .htmlRendering,
                .css,
                .cssTheming,
                .markdownHtmlRendering,
                .color,
                .rfc4648,
                .whatwgFormURLEncoded,
                .bytePrimitives,
                .bytePrimitivesStandardLibraryIntegration,
                .product(name: "SVG", package: "swift-svg"),
            ]
        ),
        .testTarget(
            name: .html.tests,
            dependencies: [
                .html,
                .htmlRenderingCoreTestSupport,
            ],
            path: "Tests/HTML Tests"
        )
    ],
    swiftLanguageModes: [.v6]
)

extension String {
    var tests: Self { "\(self) Tests" }
    var foundation: Self { self + " Foundation" }
}

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
