//
//  ViewController.swift
//  ARSample2
//
//  Created by Nithin on 20/06/20.
//  Copyright © 2020 Nithin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    fileprivate var arOptions = ["Chair", "Sofa", "Table"]
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = arOptions[indexPath.row]
        
        tableView.tableFooterView = UIView(frame: .zero)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let arViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ARViewController") as? ARViewController {
            
            arViewController.arObject = arOptions[indexPath.row]
            navigationController?.pushViewController(arViewController, animated: true)
        }
    }
}
