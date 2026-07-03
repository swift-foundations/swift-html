//
//  LazyVGrid Tests.swift
//  swift-html
//
//  Snapshot tests for LazyVGrid layout component
//

import HTML
import HTML_Rendering_Core_Test_Support
import Layout_Primitives
import Testing

@Suite(.snapshots(record: .missing))
struct LazyVGridSnapshotTests {
    @Test
    func `LazyVGrid with fractions columns`() {
        snapshot(as: .html) {
            LazyVGrid(columns: .fractions([.fr(1), .fr(2)])) {
                div { "Item 1" }
                div { "Item 2" }
                div { "Item 3" }
            }
        } matches: {
            """
            <div class="grid-template-columns-0 display-1 width-2">
              <div>Item 1
              </div>
              <div>Item 2
              </div>
              <div>Item 3
              </div>
            </div>
            """
        }
    }

    @Test
    func `LazyVGrid with count columns`() {
        snapshot(as: .html) {
            LazyVGrid(columns: .count(3)) {
                div { "Item 1" }
                div { "Item 2" }
                div { "Item 3" }
            }
        } matches: {
            """
            <div class="grid-template-columns-0 display-1 width-2">
              <div>Item 1
              </div>
              <div>Item 2
              </div>
              <div>Item 3
              </div>
            </div>
            """
        }
    }

    @Test
    func `LazyVGrid with autoFit columns`() {
        snapshot(as: .html) {
            LazyVGrid(columns: .autoFit(minWidth: .px(200))) {
                div { "Item 1" }
                div { "Item 2" }
                div { "Item 3" }
            }
        } matches: {
            """
            <div class="grid-template-columns-0 display-1 width-2">
              <div>Item 1
              </div>
              <div>Item 2
              </div>
              <div>Item 3
              </div>
            </div>
            """
        }
    }
}
