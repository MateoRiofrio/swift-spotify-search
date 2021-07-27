//
//  Search2ViewController.swift
//  SpotifySearch4
//
//  Created by Mateo Riofrio on 7/22/21.
//

import UIKit
import SwiftUI

class SearchViewController: UIHostingController<SearchView>{

    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: SearchView())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.hidesBackButton = true
        self.navigationItem.largeTitleDisplayMode = .always
        self.title = "Search"
        
    }

}

struct SearchViewController_Previews:
    PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
