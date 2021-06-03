//
//  BudgetModel.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 5/30/21.
//

import Foundation
import CoreData

class BudgetModel: ObservableObject {
   let container: NSPersistentContainer
   @Published var savedEntities: [BudgetEntity] = []
   
   init() {
      container = NSPersistentContainer(name: "BudgetAppContainer")
      container.loadPersistentStores { description, error in
         if let error = error {
            print("ERROR LOADING CORE DATA. \(error)")
         }
      }
      fetchBudgets()
   }
   
   // MARK: fetchABudgets
   func fetchBudgets() {
      // Create a fetch request
      let request = NSFetchRequest<BudgetEntity>(entityName: "BudgetEntity")
      request.sortDescriptors = [NSSortDescriptor(key: "userOrder", ascending: true), NSSortDescriptor(key: "name", ascending: true)]
      do {
         // Try to fetch the fetch request and store the results in savedEntities
         savedEntities = try container.viewContext.fetch(request)
      } catch let error {
         print("Error fetching: \(error)")
      }
   }
   
   // MARK: addBudget
   func addBudget(name: String, budgetAmount: Double) {
      let newBudget = BudgetEntity(context: container.viewContext)
      newBudget.name = name
      newBudget.budgetAmount = budgetAmount
      newBudget.balance = budgetAmount
      newBudget.id = UUID()
      saveData()
   }
   
   // MARK: deleteBudget
   func deleteBudget(indexSet: IndexSet) {
      guard let index = indexSet.first else { return }
      let entity = savedEntities[index]
      container.viewContext.delete(entity)
      saveData()
   }
   
   // MARK: saveData
   func saveData() {
      do {
         try container.viewContext.save()
         // fetchBudgets() will update the UI with the new saved data
         fetchBudgets()
      } catch let error {
         print("Error saving: \(error)")
      }
   }
}
