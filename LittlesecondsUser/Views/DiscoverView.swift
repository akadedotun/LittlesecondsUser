import SwiftUI

// MARK: - Swipe Card
private struct SwipeCard: View {
    let business: Business
    let dragOffset: CGSize
    let isTop: Bool
    var dragProgress: CGFloat = 0   // 0 = resting behind, 1 = fully revealed
    var onDetail: () -> Void
    var onBook: () -> Void

    private var rotation: Double { isTop ? Double(dragOffset.width / 20) : 0 }
    private var likeOpacity: Double { isTop ? Double(min(0.5, max(0, dragOffset.width / 180))) : 0 }
    private var nopeOpacity: Double { isTop ? Double(min(0.5, max(0, -dragOffset.width / 180))) : 0 }

    // Back card animates from resting (scale 0.95, rotated 5°, shifted down) → active (1.0, 0°, 0)
    private var backScale: CGFloat { isTop ? 1 : 0.95 + 0.05 * dragProgress }
    private var backRotation: Double { isTop ? 0 : 5 - 5 * Double(dragProgress) }
    private var backOffsetY: CGFloat { isTop ? 0 : 8 - 8 * dragProgress }

    var body: some View {
        VStack(spacing: 0) {
            // Large image placeholder (fills most of card)
            ZStack(alignment: .bottom) {
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
                .frame(height: 460)
                .clipped()
                .clipShape(UnevenRoundedRectangle(
                    topLeadingRadius: 20, bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0, topTrailingRadius: 20
                ))

                // Gradient overlay
                LinearGradient(
                    colors: [.clear, .black.opacity(0.55)],
                    startPoint: .center,
                    endPoint: .bottom
                )
                .frame(height: 180)

                // Business name + meta overlaid on image
                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(business.name)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            HStack(spacing: 6) {
                                Text(business.category)
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Color.brandDarkGreen)
                                    .cornerRadius(8)
                                HStack(spacing: 3) {
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 11))
                                        .foregroundColor(.orange)
                                    Text(business.ratingText)
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(.white)
                                    Text("(\(business.reviewCount))")
                                        .font(.system(size: 12))
                                        .foregroundColor(.white.opacity(0.8))
                                }
                            }
                        }
                        Spacer()
                        // Distance badge
                        VStack(spacing: 2) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                            Text(business.distanceText)
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                        .padding(10)
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                    }
                }
                .padding(16)


                // Swipe tint overlay
                Color.green
                    .opacity(likeOpacity * 0.25)
                    .frame(maxWidth: .infinity)
                    .frame(height: 460)
                    .clipShape(UnevenRoundedRectangle(
                        topLeadingRadius: 20, bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0, topTrailingRadius: 20
                    ))
                    .allowsHitTesting(false)

                Color.red
                    .opacity(nopeOpacity * 0.25)
                    .frame(maxWidth: .infinity)
                    .frame(height: 460)
                    .clipShape(UnevenRoundedRectangle(
                        topLeadingRadius: 20, bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0, topTrailingRadius: 20
                    ))
                    .allowsHitTesting(false)
            }

            // Bottom info strip
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(business.fromPriceText)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.brandDarkGreen)
                    Text("\(business.services.count) services available")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
                Spacer()
                // Action buttons on card
                HStack(spacing: 12) {
                    Button(action: onDetail) {
                        Image(systemName: "info.circle")
                            .font(.system(size: 20))
                            .foregroundColor(.brandDarkGreen)
                            .frame(width: 40, height: 40)
                            .background(Color.brandDarkGreen.opacity(0.1))
                            .clipShape(Circle())
                    }
                    Button(action: onBook) {
                        Text("Book")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 10)
                            .background(Color.brandDarkGreen)
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.cardWhite)
        }
        .cornerRadius(20)
        .cardShadow()
        .scaleEffect(backScale)
        .rotationEffect(.degrees(isTop ? rotation : backRotation))
        .offset(
            x: isTop ? dragOffset.width : 0,
            y: isTop ? dragOffset.height * 0.3 : backOffsetY
        )
        .animation(.easeInOut(duration: 0.2), value: dragProgress)
    }
}

// MARK: - Discover View
struct DiscoverView: View {
    @State private var searchText = ""
    @State private var selectedCategory = "All"
    @EnvironmentObject private var appState: AppState
    @State private var dragOffset: CGSize = .zero
    @State private var skippedIDs: Set<UUID> = []
    @State private var bookingBusiness: Business? = nil
    @State private var detailBusiness: Business? = nil
    @State private var showDetail = false
    @State private var swipeActionBusiness: Business? = nil // tracks swipe animation

