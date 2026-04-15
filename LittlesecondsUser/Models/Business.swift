import SwiftUI

struct Business: Identifiable {
    let id: UUID
    let name: String
    let category: String
    let rating: Double
    let reviewCount: Int
    let distanceMiles: Double
    let fromPrice: Double
    let color: Color
    let imageName: String?
    let imageNames: [String]   // multiple images for gallery
    let services: [Service]

    init(id: UUID = UUID(), name: String, category: String, rating: Double,
         reviewCount: Int, distanceMiles: Double, fromPrice: Double,
         color: Color, imageName: String? = nil, imageNames: [String] = [], services: [Service]) {
        self.id = id
        self.name = name
        self.category = category
        self.rating = rating
        self.reviewCount = reviewCount
        self.distanceMiles = distanceMiles
        self.fromPrice = fromPrice
        self.color = color
        self.imageName = imageName
        self.imageNames = imageNames
        self.services = services
    }

    /// All gallery images — falls back to the single imageName if imageNames is empty
    var allImageNames: [String] {
        if !imageNames.isEmpty { return imageNames }
        if let name = imageName { return [name] }
        return []
    }

    var distanceText: String { "\(distanceMiles) miles" }
    var fromPriceText: String { "From £\(Int(fromPrice))" }
    var ratingText: String { String(format: "%.1f", rating) }
    var aboutText: String {
        "A top-rated \(category.lowercased()) conveniently located near Chelmsford, Essex. Known for exceptional service and a welcoming atmosphere."
    }
}
