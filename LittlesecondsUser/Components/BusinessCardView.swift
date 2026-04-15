import SwiftUI

struct BusinessCardView: View {
    let business: Business
    var onBook: () -> Void = {}

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header image placeholder
            ZStack(alignment: .bottomLeading) {
                business.color
                    .frame(height: 120)
                Text(business.category)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.brandDarkGreen)
                    .cornerRadius(8)
                    .padding(10)
            }

            // Body
            VStack(alignment: .leading, spacing: 6) {
                Text(business.name)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.brandDarkGreen)

                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.orange)
                    Text(business.ratingText)
                        .font(.system(size: 14, weight: .semibold))
                    Text("(\(business.reviewCount) reviews)")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }

                Text(business.distanceText)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)

                HStack {
                    Text(business.fromPriceText)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                    Spacer()
                    PillButton(title: "Book", action: onBook)
                }
            }
            .padding(12)
        }
        .background(Color.cardWhite)
        .cornerRadius(12)
        .cardShadow()
    }
}
