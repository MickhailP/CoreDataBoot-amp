//
//  ContentView.swift
//  CoreDataBootCamp
//
//  Created by Миша Перевозчиков on 14.06.2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: Fruit.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Fruit.name, ascending: false)])
    var fruits: FetchedResults<Fruit>
    
    @State private var fruitName: String = ""

    var body: some View {
        NavigationView {
            VStack {
                TextField("Add a new fruit name...", text: $fruitName)
                    .foregroundColor(.black)
                    .font(.headline)
                    .padding(.leading)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50 )
                    .background(.gray.opacity(0.2))
                    .cornerRadius(12)
                    .padding(.horizontal)
                Button {
                    addItem(fruitName)
                } label: {
                    Text("Add fruit")
                        .foregroundColor(.white)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50 )
                        .background(.indigo)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }

                
                List {
                    ForEach(fruits) { fruit in
                        Text(fruit.name ?? "")
                            .onTapGesture {
                                updateItems(fruit: fruit)
                            }
                    }
                    .onDelete(perform: deleteItems)
                    
                }
                .listStyle(.plain)
                .navigationTitle("Fruits")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
            }
            }
            Text("Select an item")
        }
    }

    private func addItem(_ name: String) {
        withAnimation {
            let newItem = Fruit(context: viewContext)
            newItem.name = name
            
            saveItems()
            
            fruitName = ""
        }
    }
    
   private func updateItems(fruit: Fruit) {
       withAnimation {
           let currentName = fruit.name ?? ""
           fruit.name = currentName + "!"
           
           saveItems()
       }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            guard let index = offsets.first else { return }
            let fruit  = fruits[index]
            viewContext.delete(fruit)

            saveItems()
        }
    }
    
    private func saveItems() {
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
