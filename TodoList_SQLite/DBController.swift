//
//  DBController.swift
//  TodoList_SQLite
//
//  Created by Chu Du on 29/09/2021.
//

import UIKit
import FMDB

fileprivate let DataBaseName = "TodoList"
fileprivate let DataBaseType = "db"

class DBController {
    
    // MARK: - Public
    static var shared = DBController()
    var database: FMDatabase!
    
    init() {
        self.initDatabase()
    }
    
    // MARK: - State
    func getListTodo() -> [Todo] {
        var todos = [Todo]()
        openDB()
        guard let resultSet = getResultSet(query: "select * from Todo") else {
            closeDB()
            return []
        }
        
        while resultSet.next() {
            let obj = Todo.init(resultSet: resultSet)
            todos.append(obj)
        }
        
        closeDB()
        return todos
    }
}

extension DBController {
    func excuteUpdate(query: String) -> Bool {
        openDB()
        let success = database!.executeStatements(query)
        closeDB()
        return success
    }
    
    func isExistRecord(query: String) -> Bool {
        openDB()
        let resultSet = try? database.executeQuery(query, values: nil)
        let rs = resultSet?.next() ?? false
        closeDB()
        return rs
    }
}

// MARK: - Private
private extension DBController {
    func initDatabase() {
        guard let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            return
        }
        
        let dataBaseFilePath = documentPath + "/" + DataBaseName + "." + DataBaseType
        print("databasePath = \(dataBaseFilePath)")
        if FileManager.default.fileExists(atPath: dataBaseFilePath) == false{
            try? FileManager.default.copyfileToUserDocumentDirectory(forResource: DataBaseName, ofType: DataBaseType)
        }
        database = FMDatabase.init(path: dataBaseFilePath)
        openDB()
        database.shouldCacheStatements = true
    }
    
    func getResultSet(query: String) -> FMResultSet? {
        return try? database.executeQuery(query, values: nil)
    }
    
    func openDB() {
        database.open()
    }
    
    func closeDB() {
        database.close()
    }
}


extension FileManager {
    func copyfileToUserDocumentDirectory(forResource name: String, ofType ext: String) throws {
        if let bundlePath = Bundle.main.path(forResource: name, ofType: ext),
           let destPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            let fileName = "\(name).\(ext)"
            let fullDestPath = URL(fileURLWithPath: destPath)
                .appendingPathComponent(fileName)
            let fullDestPathString = fullDestPath.path
            
            if !self.fileExists(atPath: fullDestPathString) {
                try self.copyItem(atPath: bundlePath, toPath: fullDestPathString)
            }
        }
    }
}
