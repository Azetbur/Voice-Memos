import SwiftUI
import AVKit

struct ContentView: View {
    
    // MARK: @State vars
    
    @StateObject var holder = Holder()
    
    @State private var selection = Set<Memo.ID>()
    
    @State private var editMode: EditMode = .inactive
    @State private var recordMode: Mode = .inactive
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
                
                List (selection: $selection) {
                    
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
                
            }.disabled(recordMode.isActive)
                .opacity(recordMode.isActive ? 0.5 : 1)
            
            // MARK: BottomBar
            BottomBar(recordMode: $recordMode, editMode: $editMode)
            .environmentObject(holder)
            
        }.onAppear(perform: holder.refresh)
        .searchable(text: $searchText)
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
            
            // MARK: ShareButton
            if editMode == .active {
                Button(action: {
                    //share action
                }) {
                    Image(systemName: "square.and.arrow.up")
                }//.disabled(selection.isEmpty)
            }
            
            // MARK: DeleteButton
            if editMode == .active {
                Button(action: {
                    selection.forEach { objectID in
                        holder.memos.removeAll(where: {$0.id == objectID})
                        // TODO: Delete the actual file
                        
                        let fileManager = FileManager.default
                        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
                        
                        do {
                            try fileManager.removeItem(at: )
                        } catch {
                            fatalError("\(error)")
                        }
                        
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
