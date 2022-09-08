import Foundation
import AVFAudio

class AudioRecorder {
    
    // MARK: vars
    
    //Responsible for recording
    var audioRecorder: AVAudioRecorder?
    
    //Where the recordings will be saved
    var documentPath : URL
    
    //Settings for AVAudioRecorder
    var settings : [String : Int]
    
    //How long the user's been recording for
    var currentTime : Double {
        (audioRecorder?.currentTime ?? .zero)
    }
    
    // MARK: init()
    
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
    
    // MARK: startRecording()
    
    func startRecording(recNum : Int) {

        do {
            let audioFilename = documentPath.appendingPathComponent("New Recording \(recNum).m4a")
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
        } catch {
            print("Could not start recording")
        }
        
        audioRecorder?.record()
           
    }
    
    // MARK: stopRecording()
    
    func stopRecording() {
        audioRecorder?.stop()
    }
    
}
