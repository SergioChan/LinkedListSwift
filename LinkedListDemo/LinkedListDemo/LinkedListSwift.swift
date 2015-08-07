//
//  LinkedListSwift.swift
//  LinkedListDemo
//
//  Created by chen Yuheng on 15/8/7.
//  Copyright (c) 2015年 chen Yuheng. All rights reserved.
//

import Foundation

class LinkedList: NSObject {
    var data:AnyObject?
    var head:LinkedList?
    var next:LinkedList?
    
    /**
    建立链表
    */
    func createList() {
        self.head = LinkedList()
        self.next = nil
        var now = self.head!
        for var i=0;i<20;i++ {
            var node = LinkedList()
            node.data = i
            node.next = nil
            now.next = node
            now = node
        }
    }
    
    /**
    正序输出链表
    */
    func showList() {
        var now = self.head?.next
        while (now != nil){
            println(now?.data)
            now = now?.next
        }
    }
    
    /**
    逆序输出链表
    
    :param: now 链表表头的下一个元素地址
    */
    class func reverseShowList(now:LinkedList) {
        if (now.next != nil) {
            self.reverseShowList(now.next!)
        }
        println(now.data)
    }
}