import SwiftUI
import Combine

final class AppState: ObservableObject {
    @Published var savedBusinesses: [Business] = []
    @Published var bookings: [Booking] = []

    var nextUpcomingBooking: Booking? {
        bookings.filter { $0.status == .upcoming }
              .sorted { $0.date < $1.date }
              .first
    }

    func addBooking(_ booking: Booking) {
        bookings.append(booking)
    }

    func save(_ business: Business) {
        guard !savedBusinesses.contains(where: { $0.id == business.id }) else { return }
        savedBusinesses.append(business)
    }

    func remove(_ business: Business) {
        savedBusinesses.removeAll { $0.id == business.id }
    }

    func isSaved(_ business: Business) -> Bool {
        savedBusinesses.contains(where: { $0.id == business.id })
    }
}
