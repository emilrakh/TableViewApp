//
//  ProductViewController.swift
//  TableViewApp
//
//  Created by Emil Rakhmangulov on 11.11.2021.
//

import UIKit

class ProductViewController: UITableViewController {
    
    var index: Int = 0
    var productsArray = [Product]()
    var productManager = ProductManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        productManager.delegate = self
        productManager.fetchProduct(categoryId: index)
    
    }

    //MARK: - TableView Datasource and  Delegate Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath)
        cell.textLabel?.text = productsArray[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDetail", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPathForSelectedRow
        let id = productsArray[indexPath!.row].id
        guard let detailViewController = segue.destination as?  DetailViewController else { return }
        detailViewController.index = id
    }
}

//MARK: - ProductViewController Delegate

extension ProductViewController: ProductManagerDelegate {
    func didUpdateProduct(_ productManager: ProductManager, product: [ProductModel]) {
        DispatchQueue.main.async {
            for item in product {
                self.productsArray.append(Product(id: item.id, name: item.name))
            }
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
