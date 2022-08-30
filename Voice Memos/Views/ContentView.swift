import SwiftUI
import AVKit

struct ContentView: View {
    
    // MARK: @State vars
    
    @StateObject var holder = Holder()
    
    @FocusState var searchFocus : Bool
    
    @State private var selection = Set<Memo.ID>()
    
    @State private var editMode: EditMode = .inactive
    @State private var recordMode: RecordMode = .inactive
    @State private var searchText = ""
    
    var searchResults: [Memo] {
            if searchText.isEmpty {
                return holder.memos
            } else {
                return holder.memos.filter { $0.id.contains(searchText) }
            }
        }
    
    // MARK: View
    
    var body: some View {
        ZStack {
            
            NavigationView {
                
                List {
                    
                    ForEach (searchResults) {memo in
                        
                        /*NavigationLink {
                            Detail()
                        } label: {
                            Row(memo: memo)
                        }*/
                        
                        Row(memo: memo)
                        
                    }
                    
                }
                .listStyle(InsetListStyle())
                .navigationTitle("All Recordings")
                .toolbar(content: toolbarContent)
                .environment(\.editMode, $editMode)
                .searchable(text: $searchText)
                
            }
            
            // MARK: BottomBar
            BottomBar(mode: $recordMode)
                .environmentObject(holder)
            
        }.onAppear(perform: holder.refresh)
    }
    
    
    
}

// MARK: @ToolbarContentBuilder
extension ContentView {
    @ToolbarContentBuilder
    private func toolbarContent() -> some ToolbarContent {
        
        // MARK: EditButton
        ToolbarItem(placement: .navigationBarTrailing) {
            EditButton(editMode: $editMode) {
                selection.removeAll()
                editMode = .inactive
            }
        }
        
        ToolbarItemGroup(placement: .bottomBar) {
            
            // MARK: DeleteButton
            if editMode == .active {
                Button(action: {
                    selection.forEach { objectID in
                        memos.removeAll(where: {$0.id == objectID})
                    }
                    selection = []
                    editMode = .inactive
                }) {
                    Image(systemName: "trash")
                }//.disabled(selection.isEmpty)
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
