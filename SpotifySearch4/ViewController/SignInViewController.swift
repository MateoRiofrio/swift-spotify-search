//
//  SignInViewController.swift
//  SpotifySearch4
//
//  Created by Mateo Riofrio on 7/21/21.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var connectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sign in"
        self.view.backgroundColor = .systemBackground
        self.navigationItem.hidesBackButton = true
    }
    
    @IBAction private func buttonClicked(_ sender: Any) {
        let authViewController = AuthViewController()
        authViewController.completionHandler = { [weak self] (success) in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
        }
        self.navigationController?.pushViewController(authViewController, animated: true)
    }

    
    private func handleSignIn(success: Bool) {
        guard success else {
            let alert = UIAlertController(
                title: "Oops!",
                message: "Something went wrong",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel , handler: nil))
            present(alert, animated: true)
            return
        }
        performSegue(withIdentifier: "SignInToSearch", sender: self)
    }


}
