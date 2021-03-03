//
//  Mission.swift
//  MoonShotV2
//
//  Created by Austin Roach on 3/2/21.
//

import Foundation

struct CrewRole: Codable {
    let name: String
    let role: String
}

struct Mission: Codable, Identifiable {
    let id: Int
    let launchDate: String?
    let crew: [CrewRole]
    let description: String
}
