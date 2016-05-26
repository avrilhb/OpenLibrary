//
//  ViewController.swift
//  OpenLibrary
//
//  Created by Avril  Hernández on 18/05/16.
//  Copyright © 2016 AHB. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var isbn: UITextField!
    @IBOutlet weak var tituloLabel: UILabel!
    @IBOutlet weak var autoresLabel: UILabel!
    @IBOutlet weak var portadaView: UIImageView!
    
    func sincrono(isbn:String) {
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(isbn)"
        let url = NSURL(string: urls)
        let datos: NSData? = NSData(contentsOfURL: url!)
        
        if datos == nil {
            tituloLabel.hidden = true
            autoresLabel.hidden = true
            portadaView.hidden = true
            
            let alert = UIAlertController(title: "Error", message: "No hay conexión a Internet", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
        }else{
            let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
            if texto == "{}" {
                tituloLabel.hidden = true
                autoresLabel.hidden = true
                portadaView.hidden = true
                
                let alert = UIAlertController(title: "Error", message: "Libro no encontrado.", preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
                alert.addAction(cancelAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }else{
                
                do{
                    tituloLabel.hidden = false
                    
                    let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                    
                    let isbnJson = json as! NSDictionary
                    let isbnQuery = isbnJson["ISBN:\(isbn)"] as! NSDictionary
                    let autores = isbnQuery["authors"] as! [NSDictionary]
                    let portada = isbnQuery["cover"] as! NSDictionary?
                    
                    if portada == nil{
                        portadaView.hidden = true
                    }else{
                        let portadaMedium = portada!["medium"] as! NSString as String
                        
                        if let url  = NSURL(string: portadaMedium),
                            data = NSData(contentsOfURL: url)
                        {
                            portadaView.hidden = false
                            portadaView.image = UIImage(data: data)
                        }
                    }
                    
                    self.tituloLabel.text = isbnQuery["title"] as! NSString as String
                    var autoresString = ""
                    for autor in autores{
                        if autoresString == ""{
                            autoresString += autor["name"] as! NSString as String
                        }else{
                            autoresString += ", "
                            autoresString += autor["name"] as! NSString as String
                        }
                    }
                    if autoresString == ""{
                        autoresLabel.hidden = true
                    }else{
                        autoresLabel.hidden = false
                        self.autoresLabel.text = autoresString
                    }
                    
                }catch _{

                
                }

            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tituloLabel.hidden = true
        autoresLabel.hidden = true
        portadaView.hidden = true
        isbn.clearButtonMode = UITextFieldViewMode.Always
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func textFieldDoneEditing(sender: AnyObject) {
        sender.resignFirstResponder() //Desaparecer el teclado
        sincrono(isbn.text!)
        
    }
    @IBAction func clear(sender: AnyObject) {
    }
}

