// ClaimView.swift
import SwiftUI
import PhotosUI
import Supabase
import Auth
import UIKit   // for UIImage/Data

struct ClaimView: View {
    // MARK: - Form state
    @State private var claimType: String = "Property Damage (Fire/Flood)"
    @State private var descriptionText: String = ""
    @State private var estimatedCostText: String = ""

    // Photos
    @State private var selectedPhotoItems: [PhotosPickerItem] = []
    @State private var selectedImages: [Image] = []

    // Insurance policies (multi-policy support)
    @State private var policies: [InsuranceProfile] = []
    @State private var selectedPolicyId: UUID? = nil

    // UI state
    @State private var isLoading: Bool = false
    @State private var statusMessage: String?
    @State private var statusColor: Color = .clear

    // Expanded list of claim types
    private let claimTypes = [
        "Property Damage (Fire/Flood)",
        "Property Damage (Water / Burst Pipe)",
        "Property Damage (Wind / Storm)",
        "Theft / Burglary",
        "Auto Accident",
        "Glass / Windshield Damage",
        "Liability (Injury on Property)",
        "Medical / Injury",
        "Travel / Trip Cancellation",
        "Other"
    ]

    @Environment(\.openURL) private var openURL

    // Convenience: currently selected policy
    private var selectedPolicy: InsuranceProfile? {
        guard let id = selectedPolicyId else { return nil }
        return policies.first(where: { $0.id == id })
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                Text("New Claim")
                    .font(.system(size: 28, weight: .bold))

                Text("Answer a few questions and we’ll package your info before you go to your insurer’s claim portal.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                // MARK: - Claim type
                VStack(alignment: .leading, spacing: 6) {
                    Text("Type of Claim")
                        .font(.footnote)
                        .foregroundColor(.secondary)

                    Picker("Claim Type", selection: $claimType) {
                        ForEach(claimTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }

                // Guidance box
                VStack(alignment: .leading, spacing: 8) {
                    Text("What you’ll need")
                        .font(.headline)
                    Text(requiredDocumentsText)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)

                // Description
                VStack(alignment: .leading, spacing: 6) {
                    Text("Describe what happened")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    TextEditor(text: $descriptionText)
                        .frame(minHeight: 100)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }

                // Estimated cost
                VStack(alignment: .leading, spacing: 6) {
                    Text("Estimated Cost (USD)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    TextField("e.g. 2500.00", text: $estimatedCostText)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }

                // Photos
                VStack(alignment: .leading, spacing: 6) {
                    Text("Attach Photos")
                        .font(.footnote)
                        .foregroundColor(.secondary)

                    PhotosPicker(
                        selection: $selectedPhotoItems,
                        maxSelectionCount: 5,
                        matching: .images
                    ) {
                        HStack {
                            Image(systemName: "photo.on.rectangle")
                            Text(selectedImages.isEmpty ? "Add photos" : "Add more photos")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                    .onChange(of: selectedPhotoItems) { oldItems, newItems in
                        Task {
                            await loadImages(from: newItems)
                        }
                    }

                    if !selectedImages.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(Array(selectedImages.enumerated()), id: \.offset) { _, image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 80, height: 80)
                                        .clipped()
                                        .cornerRadius(10)
                                }
                            }
                        }
                    }
                }

                // MARK: - Which insurance is this for?
                if !policies.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Which insurance is this claim for?")
                            .font(.footnote)
                            .foregroundColor(.secondary)

                        Picker("Insurance Policy", selection: $selectedPolicyId) {
                            ForEach(policies) { policy in
                                // Tag must match Picker selection type (UUID?)
                                Text("\(policy.insuranceType) – \(policy.insuranceName)")
                                    .tag(policy.id as UUID?)
                            }
                        }
                        .pickerStyle(.menu)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)

                        if let selectedPolicy {
                            Text("Member ID: \(selectedPolicy.memberId)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                } else {
                    Text("Add an insurance policy in the Insurance tab so you can link claims to specific coverage.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }

                // Save claim button
                Button {
                    Task {
                        await submitClaim()
                    }
                } label: {
                    if isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        Text("Save Claim")
                            .font(.system(size: 18, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(14)
                            .shadow(radius: 3, y: 2)
                    }
                }
                .disabled(isLoading || descriptionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

                // Status
                if let statusMessage {
                    Text(statusMessage)
                        .font(.footnote)
                        .foregroundColor(statusColor)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }

                Divider().padding(.vertical, 8)

                // MARK: - Link to insurer claim portal
                if let policy = selectedPolicy,
                   let urlString = policy.claimsUrl,
                   let url = URL(string: urlString) {

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Submit on your insurer’s website")
                            .font(.headline)
                        Text("When you’re ready, tap below to go to \(policy.insuranceName)’s claim page.")
                            .font(.footnote)
                            .foregroundColor(.secondary)

                        Button {
                            openURL(url)
                        } label: {
                            Text("Open \(policy.insuranceName) claim portal")
                                .font(.system(size: 16, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(.systemGray5))
                                .cornerRadius(12)
                        }
                    }
                } else {
                    Text("Add a claims website URL for each policy in the Insurance tab to enable quick access to your insurer’s portal.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Make a Claim")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadInsurancePolicies()
        }
    }

    // MARK: - Derived text per claim type

    private var requiredDocumentsText: String {
        switch claimType {
        case "Property Damage (Fire/Flood)":
            return "Photos of damage, incident date and location, any emergency service reports, repair estimates, and receipts for damaged items if available."
        case "Property Damage (Water / Burst Pipe)":
            return "Photos of water damage, plumber or contractor reports, incident date, and receipts or invoices for emergency repairs or mitigation."
        case "Property Damage (Wind / Storm)":
            return "Photos of roof or structural damage, weather event date, repair estimates, and any temporary repair receipts (tarps, boarding, etc.)."
        case "Theft / Burglary":
            return "Police report number, list of stolen items with approximate value, purchase receipts if available, and any photos or serial numbers."
        case "Auto Accident":
            return "Photos of all vehicles, police report number, driver and insurance details for everyone involved, repair estimates, and medical records if there were injuries."
        case "Glass / Windshield Damage":
            return "Close-up photos of the damage, full-car photos, date/location of incident, and any repair or replacement quotes."
        case "Liability (Injury on Property)":
            return "Date and location of incident, description of what happened, contact details for the injured person, any witness information, and medical or incident reports."
        case "Medical / Injury":
            return "Date of incident, provider or hospital name, diagnosis information, medical bills, receipts, and proof of any out-of-pocket costs."
        case "Travel / Trip Cancellation":
            return "Itinerary, proof of payment, airline or hotel communications, reason for cancellation, and any relevant receipts (taxis, hotels, etc.)."
        default:
            return "Describe what happened and attach any photos, receipts, or documents that help show what was lost, damaged, or interrupted."
        }
    }

    // MARK: - Supabase helpers

    /// Load all insurance policies for the current user
    private func loadInsurancePolicies() async {
        let client = SupabaseManager.shared.client

        do {
            guard let user = client.auth.currentUser else { return }

            let result: [InsuranceProfile] = try await client
                .from("insurance_profiles")
                .select()
                .eq("user_id", value: user.id)
                .execute()
                .value

            await MainActor.run {
                self.policies = result
                // Auto-select the first policy if none selected yet
                if self.selectedPolicyId == nil {
                    self.selectedPolicyId = result.first?.id
                }
            }
        } catch {
            print("Failed to load insurance policies:", error)
        }
    }

    private func submitClaim() async {
        statusMessage = nil
        statusColor = .clear
        isLoading = true
        defer { isLoading = false }

        let client = SupabaseManager.shared.client

        do {
            guard let user = client.auth.currentUser else {
                statusMessage = "You must be logged in to file a claim."
                statusColor = .red
                return
            }

            // If the user has policies, make sure one is selected
            if !policies.isEmpty && selectedPolicyId == nil {
                statusMessage = "Please select which insurance policy this claim is for."
                statusColor = .red
                return
            }

            // Parse cost
            var costValue: Double? = nil
            if !estimatedCostText.trimmingCharacters(in: .whitespaces).isEmpty {
                guard let parsed = Double(estimatedCostText.replacingOccurrences(of: ",", with: "")) else {
                    statusMessage = "Estimated cost must be a number (e.g. 2500.00)."
                    statusColor = .red
                    return
                }
                costValue = parsed
            }

            // 1) Upload images to Supabase Storage and collect URLs
            let photoUrls = await uploadImagesToSupabase(selectedPhotoItems)
            let urlsToStore: [String]? = photoUrls.isEmpty ? nil : photoUrls

            // 2) Build claim object
            let claim = Claim(
                id: nil,
                userId: user.id,
                insuranceProfileId: selectedPolicy?.id,  // 👈 link to whichever policy is chosen
                claimType: claimType,
                description: descriptionText,
                estimatedCost: costValue,
                photoUrls: urlsToStore
            )

            // 3) Save claim in Supabase
            try await client
                .from("claims")
                .insert(claim)
                .execute()

            statusMessage = "Claim saved in SafeClaim. You can now submit it on your insurer’s portal."
            statusColor = .green

        } catch {
            statusMessage = "Failed to save claim. \(error.localizedDescription)"
            statusColor = .red
        }
    }

    // Upload images to Supabase Storage and return their public URLs
    private func uploadImagesToSupabase(_ items: [PhotosPickerItem]) async -> [String] {
        var urls: [String] = []
        let client = SupabaseManager.shared.client

        for item in items {
            do {
                guard let data = try await item.loadTransferable(type: Data.self) else {
                    continue
                }

                let fileName = "\(UUID().uuidString).jpg"
                let path = "claims/\(fileName)"

                try await client.storage
                    .from("claim-photos")
                    .upload(
                        path,
                        data: data,
                        options: FileOptions(contentType: "image/jpeg")
                    )

                let publicURL = try client.storage
                    .from("claim-photos")
                    .getPublicURL(path: path)

                urls.append(publicURL.absoluteString)
            } catch {
                print("Failed to upload photo:", error)
            }
        }

        return urls
    }

    // Load images from PhotosPickerItems for on-screen preview
    private func loadImages(from items: [PhotosPickerItem]) async {
        selectedImages.removeAll()
        for item in items {
            if let data = try? await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                let image = Image(uiImage: uiImage)
                selectedImages.append(image)
            }
        }
    }
}

// ClaimView preview
struct ClaimView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ClaimView()
        }
    }
}
