//
//  Spacer Tests.swift
//  swift-html
//
//  Snapshot tests for Spacer layout component
//

import HTML
import HTML_Rendering_Core_Test_Support
import Testing

@Suite(.snapshots(record: .missing))
struct SpacerSnapshotTests {
    @Test
    func `Spacer pushes items apart in HStack`() {
        snapshot(as: .html) {
            HStack {
                div { "Left" }
                Spacer()
                div { "Right" }
            }
        }  matches: {
            """
            <div class="column-gap-0 size-1 flex-direction-2 display-3 vertical-align-4 align-items-5">
              <div>Left
              </div>
              <div class="flex-grow-6">
              </div>
              <div>Right
              </div>
            </div>
            """
        }
    }
}
