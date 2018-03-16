//
//  LoginViewController.swift
//  DPatitas
//
//  Created by Felipe Macbook Pro on 3/13/18.
//  Copyright © 2018 FabianFuenmayor. All rights reserved.
//

import UIKit
import SwiftyJSON

class LoginViewController: UIViewController {

    @IBOutlet weak var text_name: UITextField!
    @IBOutlet weak var text_passw: UITextField!
    
    @IBOutlet weak var switch_log: UISwitch!
    
    var connector = Connector()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(_ sender: Any) {
        // Obtener los valores de los outlets
        let name = self.text_name.text
        let pass = self.text_passw.text
        let isWalker = self.switch_log.isOn
        
        if ((name != "") && (pass != "")){
            var rol = ""
            
            if (isWalker){
                rol = "paseador"
            }else{
                rol = "cliente"
            }
            
            //Continue
            let params = [
                "email" : name!,
                "password" : pass!,
                "rol" : rol
            ]
            
            connector.doPost(url: "/login", params: params, completion: { (response : JSON) in
                if (response["error"].exists()){
                    let alert = UIAlertController(title: "Alert", message: "Incorrect username or password", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Accept", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                }else{
                    UserDefaults.standard.set(response.rawString(), forKey: "USUARIO")
                    UserDefaults.standard.synchronize()
                    
                    self.performSegue(withIdentifier: rol, sender: nil)
                }
            })
        }else{
            let alert = UIAlertController(title: "Alert", message: "Please complete all fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        
        // Conexion con al API
        
        // Redirigir segun la respuesta
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
