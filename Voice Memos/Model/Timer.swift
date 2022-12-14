import Foundation

extension Double {
    
    func time() -> (String) {
        let milliseconds = String(format: "%02d", Int(self * 100)%100)
        let seconds = String(format: "%02d", Int(self) % 60)
        let minutes = String(format: "%02d", (Int(self) / 60) % 60)
        
        return("\(minutes):\(seconds),\(milliseconds)")
    }
}
