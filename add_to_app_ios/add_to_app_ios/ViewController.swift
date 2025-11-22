//
//  ViewController.swift
//  add_to_app_ios
//
//  Created by tri_phan_dev on 7/7/24.
//

import UIKit
import Flutter
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func openFlutter(_ sender: Any) {
        let flutterEngine = (UIApplication.shared.delegate as! AppDelegate).flutterEngine
            let flutterViewController =
                FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
            present(flutterViewController, animated: true, completion: nil)
    }
    
}

