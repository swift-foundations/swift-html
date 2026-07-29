# Embedded Swift and WebAssembly for Client-Side HTML Rendering

<!--
---
version: 1.1.0
last_updated: 2026-07-28
status: ANALYSIS
---
-->

## Abstract

This paper assesses the feasibility of compiling `swift-html` to WebAssembly under Embedded Swift, enabling HTML generation in the browser from Swift source. We establish that the non-embedded WASI configuration is disqualified on payload grounds (~7.8 MB for a trivial program against a derived budget of 45–150 KB), making Embedded Swift a precondition rather than an optimisation. We then audit `swift-html`'s full transitive closure — **172 packages**, of which 168 are locally resolvable — and harvest 105 usable Embedded-Wasm CI outcomes from the primitives layer.

The central empirical result is that the ecosystem's Embedded Wasm failure rate, superficially 86%, is **not** a diffuse compatibility problem. A single construct — `Mutex<Storage>` in one file of `swift-property-primitives` — accounts for essentially all of it. A reachability model built from that one construct predicts observed CI outcomes with 90% agreement across 105 packages. The residual is explained by package-level rather than target-level granularity in the model.

We conclude that Embedded Wasm support for `swift-html` is gated by a small, enumerable set of defects rather than by architectural incompatibility, and we classify each against four remediation mechanisms already precedented in this codebase.

**Version 1.1.0 adds measured results (§11).** The premise is now empirical rather than cited: an embedded hello-world is **9,065 B gzip** against **1,869,739 B gzip** for the identical program on the full WASI stdlib — a **206× ratio** that places the non-embedded configuration roughly 40× outside the competitive budget before any `swift-html` code exists. Building `swift-html` itself surfaced a five-blocker chain, of which two are resolved (markdown behind a validated package trait; a reflection call that is `#if DEBUG`-only), two are mechanical (a `StringLiteralType` unavailability across three standards packages, and 105 shorthand key paths across 65 files), and one is structural — a dynamic cast in a dependency-injection container reached, unexpectedly, through `swift-ieee-754`. The compiler abort that made this work impossible on stable Swift is **fixed on 6.5-dev**. Rungs 2 and 3 of the size ladder remain unmeasured; §11.6 states exactly what remains. §11.5 records where this paper's own static audit under-reported, and why grep-based audits bound blockers only from below.

---

## 1. Introduction

The motivating goal is to use `swift-html` to generate HTML client-side, in the browser, from Swift. This requires three things to be true in sequence:

1. Swift must compile to WebAssembly at a payload size the web tolerates.
2. `swift-html` and its transitive closure must compile under the language subset that smallness requires.
3. The resulting binary must remain small once a real dependency graph is linked, not merely for a trivial program.

Item 1 is settled by prior art (§2). Item 2 is the subject of this paper's empirical work (§4–§5). Item 3 is **not answered here**, and §7 explains why.

### 1.1 Target model

This research targets the **render-to-string** model: Swift renders a complete HTML string, which JavaScript assigns to `innerHTML`. This is chosen over direct DOM node construction because it minimises the JavaScript interop surface to a single import and matches `swift-html`'s existing byte-oriented rendering pipeline. Direct DOM manipulation — and with it the question of whether JavaScriptKit functions under Embedded Swift — is deferred as future work.

---

## 2. Size budget derivation

A feasibility claim requires a falsifiable threshold. We derive one from supply and demand.

### 2.1 Supply — what the configurations cost

| Configuration | Reported size | Source |
|---|---|---|
| Embedded Swift, Hello World | 9.7 KB | swift.org, cited in `swift-institute/Research/wasm-ci-strategy-and-sdk-toolchain-coupling.md` (2026-05-05) |
| Full WASI stdlib, Hello World | ~7.8 MB (some reports 10–15 MB) | Swift Forums, swiftwasm |
| Threshold below which Embedded is required | 400 KB | swiftwasm guidance |

