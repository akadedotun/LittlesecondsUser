import SwiftUI

struct DiscoverViewV2: View {
    @EnvironmentObject private var appState: AppState
    @State private var selectedCategory = "All"
    @State private var bookingBusiness: Business? = nil
    @State private var detailBusiness: Business? = nil
    @State private var showDetail = false
    @State private var selectedBooking: Booking? = nil

    private let categories = ["All", "Salons", "Barbers", "Spas", "Nails", "Lashes", "Brows", "Massage", "Skincare", "Makeup", "Waxing", "Wellness"]

    private var filteredBusinesses: [Business] {
        let categoryMap: [String: String] = ["Salons": "Salon", "Spas": "Spa", "Barbers": "Barber"]
        if let cat = categoryMap[selectedCategory] {
            return SampleData.businesses.filter { $0.category == cat }
        }
        return SampleData.businesses
    }

    private var recommendedBusinesses: [Business] {
        Array(filteredBusinesses.prefix(4))
    }

    private var newBusinesses: [Business] {
        Array(filteredBusinesses.dropFirst(2))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {

                    // Header
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Hey, Alex")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.primary)
                            if let booking = appState.nextUpcomingBooking {
                                Text("Next: \(booking.business.name) · \(booking.dateText)")
                                    .font(.system(size: 13))
                                    .foregroundColor(.secondary)
                                    .onTapGesture { selectedBooking = booking }
                            }
                        }
                        Spacer()
                        // Avatar
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
                    .padding(.bottom, 20)

                    // Category chips
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(categories, id: \.self) { cat in
                                let isSelected = selectedCategory == cat
                                Text(cat)
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(isSelected ? .white : .black)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(isSelected ? Color.brandDarkGreen : Color.cardWhite.opacity(0.5))
                                    .cornerRadius(20)
                                    .onTapGesture { selectedCategory = cat }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.bottom, 24)

                    // Recommended section
                    sectionHeader("Recommended")
                    recommendedGrid
                        .padding(.bottom, 28)

                    // Near you section
                    sectionHeader("Near You")
                    nearYouList
                        .padding(.bottom, 28)

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
            .font(.system(size: 20, weight: .semibold))
            .foregroundColor(.primary)
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
    }

    // MARK: - Recommended 2-column grid
    private var recommendedGrid: some View {
        let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]
        return LazyVGrid(columns: columns, spacing: 12) {
            ForEach(recommendedBusinesses) { business in
                gridCard(business)
            }
        }
        .padding(.horizontal, 16)
    }

    private func gridCard(_ business: Business) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image
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
            .frame(height: 120)
            .clipped()
            .clipShape(UnevenRoundedRectangle(
                topLeadingRadius: 12, bottomLeadingRadius: 0,
                bottomTrailingRadius: 0, topTrailingRadius: 12
            ))

            // Info
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

                Text(business.category)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.brandDarkGreen)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.brandDarkGreen.opacity(0.1))
                    .clipShape(Capsule())
            }
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.cardWhite)
            .clipShape(UnevenRoundedRectangle(
                topLeadingRadius: 0, bottomLeadingRadius: 12,
                bottomTrailingRadius: 12, topTrailingRadius: 0
            ))
        }
        .cornerRadius(12)
        .cardShadow()
        .onTapGesture { detailBusiness = business; showDetail = true }
    }

    // MARK: - Near You horizontal scroll
    private var nearYouList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                ForEach(newBusinesses) { business in
                    nearYouCard(business)
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private func nearYouCard(_ business: Business) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image
            Group {
                if let name = business.imageName, let uiImage = UIImage(named: name) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                } else {
                    business.color
                }
            }
            .frame(width: 200, height: 130)
            .clipped()
            .clipShape(UnevenRoundedRectangle(
                topLeadingRadius: 12, bottomLeadingRadius: 0,
                bottomTrailingRadius: 0, topTrailingRadius: 12
            ))

            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(business.name)
                    .font(.system(size: 15, weight: .semibold))
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

                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                    Text(business.distanceText)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
            }
            .padding(10)
            .frame(width: 200, alignment: .leading)
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
