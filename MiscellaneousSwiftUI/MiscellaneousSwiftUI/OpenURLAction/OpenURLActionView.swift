//
//  OpenURLActionView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/28/25.
//

import SwiftUI

struct OpenURLActionView: View {
    var body: some View {
        _OpenURLActionView()
//            .environment(\.openURL, OpenURLAction(handler: { url in
//                print(url)
//                return .discarded
//            }))
    }
}

fileprivate struct _OpenURLActionView: View {
//    private static let urls: [URL] = [
//        URL(string: "https://www.google.com")!,
//        URL(string: UIApplication.openSettingsURLString)!
//    ]
    
    @Environment(\.openURL) private var openURL
    @Environment(\._openURL) private var openURL2
    @Environment(\._openSensitiveURL) private var openSensitiveURL
    
    var body: some View {
        List {
            #if !os(watchOS)
            Button("Open Google (openURL)") { 
                openURL(URL(string: "https://www.google.com")!) { accepted in
                    print(accepted)
                }
            }
            
            Button("Open Google (_openURL)") { 
                openURL2(URL(string: "https://www.google.com")!) { accepted in
                    print(accepted)
                }
            }
            #else
            Button("Open Google (openURL)") { 
                openURL(URL(string: "https://www.google.com")!)
            }
            
            Button("Open Google (_openURL)") { 
                openURL2(URL(string: "https://www.google.com")!)
            }
            #endif
            
            Button("Open Google (openURL)") { 
                openURL(URL(string: "https://www.google.com")!, prefersInApp: true)
            }
        }
        .onOpenURL { url in
            // Default Browser일 때만
            print(url)
        }
        .onOpenURL(prefersInApp: true) 
#warning("TODO: ??? prefersInApp")
    }
}

#Preview {
    OpenURLActionView()
}
