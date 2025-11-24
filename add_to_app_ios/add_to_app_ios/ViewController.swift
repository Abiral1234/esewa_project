//
//  ViewController.swift
//  add_to_app_ios
//

import UIKit
import Flutter

class ViewController: UIViewController {

    lazy var flutterEngine = (UIApplication.shared.delegate as? AppDelegate)?.flutterEngine


    // MARK: - Outlets
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var themeSwitch: UISwitch!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var txtEmail: UITextField!      // << connect this
    @IBOutlet weak var txtPassword: UITextField!   // << connect this

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set initial label text based on switch state
        themeLabel?.text = themeSwitch?.isOn ?? false ? "Dark Theme" : "Light Theme"
        
        // Style the login button
        loginButton?.backgroundColor = UIColor.systemBlue
        loginButton?.setTitleColor(.white, for: .normal)
        loginButton?.layer.cornerRadius = 20
        loginButton?.clipsToBounds = true
    }

    // MARK: - Validate Email
    func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }

    // MARK: - Show Alert
    func showAlert(_ title: String, _ msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    // MARK: - Switch Toggle Action
    @IBAction func themeSwitchChanged(_ sender: UISwitch) {
        themeLabel?.text = sender.isOn ? "Dark Theme" : "Light Theme"
    }

    // MARK: - Login Button Action
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        let email = txtEmail.text ?? ""
        let password = txtPassword.text ?? ""

        // Empty fields check
        if email.isEmpty || password.isEmpty {
            showAlert("Missing Fields", "Please enter both email and password.")
            return
        }

        // Email format validation
        else if !isValidEmail(email) {
            showAlert("Invalid Email", "Please enter a valid email address.")
            return
        }

        // Password strength validation
        else if password.count < 6 {
            showAlert("Weak Password", "Password must be at least 6 characters.")
            return
        }
        else{
            openFlutter(sender)
        }

        // If everything is valid → go to Flutter
        
    }

    // MARK: - Flutter Navigation
   @IBAction func openFlutter(_ sender: Any) {
    guard let flutterEngine = flutterEngine else {
        print("Flutter engine not found!")
        return
    }

    let flutterVC = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)

    // CHANNEL from Native → Flutter
    let navChannel = FlutterMethodChannel(
        name: "com.example.app/navChannel",
        binaryMessenger: flutterVC.binaryMessenger
    )

    // CHANNEL from Flutter → Native
    let payChannel = FlutterMethodChannel(
        name: "com.example.app/payChannel",
        binaryMessenger: flutterVC.binaryMessenger
    )

    // Listen for Flutter "pay" event
    payChannel.setMethodCallHandler { [weak flutterVC] call, result in
        if call.method == "payButtonPressed" {
            flutterVC?.dismiss(animated: true)
            result("Returned to iOS Native")
        }
    }

    // Prepare data to send to Flutter
    let theme = themeSwitch.isOn ? "dark" : "light"
    let uuid = UUID().uuidString
    let email = txtEmail.text ?? ""

    let userData: [String: Any] = [
        "uuid": uuid,
        "theme": theme,
        "email": email
    ]

    // Send initial login data to Flutter
    navChannel.invokeMethod("loginData", arguments: userData)

    present(flutterVC, animated: true)
}

}
