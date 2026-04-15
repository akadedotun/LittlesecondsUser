import SwiftUI

struct AccountView: View {
    @State private var notificationsEnabled = true

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Profile card
                    HStack(spacing: 14) {
                        Circle()
                            .fill(Color.brandDarkGreen)
                            .frame(width: 60, height: 60)
                            .overlay(
                                Text("AO")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.white)
                            )

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Alex Okafor")
                                .font(.system(size: 18, weight: .semibold))
                            Text("alex@email.com")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding(16)
                    .background(Color.cardWhite)
                    .cornerRadius(12)
                    .cardShadow()
                    .padding(.horizontal, 16)
                    .padding(.top, 8)

                    // Settings rows
                    VStack(spacing: 0) {
                        settingsRow(icon: "calendar", title: "My Bookings", showDivider: true) {}
                        settingsRow(icon: "creditcard", title: "Payment Methods", showDivider: true) {}

                        // Notifications row with toggle
                        HStack(spacing: 12) {
                            Image(systemName: "bell")
                                .font(.system(size: 16))
                                .foregroundColor(.brandDarkGreen)
                                .frame(width: 24)
                            Text("Notifications")
                                .font(.system(size: 16))
                            Spacer()
                            Toggle("", isOn: $notificationsEnabled)
                                .tint(.brandDarkGreen)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)

                        Divider().padding(.leading, 52)

                        settingsRow(icon: "questionmark.circle", title: "Help & Support", showDivider: false) {}
                    }
                    .background(Color.cardWhite)
                    .cornerRadius(12)
                    .cardShadow()
                    .padding(.horizontal, 16)

                    // Sign out
                    VStack(spacing: 0) {
                        Button {
                        } label: {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .font(.system(size: 16))
                                    .foregroundColor(.red)
                                    .frame(width: 24)
                                Text("Sign Out")
                                    .font(.system(size: 16))
                                    .foregroundColor(.red)
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                        }
                    }
                    .background(Color.cardWhite)
                    .cornerRadius(12)
                    .cardShadow()
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
            }
            .background(Color.backgroundGray)
            .navigationTitle("Account")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private func settingsRow(icon: String, title: String, showDivider: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(.brandDarkGreen)
                    .frame(width: 24)
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .overlay(alignment: .bottom) {
            if showDivider {
                Divider().padding(.leading, 52)
            }
        }
    }
}
