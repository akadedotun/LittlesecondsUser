import SwiftUI

struct BookingDetailSheet: View {
    let booking: Booking
    var onDismiss: () -> Void = {}

    @EnvironmentObject private var appState: AppState
    @State private var showCancelConfirm = false

    var body: some View {
        VStack(spacing: 0) {
            // Drag indicator
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.secondary.opacity(0.3))
                .frame(width: 40, height: 5)
                .padding(.top, 12)
                .padding(.bottom, 20)

            // Header
            Text("Booking Details")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.brandDarkGreen)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.bottom, 20)

            // Summary card
            VStack(alignment: .leading, spacing: 12) {
                summaryRow(label: "Business", value: booking.business.name)
                Divider()
                summaryRow(label: "Service", value: booking.service.name)
                Divider()
                summaryRow(label: "Date", value: booking.dateText)
                Divider()
                summaryRow(label: "Time", value: booking.time)
                Divider()
                summaryRow(label: "Price", value: booking.service.priceText)
                Divider()
                summaryRow(label: "Status", value: booking.status == .upcoming ? "Upcoming" : "Past")
            }
            .padding(16)
            .background(Color.cardWhite)
            .cornerRadius(12)
            .cardShadow()
            .padding(.horizontal, 16)

            Spacer()

            // Cancel button
            Button("Cancel Booking") {
                showCancelConfirm = true
            }
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(.red)
            .padding(.bottom, 24)
        }
        .background(Color.backgroundGray)
        .confirmationDialog("Cancel this booking?", isPresented: $showCancelConfirm, titleVisibility: .visible) {
            Button("Cancel Booking", role: .destructive) {
                appState.cancelBooking(booking)
                onDismiss()
            }
            Button("Keep Booking", role: .cancel) {}
        }
    }

    private func summaryRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.primary)
        }
    }
}
