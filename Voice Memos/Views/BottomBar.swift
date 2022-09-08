import SwiftUI
import AVKit

struct BottomBar: View {
    
    // MARK: @Environment(Object var)
    
    //Holds an array of all recordings (memos), refreshes and deletes them
    @EnvironmentObject var holder: Holder
    
    //Whether the List in ContentView is being searched
    @Environment(\.isSearching) private var isSearching
    
    // MARK: @Binding vars
    
    //Whether you are recording, disables all other functionality
    @Binding var recordMode: Mode
    
    //Wheter you are in edit mode, disables recording
    @Binding var editMode: EditMode
    
    //Row which is expanded into a more detailed view, can only be one
    @Binding var rowInFocus : Memo.ID
    
    //Whether an animation is in progress, enables hit testing (disables everything)
    @Binding var isAnimating : Bool
    
    // MARK: @State vars
    
    //
    @State private var nibbleMode: Mode = .inactive
    
    //Contains AVAudioRecorder, responsible for recording
    @State var recorder = AudioRecorder()
    
    //Whether the text which is shown when recording is shown
    @State var showText = false
    
    //Shows how long the user's been recording a new recording for
    @State var timerText = "00:00:00"
    
    // MARK: vars
    
    var meterTimer = Timer.publish(every: 0.001, on: .main, in: .common).autoconnect()
    
    // MARK: View
    
    var body: some View {
        if !isSearching && !editMode.isEditing {
        VStack {
            
            Spacer()
            
            ZStack(alignment: .bottom) {
                
                // MARK: BottomSheet
                
                RoundedRectangle(cornerRadius: recordMode.isActive ? 10 : 0)
                    .foregroundColor(Color(red: 28/255, green: 28/255, blue: 30/255))
                    .frame(maxWidth: .infinity,
                           maxHeight: recordMode.isActive ? 290 : 100)
            
                // MARK: Nipple
                
                VStack {
                    if nibbleMode.isActive {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 35, height: 5)
                            .foregroundColor(Color.secondary)
                            .opacity(0.5)
                            .padding(.bottom, 270)
                            .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity), removal: .identity))
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .opacity(nibbleMode.isActive ? 1 : 0)
                            .padding(.bottom, 8)
                    }
                }
                
                // MARK: Text
                
                VStack {
                    if showText == true {
                        Text("New Recording \(holder.nextRecNum)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.bottom, 10)
                        
                        Text(timerText)
                            .font(.subheadline)
                            .foregroundColor(Color.secondary)
                            .padding(.bottom, 188)
                            .onReceive(meterTimer) {_ in
                                timerText = recorder.currentTime.time()
                            }
                            .monospacedDigit()
                    }
                }.opacity(recordMode.isActive ? 1 : 0)
                .animation(.easeIn(duration: 0.2).delay(0.5), value: recordMode)
                
                
                
                RecordButton(recordMode: $recordMode, nibbleMode: $nibbleMode) {
                    rowInFocus = ""
                    isAnimating = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        isAnimating = false
                    }
                    DispatchQueue.main.async {
                        if recordMode == .active {
                            showText = true
                            recorder.startRecording(recNum: holder.nextRecNum)
                        } else {
                            showText = false
                            recorder.stopRecording()
                            holder.refresh()
                            holder.nextRecNum += 1
                            //rowInFocus = holder.memos[memos.count - 1].id
                        }
                    }
                }.padding(.bottom, 25)
                
            }
            }
        }
    }
}

/*struct BottomBar_Previews: PreviewProvider {
    static var previews: some View {
        BottomBar(mode: .constant(.inactive))
    }
}*/
