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
        self.id = resultSet.string(forColumn: "Id") ?? ""
        self.name = resultSet.string(forColumn: "Name") ?? ""
    }
    
    func insertToDB() {
        let query = "insert into Todo (Id, Name) values ('\(id)', '\(name)')"
        _ = DBController.shared.excuteUpdate(query: query)
    }
        
    func delete() {
        let query = "delete from Todo where Id = \(self.id)"
        _ = DBController.shared.excuteUpdate(query: query)
    }
    
    func saveUpdate() {
        let query = "update Todo set Name = \(self.name) where Id = \(self.id)"
        _ = DBController.shared.excuteUpdate(query: query)
    }
}
