// Claim.swift
import Foundation

struct Claim: Codable, Identifiable {
    let id: UUID?
    let userId: UUID
    let insuranceProfileId: UUID?
    var claimType: String
    var description: String
    var estimatedCost: Double?
    var photoUrls: [String]?    // URLs to images in Storage

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case insuranceProfileId = "insurance_profile_id"
        case claimType = "claim_type"
        case description
        case estimatedCost = "estimated_cost"
        case photoUrls = "photo_urls"
    }
}
