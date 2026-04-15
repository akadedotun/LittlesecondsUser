import Foundation

enum BookingStatus {
    case upcoming, past
}

struct Booking: Identifiable {
    let id: UUID
    let business: Business
    let service: Service
    let date: Date
    let time: String
    var status: BookingStatus

    init(id: UUID = UUID(), business: Business, service: Service,
         date: Date, time: String, status: BookingStatus = .upcoming) {
        self.id = id
        self.business = business
        self.service = service
        self.date = date
        self.time = time
        self.status = status
    }

    var dateText: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
