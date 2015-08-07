//
//  ViewController.swift
//  LinkedListDemo
//
//  Created by chen Yuheng on 15/8/7.
//  Copyright (c) 2015年 chen Yuheng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var test = LinkedList()
        test.createList()
        //test.showList()
        LinkedList.reverseShowList(test.head!.next!)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

