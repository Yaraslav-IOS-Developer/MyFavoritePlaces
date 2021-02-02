//
//  MainTableViewController.swift
//  MyFavoritePlaces
//
//  Created by Yaroslav on 2.02.21.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    let restaurantName = [
        "Burger Heroes", "Kitchen", "Bonsai",
        "Дастархан", "Индокитай", "X.O", "Балкан Гриль",
        "Sherlock Holmes", "Speak Easy", "Morris Pub",
        "Вкусные истории", "Классик", "Love&Life", "Шок", "Бочка"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return restaurantName.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        cell.textLabel?.text = restaurantName[indexPath.row]
        cell.imageView?.image = UIImage(named: restaurantName[indexPath.row])
        cell.imageView?.layer.cornerRadius = cell.frame.size.height / 2
        cell.imageView?.clipsToBounds = true
        
        return cell
    }
    
    // MARK: -  Table View Delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
