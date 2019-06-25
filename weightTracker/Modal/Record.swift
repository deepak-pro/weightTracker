//
//  Record.swift
//  weightTracker
//
//  Created by Deepak on 25/06/19.
//  Copyright © 2019 Deepak. All rights reserved.
//

import Foundation
import RealmSwift

class Record : Object {
    @objc dynamic var id = 0
    @objc dynamic var date : Date?
    @objc dynamic var weight : Double = 0
}
