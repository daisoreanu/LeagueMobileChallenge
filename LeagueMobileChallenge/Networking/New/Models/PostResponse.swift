//
//  PostResponse.swift
//  LeagueMobileChallenge
//
//  Created by Daisoreanu Laurentiu on 27.08.2022.
//

import Foundation

//{
//    "userId": 3,
//    "id": 26,
//    "title": "est et quae odit qui non",
//    "body": "similique esse doloribus nihil ..."
//}

struct PostResponse: Decodable {
    var id: Int
    var userId: Int
    var title: String
    var body: String
}
