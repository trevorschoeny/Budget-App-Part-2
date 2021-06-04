//
//  EditTransactionView.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 6/4/21.
//

import SwiftUI

struct EditTransactionView: View {
   
   @EnvironmentObject var model:TransactionModel
   @EnvironmentObject var accountModel:AccountModel
   @EnvironmentObject var budgetModel:BudgetModel
   
   @Environment(\.presentationMode) var isPresented
   @State var showAlert = false
   
   
   @Binding var oldTransaction: NewTransaction
   @Binding var newTransaction: NewTransaction
   @Binding var inputTransaction: TransactionEntity
   
    var body: some View {
      NavigationView {
         VStack {
            Form {
               // MARK: Description
               TextField("Add description here...", text: $newTransaction.name.bound)
               
               // MARK: Date
               DatePicker("Date of Transaction: ", selection: $newTransaction.date, displayedComponents: .date)
               
               VStack(alignment: .leading) {
                  // MARK: Debit or Credit
                  HStack(spacing: 0) {
                     if newTransaction.debit {
                        Text("Debit to . . .")
                     }
                     else {
                        Text("Credit from . . .")
                     }
                     // MARK: Account
                     Picker(selection: $newTransaction.account, label: Text("")) {
                        ForEach(accountModel.savedEntities) { a in
                           Text(a.name ?? "no name").tag(a as AccountEntity?)
                        }
                     }
                     .lineLimit(1)
                     Spacer()
                     if newTransaction.debit {
                        Toggle("", isOn: $newTransaction.debit)
                           .frame(width: 60)
                     }
                     else {
                        Toggle("", isOn: $newTransaction.debit)
                           .frame(width: 60)
                     }
                  }
               }
               
               // MARK: Amount
               HStack {
                  Text("$ ")
                  TextField("Amount", text: $newTransaction.amount.value)
                     .keyboardType(.decimalPad)
               }
               
               // MARK: Budget
               if !newTransaction.debit {
                  HStack {
                     Text("Budget:")
                     Picker(selection: $newTransaction.budget, label: Text("")) {
                        ForEach(budgetModel.savedEntities) { b in
                           Text(b.name ?? "no name").tag(b as BudgetEntity?)
                        }
                        .lineLimit(1)
                     }
                  }
               }
               
               // MARK: Remove Budget
               if newTransaction.budget != nil {
                  HStack {
                     Spacer()
                     Button(action: {
                        newTransaction.budget = nil
                     }, label: {
                        Text("Clear Budget")
                           .foregroundColor(.blue)
                     })
                     Spacer()
                  }
                  
               }
               
               //MARK: Notes
               VStack(alignment: .leading, spacing: 0.0) {
                  Text("Notes: ")
                     .padding(.top, 5.0)
                  
                  TextEditor(text: $newTransaction.notes.bound)
               }
            }
            
            // MARK: Cancel Button
            Button(action: {
               self.isPresented.wrappedValue.dismiss()
            }, label: {
               Text("Cancel ")
                  .foregroundColor(.blue)
            })
            .padding(.top, 5.0)
            
            // MARK: Save Button
            Button(action: {

               // Show Alert
               if newTransaction.name == "" || newTransaction.name == nil || newTransaction.amount.value == "" || newTransaction.amount.value.filter({ $0 == "."}).count > 1 || newTransaction.account == nil {
                  showAlert = true
               }
               // Submit Transaction
               else {
                  model.updateTransaction(transaction: inputTransaction, newTransaction: newTransaction)
                  updateAccountBalance()
                  if !newTransaction.debit {
                     updateBudgetBalance()
                  }
               }
               self.isPresented.wrappedValue.dismiss()

            }, label: {
               ZStack {
                  Rectangle()
                     .font(.headline)
                     .foregroundColor(Color(#colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)))
                     .frame(height: 55)
                     .cornerRadius(10)
                     .padding(.horizontal)
                  Text("Save")
                     .font(.headline)
                     .foregroundColor(.white)
               }
            })
            .alert(isPresented: $showAlert, content: {
               Alert(title: Text("Invalid Entries"), message: Text("Please enter a valid input for each entry."), dismissButton: .default(Text("Ok")))
            })
            .font(.headline)
            .foregroundColor(.white)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(Color(#colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)))
            .cornerRadius(10)
            .padding([.leading, .bottom, .trailing])
         }
         .navigationTitle("Edit Transaction")
      }
    }
   private func updateAccountBalance() {
      for i in accountModel.savedEntities {
         if oldTransaction.account?.name == i.name {
            if !oldTransaction.debit {
               i.balance += Double(oldTransaction.amount.value) ?? 0.0
            } else {
               i.balance -= Double(oldTransaction.amount.value) ?? 0.0
            }
            accountModel.saveData()
         }
      }
      for i in accountModel.savedEntities {
         if newTransaction.account?.name == i.name {
            if !newTransaction.debit {
               i.balance -= Double(newTransaction.amount.value) ?? 0.0
            } else {
               i.balance += Double(newTransaction.amount.value) ?? 0.0
            }
            accountModel.saveData()
         }
      }
   }
   private func updateBudgetBalance() {
      for i in budgetModel.savedEntities {
         if oldTransaction.budget?.name == i.name {
            i.balance += Double(oldTransaction.amount.value) ?? 0.0
            budgetModel.saveData()
         }
      }
      for i in budgetModel.savedEntities {
         if newTransaction.budget?.name == i.name {
            i.balance -= Double(newTransaction.amount.value) ?? 0.0
            budgetModel.saveData()
         }
      }
   }
}

//struct EditTransactionView_Previews: PreviewProvider {
//    static var previews: some View {
//      EditTransactionView(newTransaction: NewTransaction(), inputTransaction: TransactionEntity())
//    }
//}
