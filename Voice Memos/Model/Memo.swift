import Foundation

var memos: [Memo] = []

struct Memo: Identifiable, Hashable {
    
    var id: String { fileURL.lastPathComponent.replacingOccurrences(of: ".m4a", with: "") }
    
    let fileURL: URL
    
    let createdAt: Date
    
    let time: String
    
    let duration: String
    
    let isFocused: Bool
    
}

extension Memo {
    static var mock: Memo = { .init(fileURL: URL(fileURLWithPath: ""), createdAt: Date(), time: "time", duration: "dutration", isFocused: true) }()
}
