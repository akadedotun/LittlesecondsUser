import SwiftUI

struct SampleData {

    static let businesses: [Business] = [
        Business(
            name: "Luxe Hair Studio",
            category: "Salon",
            rating: 4.9,
            reviewCount: 210,
            distanceMiles: 0.3,
            fromPrice: 30,
            color: Color(red: 0.85, green: 0.72, blue: 0.88),
            imageName: "business1",
            services: [
                Service(name: "Blow dry", durationMinutes: 45, price: 30),
                Service(name: "Highlights", durationMinutes: 90, price: 85),
                Service(name: "Cut & style", durationMinutes: 60, price: 55),
                Service(name: "Hair treatment", durationMinutes: 30, price: 40)
            ]
        ),
        Business(
            name: "The Salon Co.",
            category: "Barber",
            rating: 4.7,
            reviewCount: 98,
            distanceMiles: 0.6,
            fromPrice: 15,
            color: Color(red: 0.72, green: 0.85, blue: 0.98),
            imageName: "business2",
            services: [
                Service(name: "Fade", durationMinutes: 30, price: 15),
                Service(name: "Beard trim", durationMinutes: 20, price: 12),
                Service(name: "Cut & beard", durationMinutes: 45, price: 25),
                Service(name: "Hot towel shave", durationMinutes: 30, price: 20)
            ]
        ),
        Business(
            name: "Bless Fade",
            category: "Barber",
            rating: 4.8,
            reviewCount: 156,
            distanceMiles: 1.1,
            fromPrice: 20,
            color: Color(red: 0.88, green: 0.96, blue: 0.88),
            imageName: "business3",
            imageNames: ["blessfade1", "blessfade2", "blessfade3", "blessfade4"],
            services: [
                Service(name: "Skin Fade", durationMinutes: 35, price: 20),
                Service(name: "Taper Fade", durationMinutes: 35, price: 22),
                Service(name: "Caesar Cut", durationMinutes: 40, price: 25),
                Service(name: "Buzz Cut", durationMinutes: 20, price: 15)
            ]
        ),
        Business(
            name: "Curl & Co.",
            category: "Salon",
            rating: 4.6,
            reviewCount: 74,
            distanceMiles: 0.8,
            fromPrice: 35,
            color: Color(red: 0.98, green: 0.88, blue: 0.72),
            imageName: "business4",
            services: [
                Service(name: "Wash & go", durationMinutes: 45, price: 35),
                Service(name: "Twist out", durationMinutes: 60, price: 50),
                Service(name: "Trim", durationMinutes: 30, price: 25),
                Service(name: "Deep condition", durationMinutes: 45, price: 40)
            ]
        ),
        Business(
            name: "Fade Kings",
            category: "Barber",
            rating: 4.9,
            reviewCount: 312,
            distanceMiles: 0.2,
            fromPrice: 18,
            color: Color(red: 0.98, green: 0.78, blue: 0.72),
            imageName: "business5",
            services: [
                Service(name: "Skin fade", durationMinutes: 35, price: 18),
                Service(name: "Line up", durationMinutes: 20, price: 12),
                Service(name: "Full cut", durationMinutes: 45, price: 22),
                Service(name: "Kid's cut", durationMinutes: 30, price: 14)
            ]
        ),
        Business(
            name: "Bloom Wellness",
            category: "Spa",
            rating: 4.7,
            reviewCount: 189,
            distanceMiles: 1.4,
            fromPrice: 40,
            color: Color(red: 0.72, green: 0.92, blue: 0.88),
            imageName: "business6",
            services: [
                Service(name: "Aromatherapy", durationMinutes: 60, price: 40),
                Service(name: "Body scrub", durationMinutes: 45, price: 45),
                Service(name: "Mini facial", durationMinutes: 30, price: 35),
                Service(name: "Reflexology", durationMinutes: 45, price: 42)
            ]
        )
    ]

    static var bookings: [Booking] {
        guard businesses.count >= 2 else { return [] }
        let b0 = businesses[0]
        let b1 = businesses[1]
        return [
            Booking(
                business: b0,
                service: b0.services[0],
                date: Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date(),
                time: "10:00",
                status: .upcoming
            ),
            Booking(
                business: b1,
                service: b1.services[1],
                date: Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date(),
                time: "14:00",
                status: .past
            )
        ]
    }
}
