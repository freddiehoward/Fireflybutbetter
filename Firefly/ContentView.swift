//
//  ContentView.swift
//  Firefly
//
//  Created by Howard, Freddie (ABH) on 14/06/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var newToDo: String = ""
    @State private var todos: [Todo] = []
    
    private let firebaseManager = FirebaseManager.shared
    
    var body: some View {
        NavigationStack{
            List{
                if todos.isEmpty {
                    Text("Add your first todo below")
                }
                else {
                    ForEach(todos, id:\.id) { todo in
                        Text(todo.content)
                    }
                    .onDelete(perform: { indexSet in
                        indexSet.forEach { index in
                            firebaseManager.deleteTodo(id: todos[index].id) { error in
                                if let error = error {
                                    print("Error: \(error.localizedDescription)")
                                }
                            }
                        }
                        todos.remove(atOffsets: indexSet)
                    })
                }
            }
            .listStyle(.plain)
            TextField("enter a todo", text: $newToDo)
                .onSubmit {
                    if newToDo.count > 0 {
                        firebaseManager.saveToDo(todo: newToDo)
                        newToDo = ""
                    }
                }
                .navigationTitle("Firefly but better")
        }
        .onAppear {
            firebaseManager.getToDos{todos, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
                else {
                    guard let todos = todos else {
                        print("hell naw smethings gone wrong")
                        return
                    }
                    
                    self.todos = todos.sorted {
                        $0.createdAt < $1.createdAt
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