    private let categories = ["All", "Salons", "Barbers", "Spas", "Nails", "Lashes", "Brows", "Massage", "Skincare", "Makeup", "Waxing", "Wellness"]
    private let swipeThreshold: CGFloat = 100

    private var filteredBusinesses: [Business] {
        // Category filter — only the 3 we have real data for; rest show all
        let categoryMap: [String: String] = ["Salons": "Salon", "Spas": "Spa", "Barbers": "Barber"]
        let byCategory: [Business]
        if let cat = categoryMap[selectedCategory] {
            byCategory = SampleData.businesses.filter { $0.category == cat }
        } else {
            byCategory = SampleData.businesses
        }

        let searched = searchText.isEmpty ? byCategory : byCategory.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }

        let savedIDs = Set(appState.savedBusinesses.map { $0.id })
        return searched.filter { !skippedIDs.contains($0.id) && !savedIDs.contains($0.id) }
    }

    private var topBusiness: Business? { filteredBusinesses.first }
    private var nextBusiness: Business? { filteredBusinesses.dropFirst().first }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Greeting
                HStack {
                    Text("Good morning, Alex")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.brandDarkGreen)
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.brandDarkGreen)
                        Text("Chelmsford")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 24)
                .padding(.bottom, 8)

                // Upcoming booking banner
                if let booking = appState.nextUpcomingBooking {
                    HStack(spacing: 12) {
                        Image(systemName: "calendar.badge.clock")
                            .font(.system(size: 20))
                            .foregroundColor(.brandDarkGreen)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Upcoming: \(booking.business.name)")
                                .font(.system(size: 14, weight: .semibold))
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
                    .padding(.bottom, 8)
                }

                // Search bar
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("Search salons, spas, barbers...", text: $searchText)
                        .font(.system(size: 16))
                }
                .padding(12)
                .background(Color.cardWhite)
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                .padding(.horizontal, 16)
                .padding(.bottom, 16)

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
                .padding(.bottom, 16)
                // Card deck
                if filteredBusinesses.isEmpty {
                    emptyState
                } else {
                    ZStack {
                        // Background card — animates in as top card is dragged
                        if let next = nextBusiness {
                            SwipeCard(
                                business: next,
                                dragOffset: .zero,
                                isTop: false,
                                dragProgress: min(1, abs(dragOffset.width) / swipeThreshold),
                                onDetail: {},
                                onBook: {}
                            )
                            .allowsHitTesting(false)
                        }

                        // Top card (draggable)
                        if let top = topBusiness {
                            SwipeCard(
                                business: top,
                                dragOffset: dragOffset,
                                isTop: true,
                                onDetail: { detailBusiness = top; showDetail = true },
                                onBook: { bookingBusiness = top }
                            )
                            .gesture(
                                DragGesture(minimumDistance: 10)
                                    .onChanged { value in
                                        withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.7)) {
                                            dragOffset = value.translation
                                        }
                                    }
                                    .onEnded { value in
                                        handleSwipeEnd(business: top, translation: value.translation)
                                    }
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)

                }

                Spacer(minLength: 0)
            }
            .background(Color.backgroundGray)
            .sheet(item: $bookingBusiness) { business in
                BookingFlowView(business: business, onDismiss: { bookingBusiness = nil })
            }
            .navigationDestination(isPresented: $showDetail) {
                if let business = detailBusiness {
                    BusinessDetailView(business: business)
                }
            }
        }
    }

    // MARK: - Swipe Logic
    private func handleSwipeEnd(business: Business, translation: CGSize) {
        if translation.width > swipeThreshold {
            swipeCard(business: business, liked: true)
        } else if translation.width < -swipeThreshold {
            swipeCard(business: business, liked: false)
        } else {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.75, blendDuration: 0.1)) {
                dragOffset = .zero
            }
        }
    }

    private func swipeCard(business: Business, liked: Bool) {
        let flyOffset: CGFloat = liked ? 700 : -700
        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
            dragOffset = CGSize(width: flyOffset, height: dragOffset.height * 0.5)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            if liked {
                appState.save(business)
            } else {
                skippedIDs.insert(business.id)
            }
            dragOffset = .zero
        }
    }

    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "sparkles")
                .font(.system(size: 48))
                .foregroundColor(.brandDarkGreen.opacity(0.5))
            Text("You've seen them all!")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.brandDarkGreen)
            Text("Change category or check back later")
                .font(.system(size: 15))
                .foregroundColor(.secondary)
            Button("Start over") {
                skippedIDs.removeAll()
                appState.savedBusinesses.removeAll()
            }
            .font(.system(size: 15, weight: .semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Color.brandDarkGreen)
            .cornerRadius(20)
            Spacer()
        }
    }
}
