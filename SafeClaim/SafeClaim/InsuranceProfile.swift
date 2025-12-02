// InsuranceProfile.swift
import Foundation

struct InsuranceProfile: Codable, Identifiable {
    let id: UUID?
    let userId: UUID
    var insuranceName: String
    var insuranceType: String
    var groupNumber: String
    var memberId: String
    var claimsUrl: String?   // URL to insurer's claims page

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case insuranceName = "insurance_name"
        case insuranceType = "insurance_type"
        case groupNumber = "group_number"
        case memberId = "member_id"
        case claimsUrl = "claims_url"
    }
}
