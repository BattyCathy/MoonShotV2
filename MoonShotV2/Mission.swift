//
//  Mission.swift
//  MoonShotV2
//
//  Created by Austin Roach on 3/2/21.
//

import Foundation



struct Mission: Codable, Identifiable {
    struct CrewRole: Codable {
        let name: String
        let role: String
    }
    let id: Int
    let launchDate: String?
    let crew: [CrewRole]
    let description: String
}
