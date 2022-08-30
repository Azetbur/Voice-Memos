import Foundation
import AVFAudio

class AudioRecorder {
    
    var audioRecorder: AVAudioRecorder?
    
    //var recordings = [Recording]()
    
    var documentPath : URL
    
    var settings : [String : Int]
    
    private var meterTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
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
    
    /*func startSession(recNum : Int) {
        do {
            let audioFilename = documentPath.appendingPathComponent("New Recording \(recNum).m4a")
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
        } catch {
            print("Could not start recording")
        }
        
        
    }*/
    
    func currentTime () -> (String) {
        return(String(audioRecorder?.currentTime ?? .zero))
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
        //fetchRecordings()
    }
    
    /*func fetchRecordings() {
        recordings.removeAll()
            
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        for audio in directoryContents {
            let recording = Recording(fileURL: audio, createdAt: getCreationDate(for: audio))
            recordings.append(recording)
        }
            
        recordings.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedAscending})
            
    }*/
    
}
