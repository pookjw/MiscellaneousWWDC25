//
//  TabBarView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/29/25.
//

import SwiftUI

struct TabBarView: View {
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) { 
            Tab(value: 0) { 
                List(0..<500) { number in
                    Text(String(number))
                }
            } label: { 
                Label("0", systemImage: "apple.intelligence")
            }
            
            Tab(value: 1, role: .search) { 
                List(0..<500) { number in
                    Text(String(number))
                }
            } label: { 
                Label("1", systemImage: "apple.intelligence")
            }
        }
#if os(iOS)
        .tabBarMinimizeBehavior(.onScrollDown)
        .tabViewBottomAccessory { 
            Text("Bottom Accessory!")
        }
#endif
    }
}

#Preview {
    TabBarView()
}
