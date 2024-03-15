import SwiftUI

struct EmojiButton: View {
    let imageName: String
    let action: () -> Void
    
    @State private var isSelected: Bool = false
    
    var body: some View {
        Button(action: {
            withAnimation {
                isSelected.toggle()
                action()
            }
        }) {
            VStack {
                Image(imageName)
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 200)
                    .background(isSelected ? Color.blue.opacity(0.5) : Color.gray.opacity(0.5))
                    .cornerRadius(20)
                    .foregroundColor(.white)
                    .scaledToFit()
                    .rotationEffect(isSelected ? .degrees(45) : .degrees(0))
                    .opacity(isSelected ? 0.5 : 1.0)
                    .animation(.spring())
            
            }
            .offset(y: -50)
            
        }
        .buttonStyle(PlainButtonStyle())
    }
}
