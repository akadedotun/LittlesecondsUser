import SwiftUI

struct SavedView: View {
    @EnvironmentObject private var appState: AppState
    @State private var bookingBusiness: Business? = nil

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            Group {
                if appState.savedBusinesses.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(appState.savedBusinesses) { business in
                                NavigationLink(destination: BusinessDetailView(business: business)) {
                                    BusinessCardView(
                                        business: business,
                                        onBook: { bookingBusiness = business }
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20)
                    }
                }
            }
            .background(Color.backgroundGray)
            .navigationTitle("Saved")
            .navigationBarTitleDisplayMode(.large)
            .sheet(item: $bookingBusiness) { business in
                BookingFlowView(business: business, onDismiss: { bookingBusiness = nil })
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            Text("Save businesses you love")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.secondary)
        }
    }
}
