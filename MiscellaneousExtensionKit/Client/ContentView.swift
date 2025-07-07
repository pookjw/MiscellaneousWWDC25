//
//  ContentView.swift
//  Client
//
//  Created by Jinwoo Kim on 7/7/25.
//

import SwiftUI
import ExtensionKit

struct EXAppExtensionBrowserView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> EXAppExtensionBrowserViewController {
        let viewController = EXAppExtensionBrowserViewController()
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: EXAppExtensionBrowserViewController, context: Context) {
        
    }
}

struct EXHostView: UIViewControllerRepresentable {
    private let identity: AppExtensionIdentity
    
    init(identity: AppExtensionIdentity) {
        self.identity = identity
    }
    
    func makeUIViewController(context: Context) -> EXHostViewController {
        let uiViewController = EXHostViewController()
        uiViewController.configuration = .init(appExtension: identity, sceneID: "Test")
        return uiViewController
    }
    
    func updateUIViewController(_ uiViewController: EXHostViewController, context: Context) {
        
    }
}

struct ContentView: View {
    @State private var monitor = AppExtensionPoint.Monitor()
    @State private var identities: [AppExtensionIdentity] = []
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink("EXAppExtensionBrowserViewController") { 
                        EXAppExtensionBrowserView()
                    }
                }
                
                Section {
                    ForEach(identities) { identity in
                        NavigationLink(identity.localizedName) {
                            EXHostView(identity: identity)
                        }
                    }
                }
            }
        }
        .task {
            try! await monitor.addAppExtensionPoint(AppExtensionPoint(identifier: "com.pookjw.Host.Extension"))
            identities = monitor.identities
        }
    }
}

#Preview {
    ContentView()
}
