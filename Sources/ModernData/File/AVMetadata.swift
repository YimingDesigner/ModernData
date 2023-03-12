//
//  File.swift
//  
//
//  Created by Yiming Liu on 3/11/23.
//

import Foundation
import AVFoundation
import ID3TagEditor

@available(macOS 13.0, *)
public extension URL {
    
    func fullMetadata() async throws -> [AVMetadataItem] {
        let asset = AVAsset(url: self)
        async let commonMetadata = asset.load(.commonMetadata)
        async let specificMetadata = asset.load(.metadata)
        var fullMetadata: [AVMetadataItem] = []
        
        do {
             fullMetadata = try await commonMetadata + specificMetadata
        } catch { throw error }
        
        return fullMetadata
    }
    
    func metadata(_ identifier: AVMetadataIdentifier) async throws -> [AVMetadataItem] {
        var filteredItems: [AVMetadataItem] = []
        
        do {
            filteredItems.append(contentsOf: AVMetadataItem.metadataItems(from: try await fullMetadata(), filteredByIdentifier: identifier))
        }
        
        return filteredItems
    }
    
    func metadata(_ identifiers: [AVMetadataIdentifier]) async throws -> [AVMetadataItem] {
        var filteredItems: [AVMetadataItem] = []
        
        do {
            let fullMetadata = try await fullMetadata()
            for identifier in identifiers {
                filteredItems.append(contentsOf: AVMetadataItem.metadataItems(from: fullMetadata, filteredByIdentifier: identifier))
            }
        } catch { throw error }
        
        return filteredItems
    }
    
    func setMetadata(_ frameName: FrameName, with value: String?) throws {
        do {
            if let id3Tag = try ID3TagEditor().read(from: self.path) {
                if let value = value {
                    id3Tag.frames[frameName] = ID3FrameWithStringContent(content: value)
                } else { id3Tag.frames.removeValue(forKey: frameName) }
                try ID3TagEditor().write(tag: id3Tag, to: self.path)
            }
        } catch { throw error }
    }
    
    func setMetadata(_ frameName: FrameName, with value: Int?) throws {
        do {
            if let id3Tag = try ID3TagEditor().read(from: self.path) {
                if let value = value {
                    id3Tag.frames[frameName] = ID3FrameWithIntegerContent(value: value)
                } else { id3Tag.frames.removeValue(forKey: frameName) }
                try ID3TagEditor().write(tag: id3Tag, to: self.path)
            }
        } catch { throw error }
    }
    
    func setMetadata(_ frameName: FrameName, with value: Data?) throws {
        do {
            if let id3Tag = try ID3TagEditor().read(from: self.path) {
                if let value = value {
                    id3Tag.frames[frameName] = ID3FrameAttachedPicture(picture: value, type: .other, format: .png)
                } else { id3Tag.frames.removeValue(forKey: frameName) }
                try ID3TagEditor().write(tag: id3Tag, to: self.path)
            }
        } catch { throw error }
    }
}

