//
//  URLExtension.swift
//
//
//  Created by Yiming Liu on 2/7/23.
//

import Foundation
import UniformTypeIdentifiers

@available(macOS 13.0, *)
public extension URL {
    
    // MARK: - Property
    
    var isFile: Bool {
        if self.isExisting && self.isFileURL && !self.isFolder { return true } else { return false }
    }
    
    var isFolder: Bool {
        (try? self.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }
    
    var isExisting: Bool {
        FileManager.default.fileExists(atPath: self.path())
    }
    
    var contentType: UTType? {
        (try? self.resourceValues(forKeys: [.contentTypeKey]))?.contentType
    }
    
    var contentNameWithExtension: String {
        self.lastPathComponent
    }
    
    var contentName: String {
        self.deletingPathExtension().lastPathComponent
    }
    
    var contentExtension: String {
        self.pathExtension
    }
    
    var contentSize: Int? {
        (try? self.resourceValues(forKeys: [.fileSizeKey]))?.fileSize
    }
    
    // MARK: - Directory
    
    var parent: URL {
        self.deletingLastPathComponent()
    }
    
    var siblings: [URL] {
        self.parent.substitutes
    }
    
    var puncturedSiblings: [URL] {
        self.siblings.filter { !($0 == self) }
    }
    
    var substitutes: [URL] {
        do {
            let items = try FileManager.default.contentsOfDirectory(atPath: self.path)
            return items.map { self.appendingPathComponent($0) }
        } catch {
            return []
        }
    }
    
    var children: [URL] {
        var children: [URL] = []
        for url in self.substitutes {
            children.append(url)
            if url.isFolder { children.append(contentsOf: url.children) }
        }
        return children
    }
    
    func children(atLevel: Int) -> [URL] {
        children(currentLevel: 0, atLevel: atLevel)
    }

    func children(withinLevel: Int) -> [URL] {
        children(currentLevel: 0, withinLevel: withinLevel)
    }
    
    private func children(currentLevel: Int, atLevel: Int) -> [URL] {
        var children: [URL] = []
        for url in self.substitutes {
            if currentLevel == atLevel { children.append(url) }
            if currentLevel < atLevel && url.isFolder { children.append(contentsOf: url.children(currentLevel: currentLevel + 1, atLevel: atLevel)) }
        }
        return children
    }
    
    private func children(currentLevel: Int, withinLevel: Int) -> [URL] {
        var children: [URL] = []
        for url in self.substitutes {
            if currentLevel <= withinLevel { children.append(url) }
            if currentLevel < withinLevel && url.isFolder { children.append(contentsOf: url.children(currentLevel: currentLevel + 1, withinLevel: withinLevel)) }
        }
        return children
    }
    
    // MARK: - File Operations
    
    func removePermanently() {
        do {
            try FileManager.default.removeItem(at: self)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func trash(resultingItemURL: AutoreleasingUnsafeMutablePointer<NSURL?>? = nil) {
        do {
            try FileManager.default.trashItem(at: self, resultingItemURL: resultingItemURL)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func createFile(contents: Data?) {
        FileManager.default.createFile(atPath: self.path(), contents: contents)
    }
    
    func createFolder() {
        do {
            try FileManager.default.createDirectory(at: self, withIntermediateDirectories: true)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func copy(to target: URL) {
        do {
            try FileManager.default.copyItem(at: self, to: target)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func move(to target: URL) {
        do {
            try FileManager.default.moveItem(at: self, to: target)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    mutating func rename(name: String, extension contentExtension: String) {
        if self.isExisting {
            let newURL = self.deletingLastPathComponent().appending(component: name + "." + contentExtension)
            self.move(to: newURL)
            self = newURL
        }
    }
    
    mutating func rename(name: String, extension contentExtension: UTType) {
        self.rename(name: name, extension: contentExtension.identifier)
    }
    
    mutating func rename(to name: String) {
        self.rename(name: name, extension: self.contentExtension)
    }
    
    mutating func rename(extension contentExtension: String) {
        self.rename(name: self.contentName, extension: contentExtension)
    }
    
    mutating func rename(extension contentExtension: UTType) {
        self.rename(name: self.contentName, extension: contentExtension.identifier)
    }
    
}

// MARK: - [URL] Filter

@available(macOS 13.0, *)
public extension Array<URL> {
    
    func filter(types: [UTType]) -> [URL] {
        self.filter {
            if let contentType = $0.contentType {
                return types.contains(contentType)
            } else {
                return false
            }
        }
    }
    
    func filter(exceptTypes: [UTType]) -> [URL] {
        self.filter {
            if let contentType = $0.contentType {
                return !exceptTypes.contains(contentType)
            } else {
                return true
            }
        }
    }
    
}
