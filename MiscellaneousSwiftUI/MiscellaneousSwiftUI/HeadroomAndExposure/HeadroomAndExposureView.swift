//
//  HeadroomAndExposureView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/29/25.
//

#if !os(watchOS)

import SwiftUI

struct HeadroomAndExposureView: View {
    @State private var color = Color.orange
    @State private var headroom: Double = 0
    @State private var exposure: Double = 0
    
    var body: some View {
        VStack {
            ColorPicker("", selection: $color, supportsOpacity: true)
            Slider(value: $headroom, in: 0...1000, label: { Text("Headroom") }, onEditingChanged: { _ in })
            Slider(value: $exposure, in: 0...2, label: { Text("Exposure") }, onEditingChanged: { _ in })
        }
        .ignoresSafeArea()
        .containerRelativeFrame([.horizontal, .vertical])
        .background(color.headroom(headroom).exposureAdjust(exposure))
    }
}

#Preview {
    HeadroomAndExposureView()
}

#endif
