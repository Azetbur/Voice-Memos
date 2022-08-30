import SwiftUI

struct Row: View {
    var memo: Memo
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(memo.id)
                .fontWeight(.bold)
            Spacer()
            HStack {
                Text(memo.time)
                Text(memo.duration)
            }.foregroundColor(.secondary)
            .font(.subheadline)
        }.padding(5)
    }
}

/*struct Row_Previews: PreviewProvider {
    static var previews: some View {
        Row()
    }
}*/
