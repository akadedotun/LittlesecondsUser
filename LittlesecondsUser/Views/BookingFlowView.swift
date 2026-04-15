import SwiftUI

struct BookingFlowView: View {
    let business: Business
    var onDismiss: () -> Void = {}

    @EnvironmentObject private var appState: AppState
    @State private var step: Int = 1
    @State private var selectedService: Service? = nil
    @State private var selectedDate: Date = Date()
    @State private var selectedTime: String? = nil
    @State private var confirmed: Bool = false

    private let timeSlots = ["9:00", "10:00", "11:00", "14:00", "15:00", "16:00"]

    // MARK: - Button state
    private var buttonTitle: String {
        switch step {
        case 1: return "Next"
        case 2: return "Next"
        default: return "Confirm Booking"
        }
    }

    private var buttonEnabled: Bool {
        switch step {
        case 1: return selectedService != nil
        case 2: return selectedTime != nil
        default: return true
        }
    }

    private func advanceStep() {
        switch step {
        case 1: if selectedService != nil { step = 2 }
        case 2: if selectedTime != nil { step = 3 }
        default:
            if let service = selectedService, let time = selectedTime {
                appState.addBooking(Booking(
                    business: business,
                    service: service,
                    date: selectedDate,
                    time: time,
                    status: .upcoming
                ))
            }
            confirmed = true
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Drag indicator
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.secondary.opacity(0.3))
                .frame(width: 40, height: 5)
                .padding(.top, 12)
                .padding(.bottom, 16)

            if confirmed {
                confirmationView
            } else {
                // Step indicator
                stepIndicator
                    .padding(.bottom, 20)

                // Scrollable content — padded so it never hides behind the button
                ScrollView {
                    Group {
                        if step == 1 { stepOne }
                        else if step == 2 { stepTwo }
                        else { stepThree }
                    }
                    .padding(.bottom, 90) // room for pinned button
                }

                // Pinned button
                CustomButton(buttonTitle, style: .primary, action: advanceStep)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    .opacity(buttonEnabled ? 1 : 0.5)
                    .disabled(!buttonEnabled)
            }
        }
        .background(Color.backgroundGray)
    }

    // MARK: - Step Indicator
    private var stepIndicator: some View {
        HStack(spacing: 8) {
            ForEach(1...3, id: \.self) { i in
                Circle()
                    .fill(i <= step ? Color.brandDarkGreen : Color.secondary.opacity(0.3))
                    .frame(width: 10, height: 10)
            }
        }
    }

    // MARK: - Step 1: Choose Service
    private var stepOne: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Choose a service")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.brandDarkGreen)
                .padding(.horizontal, 16)

            VStack(spacing: 12) {
                ForEach(business.services) { service in
                    ServiceRowView(
                        service: service,
                        isSelected: selectedService?.id == service.id,
                        onTap: { selectedService = service }
                    )
                }
            }
            .padding(.horizontal, 16)
        }
    }

    // MARK: - Step 2: Choose Date & Time
    private var stepTwo: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Choose date & time")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.brandDarkGreen)
                .padding(.horizontal, 16)

            weekStripPicker
                .padding(.horizontal, 16)

            VStack(alignment: .leading, spacing: 12) {
                Text("Available times")
                    .font(.system(size: 16, weight: .semibold))
                    .padding(.horizontal, 16)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(timeSlots, id: \.self) { slot in
                            let isSelected = selectedTime == slot
                            Text(slot)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(isSelected ? .white : .brandDarkGreen)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(isSelected ? Color.brandDarkGreen : Color.cardWhite)
                                .clipShape(Capsule())
                                .cardShadow()
                                .onTapGesture { selectedTime = slot }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
    }

    private var weekStripPicker: some View {
        let calendar = Calendar.current
        let today = Date()
        let weekDates = (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: today) }
        let dayFormatter: DateFormatter = {
            let f = DateFormatter()
            f.dateFormat = "EEE"
            return f
        }()
        let numFormatter: DateFormatter = {
            let f = DateFormatter()
            f.dateFormat = "d"
            return f
        }()

        return HStack(spacing: 8) {
            ForEach(weekDates, id: \.self) { date in
                let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)
                VStack(spacing: 4) {
                    Text(dayFormatter.string(from: date))
                        .font(.system(size: 11))
                        .foregroundColor(isSelected ? .white : .secondary)
                    Text(numFormatter.string(from: date))
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(isSelected ? .white : .primary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(isSelected ? Color.brandDarkGreen : Color.cardWhite)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .cardShadow()
                .onTapGesture { selectedDate = date }
            }
        }
    }

    // MARK: - Step 3: Confirm
    private var stepThree: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Confirm booking")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.brandDarkGreen)
                .padding(.horizontal, 16)

            summaryCard
                .padding(.horizontal, 16)
        }
    }

    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            summaryRow(label: "Business", value: business.name)
            Divider()
            summaryRow(label: "Service", value: selectedService?.name ?? "-")
            Divider()
            summaryRow(label: "Date", value: formattedDate)
            Divider()
            summaryRow(label: "Time", value: selectedTime ?? "-")
            Divider()
            summaryRow(label: "Price", value: selectedService?.priceText ?? "-")
        }
        .padding(16)
        .background(Color.cardWhite)
        .cornerRadius(12)
        .cardShadow()
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

    private var formattedDate: String {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f.string(from: selectedDate)
    }

    // MARK: - Confirmation
    private var confirmationView: some View {
        VStack(spacing: 0) {
            // Content pinned to top
            VStack(spacing: 20) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 72))
                    .foregroundColor(.brandDarkGreen)
                    .padding(.top, 24)

                Text("Booking Confirmed!")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.brandDarkGreen)

                summaryCard
                    .padding(.horizontal, 16)
            }
            .frame(maxWidth: .infinity, alignment: .top)

            Spacer()

            // Button pinned to bottom
            CustomButton("Done", style: .primary) {
                onDismiss()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
    }
}
