import SwiftUI

struct BusinessDetailView: View {
    let business: Business
    @State private var showBookingFlow = false

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {

                    // Hero image — always the single imageName
                    Group {
                        if let name = business.imageName, let uiImage = UIImage(named: name) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                        } else {
                            business.color
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 260)
                    .clipped()

                    VStack(alignment: .leading, spacing: 16) {
                        // Info card
                        VStack(alignment: .leading, spacing: 10) {
                            Text(business.name)
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(.brandDarkGreen)

                            Text(business.category)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 5)
                                .background(Color.brandDarkGreen)
                                .clipShape(Capsule())

                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 13))
                                    .foregroundColor(.orange)
                                Text(business.ratingText)
                                    .font(.system(size: 15, weight: .semibold))
                                Text("(\(business.reviewCount) reviews)")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                            }

                            HStack(spacing: 4) {
                                Image(systemName: "location.fill")
                                    .font(.system(size: 13))
                                    .foregroundColor(.brandDarkGreen)
                                Text(business.distanceText)
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.cardWhite)
                        .cornerRadius(12)
                        .cardShadow()

                        Divider()

                        // About section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("About")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.brandDarkGreen)
                            Text(business.aboutText)
                                .font(.system(size: 16))
                                .foregroundColor(.secondary)
                                .lineLimit(3)
                        }

                        // More Photos section — only shown when imageNames is populated
                        if !business.imageNames.isEmpty {
                            morePhotosSection
                        }

                        // Services section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Services")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.brandDarkGreen)

                            ForEach(business.services) { service in
                                ServiceRowView(service: service)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 100)
                }
            }
            .background(Color.backgroundGray)

            // Pinned Book Now button
            VStack {
                CustomButton("Book Now", style: .primary) {
                    showBookingFlow = true
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
            .background(
                Color.backgroundGray
                    .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: -4)
            )
        }
        .navigationTitle(business.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.light)
        .tint(.brandDarkGreen)
        .sheet(isPresented: $showBookingFlow) {
            BookingFlowView(business: business, onDismiss: { showBookingFlow = false })
        }
    }

    // MARK: - More Photos
    private var morePhotosSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("More Photos")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.brandDarkGreen)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(business.imageNames, id: \.self) { name in
                        Group {
                            if let uiImage = UIImage(named: name) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                business.color
                            }
                        }
                        .frame(width: 160, height: 120)
                        .clipped()
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 1) // prevent shadow clipping
            }
            .padding(.horizontal, -16) // bleed to edges
            .padding(.leading, 16)
        }
    }
}
