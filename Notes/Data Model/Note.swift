//
//  Note.swift
//  Notes
//
//  Created by Iliyas Shakhabdin on 21.04.2024.
//

import Foundation
import RealmSwift

class Note: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var content: String = ""
    @objc dynamic var dateCreated: Date?
}
