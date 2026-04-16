import SwiftUI

struct DiscoverViewV4: View {
    @EnvironmentObject private var appState: AppState
    @State private var bookingBusiness: Business? = nil
    @State private var detailBusiness: Business? = nil
    @State private var showDetail = false
    @State private var selectedBooking: Booking? = nil

    private var promotedBusinesses: [Business] {
        Array(SampleData.businesses.prefix(5))
    }

    private var recommendedBusinesses: [Business] {
        Array(SampleData.businesses.dropFirst(2).prefix(4))
    }

    private var nearYouBusinesses: [Business] {
        SampleData.businesses.sorted { $0.distanceMiles < $1.distanceMiles }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {

                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Hey, Alex")
                                .font(.system(size: 26, weight: .bold))
                                .foregroundColor(.primary)
                            Text("Essex, UK")
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        ZStack {
                            Circle()
                                .fill(Color.brandDarkGreen)
                                .frame(width: 40, height: 40)
                            Text("AO")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 36)
                    .padding(.bottom, 16)

                    // Upcoming banner
                    if let booking = appState.nextUpcomingBooking {
                        HStack(spacing: 12) {
                            Image(systemName: "calendar.badge.clock")
                                .font(.system(size: 18))
                                .foregroundColor(.brandDarkGreen)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Upcoming: \(booking.business.name)")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.brandDarkGreen)
                                Text("\(booking.service.name) · \(booking.dateText) at \(booking.time)")
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                        .padding(12)
                        .background(Color.brandDarkGreen.opacity(0.08))
                        .cornerRadius(12)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                        .onTapGesture { selectedBooking = booking }
                    }

                    // Top Promoted
                    sectionHeader("Top Promoted Near You")
                    topPromotedRow
                        .padding(.bottom, 32)

                    // Recommended
                    sectionHeader("Recommended for You")
                    recommendedRow
                        .padding(.bottom, 32)

                    // Near You
                    sectionHeader("Near You")
                    nearYouRow
                        .padding(.bottom, 32)
                }
            }
            .background(Color.backgroundGray)
            .sheet(item: $bookingBusiness) { business in
                BookingFlowView(business: business, onDismiss: { bookingBusiness = nil })
            }
            .sheet(item: $selectedBooking) { booking in
                BookingDetailSheet(booking: booking, onDismiss: { selectedBooking = nil })
                    .environmentObject(appState)
            }
            .navigationDestination(isPresented: $showDetail) {
                if let business = detailBusiness {
                    BusinessDetailView(business: business)
                }
            }
        }
    }

    // MARK: - Section Header
    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(.primary)
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
    }

    // MARK: - Top Promoted
    private var topPromotedRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                ForEach(promotedBusinesses) { business in
                    promotedCard(business)
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private func promotedCard(_ business: Business) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Group {
                if let name = business.imageName, let uiImage = UIImage(named: name) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                } else {
                    business.color
                }
            }
            .frame(width: 160, height: 200)
            .clipped()
            .clipShape(UnevenRoundedRectangle(
                topLeadingRadius: 12, bottomLeadingRadius: 0,
                bottomTrailingRadius: 0, topTrailingRadius: 12
            ))

            VStack(alignment: .leading, spacing: 4) {
                Text(business.name)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                HStack(spacing: 3) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 11))
                        .foregroundColor(.orange)
                    Text(business.ratingText)
                        .font(.system(size: 12, weight: .semibold))
                    Text("(\(business.reviewCount))")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                Text(business.category)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }
            .padding(10)
            .frame(width: 160, alignment: .leading)
            .background(Color.cardWhite)
            .clipShape(UnevenRoundedRectangle(
                topLeadingRadius: 0, bottomLeadingRadius: 12,
                bottomTrailingRadius: 12, topTrailingRadius: 0
            ))
        }
        .cardShadow()
        .onTapGesture { detailBusiness = business; showDetail = true }
    }

    // MARK: - Recommended horizontal scroll
    private var recommendedRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                ForEach(recommendedBusinesses) { business in
                    mediumCard(business)
                }
            }
            .padding(.horizontal, 16)
        }
    }

    // MARK: - Near You horizontal scroll
    private var nearYouRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                ForEach(nearYouBusinesses) { business in
                    mediumCard(business)
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private func mediumCard(_ business: Business) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Group {
                if let name = business.imageName, let uiImage = UIImage(named: name) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                } else {
                    business.color
                }
            }
            .frame(width: 180, height: 120)
            .clipped()
            .clipShape(UnevenRoundedRectangle(
                topLeadingRadius: 12, bottomLeadingRadius: 0,
                bottomTrailingRadius: 0, topTrailingRadius: 12
            ))

            VStack(alignment: .leading, spacing: 4) {
                Text(business.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                HStack(spacing: 3) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 11))
                        .foregroundColor(.orange)
                    Text(business.ratingText)
                        .font(.system(size: 12, weight: .semibold))
                    Text("(\(business.reviewCount))")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                Text(business.distanceText)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            .padding(10)
            .frame(width: 180, alignment: .leading)
            .background(Color.cardWhite)
            .clipShape(UnevenRoundedRectangle(
                topLeadingRadius: 0, bottomLeadingRadius: 12,
                bottomTrailingRadius: 12, topTrailingRadius: 0
            ))
        }
        .cardShadow()
        .onTapGesture { detailBusiness = business; showDetail = true }
    }
}
