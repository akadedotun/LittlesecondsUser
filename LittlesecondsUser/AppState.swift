import SwiftUI
import Combine

final class AppState: ObservableObject {
    @Published var savedBusinesses: [Business] = []

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
