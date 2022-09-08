import Foundation
import AVFAudio

class AudioRecorder {
    
    var audioRecorder: AVAudioRecorder?
    
    var documentPath : URL
    
    var settings : [String : Int]
    
    init() {
        
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            fatalError("Failed to set up recording session")
        }

        documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
    }
    
    var currentTime : Double {
        (audioRecorder?.currentTime ?? .zero)
    }
    
    func startRecording(recNum : Int) {

        do {
            let audioFilename = documentPath.appendingPathComponent("New Recording \(recNum).m4a")
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
        } catch {
            print("Could not start recording")
        }
        
        audioRecorder?.record()
           
    }
    
    func stopRecording() {
        audioRecorder?.stop()
    }
    
}
