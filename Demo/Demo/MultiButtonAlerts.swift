//
//  MultiButtonAlerts.swift
//  Demo
//
//  Created by David Walter on 31.12.22.
//

import SwiftUI
import CustomAlert

struct MultiButtonAlerts: View {
    @State private var showSimple = false
    @State private var showComplex = false
    
    var body: some View {
        Section {
            Button {
                showSimple = true
            } label: {
                Text("Simple MultiButton")
            }
            .customAlert("Multibutton Alert", isPresented: $showSimple, modifiers: makeModifier()) {
                Text("Simple Multibutton")
            } actions: {
                MultiButton {
                    Button {
                        
                    } label: {
                        Text("OK")
                    }

                    Button(role: .cancel) {
                        
                    } label: {
                        Text("Cancel")
                    }
                }
            }
            
            Button {
                showComplex = true
            } label: {
                Text("Complex MultiButton")
            }
            .customAlert("Multibutton Alert", isPresented: $showComplex, modifiers: makeModifier()) {
                Text("Complex Multibutton")
            } actions: {
                MultiButton {
                    Button {
                        
                    } label: {
                        Text("A")
                    }

                    Button {
                        
                    } label: {
                        Text("B")
                    }
                    
                    Button {
                        
                    } label: {
                        Text("C")
                    }
                }
                
                Button(role: .cancel) {
                    
                } label: {
                    Text("Cancel")
                }
            }
        } header: {
            Text("Multibutton")
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

struct MultiButtonAlerts_Previews: PreviewProvider {
    static var previews: some View {
        List {
            MultiButtonAlerts()
        }
    }
}
