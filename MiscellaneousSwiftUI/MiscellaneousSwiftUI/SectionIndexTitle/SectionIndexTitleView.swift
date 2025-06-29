//
//  SectionIndexTitleView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/29/25.
//

import SwiftUI

struct SectionIndexTitleView: View {
    @State private var listSectionIndexVisibility: Visibility = .visible
    
    var body: some View {
        List {
            ForEach(1...9, id: \.self) { index in
                Section("Section \(index)") {
                    Text("Hello World! (Section \(index))")
                }
                .sectionIndexLabel(Text("\(index)"))
            }
        }
        .listSectionIndexVisibility(listSectionIndexVisibility)
        .overlay(alignment: .center) { 
            Toggle(
                isOn: Binding(
                    get: {
                        listSectionIndexVisibility == .visible
                    },
                    set: { newValue in
                        if newValue {
                            listSectionIndexVisibility = .visible
                        } else {
                            listSectionIndexVisibility = .hidden
                        }
                    }
                ),
                label: {
                    Text("listSectionIndexVisibility")
                }
            )
        }
    }
}

#Preview {
    SectionIndexTitleView()
}
