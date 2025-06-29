//
//  ButtonRoleView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/29/25.
//

import SwiftUI

struct ButtonRoleView: View {
    var body: some View {
        VStack { 
            Button(role: .destructive) { }
            Button(role: .cancel) { }
            Button(role: .confirm) { }
            Button(role: .close) { }
        }
    }
}

#Preview {
    ButtonRoleView()
}
