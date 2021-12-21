//
//  Tasks.swift
//  BucketList
//
//  Created by Shahad Nasser on 21/12/2021.
//

import Foundation

struct Task: Codable {
    let id: Int
    var objective: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case objective
        case createdAt = "created_at"
    }
}
