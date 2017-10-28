//
//  Next2ViewController.swift
//  ViewPagers_Example
//
//  Created by Steve on 28/10/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class Next2ViewController: TableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.items = [
            "next 2",
            "next 2",
            "next 2",
            "next 2",
            "next 2",
            "next 2",
            "next 2",
        ]
        self.tableView.reloadData()
    }
}
