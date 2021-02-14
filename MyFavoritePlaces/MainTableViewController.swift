//
//  MainTableViewController.swift
//  MyFavoritePlaces
//
//  Created by Yaroslav on 2.02.21.
//

import UIKit
import RealmSwift

class MainTableViewController: UITableViewController {
    
    var places:  Results<Place>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        places = realm.objects(Place.self)

        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return places.isEmpty ? 0 : places.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as! CustomTableViewCell
        
        let place = places[indexPath.row]
        
        cell.nameLabel.text = place.name
        cell.locationLabel.text = place.location
        cell.typeLabel.text = place.type
        
        cell.imageOfPlace.image = UIImage(data: place.imageData!)
        
        cell.imageOfPlace.layer.cornerRadius = cell.imageOfPlace.frame.size.height / 2
        cell.imageOfPlace.clipsToBounds = true
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let place = places[indexPath.row]
        let deletAction = UITableViewRowAction(style: .default, title: "Delete") { (_, _) in
            
            StorageManager.deletObject(place)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return [deletAction]
    }
    

    
     // MARK: - Navigation

     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "swoDetails" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let place = places[indexPath.row]
            let newPlaceVC = segue.destination as! NewPlaceTableViewController
            newPlaceVC.currentPlace = place
        }
    }
    
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        
        guard let newPlaceVC = segue.source as? NewPlaceTableViewController else { return }
        newPlaceVC.savePlace()
        
        tableView.reloadData()
        
    }

}
