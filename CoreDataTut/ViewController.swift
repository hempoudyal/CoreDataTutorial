//
//  ViewController.swift
//  CoreDataTut
//
//  Created by Hem Poudyal on 12/5/18.
//  Copyright © 2018 Hem Poudyal. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    //var names: [String] = []
    var movies: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "The Movies"
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        //pull up the application delegate and grab a reference to its persistent container to on its NSManagedObjectContext.
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Movies")
        //NSFetchRequest is the class responsible for fetching from Core Data. Fetch requests are both powerful and flexible. You can use fetch requests to fetch a set of objects meeting the provided criteria
        
        //3
        do {
            movies = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }



    @IBAction func addName(_ sender: Any) {
        let alert = UIAlertController(title: "Movie Name",
                                      message: "Add a new movie name",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) {
                                        [unowned self] action in
                                        
                                        guard let textField = alert.textFields?.first,
                                            let nameToSave = textField.text else {
                                                return
                                        }
                                        
                                        //self.names.append(nameToSave)
                                        self.save(name: nameToSave)
                                        self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func save(name: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
           //You can consider a managed object context as an in-memory “scratchpad” for working with managed objects. Think of saving a new managed object to Core Data as a two-step process: first, you insert a new managed object into a managed object context; once you’re happy, you “commit” the changes in your managed object context to save it to disk.
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        //This default managed object context lives as a property of the NSPersistentContainer in the application delegate. To access it, you first get a reference to the app delegate.
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "Movies",
                                       in: managedContext)!
        //An entity description is the piece linking the entity definition from your Data Model with an instance of NSManagedObject at runtime.
        
        let movie = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 3
       movie.setValue(name, forKeyPath: "name") //if the key is not same it will crash
        
        // 4
        do { //save can throw error, so we are using try to catch the erroy
            try managedContext.save()
            movies.append(movie)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return names.count
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //cell.textLabel?.text = names[indexPath.row]
        let movie = movies[indexPath.row]
        cell.textLabel?.text = movie.value(forKeyPath: "name") as? String // KVC key value coding
        return cell
    }
    
}
