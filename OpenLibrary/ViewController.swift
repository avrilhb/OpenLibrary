//
//  ViewController.swift
//  OpenLibrary
//
//  Created by Avril  Hernández on 18/05/16.
//  Copyright © 2016 AHB. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

   
    @IBOutlet weak var isbn: UITextField!
    @IBOutlet weak var resultadoEtiqueta: UILabel!
    @IBOutlet weak var resultadoTextView: UITextView!
    @IBOutlet weak var btnClear: UIButton!
    
    func sincrono(isbn:String) {
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(isbn)"
        let url = NSURL(string: urls)
        let datos: NSData? = NSData(contentsOfURL: url!)
        
        /*if datos == nil{
            resultadoTextView.hidden = true
            let alert = UIAlertController(title: "Error", message: "No hay conexión a Internet", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
        }else if texto == "{}" {
            resultadoTextView.hidden = true
            let alert = UIAlertController(title: "Error", message: "Libro no encontrado.", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }else{
            resultadoTextView.hidden = false
            self.resultadoTextView.text = texto! as String
        }*/
        
        
        
        if datos == nil {
            resultadoTextView.hidden = true
            let alert = UIAlertController(title: "Error", message: "No hay conexión a Internet", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
        }else{
            let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
            if texto == "{}" {
                resultadoTextView.hidden = true
                let alert = UIAlertController(title: "Error", message: "Libro no encontrado.", preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
                alert.addAction(cancelAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }else{
                resultadoTextView.hidden = false
                self.resultadoTextView.text = texto! as String
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        resultadoTextView.hidden = true
        
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

