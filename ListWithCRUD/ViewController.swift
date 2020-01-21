//
//  ViewController.swift
//  ListWithCRUD
//
//  Created by mobapp12 on 20/01/2020.
//  Copyright © 2020 H3AR7B3A7. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var items:[Idea] = [Idea]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        items = Repo.sharedInstance.getAllIdeas()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailsSegue"{
            // Find cell
            let cell = sender as! UITableViewCell
            // Where
            let indexPath = tableView.indexPath(for: cell)!
            // Fetch data
            let idea = items[indexPath.row]
            // Destination
            let detailsVC = segue.destination as! IdeaDetailViewController
            // Put data in idea
            detailsVC.ideaToUpdate = idea
        }
    }
}

extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentCell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        let currentIdea = items[indexPath.row]
        currentCell?.textLabel?.text = currentIdea.title
        
        return currentCell!
    }
}

extension ViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            // Find idea to delete
            let toDelete = items[indexPath.row]
            // Delete from Repo
            Repo.sharedInstance.deleteIdea(ideaToDelete: toDelete)
            // Delete from tableView
            items.remove(at: indexPath.row)
            // Animatie
            tableView.deleteRows(at: [indexPath], with: .middle)
        }
    }
}

extension ViewController:UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            items = Repo.sharedInstance.getAllIdeas()
        }else{
            items = Repo.sharedInstance.getIdeasByPartOfTitle(filter: searchText)
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
