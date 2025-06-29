//
//  SensoryFeedbackView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/29/25.
//

import SwiftUI

struct SensoryFeedbackView: View {
    @State private var sensoryFeedback: SensoryFeedback?
    
    var body: some View {
        List {
            Section {
                Button("Success") {
                    sensoryFeedback = .success
                }
                Button("Warning") {
                    sensoryFeedback = .warning
                }
                Button("Error") {
                    sensoryFeedback = .error
                }
                Button("Selection") {
                    sensoryFeedback = .selection
                }
                Button("Increase") {
                    sensoryFeedback = .increase
                }
                Button("Decrease") {
                    sensoryFeedback = .decrease
                }
                Button("Start") {
                    sensoryFeedback = .start
                }
                Button("Stop") {
                    sensoryFeedback = .stop
                }
                Button("Alignment") {
                    sensoryFeedback = .alignment
                }
                Button("Level Change") {
                    sensoryFeedback = .levelChange
                }
                Button("Path Complete") {
                    sensoryFeedback = .pathComplete
                }
                Button("Impact") {
                    sensoryFeedback = .impact
                }
            }
            
            Section(header: Text("Impact - Weight")) {
                Button("Weight: Light") {
                    sensoryFeedback = .impact(weight: .light, intensity: 1.0)
                }
                Button("Weight: Medium") {
                    sensoryFeedback = .impact(weight: .medium, intensity: 1.0)
                }
                Button("Weight: Heavy") {
                    sensoryFeedback = .impact(weight: .heavy, intensity: 1.0)
                }
            }
            
            Section(header: Text("Impact - Flexibility")) {
                Button("Flexibility: Solid") {
                    sensoryFeedback = .impact(flexibility: .solid, intensity: 1.0)
                }
                Button("Flexibility: Soft") {
                    sensoryFeedback = .impact(flexibility: .soft, intensity: 1.0)
                }
            }
            
            Section(header: Text("Selection Feedback")) {
                Button("Selection: Maximum") {
                    sensoryFeedback = .selection(.maximum)
                }
                Button("Selection: Minimum") {
                    sensoryFeedback = .selection(.minimum)
                }
                Button("Selection: On") {
                    sensoryFeedback = .selection(.on)
                }
                Button("Selection: Off") {
                    sensoryFeedback = .selection(.off)
                }
            }

            Section(header: Text("Press Feedback")) {
                Button("Press: Button") {
                    sensoryFeedback = .press(.button)
                }
                Button("Press: Button Icon Only") {
                    sensoryFeedback = .press(.buttonIconOnly)
                }
                Button("Press: Slider") {
                    sensoryFeedback = .press(.slider)
                }
                Button("Press: Toggle") {
                    sensoryFeedback = .press(.toggle)
                }
                Button("Press: Tab") {
                    sensoryFeedback = .press(.tab)
                }
            }

            Section(header: Text("Release Feedback")) {
                Button("Release: Slider") {
                    sensoryFeedback = .release(.slider)
                }
            }
        }
            .sensoryFeedback(trigger: sensoryFeedback) {
                if let sensoryFeedback {
                    self.sensoryFeedback = nil
                    return sensoryFeedback
                } else {
                    return nil
                }
            }
    }
}

#Preview {
    SensoryFeedbackView()
}
