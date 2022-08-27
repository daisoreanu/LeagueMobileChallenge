//
//  UserResponse.swift
//  LeagueMobileChallenge
//
//  Created by Daisoreanu Laurentiu on 27.08.2022.
//

import Foundation

//{
//    "id": 1,
//    "avatar": "https://i.pravatar.cc/150?u=1",
//    "name": "Leanne Graham",
//    "username": "Bret",
//    "email": "Sincere@april.biz",
//    "address": {
//        "street": "Kulas Light",
//        "suite": "Apt. 556",
//        "city": "Gwenborough",
//        "zipcode": "92998-3874",
//        "geo": {
//            "lat": "-37.3159",
//            "lng": "81.1496"
//        }
//    },
//    "phone": "1-770-736-8031 x56442",
//    "website": "hildegard.org",
//    "company": {
//        "name": "Romaguera-Crona",
//        "catchPhrase": "Multi-layered...",
//        "bs": "harness real-time e-markets"
//    }
//}

struct UserResponse: Codable {
    let id: Int
    let avatar: String
    let name: String
    let username, email: String?
    let address: AddressResponse?
    let phone, website: String?
    let company: CompanyResponse?
}

// MARK: - Address
struct AddressResponse: Codable {
    let street, suite, city, zipcode: String?
    let geo: GeoResponse?
}

// MARK: - Geo
struct GeoResponse: Codable {
    let lat, lng: String?
}

// MARK: - Company
struct CompanyResponse: Codable {
    let name, catchPhrase, bs: String?
}
