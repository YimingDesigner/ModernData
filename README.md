# ModernData

On the one hand, Apple's frameworks did a great job on simplifying the difficulty to make an app. On the other hand, they sacrificed some useful functionality which is complicated but useful in practice. Here, we create ModernData mainly based on Apple's frameworks to make our life easier to deal with data and files.

## Data

### `Array` CRUD

```swift
extension Array where Element: Identifiable {
    func find(id: Element.ID) -> [Element]
    func findFirst(id: Element.ID) -> Element?
    func find(where: { element in } -> Bool) -> [Element]
    func findFirst(where: { element in } -> Bool) -> Element?
    func remove(id: Element.ID)
    func remove(where: { element in } -> Bool)
    func removeFirst(where: { element in } -> Bool)
}

extension Array {
    func add(Element, with: SortComparator)
}
```

### Encode and Decode `Array` with `String`

```swift
extension Array where Element == String {
    func encodeToString() -> String   
}

extension Array {
    func encodeToString(_ string: (Element) -> String) -> String   
}

extension String {
    func decodeToArray() -> [String]
}
```

### `Binding` Extensions

```swift
@Binding var double: Double
double.float()
cgFloat.float()
```

### Unwrap `Binding<Value?>` to `Binding<Value>`

```swift
@Binding var content: String?
TextField("TextField", text: $content ?? "Default Content")
```

## File

### `URL` Foundation

```swift
extension URL {
    // Property
  	var isFile: Bool
    var isFolder: Bool
    var isExisting: Bool
    var contentType: UTType?
    var contentNameWithExtension: String
    var contentName: String
    var contentExtension: String
    var contentSize: Int?
    
    // Directory
    var parent: URL
    var siblings: [URL]
    var puncturedSiblings: [URL]
    var substitutes: [URL]
    var children: [URL]
    func children(atLevel: Int) -> [URL]
    func children(withinLevel: Int) -> [URL]
  
    // File Operation
    func removePermanently()
    func trash(resultingItemURL: AutoreleasingUnsafeMutablePointer<NSURL?>? = nil)
    func createFile(contents: Data?)
    func createFolder()
    func copy(to target: URL)
    func move(to target: URL)
}
```

### Audio Video Metadata

```swift
extension URL {    
    func fullMetadata() async throws -> [AVMetadataItem]
    func metadata(_ identifier: AVMetadataIdentifier) async throws -> [AVMetadataItem]
    func metadata(_ identifiers: [AVMetadataIdentifier]) async throws -> [AVMetadataItem]

    // Value: String, Int, or Data(png)
    func setMetadata(_ frameName: FrameName, with value: Value?) throws
}
```

