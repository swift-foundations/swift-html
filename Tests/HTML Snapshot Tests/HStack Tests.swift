//
//  HStack Tests.swift
//  swift-html
//
//  Snapshot tests for HStack layout component
//

import HTML
import HTML_Rendering_Core_Test_Support
import Testing

@Suite(.snapshots(record: .missing))
struct HStackSnapshotTests {
    @Test
    func `HStack renders with default settings`() {
        snapshot(as: .html) {
            HStack {
                div { "First item" }
                div { "Second item" }
            }
        } matches: {
            """
            <div class="column-gap-0 size-1 flex-direction-2 display-3 vertical-align-4 align-items-5">
              <div>First item
              </div>
              <div>Second item
              </div>
            </div>
            """
        }
    }

    @Test
    func `HStack with custom spacing and alignment`() {
        snapshot(as: .html) {
            HStack(alignment: .top, spacing: .px(20)) {
                div { "First item" }
                div { "Second item" }
            }
        } matches: {
            """
            <div class="column-gap-0 size-1 flex-direction-2 display-3 vertical-align-4 align-items-5">
              <div>First item
              </div>
              <div>Second item
              </div>
            </div>
            """
        }
    }
}
