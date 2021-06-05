//
//  TransactionDetailView.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 5/28/21.
//

import SwiftUI

struct TransactionDetailView: View {
   
   @EnvironmentObject var model:TransactionModel
   @EnvironmentObject var accountModel:AccountModel
   @EnvironmentObject var budgetModel:BudgetModel
   
   @State var transaction: TransactionEntity
   @State var oldTransaction = NewTransaction(date: Date())
   @State var newTransaction = NewTransaction(date: Date())
   @State var showingPopover = false
   
   var body: some View {
      VStack(alignment: .leading, spacing: 0.0) {
         List {
            
            // MARK: Description
            HStack {
               Text(transaction.name ?? "No Name")
                  .font(.largeTitle)
                  .multilineTextAlignment(.leading)
               Spacer()
            }
            .padding(.vertical, 5.0)
            
            HStack {
               Spacer()
               VStack {
                  // MARK: Amount
                  if transaction.debit {
                     Text("$" + String(transaction.amount))
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.green)
                  }
                  else {
                     Text("($" + String(transaction.amount) + ")")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.red)
                  }
                  
                  // MARK: Account
                  if transaction.debit {
                     Text("to " + (transaction.account ?? "No Account"))
                        .font(.title2)
                        .fontWeight(.light)
                  }
                  else {
                     Text("from " + (transaction.account ?? "No Account"))
                        .font(.title2)
                        .fontWeight(.light)
                  }
               }
               .padding(.vertical)
               Spacer()
            }
            
            // MARK: Date
            HStack {
               Text("Date: ")
                  .foregroundColor(Color.gray)
               Spacer()
               Text(transaction.date?.addingTimeInterval(0) ?? Date(), style: .date)
            }
            
            if !transaction.debit {
               // MARK: Budget
               HStack {
                  Text("Budget: ")
                     .foregroundColor(Color.gray)
                  Spacer()
                  Text(transaction.budget ?? "")
               }
            }
            
            // MARK: Notes
            VStack(alignment: .leading) {
               Text("Notes:")
                  .foregroundColor(Color.gray)
                  .padding(.vertical, 6.0)
               if transaction.notes != "" && transaction.notes != nil {
                  Text(transaction.notes ?? "")
                     .multilineTextAlignment(.leading)
                     .padding(.bottom, 6.0)
               }
            }
         }
         .listStyle(InsetGroupedListStyle())
      }
      .navigationBarItems(trailing: editButton)
      .navigationBarTitleDisplayMode(.inline)
      .popover(isPresented: self.$showingPopover, content: {
         EditTransactionView(oldTransaction: $oldTransaction, newTransaction: $newTransaction, inputTransaction: $transaction)
      })
   }
   
   private var editButton: some View {
      Button(action: {
         prepareNewTransaction()
         showingPopover = true
      }, label: {
         Text("Edit")
            .foregroundColor(.blue)
      })
   }
   func prepareNewTransaction() {
      
      // Old Account
      for a in accountModel.savedEntities {
         if transaction.account == a.name {
            oldTransaction.account = a
         }
      }
      oldTransaction.amount.value = String(transaction.amount)
      if !transaction.debit {
         for b in budgetModel.savedEntities {
            if transaction.budget == b.name {
               oldTransaction.budget = b
            }
         }
      }
      oldTransaction.date = transaction.date ?? Date()
      oldTransaction.debit = transaction.debit
      oldTransaction.name = transaction.name
      oldTransaction.notes = transaction.notes
      
      // New Account
      for a in accountModel.savedEntities {
         if transaction.account == a.name {
            newTransaction.account = a
         }
      }
      if !transaction.debit {
         for b in budgetModel.savedEntities {
            if transaction.budget == b.name {
               newTransaction.budget = b
            }
         }
      }
      newTransaction.date = transaction.date ?? Date()
      newTransaction.debit = transaction.debit
      newTransaction.notes = transaction.notes
   }
}

struct TransactionDetailView_Previews: PreviewProvider {
   static var previews: some View {
      let model = TransactionModel()
      
      TransactionDetailView(transaction: model.savedEntities[0])
   }
}
