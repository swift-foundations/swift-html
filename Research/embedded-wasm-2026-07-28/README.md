# Embedded Swift / WebAssembly research artifacts — 2026-07-28/29

Overnight run investigating whether `swift-html` can build for WebAssembly under Embedded Swift.

The paper this evidence supports is its sibling in this directory:
[`Embedded Swift and WebAssembly for Client-Side HTML Rendering.md`](Embedded%20Swift%20and%20WebAssembly%20for%20Client-Side%20HTML%20Rendering.md) (v1.1.0).
This subtree holds the supporting evidence behind it.

**Machine paths in this corpus have been rewritten to placeholders** (`$SCRATCH`,
`$TOOLCHAINS`, `$SWIFT_SDKS`, `$INSTITUTE`, `$HOME`, `$TMPDIR`) so the logs stay
readable without carrying anything host-specific. Commands are therefore
illustrative, not copy-pasteable, and paths inside build logs will not resolve.

## Headline results (the irreplaceable part)

**Measured sizes** — release, SDK `swift-6.3.3-RELEASE_wasm-embedded`, `print("hi")`, no dependencies:

| Configuration | raw | gzip |
|---|---|---|
| Embedded | 21,579 B | **9,065 B** |
| WASI full stdlib | 7,085,523 B | 1,869,739 B |
| Ratio | 328× | **206×** |

`artifacts/emb.wasm` is the embedded binary, kept because it substantiates the
9,065 B figure — the surprising, load-bearing half of the ratio — and costs 21 KB.

**`wasi.wasm` (7,085,523 B) was deliberately not committed.** A 6.8 MB blob is a
permanent cost in a package repository every SwiftPM consumer clones, and it is
the *control* measurement: the maximally trivial, fully documented case that the
recipe below regenerates. Its identity is preserved instead:

| file | bytes | gzip | SHA-256 |
|---|---|---|---|
| `emb.wasm` (committed) | 21,579 | 9,065 | `3581c21f6c12a3803d46565e916af9a93c9bd15107b3c0894ab90a9b7023e4c6` |
| `wasi.wasm` (not committed) | 7,085,523 | 1,869,739 | `e39661bdc0989059b6785aea3e90b755122e05d30bc96d46831d73a23bac09e6` |

Regenerate the control by building `artifacts/ladder/rung1-hello` (sources are
committed) against the non-embedded SDK `swift-6.3.3-RELEASE_wasm`, release
configuration, and compare the digest above.

**Budget for comparison (gzip):** competitive ≤45 KB, viable ≤150 KB, failed >400 KB.

**Blocker chain** building `swift-html`'s HTML target, release, SDK `swift-DEVELOPMENT-SNAPSHOT-2026-07-11-a_wasm-embedded`:

| | Blocker | Class | Status |
|---|---|---|---|
| A | `StringLiteralType` unavailable — 12 sites (swift-whatwg-html 10, swift-w3c-cssom 3, swift-w3c-css 1) | Mechanical → `String` | Worked around |
| B | swift-markdown needs Foundation | Package trait | **RESOLVED, validated** |
| C | `String(reflecting:)` in swift-machine-primitives | `#if DEBUG`-only | **RESOLVED by release build** |
| D | Key paths — 105 sites / 65 files | Mechanical → closures | Worked around |
| E | Dynamic cast in swift-dependency-primitives DI container, via swift-ieee-754 | `#if !hasFeature(Embedded)` | **RESOLVED by cutting edge** |
| F | `Codable` — 42 inline conformances / 39 files, 11 extension blocks | Mixed | Worked around |
| G | Cannot specialize generic function — swift-dimension-primitives `Tagged+Quantized.swift:32` | **Structural** | OPEN |

**Compiler abort (swift-institute/Issues#58): FIXED on 6.5-dev.** `Render_Primitive.swiftmodule` builds; 189 modules compiled past where 6.3.3 aborted at `ASTContext.cpp:5924`. Envelope correction also established: it DOES reproduce on macOS-arm64 in DEBUG when the target is wasm32, because Embedded forces CMO regardless of `-O`. Both posted as comments on Issues#58.

**Mutex finding (Issues#59):** 90 of 105 L1 `embedded-wasm-sdk` failures trace to one `Mutex<Storage>` in `swift-property-primitives`. Taint model predicts CI outcomes at 90% agreement (95/105).

## Toolchain facts

- Xcode's clang has **no WebAssembly backend** — `DEVELOPER_DIR=/Applications/Xcode.app` fails on `cmark-gfm` C sources. A swift.org toolchain is mandatory.
- Host-native Embedded on macOS is **impossible**: no Embedded stdlib flavour in the macOS SDK. Cross-compiling to wasm32 is the only local Embedded surface.
- **No 6.4-branch Wasm SDK exists.** Snapshot Wasm SDKs map to 6.5-dev (main) only.
- These results depend on two toolchains, both installed via `swiftly` and both named
  explicitly wherever they are used: **Swift 6.3.3-RELEASE** (paired with
  `swift-6.3.3-RELEASE_wasm-embedded`, used for the size measurements) and
  **`main-snapshot-2026-07-11`** = 6.5-dev (paired with
  `swift-DEVELOPMENT-SNAPSHOT-2026-07-11-a_wasm-embedded`, used for the blocker chain).
  The SDK is ABI-paired to its toolchain patch version, so the pairing is not optional.
- Because every command names its toolchain explicitly, none of this depends on which
  toolchain is the machine's default. Host shell and default-toolchain configuration is
  local machine state and is deliberately not recorded here; see
  `swift-institute/Workspace` → `TOOLCHAINS.md` for the Institute's toolchain setup.

## Contents

- `data/` — dependency closure (172 packages), layer classification, static audit, CI harvest (`harvest2.tsv` is the corrected one), issue bodies as filed
- `logs/` — every build log; `rel*.log` are the 6.5-dev release chain, `rel8.log` is the last (blocker G)
- `patches/` — throwaway workaround scripts (patchA/D/E/F). **Not remediation proposals** — patchF2 deletes public API to reach a measurement.
- `artifacts/` — `emb.wasm` (the measured embedded binary) and the rung-1 ladder
  package *sources*. The SwiftPM `.build/` tree that produced them is **not** committed:
  `.gitignore` excludes `.build/` fleet-wide, it was 7.2 MB of module cache and object
  files, and it was where most host-specific paths lived. `wasi.wasm` is likewise not
  committed — see the size table above for its digest and how to regenerate it.
- `trait-gate-fix/` — **the validated Blocker B fix**: `Package.swift` with a `Markdown` trait (default-on) and gated `exports.swift`. This is the one change worth landing.

## Reproduce a build

```
export PATH="$HOME/.swiftly/bin:$PATH"
cd <copy of swift-html with trait-gate-fix applied>
swiftly run swift build -c release \
  --swift-sdk swift-DEVELOPMENT-SNAPSHOT-2026-07-11-a_wasm-embedded \
  --target HTML --disable-default-traits +main-snapshot-2026-07-11
```

Then apply `patches/patchA.sh <scratch-path>` etc. as blockers reappear (fresh checkouts lose the patches).

## Status

`swift-html` does **not** yet compile for Embedded Wasm. Rungs 2 and 3 (single `<div>`, realistic page) are **unmeasured** — the central size question is still open. Next step: assess whether blocker G is load-bearing or arrives on a cuttable edge like E.

No Institute repo was committed to. All package edits were to throwaway scratch checkouts.
