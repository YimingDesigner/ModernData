//
//  BindingEtension.swift
//  
//
//  Created by Yiming Liu on 2/2/23.
//

import Foundation
import SwiftUI

@available(macOS 13.0, *)
public extension Binding where Value == Double {
    
    func float() -> Binding<Float> {
        return Binding<Float>(
            get: { Float(self.wrappedValue) },
            set: { self.wrappedValue = Double($0)})
    }
    
    func cgFloat() -> Binding<CGFloat> {
        return Binding<CGFloat>(
            get: { CGFloat(self.wrappedValue) },
            set: { self.wrappedValue = Double($0)})
    }
    
}
