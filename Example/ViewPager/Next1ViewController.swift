//
//  NextViewController.swift
//  ViewPagers_Example
//
//  Created by Steve on 28/10/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class Next1ViewController: TableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blue
        self.items = [
            "next 1",
            "next 1",
            "next 1",
            "next 1",
            "next 1",
            "next 1",
            "next 1",
        ]
        self.tableView.reloadData()
    }
}
