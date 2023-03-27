//
//  TemporaryURL.swift
//  
//
//  Created by Yiming Liu on 3/27/23.
//

import Foundation

@available(macOS 13.0, *)
public final class TemporaryURL {
    
    public let url: URL
    
    public init(name: String, extension ext: String) {
        url = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(name)
            .appendingPathExtension(ext)
    }
    
    public init(extension ext: String) {
        url = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension(ext)
    }
    
    deinit {
        url.removePermanently()
    }
    
}
