//
//  CategoryData.swift
//  TableViewApp
//
//  Created by Emil Rakhmangulov on 11.11.2021.
//

import Foundation

struct CategoryData: Codable {
    let data: [CatData]
}

struct CatData: Codable {
    let id: Int
    let name: String
    let unit: String
    let count: Int
}
