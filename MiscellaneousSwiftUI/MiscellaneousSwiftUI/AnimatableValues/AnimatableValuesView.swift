//
//  AnimatableValuesView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/28/25.
//

import SwiftUI

struct AnimatableValuesView: View {
    var body: some View {
        OffsetView()
    }
}

fileprivate struct OffsetView: View {
    @State var x: CGFloat = 0
    @State var y: CGFloat = 200
    
    var body: some View {
        Button("Move") {
            x = x == 0 ? 200 : 0
            y = y == 200 ? 400 : 200
        }
        MoveView(x: x, y: y)
            .animation(.smooth, value: x)
            .animation(.smooth, value: y)
    }
}

fileprivate struct MoveView: View, Animatable {
    var x: CGFloat
    var y: CGFloat
    
    var animatableData: AnimatableValues<CGFloat, CGFloat> {
        get {
            AnimatableValues(
                { self[_animatableValue: \.x] }(),
                { self[_animatableValue: \.y] }()
            )
        }
        set {
            self[_animatableValue: \.x] = newValue.value.0
            self[_animatableValue: \.y] = newValue.value.1
        }
    }
    
    var body: some View {
        Rectangle()
            .foregroundStyle(.red)
            .frame(width: 100, height: 100)
            .offset(x: x, y: y)
            .onChange(of: x) { oldValue, newValue in
                print(newValue)
            }
    }
}

#Preview {
    AnimatableValuesView()
}
