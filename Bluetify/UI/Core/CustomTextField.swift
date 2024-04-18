//
//  CustomTextField.swift
//  Bluetify
//
//  Created by M Alfin Syahruddin on 03/04/24.
//

import SwiftUI


struct CustomTextField: View {
    var label: String
    var text: Binding<String>
    var isDisabled: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.primary.opacity(0.5))
            
            TextField(label, text: text)
                .disabled(isDisabled)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isDisabled ? Color.primary.opacity(0.1) : .clear)
                .cornerRadius(8)
                .overlay( /// apply a rounded border
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.primary.opacity(0.25), lineWidth: isDisabled ? 0 : 1)
                )
        }
    }
}
