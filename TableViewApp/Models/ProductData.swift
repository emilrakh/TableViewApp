//
//  ProductData.swift
//  TableViewApp
//
//  Created by Emil Rakhmangulov on 11.11.2021.
//

import Foundation

struct ProductData: Codable {
    let data: [ProdData]
}

struct ProdData: Codable {
    let id: Int
    let name: String
    let ccal: Int
    let date: String
    let category_id: Int
    let created_at: String
    let updated_at: String
}
