import SwiftUI
import SwiftUIUtils

struct CharacterView: View {
    let presentation: CharacterPresentation

    var body: some View {
        ZStack(alignment: .bottom) {
            URLImage(imageUrl: presentation.image)
                .scaledToFill()
            Text(presentation.name)
                .font(.headline)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding([.all], 6)
                .background(Color.primary.colorInvert().opacity(0.75))
        }
        .addBorder(Color.primary, cornerRadius: 12)
    }
}

struct CharacterView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            let presentation = CharacterPresentation(
                image: nil,
                name: "Rick Sánchez",
                model: .mock
            )

            CharacterView(presentation: presentation)
                .frame(width: 300, height: 300)
                .previewLayout(.sizeThatFits)

            CharacterView(presentation: presentation)
                .frame(width: 300, height: 300)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
