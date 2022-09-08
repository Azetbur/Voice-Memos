import SwiftUI

struct EditButton: View {
    
    // MARK: vars
    
    //Wheter you are in edit mode, disables recording
    @Binding var editMode: EditMode
    
    //Action to execute when edit mode is inactive and the edit button is pressed
    var actionInactive: () -> Void = {}
    
    //Action to execute when edit mode is active and the edit button is pressed
    var actionActive: () -> Void = {}
    
    // MARK: View
    
    var body: some View {
        Button {
            withAnimation {
                if editMode == .active {
                    actionActive()
                    editMode = .inactive
                } else {
                    actionInactive()
                    editMode = .active
                }
            }
        } label: {
            if editMode == .active {
                Text("Cancel").bold()
            } else {
                Text("Edit")
            }
        }
    }
}

// MARK: Preview
struct EditButton_Previews: PreviewProvider {
    static var previews: some View {
        EditButton(editMode: .constant(.inactive))
            .preferredColorScheme(.dark)
    }
}
