import SwiftUI
import AVFAudio

struct Row: View {
    
    // MARK: vars
    
    //Holds an array of all recordings (memos), refreshes and deletes them
    @ObservedObject var MemoHolder : Holder
    
    //Contains AVAudioPlayer, responsible for playback
    @EnvironmentObject var audioPlayer : AudioPlayer
    
    //Row which is expanded into a more detailed view, can only be one
    @Binding var rowInFocus : Memo.ID
    
    //The recording (memo) the row is displaying details about
    var memo: Memo
    
    //Whether this row is expanded into a more detailed view
    var inFocus: Bool {
        rowInFocus == memo.id
    }
    
    // MARK: View
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                
                VStack (alignment: .leading, spacing: 5) {
                    Text(memo.id)
                        .fontWeight(.bold)
                    Text(memo.time)
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                }.padding(.vertical, 5)
                
                Spacer()
                
                if inFocus {
                    
                    // MARK: DetailsButton
                    Button {
                        // TODO: DetailsButton action
                    } label: {
                        Image(systemName: "ellipsis.circle").imageScale(.large)
                            .foregroundColor(.blue)
                    }
                    
                } else {
                    VStack {
                        Spacer()
                        Text(memo.duration)
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                            .padding(.bottom, 5)
                    }
                }
            }
            
            if inFocus {
                HStack {
                    
                    // MARK: SettingButton
                    Button(action: {
                        // TODO: SettingsButton action
                    }) {
                        Image(systemName: "slider.horizontal.3").imageScale(.large)
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    // MARK: Back15Button
                    Button(action: {
                        // TODO: Back15Button action
                    }) {
                        Image(systemName: "gobackward.15").imageScale(.small)
                            .font(Font.title.weight(.regular))
                    }
                    
                    // MARK: PlayPauseButton
                    Button {
                        audioPlayer.toggle(audio: memo.fileURL)
                    } label: {
                        Image(systemName: audioPlayer.isPlaying ? "stop.fill" : "play.fill").imageScale(.large) // FIXME: icon does not change
                            .font(.system(size: 25))
                            .padding(.horizontal, 20)
                    }
                    
                    // MARK: Forward15Button
                    Button(action: {
                        // TODO: Forward15Button action
                    }) {
                        Image(systemName: "goforward.15").imageScale(.small)
                            .font(Font.title.weight(.regular))
                    }
                    
                    Spacer()
                    
                    // MARK: DeleteButton
                    Button(action: {
                        MemoHolder.delete(set: [memo.id], action: {
                            rowInFocus = ""
                        })
                    }) {
                        Image(systemName: "trash").imageScale(.large)
                            .foregroundColor(.blue)
                    }
                    
                }
                .padding(.bottom, 10)
            }
        }.if (rowInFocus != memo.id) {view in
            view.onTapGesture {
                rowInFocus = memo.id
            }
        }
    }
    
}

// MARK: .if extension

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

// MARK: Preview

struct Row_Previews: PreviewProvider {
    static var previews: some View {
        Row(MemoHolder: Holder(), rowInFocus: .constant(Memo.mock.id), memo: Memo.mock)
        .environmentObject(AudioPlayer())
        .preferredColorScheme(.dark)
    }
}
