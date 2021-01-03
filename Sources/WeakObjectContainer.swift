//
//  WeakObjectContainer.swift
//  TBEmptyDataSet
//
//  Created by Xin Hong on 2016/11/4.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import UIKit

class WeakObjectContainer: NSObject {
    weak var object: AnyObject?

    init(object: Any) {
        super.init()
        self.object = object as AnyObject
    }
}
