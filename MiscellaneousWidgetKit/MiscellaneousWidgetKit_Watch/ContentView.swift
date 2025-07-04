//
//  ContentView.swift
//  MiscellaneousWidgetKit Watch Watch App
//
//  Created by Jinwoo Kim on 7/4/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            NavigationLink("WidgetCenter") {
                WidgetCenterView()
            }
            
            NavigationLink("MyWidgetCenter") {
                MyWidgetCenterView()
            }
        }
    }
}

#Preview {
    ContentView()
}
