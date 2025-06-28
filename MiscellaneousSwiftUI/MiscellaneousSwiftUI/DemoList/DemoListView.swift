//
//  DemoListView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/26/25.
//

import SwiftUI

struct DemoListView: View {
    @State private var paths: [Demo] = []
    
    var body: some View {
        NavigationStack(path: $paths) { 
            List(Demo.allCases.reversed()) { demo in
                NavigationLink(String(describing: demo), value: demo)
            }
            .navigationTitle("Miscellaneous")
            .navigationDestination(for: Demo.self) { demo in
                demo.makeView()
            }
        }
        .onAppear { 
            paths = [Demo.defaultCase]
        }
    }
}

#Preview {
    DemoListView()
}
