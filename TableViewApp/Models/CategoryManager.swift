//
//  CategoryManager.swift
//  TableViewApp
//
//  Created by Emil Rakhmangulov on 11.11.2021.
//

import Foundation

protocol CategoryManagerDelegate {
    func didUpdateCategory(_ categoryManager: CategoryManager, category: [CategoryModel])
    func didFailWithError(error: Error)
}

struct CategoryManager {
    let categoryURL = "http://62.109.7.98/api/categories"
    
    var delegate: CategoryManagerDelegate?
    
    func fetchCategory() {
        let urlString = "\(categoryURL)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString:String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, responce, error) in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let category = self.parseJSON(safeData) {
                        self.delegate?.didUpdateCategory(self, category: category)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ categoryData: Data) -> [CategoryModel]? {
        let decoder = JSONDecoder()
        do {
            var array = [CategoryModel]()
            let decodeData = try decoder.decode(CategoryData.self, from: categoryData)
            let dataArray = decodeData.data
            for item in dataArray {
                let id = item.id
                let name = item.name
                let unit = item.unit
                let count = item.count
                
                let category = CategoryModel(id: id, name: name, unit: unit, count: count)
                array.append(category)
            }
            return array
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
