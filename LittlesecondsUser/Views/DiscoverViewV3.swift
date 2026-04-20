import SwiftUI

// MARK: - Onboarding Sheet
private struct OnboardingSheet: View {
    var onComplete: ([String: String]) -> Void

    @State private var step = 0
    @State private var answers: [String: String] = [:]

    private let questions: [(key: String, title: String, subtitle: String, options: [String])] = [
        ("service",  "What are you looking for?",   "Pick what suits you today",           ["Hair",  "Nails",  "Spa",    "Brows & Lashes"]),
        ("distance", "How far will you travel?",     "We'll show nearby options first",     ["Under 1 mile", "1–3 miles", "Any distance"]),
        ("budget",   "What's your budget?",          "We'll match you to the right places", ["Budget £10–25", "Mid £25–60", "Premium £60+"])
    ]

    private var current: (key: String, title: String, subtitle: String, options: [String]) {
        questions[step]
    }

    var body: some View {
        VStack(spacing: 0) {
            // Drag indicator
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.secondary.opacity(0.3))
                .frame(width: 40, height: 5)
                .padding(.top, 12)
                .padding(.bottom, 24)

            // Progress dots
            HStack(spacing: 8) {
                ForEach(0..<questions.count, id: \.self) { i in
                    Capsule()
                        .fill(i <= step ? Color.brandDarkGreen : Color.secondary.opacity(0.2))
                        .frame(width: i == step ? 24 : 8, height: 8)
                        .animation(.spring(response: 0.3), value: step)
                }
            }
            .padding(.bottom, 28)

            // Question
            VStack(alignment: .leading, spacing: 8) {
                Text(current.title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)
                Text(current.subtitle)
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.bottom, 28)

            // Options
            VStack(spacing: 12) {
                ForEach(current.options, id: \.self) { option in
                    let isSelected = answers[current.key] == option
                    Button {
                        answers[current.key] = option
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            if step < questions.count - 1 {
                                withAnimation { step += 1 }
                            } else {
                                onComplete(answers)
                            }
                        }
                    } label: {
                        HStack {
                            Text(option)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(isSelected ? .white : .primary)
                            Spacer()
                            if isSelected {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(isSelected ? Color.brandDarkGreen : Color.cardWhite)
                        .cornerRadius(14)
                        .cardShadow()
                    }
                }
            }
            .padding(.horizontal, 24)

            Spacer()
        }
        .background(Color.backgroundGray)
    }
}

// MARK: - V3 Discover View
struct DiscoverViewV3: View {
    @EnvironmentObject private var appState: AppState
    @State private var showOnboarding = true
    @State private var preferences: [String: String] = [:]
    @State private var bookingBusiness: Business? = nil
    @State private var detailBusiness: Business? = nil
    @State private var showDetail = false
    @State private var selectedBooking: Booking? = nil

    private var defaultHero: Business {
        SampleData.businesses.first(where: { $0.name == "Curl & Co." }) ?? SampleData.businesses[0]
    }

    private var heroBusiness: Business {
        preferences.isEmpty
            ? defaultHero
            : (SampleData.businesses.first(where: { $0.name == "Bless Fade" }) ?? SampleData.businesses[0])
    }

    private var nearYouBusinesses: [Business] {
        SampleData.businesses.filter { $0.id != heroBusiness.id }
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
                            if !preferences.isEmpty, let service = preferences["service"] {
                                Text("Showing \(service) near you")
                                    .font(.system(size: 13))
                                    .foregroundColor(.secondary)
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

                    // Hero card
                    heroCard
                        .padding(.horizontal, 16)
                        .padding(.bottom, 28)

                    // Near You
                    Text("Near You")
                        .font(.system(size: 20, weight: .semibold))
                        .padding(.horizontal, 16)
                        .padding(.bottom, 12)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 14) {
                            ForEach(nearYouBusinesses) { business in
                                nearCard(business)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.bottom, 28)
                }
            }
            .background(Color.backgroundGray)
            .sheet(isPresented: $showOnboarding) {
                OnboardingSheet { answers in
                    preferences = answers
                    showOnboarding = false
                }
                .presentationDetents([.height(430)])
                .presentationDragIndicator(.hidden)
            }
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

    // MARK: - Hero Card
    private var heroCard: some View {
        ZStack(alignment: .bottom) {
            // Image
            Group {
                if let name = heroBusiness.imageName, let uiImage = UIImage(named: name) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                } else {
                    heroBusiness.color
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 420)
            .clipped()
            .cornerRadius(20)

            // Gradient
            LinearGradient(
                colors: [.clear, .black.opacity(0.75)],
                startPoint: .center,
                endPoint: .bottom
            )
            .cornerRadius(20)

            // Content overlay
            VStack(alignment: .leading, spacing: 12) {
                // Tags
                HStack(spacing: 6) {
                    if !preferences.isEmpty {
                        tagPill("⭐ Top Recommendation")
                    } else {
                        tagPill("Featured")
                    }
                    tagPill(heroBusiness.category)
                }

                // Name
                Text(heroBusiness.name)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)

                // Meta row
                HStack(spacing: 8) {
                    HStack(spacing: 3) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.orange)
                        Text(heroBusiness.ratingText)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white)
                        Text("(\(heroBusiness.reviewCount))")
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    Text("·")
                        .foregroundColor(.white.opacity(0.5))
                    Text(heroBusiness.distanceText)
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.7))
                }

                // Action buttons
                HStack(spacing: 12) {
                    Button {
                        bookingBusiness = heroBusiness
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "calendar")
                                .font(.system(size: 14, weight: .semibold))
                            Text("Book Now")
                                .font(.system(size: 15, weight: .semibold))
                        }
                        .foregroundColor(.brandDarkGreen)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .background(Color.white)
                        .cornerRadius(12)
                    }

                    Button {
                        detailBusiness = heroBusiness
                        showDetail = true
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "info.circle")
                                .font(.system(size: 14, weight: .semibold))
                            Text("More Info")
                                .font(.system(size: 15, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(12)
                    }
                }
            }
            .padding(20)
        }
        .cornerRadius(20)
        .cardShadow()
    }

    private func tagPill(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 11, weight: .semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(Color.white.opacity(0.2))
            .clipShape(Capsule())
    }

    // MARK: - Near You Card
    private func nearCard(_ business: Business) -> some View {
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
