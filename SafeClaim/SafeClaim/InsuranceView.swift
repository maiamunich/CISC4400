// InsuranceView.swift
import SwiftUI
import Supabase
import Auth

struct InsuranceView: View {
    // Form fields
    @State private var insuranceName: String = ""
    @State private var insuranceType: String = "Health"
    @State private var groupNumber: String = ""
    @State private var memberId: String = ""
    @State private var claimsUrl: String = ""

    // UI state
    @State private var isLoading: Bool = false
    @State private var statusMessage: String?
    @State private var statusColor: Color = .clear

    // Available insurance types for dropdown
    private let insuranceTypes = [
        "Health",
        "Dental",
        "Vision",
        "Auto",
        "Home",
        "Renters",
        "Life",
        "Other"
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                Text("Insurance Information")
                    .font(.system(size: 28, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 8)

                Text("Add your insurance information so SafeClaim can pre-fill details when you file a claim.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                // Form fields
                VStack(spacing: 16) {

                    // Insurance name
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Insurance Name")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        TextField("e.g. Blue Shield, Kaiser", text: $insuranceName)
                            .textInputAutocapitalization(.words)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }

                    // Insurance type (dropdown)
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Insurance Type")
                            .font(.footnote)
                            .foregroundColor(.secondary)

                        Picker("Insurance Type", selection: $insuranceType) {
                            ForEach(insuranceTypes, id: \.self) { type in
                                Text(type).tag(type)
                            }
                        }
                        .pickerStyle(.menu)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }

                    // Group number
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Group Number")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        TextField("Group ID / Plan number", text: $groupNumber)
                            .textInputAutocapitalization(.never)
                            .autocapitalization(.none)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }

                    // Member ID
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Member ID")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        TextField("Member ID", text: $memberId)
                            .textInputAutocapitalization(.never)
                            .autocapitalization(.none)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }

                    // Claims URL
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Claims Website URL")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        TextField("https://your-insurer.com/claims", text: $claimsUrl)
                            .keyboardType(.URL)
                            .textInputAutocapitalization(.never)
                            .autocapitalization(.none)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }
                }

                // Save button
                Button {
                    Task {
                        await saveInsurance()
                    }
                } label: {
                    if isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        Text("Save Insurance")
                            .font(.system(size: 18, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(14)
                            .shadow(radius: 3, y: 2)
                    }
                }
                .disabled(isLoading || insuranceName.isEmpty)
                .padding(.top, 8)

                // Status message
                if let statusMessage {
                    Text(statusMessage)
                        .font(.footnote)
                        .foregroundColor(statusColor)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Insurance")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadInsurance()
        }
    }

    // MARK: - Supabase integration

    /// Load the current user's existing insurance (if any)
    private func loadInsurance() async {
        isLoading = true
        statusMessage = nil

        let client = SupabaseManager.shared.client

        do {
            guard let user = client.auth.currentUser else {
                statusMessage = "You must be logged in to load insurance info."
                statusColor = .red
                isLoading = false
                return
            }

            let profiles: [InsuranceProfile] = try await client
                .from("insurance_profiles")
                .select()
                .eq("user_id", value: user.id)
                .limit(1)
                .execute()
                .value

            if let profile = profiles.first {
                insuranceName = profile.insuranceName
                insuranceType = profile.insuranceType
                groupNumber = profile.groupNumber
                memberId = profile.memberId
                claimsUrl = profile.claimsUrl ?? ""
            }

            isLoading = false
        } catch {
            isLoading = false
            statusMessage = "Failed to load insurance. \(error.localizedDescription)"
            statusColor = .red
        }
    }

    /// Insert or update the current user's insurance info
    private func saveInsurance() async {
        statusMessage = nil
        statusColor = .clear
        isLoading = true
        defer { isLoading = false }

        let client = SupabaseManager.shared.client

        do {
            guard let user = client.auth.currentUser else {
                statusMessage = "You must be logged in to save insurance info."
                statusColor = .red
                return
            }

            let profile = InsuranceProfile(
                id: nil,
                userId: user.id,
                insuranceName: insuranceName,
                insuranceType: insuranceType,
                groupNumber: groupNumber,
                memberId: memberId,
                claimsUrl: claimsUrl.isEmpty ? nil : claimsUrl
            )

            try await client
                .from("insurance_profiles")
                .upsert(profile, onConflict: "user_id")
                .execute()

            statusMessage = "Insurance information saved."
            statusColor = .green
        } catch {
            statusMessage = "Failed to save insurance. \(error.localizedDescription)"
            statusColor = .red
        }
    }
}

struct InsuranceView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            InsuranceView()
        }
    }
}
