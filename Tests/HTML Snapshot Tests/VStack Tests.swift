//
//  VStack Tests.swift
//  swift-html
//
//  Snapshot tests for VStack layout component
//

import HTML
import HTML_Rendering_Core_Test_Support
import Testing

@Suite(.snapshots(record: .missing))
struct VStackSnapshotTests {
    @Test
    func `VStack renders with default settings`() {
        snapshot(as: .html) {
            VStack {
                div { "First item" }
                div { "Second item" }
            }
        } matches: {
            """
            <div class="row-gap-0 max-width-1 flex-direction-2 display-3 align-items-4">
              <div>First item
              </div>
              <div>Second item
              </div>
            </div>
            """
        }
    }

    @Test
    func `VStack with custom spacing and alignment`() {
        snapshot(as: .html) {
            VStack(alignment: .start, spacing: .px(15)) {
                div { "First item" }
                div { "Second item" }
            }
        } matches: {
            """
            <div class="row-gap-0 max-width-1 flex-direction-2 display-3 align-items-4">
              <div>First item
              </div>
              <div>Second item
              </div>
            </div>
            """
        }
    }
}
