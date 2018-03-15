//
//  PokedexViewController.swift
//  Pokemon Go
//
//  Created by Steven Lerner on 3/14/18.
//  Copyright © 2018 Steven Lerner. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = "I LOVE POKEMON!"
        
        return cell
    }

    @IBAction func returnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
