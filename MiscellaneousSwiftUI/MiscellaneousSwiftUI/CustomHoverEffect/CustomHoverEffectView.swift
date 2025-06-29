//
//  CustomHoverEffectView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/29/25.
//

#if os(visionOS)

import SwiftUI

struct CustomHoverEffectView: View {
    @Namespace private var namespace
    
    var body: some View {
        VStack(spacing: 0) {
            Color.orange
                .hoverEffectGroup(id: "id", in: namespace, behavior: .activatesGroup)
            
            Color.blue
                .hoverEffect(
                    in: HoverEffectGroup(id: "id", in: namespace, behavior: .followsGroup),
                    isEnabled: true
                ) { effect, isActive, proxy in
                    effect.offset(x: isActive ? -proxy.size.width * 0.5 : 0)
                }
            
            // 자기만 Activate함
            Color.green
                .hoverEffectGroup(id: "id", in: namespace, behavior: .preservesGroup)
                .hoverEffect { effect, isActive, proxy in
                    effect.offset(x: isActive ? proxy.size.width * 0.5 : 0)
                }
            
            Color.pink
                .hoverEffect(
                    in: HoverEffectGroup(id: "id", in: namespace, behavior: .ignoresGroup),
                    isEnabled: true
                ) { effect, isActive, proxy in
                    effect.offset(x: isActive ? proxy.size.width * 0.5 : 0)
                }
        }
    }
}

#Preview {
    CustomHoverEffectView()
}

#endif
