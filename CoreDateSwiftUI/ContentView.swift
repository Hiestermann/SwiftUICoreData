//
//  ContentView.swift
//  CoreDateSwiftUI
//
//  Created by Kilian on 15.08.19.
//  Copyright © 2019 Kilian. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: ToDoItem.getAllToDoItems()) var toDoItems:FetchedResults<ToDoItem>
    
    @State private var newTodoItem = ""
    
    var body: some View {
        NavigationView {
            Text("")
            List {
                Section(header: Text("Whats next?")) {
                    HStack {
                        TextField("New Item", text: self.$newTodoItem)
                        Button(action: {
                            let toDoItem = ToDoItem(context: self.managedObjectContext)
                            toDoItem.title = self.newTodoItem
                            toDoItem.createdAt = Date()
                            
                            do {
                                try self.managedObjectContext.save()
                            } catch {
                                print(error)
                            }
                            self.newTodoItem = ""
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(Color.green)
                                .imageScale(.large)
                        }
                    }
                }.font(.headline)
                Section(header: Text("To Do")) {
                     ForEach(self.toDoItems) { toDoItem in
                        ToDoItemView(title: toDoItem.title!, createdAt: "\(toDoItem.createdAt!)")
                     }.onDelete { indexSet in
                        let deleteItem = self.toDoItems[indexSet.first!]
                        self.managedObjectContext.delete(deleteItem)
                        
                        do {
                            try self.managedObjectContext.save()
                        } catch {
                            print(error)
                        }
                    }
                }
            }
        }
    .navigationBarTitle(Text("My List"))
    .navigationBarItems(trailing: EditButton())
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