The ~800× ratio between the two configurations is why Embedded mode is a precondition. Note the 9.7 KB figure is dated: the current [swift.org Wasm article](https://www.swift.org/documentation/articles/wasm-getting-started.html) no longer publishes a number.

### 2.2 Demand — what the web tolerates

JavaScript bytes per page, mobile ([HTTP Archive Web Almanac 2025](https://almanac.httparchive.org/en/2025/page-weight)):

| p10 | p25 | p50 | p75 | p90 |
|---|---|---|---|---|
| 89 KB | 270 KB | 646 KB | 1,233 KB | 1,910 KB |

Framework runtimes for comparison (min+gzip): Preact ~4 KB, SolidJS ~7 KB, Vue 3 ~34 KB, React 19 ~42 KB. Complete dashboard applications: Svelte 47 KB, Vue 89 KB, React 156 KB.

### 2.3 The budget

The correct yardstick is the framework runtime `swift-html` would displace, not whole-page JavaScript.

| Threshold | Value | Rationale |
|---|---|---|
| Runtime floor (hello world) | ≤ 25 KB | ~2.5× headroom over published 9.7 KB |
| **Competitive** | **≤ 45 KB** | Parity with React 19's ~42 KB runtime |
| **Viable ceiling** | **≤ 150 KB** | Inside p25 mobile JS budget; below React's full-dashboard 156 KB |
| Failed | > 400 KB | Exceeds swiftwasm's Embedded threshold; approaches median whole-page JS |

**Methodological note.** All framework figures above are gzip. Any Swift measurement must be reported in gzip for comparison and brotli separately; conflating them flatters Swift by 15–20%. Further, rendering to `innerHTML` performs strictly less work than React (no reactivity, no reconciliation), so parity with React is the *floor* of a fair comparison, not a victory.

---

## 3. Toolchain and SDK constraints

Established in-house and re-verified for this paper:

1. **Both shipped Wasm SDK IDs target `wasm32-unknown-wasip1`.** `swift-X.Y.Z-RELEASE_wasm` (full stdlib) and `swift-X.Y.Z-RELEASE_wasm-embedded` (Embedded subset). **No bare-metal `wasm32-unknown-none` SDK is published.**
2. **Selecting `_wasm-embedded` auto-injects** `-enable-experimental-feature Embedded -static-stdlib -wmo -D__EMBEDDED_SWIFT__` via the bundle's `embedded-toolset.json`. The SDK ID and the compiler flag are not independent choices.
3. **The SDK is ABI-paired to its toolchain patch version.** As of 2026-07-28, `releases.json` publishes `wasm-sdk` for 6.3, 6.3.1, 6.3.2, 6.3.3 — and no 6.4 release exists. The 6.4 bundle URL returns HTTP 404.
4. **The ecosystem spells the gate `hasFeature(Embedded)`**, not the injected `__EMBEDDED_SWIFT__` define. `hasFeature` is compiler-native and fires regardless of how Embedded was enabled.

---

## 4. Closure audit

### 4.1 Method

The closure was computed by recursively parsing `.package(url:)` declarations across locally-cloned manifests, rooted at `swift-html`.

**Result: 172 packages.** 168 have local manifests; 4 do not (`swift-collections`, `swift-markdown`, `swift-syntax`, `swift-tagged-primitives`) and are excluded from static analysis.

| Layer | Packages | Embedded CI coverage |
|---|---|---|
| `swift-primitives` (L1) | 107 | **Yes** — `embedded` + `embedded-wasm-sdk` |
| `swift-standards` (L2) | 39 | **None** |
| `swift-foundations` (L3) | 22 | **None** |
| External | 4 | n/a |

**Embedded buildability is enforced only at L1.** The `swift-primitives` layer wrapper mandates it as a layer invariant ("a package that cannot satisfy this invariant is, by that fact, not a primitive"). The `swift-foundations` and `swift-standards` wrappers define only `matrix` and `ci-ok`. `swift-html` is L3 and therefore has **no embedded coverage today**.

Consequently 62% of the closure has per-commit empirical evidence and 35% has none.

### 4.2 Static blocker scan

Occurrence counts across the 168 locally-resolvable packages, with `#if !hasFeature(Embedded)` regions stripped before matching:

| Construct | L1 | L2 | L3 |
|---|---|---|---|
| `Mutex` / `import Synchronization` | 20 | 2 | 21 |
| `import Foundation` | 0 | 3 | 8 |
| Existential metatype (`any P.Type`) | 1 | 0 | 3 |
| Existential (`any P`) | 12 | 76 | 25 |
| `Mirror` / reflection | **0** | **0** | **0** |
| Ungated `Codable` conformance | 4 | 21 | 4 |

Two observations. **Reflection is entirely absent from the closure** — zero occurrences in 168 packages, eliminating the single most intractable Embedded blocker class. And the existential counts are inflated by documentation comments; the `ExistentialAny` upcoming feature is enabled ecosystem-wide, so genuine existential *use* is far rarer than the raw count suggests.

Packages carrying `Mutex`/`Synchronization` (12): `swift-witnesses` (13), `swift-async-primitives` (5), `swift-css` (4), `swift-environment` (4), `swift-ownership-primitives` (4), `swift-property-primitives` (4), `swift-cpu-primitives` (2), `swift-ieee-754` (2), `swift-ordinal-primitives` (2), `swift-affine-primitives` (1), `swift-cardinal-primitives` (1), `swift-clock-primitives` (1).

Packages importing Foundation (6): `swift-translating` (5), `swift-translating-dependencies` (2), `swift-css` (1), `swift-rfc-3987` (1), `swift-rfc-4648` (1), `swift-rfc-5322` (1). Note `swift-translating` is reached only through `swift-html`'s **`Translating` package trait**, which is not enabled by default — it does not affect the default build.

---

## 5. Empirical result: one construct explains the failure rate

### 5.1 Observed CI outcomes

Harvested from the most recent conclusive (`success`/`failure`) CI run of each of the 107 L1 packages:

| Job | Success | Failure | No data |
|---|---|---|---|
| `embedded` (nightly Linux, language subset) | 88 | 17 | 2 |
| `embedded-wasm-sdk` (stable 6.3, Wasm SDK) | **15** | **90** | 2 |

The disparity is the finding. **84% of packages satisfy the Embedded language subset; only 14% build under the Embedded Wasm SDK.** The bottleneck is not the language restriction — it is specific to the Wasm target.

### 5.2 Root-cause classification

Thirty failing packages were sampled and their build logs classified by first error. Every genuine compilation failure resolved to the same diagnostic:

```
swift-property-primitives/Sources/Property Consume Primitives/Property.Consume.State.swift:44:32:
error: cannot find type 'Mutex' in scope
```

from:

```swift
@usableFromInline
internal let _storage: Mutex<Storage>
```

An initial pass classified 13 of the 30 as `error: cancelled`. This was an artefact of the extractor sorting diagnostics alphabetically (`cancelled` < `cannot find`); `cancelled` is the Swift driver terminating sibling frontend jobs after a peer fails. Direct inspection of one such log found 12 `Mutex` mentions. The correct reading is that **all sampled genuine failures share one root cause**.

`Mutex` requires the `Synchronization` module, which is unavailable in the Embedded Wasm stdlib.

### 5.3 Reachability model and validation

To test whether one construct explains the fleet-wide pattern, we built a transitive taint model over the manifest graph: a package is *tainted* if it declares `Mutex`/`Synchronization` or depends on a tainted package. Prediction: tainted ⇒ wasm failure.

Evaluated against 105 packages with conclusive CI outcomes:

| | Predicted fail | Predicted pass |
|---|---|---|
| **Observed fail** | 87 | 3 |
| **Observed pass** | 7 | 8 |

**Agreement: 95/105 = 90%.**

The 7 false positives (taint reaches the package, yet it builds) are expected and do not weaken the result: the model is **package-level**, whereas SwiftPM links only *reachable targets*. A package may depend on `swift-property-primitives` without pulling in the `Property Consume Primitives` target. A target-level model would eliminate most of these.

The 3 unexplained failures (`swift-error-primitives`, `swift-terminal-primitives`, `swift-render-primitives`) carry independent root causes and are the residual worth investigating next.

**Interpretation.** The 86% Embedded-Wasm failure rate is one defect amplified by dependency structure, not ninety defects. `swift-property-primitives` is in `swift-html`'s closure with 14 direct dependents inside that closure alone.

---

## 6. Blockers specific to `swift-html`

### 6.1 `elementType` — existential metatype

[`HTML.Element.swift:48`](../../swift-html-render/Sources/HTML%20Rendering%20Core/HTML.Element.swift) in `swift-html-render`:

```swift
private static func elementType(for tag: String) -> (any WHATWG_HTML.Element.`Protocol`.Type)?
```

A 125-case string switch returning an existential metatype, called from `Tag.init` (line 222) to derive `isBlock`, `isVoid`, and `isPreElement`. It is already annotated `swiftlint:disable no_any_protocol_existential`.

**Correction (v1.1.0).** Version 1.0.0 of this paper stated that "existentials and metatypes are both prohibited under Embedded Swift." **That was wrong**, and the error was material enough to change the recommendation's basis. The current Embedded documentation states that Embedded Swift "allows and supports forming existentials of any kind", and explicitly permits `is`, `as?`, and `as!` for testing an existential against a *concrete* type. What remains prohibited is casting **to** an existential type or an existential metatype, calling unbounded generic methods on existentials, and opening existentials into generics. `elementType` *forms* an existential metatype from concrete `.self` values rather than casting to one, so it is not obviously prohibited.

What survives unchanged is the size argument:

- **Size.** It makes all 125 WHATWG element types reachable from a single initialiser. Dead-code elimination cannot strip *any* element even when a page uses six, pulling the full element table and its static metadata into the binary under `-wmo`.

The recommendation therefore stands, but on **one** leg rather than two. It is a size defect, not a compilation blocker.

**Recommendation: refactor and delete, do not gate.** The function computes three `Bool`s that are static properties of a tag-name string literal. A switch returning `(isBlock, isVoid, isPre)` directly requires no types, no metatypes, and no existentials. The argument does not depend on Embedded at all: the present implementation performs a metatype lookup plus protocol-witness dispatch into `.categories` (a Set membership test) and `.content.model` (an enum comparison) on every string-tag construction, to produce three booleans. The replacement is faster, smaller, removes a lint suppression, and **shrinks server-side binaries too** — which is what `swift-html` builds today.

Gating is not available here regardless: `isBlock` and `isVoid` must be correct on every platform, so `#if` would require a second implementation, which is the refactor.

### 6.2 Direct-dependency blockers

| Package | Blocker | Class |
|---|---|---|
| `swift-css` | 4× `Mutex`, 1× `import Foundation` | Investigate |
| `swift-rfc-4648` | 1× `import Foundation` | Investigate |
| `swift-html-render` | 1× existential metatype (§6.1) | **Refactor** |
| `swift-property-primitives` (transitive) | `Mutex<Storage>` | **Ecosystem-wide, §5** |

---

## 7. Remediation taxonomy

Four mechanisms, each already precedented in this codebase. No blocker requires inventing a new one.

| Situation | Mechanism | Precedent |
|---|---|---|
| Additive conformance nothing depends on | `#if !hasFeature(Embedded)` | `Codable` across ~8 primitives packages |
| Load-bearing; must be correct everywhere | **Refactor, delete old path** | §6.1 `elementType` |
| Optional caller-visible feature surface | Package trait | `swift-html`'s own `Translating` trait |
| Large cohesive non-embeddable subsystem | Separate target + CI `embedded-target` | `swift-pool-primitives`: `embedded-target: "Pool Bounded Primitives"` |

**Caution for the gating class.** CI runs an API-breakage check (γ-1c, advisory). `#if`-gating *public* API makes the public surface platform-dependent, which interacts with that job and with DocC. The `Codable` precedent is safe because conformances are additive; gating a public *method* is a design question, not a mechanical fix.

---

## 8. What this paper does not establish

**The binary-size question — the original motivation — is unmeasured.** No size figure in §2 was produced from this codebase.

The cause is a toolchain gap, not an oversight. The Embedded Wasm SDK is ABI-paired to its toolchain patch version (§3.3). The local machine runs Swift 6.4 (Xcode); swift.org's newest published Wasm SDK is 6.3.3, and no 6.4 bundle exists. Neither Docker nor swiftly is installed, so a matching 6.3.3 environment cannot be constructed locally without a toolchain installation.

**Closing this requires one of:**

1. Install a swift.org 6.3.3 toolchain locally (via swiftly) and pair it with `swift-6.3.3-RELEASE_wasm-embedded`.
2. Add an `embedded-wasm-sdk` job to the `swift-foundations` layer wrapper, or a temporary per-package job, reusing the existing `install-swift-sdk` composite action.

Option 2 is preferable: it measures on Swift 6.3, the toolchain CI actually gates, and the apparatus already exists. It also requires a decision that §9 raises.

Also unestablished: **generic specialisation cost**. Under `-wmo`, nested result-builder trees specialise into a unique concrete type per page structure. This is the classic Embedded Swift size surprise, it scales with page complexity rather than dependency count, and it is the primary reason the 45 KB competitive target is uncertain even if the 400 KB ceiling is comfortable.

---

## 9. An architectural question this forces

Embedded buildability is currently *defined* as an L1 property. The primitives layer wrapper states that a package failing the invariant "is, by that fact, not a primitive — it belongs at L2 or L3."

`swift-html` is L3. Making it Embedded-buildable therefore does not merely add a CI job; it asserts that embeddability is a property an L3 package may possess and declare. That bears on whether `embedded-wasm-sdk` belongs in the `swift-foundations` wrapper as an opt-in input rather than a layer mandate.

This is a governance decision, not a technical one, and it should be settled before CI changes land.

---

## 10. Conclusions

1. **Embedded mode is a precondition, not an optimisation.** The ~800× gap between WASI (~7.8 MB) and Embedded (9.7 KB) hello-world sizes places non-embedded WASI far outside any defensible web budget.
2. **The ecosystem's 86% Embedded-Wasm failure rate is one defect.** A `Mutex<Storage>` in `swift-property-primitives` explains observed CI outcomes across 105 packages at 90% agreement. This reframes the work from "port 172 packages" to "fix twelve packages carrying three defect classes."
3. **Reflection — the most intractable Embedded blocker — is entirely absent** from all 168 audited packages.
4. **`swift-html`'s own blocker is a single function**, whose removal is independently justified on server-side performance and size grounds.
5. **The size question remains open** and is the highest-value next step.

### Recommended sequence

| # | Action | Depends on |
|---|---|---|
| 1 | Refactor `elementType` to return `(Bool, Bool, Bool)`; delete the metatype path | — |
| 2 | Resolve `Mutex` in `swift-property-primitives` (gate or embedded-safe substitute) | — |
| 3 | Settle §9: may an L3 package declare embeddability? | — |
| 4 | Add `embedded-wasm-sdk` to a `swift-html` branch; obtain first real build outcome | 1, 2, 3 |
| 5 | Instrument the build ladder for size, gzip and brotli, with non-embedded control | 4 |
| 6 | Audit `swift-css` and `swift-rfc-4648` Foundation/`Mutex` usage | 4 |

Steps 1 and 2 are independent and can proceed immediately. Step 5 is the deliverable that answers the original question.

---

## Appendix A. Reproduction

- Closure: recursive parse of `.package(url:)` across local manifests rooted at `swift-html` → 172 packages.
- CI harvest: `gh run list --workflow ci.yml`, most recent run with conclusion `success`/`failure`; job names matched on `Embedded build` and `Embedded Wasm SDK`.
- Static scan: regex over `Sources/`, with `#if !hasFeature(Embedded)…#endif` regions stripped before matching.
- Taint model: package tainted if it declares `Mutex`/`Synchronization` or transitively depends on a tainted package.

**Known limitations.** The taint model is package-level, not target-level, over-predicting failure (7 cases). Existential counts include documentation comments. The 4 non-cloned external packages are excluded from static analysis. All CI figures are a single snapshot of 2026-07-28 and the underlying jobs are `continue-on-error: true`, so their results are advisory and excluded from `ci-ok`.

## Appendix B. Sources

- [swift.org — Getting started with Swift for WebAssembly](https://www.swift.org/documentation/articles/wasm-getting-started.html)
- [HTTP Archive Web Almanac 2025 — Page Weight](https://almanac.httparchive.org/en/2025/page-weight)
- [Swift Forums — Swift wasm binary sizes](https://forums.swift.org/t/swift-wasm-binary-sizes/51533)
- [SwiftWasm 6.1 release notes](https://blog.swiftwasm.org/posts/6-1-released/)
- `swift-institute/Research/wasm-ci-strategy-and-sdk-toolchain-coupling.md` v1.0.0 (2026-05-05)
- `swift-primitives/.github/.github/workflows/swift-ci.yml`@main
- `swift-foundations/.github/.github/workflows/swift-ci.yml`@main

---

## 11. Empirical build results (2026-07-28)

Version 1.0.0 reported the size question as unmeasurable for want of a toolchain. That is no longer true. This section records what was actually built and measured.

### 11.1 Toolchain

Two configurations were exercised on macOS arm64:

| | Toolchain | SDK |
|---|---|---|
| A | swift.org 6.3.3-RELEASE (swiftly) | `swift-6.3.3-RELEASE_wasm-embedded` |
| B | `main-snapshot-2026-07-11` (**6.5-dev**) | `swift-DEVELOPMENT-SNAPSHOT-2026-07-11-a_wasm-embedded` |

Three findings on toolchains, each correcting §3:

1. **Xcode's own toolchain cannot do this at all.** Building with `DEVELOPER_DIR=/Applications/Xcode.app` (Swift 6.3.3) fails at the *C* layer: `error: unable to create target: 'No available targets are compatible with triple "wasm32-unknown-wasip1"'`, raised by Apple's clang compiling `cmark-gfm`. Apple's clang has no WebAssembly backend. A swift.org toolchain is mandatory; this is not a version-matching issue.
2. **Host-native Embedded on macOS is impossible.** `swift build -Xswiftc -enable-experimental-feature -Xswiftc Embedded` targeting `arm64-apple-macos` fails with `error: unable to resolve module dependency: 'Swift'` — the macOS SDK ships no Embedded stdlib flavour. On a Mac, cross-compiling to wasm32 is the *only* route to any Embedded surface.
3. **There is no 6.4-branch Wasm SDK.** `swiftwasm/swift-sdk-index`'s `tag-by-version.json` maps snapshot Wasm SDKs to `6.5-dev` (main) only. Snapshot Embedded/Wasm work happens on main, not on a 6.4 branch.

### 11.2 Measured sizes

Rung 1 (runtime floor) and Rung 4 (the non-embedded control) are complete. Release configuration, SDK A, `print("hi")` only, no dependencies. `brotli` was unavailable; gzip is in any case the correct basis, since every JavaScript framework figure in §2.2 is gzip.

| Configuration | raw | gzip |
|---|---|---|
| **Embedded** | 21,579 B (21.1 KB) | **9,065 B (8.9 KB)** |
| **WASI, full stdlib** | 7,085,523 B (6.76 MB) | 1,869,739 B (1.78 MB) |
| **Ratio** | **328×** | **206×** |

**This settles §2.1's premise empirically rather than by citation.** The non-embedded configuration spends 1.78 MB gzip to print two characters — roughly 40× the 45 KB competitive budget and 12× the 150 KB viable ceiling, before any swift-html code exists. Embedded Swift is a precondition, measured on this codebase's own toolchain.

The embedded floor of 8.9 KB gzip sits inside the ≤25 KB budget of §2.3. Note the divergence from swift.org's published 9.7 KB: this build is 21.1 KB *raw*. The published figure is close to the gzip result, which suggests it may have been a compressed measurement or a barer program than one calling `print`.

### 11.3 The blocker chain

Building `swift-html`'s `HTML` target against SDK B, release configuration, blockers were resolved in sequence. Each was resolved before the next appeared, so this is an ordered chain rather than a set.

| | Blocker | Location | Class | Status |
|---|---|---|---|---|
| A | `'StringLiteralType' is unavailable` | 12 sites: swift-whatwg-html (10), swift-w3c-cssom (3), swift-w3c-css (1) — **all L2 standards** | Mechanical → `String` | Worked around |
| B | `no such module 'Foundation'` | Apple's swift-markdown, via swift-markdown-html-render | **Package trait** | **Resolved** |
| C | `'init(reflecting:)' is unavailable` | swift-machine-primitives, `Machine.Capture.Slot.swift:39` | Inside `#if DEBUG` | **Resolved by release build** |
| D | `cannot use key path in embedded Swift` | **105 sites across 65 files**, surfaced first in swift-binary-base-primitives | Mechanical → closure | Worked around |
| E | `cannot do dynamic casting in embedded Swift` | swift-dependency-primitives, `Dependency.Values.swift:65`, reached via swift-ieee-754 | `#if !hasFeature(Embedded)` at the ieee-754 edge | **Resolved** |
| F | `'Codable' is unavailable` | 42 inline conformances / 39 files; 11 extension-declared blocks (swift-rfc-1035, swift-rfc-1123) | Mixed — see below | Worked around |
| G | `cannot specialize generic function or default protocol method in this context` | swift-dimension-primitives, `Tagged+Quantized.swift:32` | **Structural** | Open |

**Blocker A is not toolchain-dependent** — it fails identically on 6.3.3 and 6.5-dev. All twelve sites are the same shape: `init(stringLiteral value: StringLiteralType)` in an `ExpressibleByStringLiteral` conformance. `StringLiteralType` is a typealias for `String`; substituting `String` is semantics-preserving.

**Blocker B is resolved and the mechanism is verified.** Markdown enters `swift-html` through exactly one line — `@_exported import Markdown_HTML_Rendering` in `Sources/HTML/exports.swift:13`. It is a re-export convenience, not load-bearing logic. Gating it behind a `Markdown` package trait (default-enabled, so existing consumers are unaffected) and building with `--disable-default-traits` removed the Foundation dependency entirely and the build proceeded. This mirrors the existing `Translating` trait exactly. **This is the recommended fix and it has been empirically validated, not merely proposed.**

**Blocker D was far wider than its diagnostics suggested.** The compiler reported 6 errors in 3 files; the actual incidence is 105 shorthand key paths across 65 files. Swift reports these lazily, so error counts materially understate remediation scope — a methodological caution for anyone estimating this work from a single build log. All observed instances are the `map(\.property)` shape, mechanically convertible to `map { $0.property }`.

**Blocker E is the only structural one, and it arrives by an unexpected path:**

```
swift-html → swift-html-render → swift-w3c-css → swift-ieee-754 → swift-dependency-primitives
```

The offending construct is a dependency-injection container reading heterogeneous storage through a cast to a generic parameter:

```swift
if let value = storage[ObjectIdentifier(key)] as? K.Value { return value }
```

`K.Value` is a generic parameter, not a concrete type, so this is precisely the dynamic cast Embedded prohibits — and unlike A and D it cannot be mechanically rewritten, because heterogeneous keyed storage is the container's purpose.

**Resolved by cutting the edge, not the container.** `swift-ieee-754` — a floating-point *standard* package — uses dependency injection in exactly one file (`IEEE_754.Exceptions.swift`, 6 references) to scope IEEE-754 sticky exception-flag state. A numeric standards package reaching for a DI framework is questionable on its own terms; that it is what blocks Embedded for an HTML renderer four hops away makes the case sharper. Gating that one file behind `#if !hasFeature(Embedded)` — returning the already-present `_global` instance under Embedded and suppressing the `Dependency.Key` conformance and its import — was applied and **the build proceeded past it**. The DI container itself was never touched. This is the `#if !hasFeature(Embedded)` remediation class of §7 working exactly as its `Codable` precedent suggests.

**Blocker F**, reached next, is ungated `Codable` conformance on `RFC_1035.Domain` and `RFC_1035.Domain.Label`. This is the one blocker class §4.2's static scan *did* detect (29 ungated conformances across the closure), and it takes the same documented treatment — the `Codable`-behind-`#if` pattern already used across roughly eight primitives packages. It is **not** as mechanical as §7 implies, and it is the largest remediation class found:

- **The house `Codable`-behind-`#if` precedent does not transfer directly.** In the primitives layer the conformance is a standalone extension (`extension Direction: Codable {}`), which `#if` wraps trivially. In `swift-rfc-1035` and 38 other files the conformance is declared **inline on the type** (`public struct Domain: Sendable, Codable {`). A conditional cannot be placed inside an inheritance clause, so remediation requires restructuring each declaration — dropping the conformance from the type and re-adding it as a gated extension. For nested types this means spelling the full nested path.
- **Incidence: 42 inline conformances across 39 files** in the reachable set alone.
- **Custom implementations must be gated as whole method bodies.** Removing the conformance is insufficient where types implement `init(from decoder: Decoder)` / `encode(to encoder: Encoder)` by hand: `Encoder`, `Decoder`, and `SingleValueDecodingContainer` are themselves unavailable in Embedded, so those members must be gated too, not merely their conformance.

This revises the §7 cost model. `Codable` was classified there as the cheapest remediation class — an additive conformance that nothing depends on. That holds for the *extension-declared* case the precedent was drawn from, and not for the inline-declared case, which dominates numerically in this closure. Anyone estimating this work from the §7 table will under-count it.

### 11.4 The compiler abort is fixed on 6.5-dev

§8 recorded a `CrossModuleOptimization` abort (`ASTContext.cpp:5924`) on parameter-pack conformance in swift-render-primitives, tracked as `swift-institute/Issues#58`. **It does not reproduce on 6.5-dev.** `Render_Primitive.swiftmodule` builds, and 189 modules compiled past the point where 6.3.3 aborted.

Two corrections to the issue's recorded envelope, both now posted there:

1. It **does** reproduce on macOS-arm64 — the issue previously recorded that it does not, and that no reproducer was possible on Apple hardware. Targeting wasm32 surfaces it.
2. It reproduces in **debug** (`-Onone`), not only release + `-O`. Selecting an `-embedded` SDK injects `-enable-experimental-feature Embedded -static-stdlib -wmo`, and Embedded runs `CrossModuleOptimization` regardless of optimization level. **The variable was never the platform; it was whether CMO ran.** `-Xswiftc -disable-cmo` does not suppress it.

### 11.5 Limitations of this paper's own static audit

§4.2's scan under-reported three of the five blockers, and the reason is worth recording because it generalises. The scan matched **type names** (`Mirror`, `KeyPath`, `Codable`, `any P`) rather than **usage syntax**. Consequently it reported zero reflection and zero key paths, while the build found `String(reflecting:)` and 105 key-path sites written as `\.property`. `StringLiteralType` was not in the pattern set at all.

The lesson is that a grep-based compatibility audit establishes a **lower bound on blockers, never an upper one**, and should not be presented as a compatibility verdict. Only a build does that. §4.2's table should be read accordingly.

### 11.6a Blocker G — generic specialization

The chain currently terminates at `swift-dimension-primitives/Sources/Dimension Primitives/Tagged+Quantized.swift:32`:

```
error: cannot specialize generic function or default protocol method in this context
```

This is the deepest of the Embedded restrictions encountered. Embedded Swift requires that all generics be fully specialized at compile time; a generic function or default protocol method reached through a context the compiler cannot monomorphize is rejected outright. Unlike A, D, and F it has no mechanical rewrite, and unlike B, C, and E it is not resolvable by cutting a dependency edge — the construct is intrinsic to the code that uses it.

It is unassessed whether this instance is genuinely load-bearing for `swift-html`'s reachable set or, like Blocker E, arrives via an incidental edge that could be cut. That assessment is the correct next step, and it should precede any attempt to refactor.

### 11.6 Status

`swift-html` does **not** yet compile for Embedded WebAssembly. Rungs 2 and 3 remain unmeasured, so the paper's central question — how large a realistic page is — is still open.

What has changed since v1.0.0 is that the remaining distance is enumerated rather than speculative. Seven blockers were encountered in sequence; five are resolved or worked around, one (F) is resolved but at higher cost than §7 predicted, and one (G) is structural and unassessed. The compiler abort that made this work impossible on stable Swift is fixed on main.

**On the workarounds.** Blockers A, D, and F were worked around by patching throwaway scratch checkouts, not by proposing those patches as fixes. Blocker F's workaround in particular — deleting inline `Codable` conformances outright — is a measurement expedient that discards public API and must not be mistaken for a remediation proposal. The purpose was to reach a size measurement; the proper fixes are given per-blocker above.

**On the trajectory.** Each resolved blocker revealed the next, and the sequence has not converged: A (mechanical) → B (trait, resolved) → C (build-config, resolved) → D (mechanical, 105 sites) → E (edge cut, resolved) → F (mechanical but costly, 53 sites) → G (structural). Extrapolating a completion estimate from seven data points that have not yet terminated would be unfounded, and this paper declines to offer one. What can be said is that no blocker so far has proved architecturally fatal to `swift-html` itself — every one has lived in a dependency, and most in packages several hops removed from HTML rendering.
