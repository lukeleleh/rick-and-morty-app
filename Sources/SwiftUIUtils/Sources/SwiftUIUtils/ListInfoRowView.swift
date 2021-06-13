import SwiftUI

public struct ListInfoRowView: View {
    let label: String
    let icon: String
    let value: String

    public init(label: String, icon: String, value: String) {
        self.label = label
        self.icon = icon
        self.value = value
    }

    public var body: some View {
        HStack {
            Label {
                Text(label)
            } icon: {
                Text(icon)
            }
            Spacer()
            Text(value)
                .foregroundColor(.accentColor)
                .fontWeight(.semibold)
        }
    }
}
