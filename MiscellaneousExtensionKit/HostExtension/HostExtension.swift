//
//  HostExtension.swift
//  HostExtension
//
//  Created by Jinwoo Kim on 7/7/25.
//

import SwiftUI
import ExtensionFoundation
import ExtensionKit

/// The AppExtensionConfiguration that will be provided by this extension.
/// This is typically defined by the extension host in a framework.
struct ExampleConfiguration: AppExtensionConfiguration {
    
    
    /// Determine whether to accept the XPC connection from the host.
    func accept(connection: NSXPCConnection) -> Bool {
        // TODO: Configure the XPC connection and return true
        return false
    }
}

struct ExampleScene: AppExtensionScene {
    var body: some AppExtensionScene {
        PrimitiveAppExtensionScene(id: "Test") { 
            Text("Hello World From Extension!")
        } onConnection: { connection in
            return true
        }
    }
}

@main
class HostExtension: AppExtension {
    
    required init() {
        // Initialize your extension here.
    }
    
    var configuration: AppExtensionSceneConfiguration {
        // Return your extension's configuration upon request.
        return AppExtensionSceneConfiguration(ExampleScene(), configuration: ExampleConfiguration())
    }
}
