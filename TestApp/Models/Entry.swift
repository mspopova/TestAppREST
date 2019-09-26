//
//  Entry.swift
//  TestApp
//
//  Created by Марина Попова on 26/09/2019.
//  Copyright © 2019 Марина Попова. All rights reserved.
//

import Foundation

class Entry {
    var body: String
    var da: Date
    var dm: Date
    
    init(body: String, da: Date, dm: Date) {
        self.body = body
        self.da = da
        self.dm = dm
    }

}
