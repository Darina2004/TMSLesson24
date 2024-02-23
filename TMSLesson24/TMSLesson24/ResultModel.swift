//
//  ResultModel.swift
//  TMSLesson24
//
//  Created by Mac on 23.02.24.
//

import Foundation

struct ResultModel: Codable {
    let results: [CityDetails]
    
    struct CityDetails: Codable {
        let formatted: String
        let annotations: Annotations
        
        struct Annotations: Codable {
            let timezone: Timezone
            
            struct Timezone: Codable {
                let name: String
            }
        }
    }
}
