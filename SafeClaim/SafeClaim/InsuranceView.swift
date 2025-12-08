// InsuranceView.swift
import SwiftUI
import Supabase
import Auth

struct InsuranceProvider: Identifiable {
    let id = UUID()
    let name: String
    let claimsURL: String
}

struct InsuranceView: View {
    // Form fields
    @State private var insuranceName: String = ""
    @State private var insuranceType: String = "Health"
    @State private var groupNumber: String = ""
    @State private var memberId: String = ""
    @State private var claimsUrl: String = ""

    // Which policy are we editing (nil = creating a new one)
    @State private var editingPolicyId: UUID? = nil

    // All policies for this user
    @State private var policies: [InsuranceProfile] = []

    // UI state
    @State private var isLoading: Bool = false
    @State private var statusMessage: String?
    @State private var statusColor: Color = .clear

    // Picker sheet state
    @State private var showProviderPicker = false
    @State private var showTypePicker = false

    // Available insurance types
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

    // Common providers – extend this list as needed
    private let providers: [InsuranceProvider] = [
        .init(name: "Aetna",                     claimsURL: "https://www.aetna.com/"),
        .init(name: "Anthem Blue Cross",        claimsURL: "https://www.anthem.com/ca/claims/"),
        .init(name: "Blue Shield of California",claimsURL: "https://www.blueshieldca.com/claims"),
        .init(name: "Cigna",                    claimsURL: "https://www.cigna.com/claims"),
        .init(name: "Kaiser Permanente",        claimsURL: "https://healthy.kaiserpermanente.org/"),
        .init(name: "UnitedHealthcare",         claimsURL: "https://www.uhc.com/claims"),
        .init(name: "Humana",                   claimsURL: "https://www.humana.com/member/claims"),
        .init(name: "Delta Dental",             claimsURL: "https://www.deltadentalins.com/"),
        .init(name: "VSP Vision",               claimsURL: "https://www.vsp.com/claim"),
        .init(name: "Geico",                    claimsURL: "https://www.geico.com/claims/"),
        .init(name: "State Farm",               claimsURL: "https://www.statefarm.com/claims"),
        .init(name: "Progressive",              claimsURL: "https://www.progressive.com/claims/"),
        .init(name: "Allstate",                 claimsURL: "https://www.allstate.com/claims"),
        .init(name: "Liberty Mutual",           claimsURL: "https://www.libertymutual.com/claims-center"),
        .init(name: "USAA",                     claimsURL: "https://www.usaa.com/inet/wc/insurance-claims")
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                Text("Insurance Information")
                    .font(.system(size: 28, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 8)

                Text("Add and manage your insurance policies so SafeClaim can pre-fill details when you file a claim.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                // Saved policies list
                if !policies.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Saved Policies")
                            .font(.headline)

                        ForEach(policies) { policy in
                            Button {
                                loadForm(from: policy)
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("\(policy.insuranceType) – \(policy.insuranceName)")
                                            .font(.subheadline)
                                            .foregroundColor(.primary)

                                        Text(policy.memberId)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    if policy.id == editingPolicyId {
                                        Text("Editing")
                                            .font(.caption2)
                                            .foregroundColor(.orange)
                                    }
                                }
                                .padding(10)
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                            }
                        }
                    }
                }

                // New policy button
                Button {
                    startNewPolicy()
                } label: {
                    Label("Add New Insurance", systemImage: "plus.circle")
                        .font(.subheadline.weight(.semibold))
                }
                .padding(.top, policies.isEmpty ? 0 : 4)

                Divider().padding(.vertical, 4)

                Text(editingPolicyId == nil ? "New Insurance Policy" : "Edit Insurance Policy")
                    .font(.headline)

