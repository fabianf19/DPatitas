//
//  DogsTableViewController.swift
//  DPatitas
//
//  Created by Fabian Fuenmayor Macbook Pro on 2/5/18.
//  Copyright © 2018 FabianFuenmayor. All rights reserved.
//

import UIKit
import SwiftyJSON

class DogsTableViewController: UITableViewController, VCFinalDelegate {
    
    var dogs : [JSON?] = []
    var connector = Connector()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
//        self.loadDogs()
    }
    
    func loadDogs(){
        let usuario_string = UserDefaults.standard.string(forKey: "USUARIO")
        if let data = usuario_string!.data(using: .utf8) {
            if let usuario = try? JSON(data: data) {
                connector.doGet(url: "/user/\(usuario["id"].stringValue)/dogs") { (response : JSON) in
                    let dogs = response["Dogs"].arrayValue
                    
                    self.dogs = []
                    
                    for dog : JSON in dogs{
                        self.dogs.append(dog)
                    }
                    
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadDogs()
    }
    
    func finishPassing(dog: JSON) {
        self.dogs.append(dog)
        self.tableView.reloadData()
    }

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
        return self.dogs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DogTableViewCell

        let dog = self.dogs[indexPath.row]
//        cell.lbl_dog_name.text = dog!["data"]["name"].string
        cell.lbl_dog_name.text = dog!["nombre"].string
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78.0
    }
    
    @IBAction func unwindToDogs(segue:UIStoryboardSegue) { }

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
        if (segue.identifier == "registrar_perro"){
            let destinationController : RegisterDogViewController = segue.destination as! RegisterDogViewController;
            destinationController.delegate = self
        }else{
            if let indexPath = tableView.indexPathForSelectedRow{
                let selectedRow = indexPath.row
                let destinationController : SolicitWalkViewController = segue.destination as! SolicitWalkViewController
                destinationController.dog = self.dogs[selectedRow]
            }
            
        }
        
    }

}
