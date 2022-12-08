import SDWebImageSwiftUI
import SwiftUI

public struct URLImage: View {
    let imageUrl: URL?

    public init(imageUrl: URL?) {
        self.imageUrl = imageUrl
    }

    public var body: some View {
        WebImage(url: imageUrl)
            .cancelOnDisappear(true)
            .resizable()
    }
}
