//
//  Model.swift
//  IosTask
//
//  Created by Pawan Dhull on 15/06/21.
//

import Foundation

// MARK: - TaskModel
struct TaskModel: Codable {
    let success: Bool?
    let totalCount: Int?
    let message: String?
    let data: DataClass?

    enum CodingKeys: String, CodingKey {
        case success
        case totalCount = "total_count"
        case message, data
    }
}

// MARK: - DataClass
struct DataClass: Codable {
    let connections: [Connection]?
    let totalCount: Int?
}

// MARK: - Connection
struct Connection: Codable {
    let connectionID, inviterProviderID, inviteeProviderID, status: Int?
    let createdOn: String?
    let inviterProvider: JSONNull?
    let inviteeProvider: InviteeProvider?

    enum CodingKeys: String, CodingKey {
        case connectionID = "connectionId"
        case inviterProviderID = "inviterProviderId"
        case inviteeProviderID = "inviteeProviderId"
        case status, createdOn, inviterProvider, inviteeProvider
    }
}

// MARK: - InviteeProvider
struct InviteeProvider: Codable {
    let providerid: Int?
    let firstName, lastName: String?
    let middleName: String?
    let photoID: String?
    let title: String?
    let degrees: [Degree]?
    let licensure: [Licensure]?
    let offices: [Office]?
    let fullName, meetingUsername: String?
    let isOnlineNow: Bool?
    let user: User?

    enum CodingKeys: String, CodingKey {
        case providerid, firstName, lastName, middleName
        case photoID = "photoId"
        case title, degrees, licensure, offices, fullName, meetingUsername, isOnlineNow, user
    }
}

// MARK: - Degree
struct Degree: Codable {
    let id, providerID, completationYear: Int?
    let qualification, institute: String?
    let specializations: JSONNull?

    enum CodingKeys: String, CodingKey {
        case id
        case providerID = "providerId"
        case completationYear, qualification, institute, specializations
    }
}

// MARK: - Licensure
struct Licensure: Codable {
    let licensureID, providerID: Int?
    let addr: String?
    let specializations: String?
    let certificateType, professionalFocuses, practiceStyle: String?

    enum CodingKeys: String, CodingKey {
        case licensureID = "licensureId"
        case providerID = "providerId"
        case addr, specializations, certificateType, professionalFocuses, practiceStyle
    }
}

// MARK: - Office
struct Office: Codable {
    let oid, pgID: Int?
    let name, address: String?
    let address2: JSONNull?
    let city, stateCode: String?
    let stateID: Int?
    let zip: String?
    let website: JSONNull?
    let lat, lng: Int?
    let country, timeZone: String?
    let ownerUserID, isDeleted: Int?
    let appInterval, campaignPageURL: JSONNull?
    let denticonOID, placeOfServiceID: Int?
    let phone, email: JSONNull?
    let fullAddress, fullAddressWithoutCountry: String?

    enum CodingKeys: String, CodingKey {
        case oid
        case pgID = "pgId"
        case name, address, address2, city, stateCode, stateID, zip, website, lat, lng, country, timeZone
        case ownerUserID = "ownerUserId"
        case isDeleted, appInterval
        case campaignPageURL = "campaignPageUrl"
        case denticonOID = "denticonOid"
        case placeOfServiceID = "placeOfServiceId"
        case phone, email, fullAddress, fullAddressWithoutCountry
    }
}

// MARK: - User
struct User: Codable {
    let id: Int?
    let email: String?
    let userName, phone, firstName, lastName: JSONNull?
    let middleName: JSONNull?
    let createdOn: String?
    let pgid: Int?
    let roles, userSubscription, password, dateOfBirth: JSONNull?
    let envType: Int?
    let deviceID, osType, employer, address1: JSONNull?
    let address2, country, state, city: JSONNull?
    let zip: JSONNull?
    let fullName: String?

    enum CodingKeys: String, CodingKey {
        case id, email, userName, phone, firstName, lastName, middleName, createdOn, pgid, roles, userSubscription, password, dateOfBirth, envType
        case deviceID = "deviceId"
        case osType, employer, address1, address2, country, state, city, zip, fullName
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
