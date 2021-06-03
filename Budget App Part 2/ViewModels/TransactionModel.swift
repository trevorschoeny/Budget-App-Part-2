//
//  TransactionModel.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 5/28/21.
//

import Foundation
import CoreData

class TransactionModel: ObservableObject {
   let container: NSPersistentContainer
   @Published var savedEntities: [TransactionEntity] = []
   
   init() {
      container = NSPersistentContainer(name: "BudgetAppContainer")
      container.loadPersistentStores { description, error in
         if let error = error {
            print("ERROR LOADING CORE DATA. \(error)")
         }
      }
      fetchTransactions()
   }
   
   // MARK: fetchTransactions
   func fetchTransactions() {
      // Create a fetch request
      let request = NSFetchRequest<TransactionEntity>(entityName: "TransactionEntity")
      request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
      do {
         // Try to fetch the fetch request and store the results in savedEntities
         savedEntities = try container.viewContext.fetch(request)
      } catch let error {
         print("Error fetching: \(error)")
      }
   }
   
   // MARK: addTransaction
   func addTransaction(name: String, date: Date, debit: Bool, account: String, amount: Double, budget: String, notes: String) {
      let newTransaction = TransactionEntity(context: container.viewContext)
      newTransaction.name = name
      newTransaction.date = date
      newTransaction.debit = debit
      newTransaction.account = account
      newTransaction.amount = amount
      newTransaction.budget = budget
      newTransaction.notes = notes
      saveData()
   }
   
   // MARK: updateTransaction
   func updateTransaction(transaction: TransactionEntity, name: String, date: Date, debit: Bool, account: String, amount: Double, budget: String, notes: String) {
      transaction.name = name
      transaction.date = date
      transaction.debit = debit
      transaction.account = account
      transaction.amount = amount
      transaction.budget = budget
      transaction.notes = notes
      saveData()
   }
   
   // MARK: deleteTransaction
   func deleteTransaction(index: Int) {
//      guard let index = indexSet.first else { return }
      let entity = savedEntities[index]
      container.viewContext.delete(entity)
      saveData()
   }
   
   // MARK: saveData
   func saveData() {
      do {
         try container.viewContext.save()
         // fetchTransactions() will update the UI with the new saved data
         fetchTransactions()
      } catch let error {
         print("Error saving: \(error)")
      }
   }
}
