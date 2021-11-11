//
//  ProductManager.swift
//  TableViewApp
//
//  Created by Emil Rakhmangulov on 11.11.2021.
//

import Foundation

protocol ProductManagerDelegate {
    func didUpdateProduct(_ productManager: ProductManager, product: [ProductModel])
    func didFailWithError(error: Error)
}

struct ProductManager {
    let productURL = "http://62.109.7.98/api/product/category/"
    
    var delegate: ProductManagerDelegate?
    
    func fetchProduct(categoryId: Int) {
        let urlString = "\(productURL)\(categoryId)"
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
                    if let product = self.parseJSON(safeData) {
                        self.delegate?.didUpdateProduct(self, product: product)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ productData: Data) -> [ProductModel]? {
        let decoder = JSONDecoder()
        do {
            var array = [ProductModel]()
            let decodeData = try decoder.decode(ProductData.self, from: productData)
            let dataArray = decodeData.data
            for item in dataArray {
                let id = item.id
                let name = item.name
                let ccal = item.ccal
                let date = item.date
                let category_id = item.category_id
                let created_at = item.created_at
                let updated_at = item.updated_at
                
                let product = ProductModel(id: id, name: name, ccal: ccal, date: date, category_id: category_id, created_at: created_at, updated_at: updated_at)
                array.append(product)
            }
            return array
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
