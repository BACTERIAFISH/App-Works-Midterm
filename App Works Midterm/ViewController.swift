//
//  ViewController.swift
//  App Works Midterm
//
//  Created by FISH on 2020/1/17.
//  Copyright © 2020 FISH. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let userProvider = UserProvider()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userProvider.getToken()
    }

}

