//
//  Todo.swift
//  Firefly
//
//  Created by Howard, Freddie (ABH) on 14/06/2024.
//

import Foundation
import FirebaseFirestore

struct Todo {
    let id: String
    let content: String
    let createdAt: Date
    
    init(id: String, data: [String: Any]) {
        self.id = id
        self.content = data["content"] as? String ?? "My todo"
        let timestamp = data["createdAt"] as? Timestamp ?? nil
        self.createdAt = timestamp?.dateValue() ?? Date()
    }
}
