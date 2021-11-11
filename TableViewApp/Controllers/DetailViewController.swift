//
//  DetailViewController.swift
//  TableViewApp
//
//  Created by Emil Rakhmangulov on 11.11.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDate: UILabel!
    @IBOutlet weak var productCcal: UILabel!
    @IBOutlet weak var productCreatedAt: UILabel!
    @IBOutlet weak var productUpdatedAt: UILabel!
    
    var index: Int = 0
    var detailManager = DetailManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        detailManager.delegate = self
        detailManager.fetchDetail(productId: index)
    }
}

//MARK: - DetailViewController Delegate

extension DetailViewController: DetailManagerDelegate {
    func didUpdateDetail(_ detailManager: DetailManager, detail: DetailModel) {
        DispatchQueue.main.async {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
            
            self.title = "id: \(detail.id)"
            self.productImage.image = UIImage(named: "\(detail.id)")
            self.productName.text = detail.name
            self.productDate.text = "Date: \(detail.date)"
            self.productCcal.text = "Ccal: \(detail.ccal)"
            self.productCreatedAt.text = "Created at: \(formatter.date(from: detail.created_at)!.formatted())"
            self.productUpdatedAt.text = "Updated at: \(formatter.date(from: detail.updated_at)!.formatted())"
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - Date

extension Date {
    init(dateString:String) {
        self = Date.iso8601Formatter.date(from: dateString)!
    }

    static let iso8601Formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        return formatter
    }()
}

