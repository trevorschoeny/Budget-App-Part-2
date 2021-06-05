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
      request.sortDescriptors = [NSSortDescriptor(key: "userOrder", ascending: true), NSSortDescriptor(key: "date", ascending: true)]
      do {
         // Try to fetch the fetch request and store the results in savedEntities
         savedEntities = try container.viewContext.fetch(request)
      } catch let error {
         print("Error fetching: \(error)")
      }
   }
   
   // MARK: addAccount
   func addAccount(newAccount: NewAccount) {
      let account = AccountEntity(context: container.viewContext)
      account.balance = Double(newAccount.balance.value) ?? 0.0
      if !newAccount.debit && account.balance != 0 {
         account.balance *= -1
      }
      account.date = Date()
      account.debit = newAccount.debit
      account.name = newAccount.name
      account.notes = newAccount.notes
      account.userOrder = 1000
      saveData()
   }
   
   // MARK: updateAccount
   func updateAccount(account: AccountEntity, newAccount: NewAccount, oldAccount: NewAccount) {
      if newAccount.balance.value == "" {
         account.balance = Double(oldAccount.balance.value) ?? 0.0
      } else {
         account.balance = Double(newAccount.balance.value) ?? 0.0
      }
      if newAccount.debit {
         account.balance = abs(account.balance)
      } else {
         account.balance = abs(account.balance) * -1
      }
      account.debit = newAccount.debit
      if newAccount.name == "" || newAccount.name == nil {
         account.name = oldAccount.name
      } else {
         account.name = newAccount.name
      }
      account.notes = newAccount.notes
      account.userOrder = newAccount.userOrder
      saveData()
   }
   
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
