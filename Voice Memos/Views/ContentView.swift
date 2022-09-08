import SwiftUI
import AVKit

struct ContentView: View {
    
    // MARK: @StateObject vars
    
    //Holds an array of all recordings (memos), refreshes and deletes them
    @StateObject var MemoHolder = Holder()
    
    //Contains AVAudioPlayer, responsible for playback
    @StateObject var audioPlayer = AudioPlayer()
    
    // MARK: @State vars
    
    //All selected memos when in edit mode, used for deletion/sharing
    @State private var selection = Set<Memo.ID>()
    
    //Wheter you are in edit mode, disables recording
    @State private var editMode: EditMode = .inactive
    
    //Whether you are recording, disables all other functionality
    @State private var recordMode: Mode = .inactive
    
    //Used for .searchable in List
    @State private var searchText = ""
    
    //Row which is expanded into a more detailed view, can only be one
    @State private var rowInFocus : Memo.ID = ""
    
    //Whether an animation is in progress, enables hit testing (disables everything)
    @State private var isAnimating = false
    
    // MARK: Computed vars
    
    //Memos displayed when searching List based on searchText
    var searchResults: [Memo] {
        if searchText.isEmpty {
            return MemoHolder.memos
        } else {
            return MemoHolder.memos.filter { $0.id.contains(searchText) }
        }
    }
    
    
    // MARK: View
    
    var body: some View {
        ZStack {
            NavigationView {
                List (selection: $selection) {
                    ForEach (searchResults) {memo in
                        Row(MemoHolder: MemoHolder, rowInFocus: $rowInFocus, memo: memo)
                            .environmentObject(audioPlayer)
                            .buttonStyle(PlainButtonStyle())
                    }
                }
                .navigationTitle("All Recordings")
                .searchable(text: $searchText)
                .listStyle(InsetListStyle())
                .toolbar(content: toolbarContent)
                .environment(\.editMode, $editMode)
                /* TODO: Implement the following in iOS 16
                 .sheet(isPresented: $presentSheet) {
                 BottomBar()
                 .presentationDetents([.medium, .height(50)])*/
                
            }.disabled(recordMode.isActive)
            .opacity(recordMode.isActive ? 0.5 : 1)
            
            BottomBar(recordMode: $recordMode, editMode: $editMode, rowInFocus: $rowInFocus, isAnimating: $isAnimating)
                .allowsHitTesting(!isAnimating)
                .environmentObject(MemoHolder)
                .onAppear {
                    MemoHolder.refresh()
                }
        }
    }
}

// MARK: @ToolbarContentBuilder

extension ContentView {
    @ToolbarContentBuilder
    private func toolbarContent() -> some ToolbarContent {
        
        // MARK: EditButton
        ToolbarItem(placement: .navigationBarTrailing) {
            EditButton(editMode: $editMode, actionInactive:  {
                rowInFocus = ""
            }, actionActive: {
                selection.removeAll()
            })
        }
        
        ToolbarItemGroup(placement: .bottomBar) {
            
            // MARK: ShareButton
            if editMode == .active {
                Button(action: {
                    /* TODO: Implement the following in iOS 16
                    ShareLink(item: myURL)*/
                }) {
                    Image(systemName: "square.and.arrow.up")
                }.disabled(selection.isEmpty)
            }
            
            // MARK: DeleteButton
            if editMode == .active {
                Button(action: {
                    MemoHolder.delete(set: selection, action: {
                        selection = []
                        editMode = .inactive
                        rowInFocus = ""
                    })
                }) {
                    Image(systemName: "trash")
                }.disabled(selection.isEmpty)
            }
        }
    }
}

// MARK: Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
