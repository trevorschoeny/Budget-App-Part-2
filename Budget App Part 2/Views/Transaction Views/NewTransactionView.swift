//
//  NewTransactionView.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 5/28/21.
//

import SwiftUI

struct NewTransactionView: View {
   
   @EnvironmentObject var model:TransactionModel
   @EnvironmentObject var accountModel:AccountModel
   @EnvironmentObject var budgetModel:BudgetModel
   
   @State var isPopover: Bool
   @Environment(\.presentationMode) var isPresented
   @State var showAlert = false
   
   @State var newTransaction = NewTransaction(date: Date())
   
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
                  if !newTransaction.debit {
                     Text("$( ")
                     TextField("Amount", text: $newTransaction.amount.value)
                        .keyboardType(.decimalPad)
                     Spacer()
                     Text(" )")
                  }
                  else {
                     Text("$ ")
                     TextField("Amount", text: $newTransaction.amount.value)
                        .keyboardType(.decimalPad)
                  }
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
            
            // MARK: Clear Button
            Button(action: {
               newTransaction.reset()
               if isPopover {
                  self.isPresented.wrappedValue.dismiss()
               }
            }, label: {
               if isPopover {
                  Text("Cancel ")
                     .foregroundColor(.blue)
               } else {
                  Text("Clear ")
                     .foregroundColor(.blue)
               }
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
                  model.addTransaction(newTransaction: newTransaction)
                  updateAccountBalance()
                  if !newTransaction.debit {
                     updateBudgetBalance()
                  }
                  if !isPopover {
                     newTransaction.reset()
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
         .navigationTitle("Add Transaction")
      }
    }
   private func updateAccountBalance() {
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
         if newTransaction.budget?.name == i.name {
            i.balance -= Double(newTransaction.amount.value) ?? 0.0
            budgetModel.saveData()
         }
      }
   }
}

struct NewTransactionView_Previews: PreviewProvider {
    static var previews: some View {
      NewTransactionView(isPopover: false)
         .environmentObject(TransactionModel())
         .environmentObject(AccountModel())
    }
}
