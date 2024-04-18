//
//  CentralModePage.swift
//  Bluetify
//
//  Created by M Alfin Syahruddin on 03/04/24.
//

import SwiftUI


struct CentralModePage: View {
    @StateObject var bluetifyCentralKit = BluetifyCentralKit()
    
    @State var message = ""

    var body: some View {
        VStack {
            switch bluetifyCentralKit.state {
            case .bluetoothUnavailable:
                Text("BLUETOOTH UNAVAILABLE")
                    .foregroundStyle(.primary.opacity(0.5))
                
            case .scanning:
                Text("SCANNING...")
                    .foregroundStyle(.primary.opacity(0.5))
                
            case .connected:
                VStack(spacing: 16) {
                    ZStack(alignment: .bottomTrailing) {
                        CustomTextField(
                            label: "Device Name",
                            text: $bluetifyCentralKit.deviceName,
                            isDisabled: true
                        )
                        
                        Button("Refresh") {
                            bluetifyCentralKit.readDeviceName()
                        }
                        .font(.caption)
                        .padding(.bottom, 12)
                        .padding(.trailing, 12)
                    }
                    
                    CustomTextField(
                        label: "Notification From Peripheral",
                        text: $bluetifyCentralKit.notification,
                        isDisabled: true
                    )
                    
                    CustomTextField(
                        label: "Message to Peripheral",
                        text: $message,
                        isDisabled: false
                    )
                    
                    HStack {
                        Spacer()
                        
                        Button("Send Message") {
                            bluetifyCentralKit.sendMessage(message)
                            
                            message = ""
                        }
                    }
                    
                    Spacer()
                }
            }
        }
        .padding(16)
        .navigationTitle("Central Mode")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            bluetifyCentralKit.stopScanning()
        }
    }
}

#Preview {
    CentralModePage()
}
