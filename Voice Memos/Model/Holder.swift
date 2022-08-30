//
//  Holder.swift
//  Voice Memos
//
//  Created by Jindrich Kocman on 29.08.2022.
//

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
                    
                let memo = Memo(fileURL: audio, createdAt: getCreationDate(for: audio), time: time, duration: duration.formatted())
                    
                memos.append(memo)
                    
            }
            
            memos.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedDescending})
            
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
