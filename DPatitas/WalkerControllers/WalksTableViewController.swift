//
//  WalksTableViewController.swift
//  DPatitas
//
//  Created by Fabian Fuenmayor Macbook Pro on 2/6/18.
//  Copyright © 2018 FabianFuenmayor. All rights reserved.
//

import UIKit
import SwiftWebSocket
import SwiftyJSON

class WalksTableViewController: UITableViewController, RequestManagerDelegate {
    var walks : [JSON?] = []
    
    var request_manager : RequestManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        request_manager = RequestManager(session : "1010211109")
        request_manager.delegate = self

    }
    
    func finishPassing(object: JSON) {
        if (object["action"].string! == "available_walks"){
            self.walks = object["data"].array!
            self.tableView.reloadData()
        }
    }

    @IBAction func unwindToWalks(segue:UIStoryboardSegue) { }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.walks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : DogTableViewCell = tableView.dequeueReusableCell(withIdentifier: "walk_cell", for: indexPath) as! DogTableViewCell

        // Configure the cell...
        let walk = self.walks[indexPath.row]
        cell.lbl_dog_name?.text = walk!["dog"]["nombre"].string

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let indexPath = tableView.indexPathForSelectedRow{
            let selectedRow = indexPath.row
            let destinationController : AcceptWalkViewController = segue.destination as! AcceptWalkViewController
            destinationController.walk = self.walks[selectedRow]
        }
    }

}
