//
//  ViewController.swift
//  TableViewApp
//
//  Created by Emil Rakhmangulov on 11.11.2021.
//

import UIKit

class CategoryViewController: UITableViewController {
    
    var categoriesArray = [Category]()
    var categoryManager = CategoryManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        categoryManager.delegate = self
        categoryManager.fetchCategory()
    }
    
    //MARK: - TableView Delegate and Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoriesArray[indexPath.row].name
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToProduct", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPathForSelectedRow
        let id = categoriesArray[indexPath!.row].id
        guard let productViewController = segue.destination as?  ProductViewController else { return }
        productViewController.index = id
    }
}

//MARK: - CategoryViewController Delegate

extension CategoryViewController: CategoryManagerDelegate {
    func didUpdateCategory(_ categoryManager: CategoryManager, category: [CategoryModel]) {
        DispatchQueue.main.async {
            for item in category {
                self.categoriesArray.append(Category(id: item.id, name: item.name))
            }
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
