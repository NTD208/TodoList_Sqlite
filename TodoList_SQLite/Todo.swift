//
//  Todo.swift
//  TodoList_SQLite
//
//  Created by Chu Du on 29/09/2021.
//

import Foundation
import FMDB

class Todo {
    var id:String
    var name:String
    
    init() {
        self.id = ""
        self.name = ""
    }
    
    init(resultSet: FMResultSet) {
        self.id = resultSet.string(forColumn: "id") ?? ""
        self.name = resultSet.string(forColumn: "name") ?? ""
    }
    
    func insertToDB() {
        let query = "insert into Todo (id, name) values ('\(id)', '\(name)')"
        _ = DBController.shared.excuteUpdate(query: query)
    }
        
    func delete() {
        let query = "delete from Todo where id = \(self.id)"
        _ = DBController.shared.excuteUpdate(query: query)
    }
    
    func saveUpdate() {
        let query = "update Todo set name = \(self.name) where id = \(self.id)"
        _ = DBController.shared.excuteUpdate(query: query)
    }
}
