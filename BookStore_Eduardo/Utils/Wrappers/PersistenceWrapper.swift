//
//  PersistenceWrapper.swift
//  BookStore_Eduardo
//
//  Created by eduardofilho on 29/04/22.
//

import Foundation

class PersistenceWrapper {
    static let shared = PersistenceWrapper()
    
    private let dataBase = UserDefaults.standard
    private init() { }
    
    func add(object: Any, id: String) {
        return dataBase.set(object, forKey: id)
    }
    
    func get <T>(id: String) -> T? {
        return dataBase.object(forKey: id) as? T
    }
}
