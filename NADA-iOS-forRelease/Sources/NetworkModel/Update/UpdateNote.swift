//
//  UpdateNote.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2023/04/05.
//

import Foundation

struct UpdateNote: Codable {
    let text: String
    let isForce: Bool
    let latestVersion: String
}
