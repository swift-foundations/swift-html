## Summary

Across the 107 `swift-primitives` packages, the advisory `embedded-wasm-sdk` CI job passes for **15** and fails for **90**. That 86% failure rate reads as broad Embedded incompatibility. It is not. **Essentially all of it traces to one stored property in one file.**

`swift-property-primitives/Sources/Property Consume Primitives/Property.Consume.State.swift:44`

```swift
@usableFromInline
internal let _storage: Mutex<Storage>
```

`Mutex` comes from the `Synchronization` module, which is unavailable in the Embedded Wasm stdlib. Every dependent that reaches this target fails to compile:

```
error: cannot find type 'Mutex' in scope
```

## Evidence

Thirty failing packages were sampled and classified by first diagnostic. Every genuine compilation failure was this one. (An initial pass mis-binned 13 as `error: cancelled` — an extraction artefact from sorting diagnostics alphabetically, `cancelled` < `cannot find`; `cancelled` is the driver terminating sibling frontend jobs after a peer fails. Direct inspection of one such log found 12 `Mutex` mentions.)

A transitive taint model was then built over the manifest graph — a package is tainted if it declares `Mutex`/`Synchronization` or depends on a tainted package — and tested against observed CI outcomes for the 105 packages with a conclusive result:

| | Predicted fail | Predicted pass |
|---|---|---|
| **Observed fail** | 87 | 3 |
| **Observed pass** | 7 | 8 |

**Agreement 95/105 = 90%**, from a model whose only input is this single construct.

The 7 false positives are expected and do not weaken the result: the model is package-level, while SwiftPM links only *reachable targets*. A package can depend on `swift-property-primitives` without pulling in `Property Consume Primitives`. A target-level model would remove most of them. The 3 unexplained failures (`swift-error-primitives`, `swift-terminal-primitives`, `swift-render-primitives`) have independent root causes and are the residual worth investigating separately — note `swift-render-primitives` is the module in the cross-module-optimization compiler abort tracked in #58.

## Why this is worth fixing first

Fixing one file plausibly moves the L1 `embedded-wasm-sdk` pass rate from 14% toward the high nineties. No other single change in the ecosystem has that leverage. It is also a precondition for Embedded/Wasm work above L1: `swift-property-primitives` sits in `swift-html`'s 172-package closure with 14 direct dependents inside that closure alone.

## Remediation options

1. `#if !hasFeature(Embedded)` around the `Mutex` path with an embedded-safe alternative — Embedded Wasm is single-threaded, so the synchronisation is not buying anything on that target. The ecosystem already uses this spelling for `Codable` across ~8 primitives packages.
2. Substitute a storage type that is embedded-available on all targets.
3. Move the consume-state surface to its own target so dependents that do not need it are unaffected — precedent: `swift-pool-primitives` uses the wrapper's `embedded-target` input for exactly this shape.

Option 1 is the smallest change; option 3 is the most structural.

## Reproduction

CI harvest: most recent conclusive (`success`/`failure`) run per package via `gh run list --workflow ci.yml`, job matched on `Embedded Wasm SDK`. Snapshot date 2026-07-28. Note the job is `continue-on-error: true` and excluded from `ci-ok`, so these results are advisory and invisible in the aggregate status check.
