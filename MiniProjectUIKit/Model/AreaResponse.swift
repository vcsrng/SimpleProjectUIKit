//
//  AreaResponse.swift
//  MiniProjectUIKit
//
//  Created by Vincent Saranang on 07/12/24.
//

import Foundation

struct AreaResponse: Decodable {
    let meals: [Area]
}

struct Area: Decodable {
    let strArea: String
}
