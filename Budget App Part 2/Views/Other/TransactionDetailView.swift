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
      GeometryReader { geo in
         VStack(alignment: .leading, spacing: 0.0) {
            List {
               
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
                        .foregroundColor(Color.green)
                  }
                  else {
                     Text("from " + (transaction.account ?? "No Account"))
                        .font(.title2)
                        .fontWeight(.light)
                        .foregroundColor(Color.red)
                  }
               }
               .padding(.vertical)
               .frame(width: geo.size.width-80)
               
               // MARK: Description
               Text(transaction.name ?? "No Name")
                  .font(.title2)
                  .foregroundColor(Color.gray)
                  .multilineTextAlignment(.leading)
                  .frame(width: geo.size.width-80)
               
               // MARK: Date
               HStack {
                  Text("Date: ")
                  Spacer()
                  Text(transaction.date?.addingTimeInterval(0) ?? Date(), style: .date)
                     .foregroundColor(Color.gray)
               }
               
               
               
               // MARK: Budget
               HStack {
                  Text("Budget: ")
                  Spacer()
                  Text(transaction.budget ?? "No Budget")
                     .foregroundColor(Color.gray)
               }
               
               // MARK: Notes
               HStack {
                  Text("Notes:")
                  Spacer()
                  if transaction.notes == "" {
                     Text("No Notes")
                        .foregroundColor(Color.gray)
                  }
                  else {
                     Text(transaction.notes ?? "No Notes")
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.leading)
                  }
               }
            }
            .listStyle(InsetGroupedListStyle())
            .lineLimit(5)
         }
      }
      .navigationBarItems(trailing: editButton)
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
      for a in accountModel.savedEntities {
         if transaction.account == a.name {
            newTransaction.account = a
         }
      }
      newTransaction.amount.value = String(transaction.amount)
      if !transaction.debit {
         for b in budgetModel.savedEntities {
            if transaction.budget == b.name {
               newTransaction.budget = b
            }
         }
      }
      newTransaction.date = transaction.date ?? Date()
      newTransaction.debit = transaction.debit
      newTransaction.name = transaction.name
      newTransaction.notes = transaction.notes
      
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
   }
}

struct TransactionDetailView_Previews: PreviewProvider {
   static var previews: some View {
      let model = TransactionModel()
      
      TransactionDetailView(transaction: model.savedEntities[0])
   }
}
