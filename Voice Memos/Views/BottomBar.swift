import SwiftUI
import AVKit

struct BottomBar: View {
    
    @EnvironmentObject var holder: Holder
    
    @Binding var recordMode: Mode
    
    @Binding var editMode: EditMode
    
    @State private var nibbleMode: Mode = .inactive
    
    @State var recorder = AudioRecorder()
    
    @State var showText = false
    
    @State var showNibble = false
    
    @State var timerText = "00:00:00"
    
    @Environment(\.isSearching) private var isSearching //This does not seem to do anything
    
    var meterTimer = Timer.publish(every: 0.001, on: .main, in: .common).autoconnect()
    
    var body: some View {
        if !isSearching && !editMode.isEditing {
        VStack {
            Spacer()
            ZStack(alignment: .bottom) {
                
                RoundedRectangle(cornerRadius: recordMode.isActive ? 10 : 0)
                    .foregroundColor(Color(red: 28/255, green: 28/255, blue: 30/255))
                    .frame(maxWidth: .infinity,
                           maxHeight: recordMode.isActive ? 290 : 100)
            
                
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
                            //.frame(height: nibbleMode.isActive ? 100 : 20)
                            .padding(.bottom, 8)
                    }
                }
                //.animation(.easeIn(duration: 0.2).delay(0.5), value: nibbleMode)
                
                
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
                    DispatchQueue.main.async {
                        if recordMode == .active {
                            showText = true
                            recorder.startRecording(recNum: holder.nextRecNum) //<- This is making the above animation have a delay
                        } else {
                            showText = false
                            recorder.stopRecording()
                            holder.refresh()
                            holder.nextRecNum += 1
                        }
                    }
                }.padding(.bottom, 25)
                    //.onAppear(perform: recorder.startSession)
                
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
