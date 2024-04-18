//
//  HomePage.swift
//  Bluetify
//
//  Created by M Alfin Syahruddin on 03/04/24.
//

import SwiftUI

struct HomePage: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                NavigationLink("Peripheral Mode") {
                    PeripheralModePage()
                }
                
                NavigationLink("Central Mode") {
                    CentralModePage()
                }
            }
            .navigationTitle("Bluetify")
        }
    }
}

#Preview {
    HomePage()
}
