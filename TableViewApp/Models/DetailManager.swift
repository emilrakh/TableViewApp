//
//  DetailManager.swift
//  TableViewApp
//
//  Created by Emil Rakhmangulov on 11.11.2021.
//

import Foundation

protocol DetailManagerDelegate {
    func didUpdateDetail(_ detailManager: DetailManager, detail: DetailModel)
    func didFailWithError(error: Error)
}

struct DetailManager {
    let detailURL = "http://62.109.7.98/api/product/"
    
    var delegate: DetailManagerDelegate?
    
    func fetchDetail(productId: Int) {
        let urlString = "\(detailURL)\(productId)"
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
                    if let detail = self.parseJSON(safeData) {
                        self.delegate?.didUpdateDetail(self, detail: detail)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ detailData: Data) -> DetailModel? {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(DetailData.self, from: detailData)
            let id = decodeData.data.id
            let name = decodeData.data.name
            let ccal = decodeData.data.ccal
            let date = decodeData.data.date
            let category_id = decodeData.data.category_id
            let created_at = decodeData.data.created_at
            let updated_at = decodeData.data.updated_at
            
            let detail = DetailModel(id: id, name: name, ccal: ccal, date: date, category_id: category_id, created_at: created_at, updated_at: updated_at)
            return detail
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
