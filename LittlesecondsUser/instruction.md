Cursor Prompt — Littleseconds Consumer iOS App
Build a SwiftUI iOS app called Littleseconds. This is the consumer-facing booking app for beauty and wellness businesses. Match the design language of the existing business-side app exactly.

Design system — apply everywhere:
swiftlet brandDarkGreen = Color(red: 0.08, green: 0.20, blue: 0.04)
let backgroundGray = Color(UIColor.systemGroupedBackground) // light grey page bg
let cardWhite = Color(UIColor.systemBackground)

Cards: white background, 12pt corner radius, subtle shadow (shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2))
Primary button: dark green fill, white SF Pro Semibold text, 14pt corner radius, full width, 54pt height — match the CustomButton.primary pattern from the existing code
Input fields: 12pt rounded stroke, Color.gray.opacity(0.6) border, 16pt internal padding — match EmailSignupView exactly
Section headers: SF Pro Semibold 20pt, brandDarkGreen
Body text: SF Pro Regular 16pt, .secondary
Page background: backgroundGray throughout
Tab bar: 4 tabs using SF Symbols, plain style, brandDarkGreen tint for selected state
Spacing: 16pt horizontal page padding throughout, 12pt between cards


App structure — Tab bar with 4 tabs:

Discover (magnifyingglass)
Bookings (calendar)
Saved (heart)
Account (person)


Tab 1 — DiscoverView

Page background: backgroundGray
Top: greeting label "Good morning, Alex" in SF Pro Semibold 22pt, brandDarkGreen
Search bar below: rounded rectangle, gray border, placeholder "Search salons, spas, barbers..."
Horizontal scrollable category chips below search: All · Salons · Spas · Barbers. Selected chip: brandDarkGreen fill, white text. Unselected: white fill, dark green text, green border
Location row: SF Symbol location.fill in brandDarkGreen + "Near Chelmsford, Essex" in gray 14pt
Section header "Near you" with a "See all" link in brandDarkGreen
Vertical list of BusinessCardView components

BusinessCardView:

White card, 12pt radius, subtle shadow
Top: solid colour rectangle placeholder (120pt height) with category label pill overlaid bottom-left (brandDarkGreen bg, white text, 8pt radius)
Body padding 12pt: Business name (SF Pro Semibold 17pt, brandDarkGreen), rating row (⭐ + score + review count in gray), distance in gray
Bottom row: price from label left-aligned ("From £20"), "Book" button right-aligned — dark green pill button, white text, compact size


BusinessDetailView (pushed from BusinessCardView):

Navigation bar title: business name, brandDarkGreen tint
Large header image placeholder (200pt solid colour rectangle)
White card below with: name, category chip, star rating + review count, distance
Divider
"About" section: 2-line description paragraph
"Services" section header
List of ServiceRowView — white card per service showing: service name (semibold), duration in gray, price right-aligned in brandDarkGreen
"Book Now" button pinned to bottom, full width, CustomButton.primary style


BookingFlowView (sheet, 3 steps):
Presented as a bottom sheet with a drag indicator. Step indicator at top (3 dots, active = brandDarkGreen).
Step 1 — Choose a service

List of ServiceRowView cards, tappable — selected state adds brandDarkGreen border and a checkmark

Step 2 — Choose date and time

Compact week strip date picker (Mon–Sun row, selected date = brandDarkGreen rounded square — match business app calendar style exactly)
"Available times" section below: horizontal scroll of time slot chips. Available: white card with dark green text. Selected: brandDarkGreen fill, white text. Hardcoded slots: 9:00, 10:00, 11:00, 14:00, 15:00, 16:00

Step 3 — Confirm

Summary card (white, 12pt radius): business name, service, date, time, price
"Confirm Booking" primary button

Confirmation screen:

Centred layout: checkmark.circle.fill SF Symbol in brandDarkGreen at 64pt, "Booking Confirmed" heading, summary details, "Done" button


Tab 2 — BookingsView

Segmented control: Upcoming / Past
Each booking shown as a white card: coloured left border strip (use brandDarkGreen), business name semibold, service name gray, date/time gray, "Cancel" button as a destructive outlined pill (red border, red text, compact)
Empty state: centered illustration placeholder + "No bookings yet" label


Tab 3 — SavedView

Grid (2 columns) of saved BusinessCardView cards
Empty state: heart SF Symbol + "Save businesses you love"


Tab 4 — AccountView

Top section white card: circle avatar with initials "AO", name "Alex Okafor", email "alex@email.com"
Rows in grouped list style (match iOS Settings aesthetic):

My Bookings
Payment Methods
Notifications (with toggle)
Help & Support
Sign Out (red, destructive)




SampleData.swift — hardcoded businesses:
1. Luxe Hair Studio — Salon — 4.9 · 210 reviews — 0.3 miles — from £30
   Services: Blow dry (45 min, £30), Highlights (90 min, £85), Cut & style (60 min, £55), Hair treatment (30 min, £40)

2. The Barbershop Co. — Barber — 4.7 · 98 reviews — 0.6 miles — from £15
   Services: Fade (30 min, £15), Beard trim (20 min, £12), Cut & beard (45 min, £25), Hot towel shave (30 min, £20)

3. Serenity Spa — Spa — 4.8 · 156 reviews — 1.1 miles — from £45
   Services: Swedish massage (60 min, £45), Deep tissue (60 min, £55), Facial (45 min, £50), Couples massage (90 min, £120)

4. Curl & Co. — Salon — 4.6 · 74 reviews — 0.8 miles — from £35
   Services: Wash & go (45 min, £35), Twist out (60 min, £50), Trim (30 min, £25), Deep condition (45 min, £40)

5. Fade Kings — Barber — 4.9 · 312 reviews — 0.2 miles — from £18
   Services: Skin fade (35 min, £18), Line up (20 min, £12), Full cut (45 min, £22), Kid's cut (30 min, £14)

6. Bloom Wellness — Spa — 4.7 · 189 reviews — 1.4 miles — from £40
   Services: Aromatherapy (60 min, £40), Body scrub (45 min, £45), Mini facial (30 min, £35), Reflexology (45 min, £42)

File structure:
Littleseconds/
  Models/
    Business.swift
    Service.swift
    Booking.swift
  Data/
    SampleData.swift
  Components/
    BusinessCardView.swift
    ServiceRowView.swift
    CustomButton.swift
  Views/
    DiscoverView.swift
    BusinessDetailView.swift
    BookingFlowView.swift
    BookingsView.swift
    SavedView.swift
    AccountView.swift
  LittlesecondsApp.swift