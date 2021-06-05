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
      request.sortDescriptors = [NSSortDescriptor(key: "userOrder", ascending: true), NSSortDescriptor(key: "date", ascending: true)]
      do {
         // Try to fetch the fetch request and store the results in savedEntities
         savedEntities = try container.viewContext.fetch(request)
      } catch let error {
         print("Error fetching: \(error)")
      }
   }
   
   // MARK: addBudget
   func addBudget(newBudget: NewBudget, diffStartBalance: Bool) {
      let budget = BudgetEntity(context: container.viewContext)
      if diffStartBalance {
         budget.balance = Double(newBudget.balance.value) ?? 0.0
      } else {
         budget.balance = Double(newBudget.budgetAmount.value) ?? 0.0
      }
      budget.budgetAmount = Double(newBudget.budgetAmount.value) ?? 0.0
      budget.date = Date()
      budget.name = newBudget.name
      budget.notes = newBudget.notes
      budget.userOrder = newBudget.userOrder
      saveData()
   }
   
   // MARK: updateBudget
   func updateBudget(budget: BudgetEntity, newBudget: NewBudget, oldBudget: NewBudget) {
      if newBudget.balance.value == "" {
         budget.balance = Double(oldBudget.balance.value) ?? 0.0
      } else {
         budget.balance = Double(newBudget.balance.value) ?? 0.0
      }
      if newBudget.budgetAmount.value == "" {
         budget.budgetAmount = Double(oldBudget.budgetAmount.value) ?? 0.0
      } else {
         budget.budgetAmount = Double(newBudget.budgetAmount.value) ?? 0.0
      }
      budget.date = Date()
      if newBudget.name == nil || newBudget.name == "" {
         budget.name = oldBudget.name
      } else {
         budget.name = newBudget.name
      }
      budget.notes = newBudget.notes
      budget.userOrder = newBudget.userOrder
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
