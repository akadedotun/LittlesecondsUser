import SwiftUI

struct BookingsView: View {
    @State private var segment = 0
    @State private var bookings = SampleData.bookings

    private var filteredBookings: [Booking] {
        bookings.filter { segment == 0 ? $0.status == .upcoming : $0.status == .past }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("", selection: $segment) {
                    Text("Upcoming").tag(0)
                    Text("Past").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)

                if filteredBookings.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(filteredBookings) { booking in
                                bookingCard(booking)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20)
                    }
                }
            }
            .background(Color.backgroundGray)
            .navigationTitle("Bookings")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private func bookingCard(_ booking: Booking) -> some View {
        HStack(spacing: 0) {
            // Left border strip
            Color.brandDarkGreen
                .frame(width: 4)
                .cornerRadius(2)

            VStack(alignment: .leading, spacing: 6) {
                Text(booking.business.name)
                    .font(.system(size: 17, weight: .semibold))
                Text(booking.service.name)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                Text("\(booking.dateText) at \(booking.time)")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)

                if booking.status == .upcoming {
                    DestructivePillButton(title: "Cancel") {
                        if let index = bookings.firstIndex(where: { $0.id == booking.id }) {
                            bookings[index].status = .past
                        }
                    }
                }
            }
            .padding(14)

            Spacer()
        }
        .background(Color.cardWhite)
        .cornerRadius(12)
        .cardShadow()
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.secondary.opacity(0.1))
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "calendar")
                        .font(.system(size: 32))
                        .foregroundColor(.secondary)
                )
            Text("No bookings yet")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.secondary)
            Spacer()
        }
    }
}
