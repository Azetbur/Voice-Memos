import SwiftUI
import AVKit
import AVFoundation

// MARK: enum RecordMode
enum RecordMode {
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
    
    @Binding var mode: RecordMode
    
    var action: () -> Void = {}
    
    var body: some View {
        Button {
            withAnimation(.easeInOut) {
                mode.toggle()
            }
            AudioServicesPlaySystemSound(mode.isActive ? 1113 : 1114)
            action()
        } label: {
            RoundedRectangle(cornerRadius: mode.isActive ? 5 : 50)
                .foregroundColor(.red)
                .scaleEffect(mode.isActive ? 0.5 : 1)
                .frame(width: 48, height: 48)
                .overlay(
                    Circle()
                        .strokeBorder(Color.white, lineWidth: 2.75)
                        .frame(width: 60, height: 100)
                )
        }
    }
}
        

// MARK: Preview

struct SelectButton_Previews: PreviewProvider {
    static var previews: some View {
        RecordButton(mode: .constant(.active))
            .preferredColorScheme(.dark)
        RecordButton(mode: .constant(.inactive))
            .preferredColorScheme(.dark)
    }
}
