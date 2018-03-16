//
//  RegistroTableViewController.swift
//  DPatitas
//
//  Created by Felipe Macbook Pro on 3/13/18.
//  Copyright © 2018 FabianFuenmayor. All rights reserved.
//

import UIKit
import SwiftyJSON

class RegistroTableViewController: UITableViewController {

    // Outlet
    @IBOutlet weak var txt_name: UITextField!
    @IBOutlet weak var txt_id: UITextField!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_pass: UITextField!
    @IBOutlet weak var switch_tipo: UISwitch!
    
    var connector = Connector()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        return 6
    }

    @IBAction func signUp(_ sender: Any) {
        // Obtener los datos del usuario de los campos
        let name = self.txt_name.text
        let cedula = self.txt_id.text
        let email = self.txt_email.text
        let password = self.txt_pass.text
        
        if (name == "" || cedula == "" || email == "" || password == ""){
            let alert = UIAlertController(title: "Alert", message: "Please complete all fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }else{
            let switch_value = self.switch_tipo.isOn
            
            // Redirigir a la seccion correspondiente
            var transicion = "";
            if (switch_value){
                transicion = "paseador"
            }else{
                transicion = "cliente"
            }
            
            let params = [
                "name" : name!,
                "cedula" : cedula!,
                "email" : email!,
                "rol" : transicion,
                "password" : password!
            ]
            
            connector.doPost(url: "/user", params: params, completion: { (response : JSON) in
                if (response["error"].exists()){
                    let alert = UIAlertController(title: "Alert", message: "The user already exists", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Accept", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                }else{
                    UserDefaults.standard.set(response.rawString(), forKey: "USUARIO")
                    UserDefaults.standard.synchronize()
                    
                    self.performSegue(withIdentifier: transicion, sender: nil)
                }
            })
            
//            self.performSegue(withIdentifier: transicion, sender: nil)
        }
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
