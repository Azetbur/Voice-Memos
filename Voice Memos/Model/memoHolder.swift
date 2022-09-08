import Foundation
import AVFoundation

class Holder: ObservableObject {
    
    @Published var memos : [Memo] = []
    
    @Published var nextRecNum = 0
    
    var calendar = Calendar.current
    
    // MARK: fetchRecordings()
    func refresh() {
        memos.removeAll()
        
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        
        for audio in directoryContents {
            
            let creationDate = getCreationDate(for: audio)
            
            let isToday = Calendar.current.isDateInToday(creationDate)
            
            let time: String
            
            if isToday {
                time = creationDate.formatted(.dateTime.hour().minute())
            } else {
                time = creationDate.formatted(.dateTime.weekday(.wide))
            }
            
            let audioAsset = AVURLAsset.init(url: audio, options: nil)
            let duration = audioAsset.duration.seconds
            
            let timeInterval : TimeInterval = duration
            let seconds = String(format: "%02d", Int(timeInterval) % 60)
            let minutes = String(format: "%02d", (Int(timeInterval) / 60) % 60)
            
            let memo = Memo(fileURL: audio, createdAt: getCreationDate(for: audio), time: time, duration: String("\(minutes):\(seconds)"), isFocused: false)
            
            memos.append(memo)
            
        }
        
        memos.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedDescending})
        
    }
    
    //MARK: delete()
    func delete(set : Set<Memo.ID>, action : () -> Void) -> () {
        
        let fileManager = FileManager.default
        set.forEach { objectID in
            
            print("objectID : \(objectID)")
            print("random memo ID : \(memos[0].id)")
            
            guard let url = memos.first(where: {$0.id == objectID})?.fileURL
            else {
                fatalError("Oft expectation fails, and most oft there where most it promises; and oft it hits where hope is coldest, and despair most fits.\nWilliam Shakespeare")
            }
            
            do {
                try fileManager.removeItem(at: url)
            } catch {
                fatalError("Could not delete recording. Is it accessible? Is it open in another app? Has the directory in which it was stored been changed?\(error)")
            }
            
            memos.removeAll(where: {$0.id == objectID})

        }
        action()
    }
    
    // MARK: getCreationDate()
    private func getCreationDate(for file: URL) -> Date {
        if let attributes = try? FileManager.default.attributesOfItem(atPath: file.path) as [FileAttributeKey: Any],
           let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
            return creationDate
        } else {
            return Date()
        }
    }
    
}
