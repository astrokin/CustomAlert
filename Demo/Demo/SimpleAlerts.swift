//
//  SimpleAlerts.swift
//  Demo
//
//  Created by David Walter on 31.12.22.
//

import SwiftUI
import CustomAlert

struct SimpleAlerts: View {
    @State private var showNative = false
    @State private var showCustom = false
    
    var body: some View {
        Section {
            Button {
                showNative = true
            } label: {
                Text("Native Alert")
            }
            .alert("Native Alert", isPresented: $showNative) {
                Button(role: .cancel) {
                    
                } label: {
                    Text("Cancel")
                }
            } message: {
                Text("Some Message")
            }
            
            Button {
                showCustom = true
            } label: {
                Text("Custom Alert")
            }
            .customAlert("Custom Alert", isPresented: $showCustom, modifiers: makeModifier()) {
                Text("Some Message")
            } actions: {
                Button(role: .cancel) {
                    
                } label: {
                    Text("Cancel")
                }
            }
        } header: {
            Text("Simple")
        }
    }
    
    private func makeModifier() -> CustomAlertModifiers {
        CustomAlertModifiers(backgroundView: {
            CustomAlertBackgroundModifier(
                padding: 30,
                cornerRadius: 13.3333,
                background: .blur(.systemMaterial))
        }, needsHorizontalDivider: true)
    }
}

struct SimpleAlerts_Previews: PreviewProvider {
    static var previews: some View {
        List {
            SimpleAlerts()
        }
    }
}
