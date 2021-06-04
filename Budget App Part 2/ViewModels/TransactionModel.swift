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
   func addTransaction(newTransaction: NewTransaction) {
      let addedTransaction = TransactionEntity(context: container.viewContext)
      addedTransaction.account = newTransaction.account?.name
      addedTransaction.amount = Double(newTransaction.amount.value) ?? 0.0
      addedTransaction.budget = newTransaction.budget?.name
      addedTransaction.date = newTransaction.date
      addedTransaction.debit = newTransaction.debit
      addedTransaction.name = newTransaction.name
      addedTransaction.notes = newTransaction.notes
      
      saveData()
   }
   
   // MARK: updateTransaction
   func updateTransaction(transaction: TransactionEntity, newTransaction: NewTransaction) {
      transaction.account = newTransaction.account?.name
      transaction.amount = Double(newTransaction.amount.value) ?? 0.0
      transaction.budget = newTransaction.budget?.name
      transaction.date = newTransaction.date
      transaction.debit = newTransaction.debit
      transaction.name = newTransaction.name
      transaction.notes = newTransaction.notes
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
