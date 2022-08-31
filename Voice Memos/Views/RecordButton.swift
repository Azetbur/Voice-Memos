import SwiftUI
import AVKit
import AVFoundation

// MARK: enum RecordMode
enum Mode {
    case active, inactive

    var isActive: Bool {
        self == .active
    }

    mutating func toggle() {
        switch self {
        case .active:
            self = .inactive
        case .inactive:
            self = .active
        }
    }
}

// MARK: RecordButton
struct RecordButton: View {
    
    @Binding var recordMode: Mode
    
    @Binding var nibbleMode: Mode
    
    @State var isAnimating = false
    
    var action: () -> Void = {}
    
    var body: some View {
        Button {
            //isAnimating = true
            withAnimation(.easeInOut) {
                recordMode.toggle()
            }
            withAnimation(.easeOut) {
                nibbleMode.toggle()
                //isAnimating = false
            }
            AudioServicesPlaySystemSound(recordMode.isActive ? 1113 : 1114)
            action()
            
        } label: {
            RoundedRectangle(cornerRadius: recordMode.isActive ? 5 : 50)
                .foregroundColor(.red)
                .scaleEffect(recordMode.isActive ? 0.5 : 1)
                .frame(width: 48, height: 48)
                .overlay(
                    Circle()
                        .strokeBorder(Color.white, lineWidth: 2.75)
                        .frame(width: 60, height: 100)
                )
        }.disabled(isAnimating)
    }
}
        

// MARK: Preview

/*struct SelectButton_Previews: PreviewProvider {
    static var previews: some View {
        RecordButton(recordMode: .constant(.active))
            .preferredColorScheme(.dark)
        RecordButton(recordMode: .constant(.inactive))
            .preferredColorScheme(.dark)
    }
}*/
