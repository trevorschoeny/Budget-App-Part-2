//
//  AccountModel.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 5/30/21.
//

import Foundation
import CoreData

class AccountModel: ObservableObject {
   let container: NSPersistentContainer
   @Published var savedEntities: [AccountEntity] = []
   
   init() {
      container = NSPersistentContainer(name: "BudgetAppContainer")
      container.loadPersistentStores { description, error in
         if let error = error {
            print("ERROR LOADING CORE DATA. \(error)")
         }
      }
      fetchAccounts()
   }
   
   // MARK: fetchAccounts
   func fetchAccounts() {
      // Create a fetch request
      let request = NSFetchRequest<AccountEntity>(entityName: "AccountEntity")
      request.sortDescriptors = [NSSortDescriptor(key: "userOrder", ascending: true), NSSortDescriptor(key: "name", ascending: true)]
      do {
         // Try to fetch the fetch request and store the results in savedEntities
         savedEntities = try container.viewContext.fetch(request)
      } catch let error {
         print("Error fetching: \(error)")
      }
   }
   
   // MARK: addAccount
   func addAccount(name: String, debit: Bool) {
      let newAccount = AccountEntity(context: container.viewContext)
      newAccount.name = name
      newAccount.debit = debit
      newAccount.balance = 0.0
      newAccount.id = UUID()
      saveData()
   }
   
   // MARK: changeAccountOrder
//   func changeAccountOrder(indexSet: IndexSet) {
//      guard let index = indexSet.first else { return }
//      let entity = savedEntities[index]
//      entity.userOrder = Int16(index)
//      saveData()
//   }
   
   // MARK: deleteAccount
   func deleteAccount(indexSet: IndexSet) {
      guard let index = indexSet.first else { return }
      let entity = savedEntities[index]
      container.viewContext.delete(entity)
      saveData()
   }
   
   // MARK: saveData
   func saveData() {
      do {
         try container.viewContext.save()
         // fetchAccounts() will update the UI with the new saved data
         fetchAccounts()
      } catch let error {
         print("Error saving: \(error)")
      }
   }
}
