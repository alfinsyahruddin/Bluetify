//
//  PeripheralModePage.swift
//  Bluetify
//
//  Created by M Alfin Syahruddin on 03/04/24.
//

import SwiftUI

struct PeripheralModePage: View {
    @StateObject var bluetifyPeripheralKit = BluetifyPeripheralKit()
    
    @State var notification = ""

    var body: some View {
        VStack {
            switch bluetifyPeripheralKit.state {
            case .bluetoothUnavailable:
                Text("BLUETOOTH UNAVAILABLE")
                    .foregroundStyle(.primary.opacity(0.5))
                
            case .advertising:
                VStack(spacing: 16) {
                    CustomTextField(
                        label: "Device Name",
                        text: $bluetifyPeripheralKit.deviceName,
                        isDisabled: false
                    )
                    
                    CustomTextField(
                        label: "Message from Central",
                        text: $bluetifyPeripheralKit.message,
                        isDisabled: true
                    )
                    
                    CustomTextField(
                        label: "Notification to Central",
                        text: $notification,
                        isDisabled: false
                    )
                    
                    HStack {
                        Spacer()
                        
                        Button("Send Notification") {
                            bluetifyPeripheralKit.sendNotification(notification)
                            notification = ""
                        }
                    }
                    
                    Spacer()
                }
            }
            
        }
        .padding(16)
        .navigationTitle("Peripheral Mode")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            bluetifyPeripheralKit.stopAdvertising()
        }
    }
}

#Preview {
    PeripheralModePage(bluetifyPeripheralKit: .init())
}
