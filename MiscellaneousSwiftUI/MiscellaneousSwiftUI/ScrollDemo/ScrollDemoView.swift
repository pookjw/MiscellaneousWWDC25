//
//  ScrollDemoView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/26/25.
//

import SwiftUI

struct ScrollDemoView: View {
    @State private var axes: Axis.Set = [.horizontal, .vertical]
#if os(watchOS)
    @State private var isConfigurationPresented = false
#endif
    @State private var scrollToIDUsingProxy: Int?
    @State private var scrollPosition = ScrollPosition()
    @State private var scrollTargetBehavior = AnyScrollTargetBehavior(ViewAlignedScrollTargetBehavior(limitBehavior: .never))
    
    var body: some View {
            ScrollView(axes) {
                ScrollViewReader { proxy in
                    ContentView()
                        .onChange(of: scrollToIDUsingProxy, initial: true) { oldValue, newValue in
                            if let newValue {
                                proxy.scrollTo(newValue)
                                scrollToIDUsingProxy = nil
                            }
                        }
                }
            }
            .scrollPosition($scrollPosition, anchor: .topLeading)
            .scrollTargetBehavior(scrollTargetBehavior)
#if os(watchOS)
        .sheet(isPresented: $isConfigurationPresented) {
            NavigationStack {
                List {
                    configuration
                }
            }
        }
#endif
        .toolbar { 
            menuToolbarItem
        }
    }
    
    @ToolbarContentBuilder
    private var menuToolbarItem: some ToolbarContent {
        ToolbarItem { 
#if os(watchOS)
            Button {
                isConfigurationPresented = true
            } label: { 
                Label("Menu", systemImage: "filemenu.and.selection")
            }
#else
            Menu {
                configuration
            } label: { 
                Label("Menu", systemImage: "filemenu.and.selection")
            }
#endif
        }
    }
    
    @ViewBuilder
    private var configuration: some View {
#if os(watchOS)
        NavigationLink("Scroll Position") {
            List { 
                scrollPositionConfiguration
            }
        }
#else
        Menu("Scroll Position") { 
            scrollPositionConfiguration
        }
#endif
        
#if os(watchOS)
        NavigationLink("View Aligned") {
            List { 
                scrollTargetBehaviorConfiguration
            }
        }
#else
        Menu("View Aligned") { 
            scrollTargetBehaviorConfiguration
        }
#endif
    }
    
    @ViewBuilder
    private var scrollPositionConfiguration: some View {
        Picker("Axes", selection: $axes) {
            ForEach([Axis.Set.horizontal, Axis.Set.vertical, [Axis.Set.horizontal, Axis.Set.vertical]], id: \.self) { axis in
                Text(String(describing: axis))
            }
        }
        
        if let edge = scrollPosition.edge {
            Text("ScrollPosition : Edge (\(String(describing: edge)))")
        } else if scrollPosition.isPositionedByUser {
            Text("ScrollPosition : isPositionedByUser")
        } else if let point = scrollPosition.point {
            Text("ScrollPosition : Point (\(String(describing: point))")
        } else if let viewID = scrollPosition.viewID {
            Text("ScrollPosition : viewID (\(String(describing: viewID))")
        }
        
        Button("Scroll to 410 using ScrollViewProxy") { 
            scrollToIDUsingProxy = 410
        }
        
        Button("Scroll to 410 using ScrollPositon") { 
            scrollPosition = ScrollPosition(id: 410)
        }
        
        Button("Scroll to (300, 300)") {
            scrollPosition = ScrollPosition(x: 300, y: 300)
        }
    }
    
    @ViewBuilder
    private var scrollTargetBehaviorConfiguration: some View {
        Button("Paging") { 
            scrollTargetBehavior = AnyScrollTargetBehavior(PagingScrollTargetBehavior())
        }
        
        Button("View Aligned (Automatic)") { 
            scrollTargetBehavior = AnyScrollTargetBehavior(ViewAlignedScrollTargetBehavior(limitBehavior: .automatic))
        }
        
        Button("View Aligned (Always)") { 
            scrollTargetBehavior = AnyScrollTargetBehavior(ViewAlignedScrollTargetBehavior(limitBehavior: .always))
        }
        
        Button("View Aligned (Never)") { 
            scrollTargetBehavior = AnyScrollTargetBehavior(ViewAlignedScrollTargetBehavior(limitBehavior: .never))
        }
        
        Button("View Aligned (Always By Few)") { 
            scrollTargetBehavior = AnyScrollTargetBehavior(ViewAlignedScrollTargetBehavior(limitBehavior: .alwaysByFew))
        }
        
        Button("View Aligned (Always By One)") { 
            scrollTargetBehavior = AnyScrollTargetBehavior(ViewAlignedScrollTargetBehavior(limitBehavior: .alwaysByOne))
        }
    }
}

#Preview {
    ScrollDemoView()
}

//extension ScrollDemoView {
//    fileprivate struct MyScrollTargetBehavior: ScrollTargetBehavior {
//        func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
//            
//        }
//    }
//}

extension Axis.Set: @retroactive Hashable, @retroactive Identifiable {
    public var id: Int8 {
        rawValue
    }
}
