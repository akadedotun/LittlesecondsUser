import SwiftUI

struct ServiceRowView: View {
    let service: Service
    var isSelected: Bool = false
    var onTap: (() -> Void)? = nil

    var body: some View {
        Button(action: { onTap?() }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(service.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    Text(service.durationText)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                Spacer()
                Text(service.priceText)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.brandDarkGreen)
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.brandDarkGreen)
                        .padding(.leading, 6)
                }
            }
            .padding(16)
            .background(Color.cardWhite)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.brandDarkGreen : Color.clear, lineWidth: 2)
            )
            .cardShadow()
        }
        .buttonStyle(.plain)
    }
}
