//
//  WeakObjectContainer.swift
//  TBEmptyDataSet
//
//  Created by Zhu Shengqi on 6/20/16.
//  Copyright © 2016 Teambition. All rights reserved.
//

import Foundation

class WeakObjectContainer: NSObject {
    weak var object: AnyObject?

    init(object: AnyObject) {
        self.object = object
        super.init()
    }
}