                // MARK: - Form fields
                VStack(spacing: 16) {

                    // Provider name + searchable dropdown
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Insurance Provider")
                            .font(.footnote)
                            .foregroundColor(.secondary)

                        HStack {
                            TextField("e.g. Blue Shield, Kaiser", text: $insuranceName)
                                .textInputAutocapitalization(.words)
                                .onChange(of: insuranceName) { oldValue, newValue in
                                    // If they type an exact provider name, auto-fill URL
                                    if let match = providers.first(where: {
                                        $0.name.compare(newValue, options: .caseInsensitive) == .orderedSame
                                    }) {
                                        claimsUrl = match.claimsURL
                                    }
                                }

                            Button {
                                showProviderPicker = true
                            } label: {
                                Image(systemName: "chevron.down.circle")
                                    .foregroundColor(.orange)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }

                    // Insurance type (searchable dropdown)
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Insurance Type")
                            .font(.footnote)
                            .foregroundColor(.secondary)

                        Button {
                            showTypePicker = true
                        } label: {
                            HStack {
                                Text(insuranceType)
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.down.circle")
                                    .foregroundColor(.orange)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }
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

                    // Claims URL (auto-filled but still editable)
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
                    Task { await saveInsurance() }
                } label: {
                    if isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        Text(editingPolicyId == nil ? "Save New Policy" : "Update Policy")
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
            await loadPolicies()
        }
        // Provider picker sheet
        .sheet(isPresented: $showProviderPicker) {
            ProviderPickerView(
                providers: providers,
                insuranceName: $insuranceName,
                claimsUrl: $claimsUrl
            )
        }
        // Type picker sheet
        .sheet(isPresented: $showTypePicker) {
            InsuranceTypePickerView(
                types: insuranceTypes,
                selection: $insuranceType
            )
        }
    }

    // MARK: - Helpers

    private func startNewPolicy() {
        editingPolicyId = nil
        insuranceName = ""
        insuranceType = "Health"
        groupNumber = ""
        memberId = ""
        claimsUrl = ""
        statusMessage = nil
        statusColor = .clear
    }

    private func loadForm(from profile: InsuranceProfile) {
        editingPolicyId = profile.id
        insuranceName = profile.insuranceName
        insuranceType = profile.insuranceType
        groupNumber = profile.groupNumber
        memberId = profile.memberId
        claimsUrl = profile.claimsUrl ?? ""
        statusMessage = nil
        statusColor = .clear
    }

    // MARK: - Supabase integration (unchanged logic, just multi-policy)

    private func loadPolicies() async {
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

            let result: [InsuranceProfile] = try await client
                .from("insurance_profiles")
                .select()
                .eq("user_id", value: user.id)
                .execute()
                .value

            await MainActor.run {
                self.policies = result
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.isLoading = false
                self.statusMessage = "Failed to load insurance. \(error.localizedDescription)"
                self.statusColor = .red
            }
        }
    }

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

            if let editingId = editingPolicyId {
                let updated = InsuranceProfile(
                    id: editingId,
                    userId: user.id,
                    insuranceName: insuranceName,
                    insuranceType: insuranceType,
                    groupNumber: groupNumber,
                    memberId: memberId,
                    claimsUrl: claimsUrl.isEmpty ? nil : claimsUrl
                )

                try await client
                    .from("insurance_profiles")
                    .update(updated)
                    .eq("id", value: editingId)
                    .execute()

                if let idx = policies.firstIndex(where: { $0.id == editingId }) {
                    policies[idx] = updated
                }

                statusMessage = "Policy updated."
                statusColor = .green
            } else {
                let newProfile = InsuranceProfile(
                    id: nil,
                    userId: user.id,
                    insuranceName: insuranceName,
                    insuranceType: insuranceType,
                    groupNumber: groupNumber,
                    memberId: memberId,
                    claimsUrl: claimsUrl.isEmpty ? nil : claimsUrl
                )

                let inserted: [InsuranceProfile] = try await client
                    .from("insurance_profiles")
                    .insert(newProfile)
                    .select()
                    .execute()
                    .value

                if let first = inserted.first {
                    policies.append(first)
                    editingPolicyId = first.id
                }

                statusMessage = "New policy saved."
                statusColor = .green
            }
        } catch {
            statusMessage = "Failed to save insurance. \(error.localizedDescription)"
            statusColor = .red
        }
    }
}


struct ProviderPickerView: View {
    @Environment(\.dismiss) private var dismiss

    let providers: [InsuranceProvider]
    @Binding var insuranceName: String
    @Binding var claimsUrl: String

    @State private var searchText: String = ""

    private var filteredProviders: [InsuranceProvider] {
        guard !searchText.isEmpty else { return providers }
        return providers.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredProviders) { provider in
                    Button {
                        insuranceName = provider.name
                        claimsUrl = provider.claimsURL
                        dismiss()
                    } label: {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(provider.name)
                            Text(provider.claimsURL)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Select Provider")
            .searchable(text: $searchText, prompt: "Search providers")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}


struct InsuranceTypePickerView: View {
    @Environment(\.dismiss) private var dismiss

    let types: [String]
    @Binding var selection: String

    @State private var searchText: String = ""

    private var filteredTypes: [String] {
        guard !searchText.isEmpty else { return types }
        return types.filter {
            $0.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredTypes, id: \.self) { type in
                    Button {
                        selection = type
                        dismiss()
                    } label: {
                        HStack {
                            Text(type)
                            if type == selection {
                                Spacer()
                                Image(systemName: "checkmark")
                                    .foregroundColor(.orange)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Insurance Type")
            .searchable(text: $searchText, prompt: "Search types")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
