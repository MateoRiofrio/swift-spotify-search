//
//  MainViewController.swift
//  SpotifySearch4
//
//  Created by Mateo Riofrio on 7/21/21.
//

import UIKit


/* View Controller that decides which screen to start on */

class MainViewController: UIViewController {
    
    public var completionHandler: ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        AuthManager.shared.refreshTokenIfNeeded { _ in }
        if (AuthManager.shared.isSignedIn) {
            performSegue(withIdentifier: "MainToSearch", sender:self)
        }
        else {
            performSegue(withIdentifier: "MainToSignIn", sender: self)
        }
    
        
    }
    
    
}
