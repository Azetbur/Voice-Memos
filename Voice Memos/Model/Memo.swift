import Foundation

var memos: [Memo] = []

struct Memo: Identifiable {
    
    var id: String { fileURL.lastPathComponent.replacingOccurrences(of: ".m4a", with: "") }
    
    let fileURL: URL
    
    let createdAt: Date
    
    let time: String
    
    let duration: String
    
}
