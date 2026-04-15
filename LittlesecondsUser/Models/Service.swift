import Foundation

struct Service: Identifiable, Hashable {
    let id: UUID
    let name: String
    let durationMinutes: Int
    let price: Double

    init(id: UUID = UUID(), name: String, durationMinutes: Int, price: Double) {
        self.id = id
        self.name = name
        self.durationMinutes = durationMinutes
        self.price = price
    }

    var durationText: String { "\(durationMinutes) min" }
    var priceText: String { "£\(Int(price))" }
}
