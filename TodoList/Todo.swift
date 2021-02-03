//
//  Todo.swift
//  TodoList
//
//  Created by Gabriel Kirkley on 2021-02-02.
//

import Foundation

struct Todo {
    let title: String
    let isComplete: Bool
    
    init(title: String, isComplete: Bool = false) {
        self.isComplete = isComplete
        self.title = title
    }
    
    func completeToggled() -> Todo {
        return Todo(title: title, isComplete: !isComplete)
    }
}
