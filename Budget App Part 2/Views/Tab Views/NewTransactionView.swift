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
   
   @Environment(\.presentationMode) var isPresented
   @State var showAlert = false
   
   @State var inputTransaction: TransactionEntity?
   
   @State var selectedDescription = ""
   @State var datePickerDate = Date()
   
   @State var selectedAccount: AccountEntity?
   @State var selectedAccountName = ""
   
   @State var debitToggle = false
   @ObservedObject var selectedAmount = NumbersOnly()
   
   @State var selectedBudget: BudgetEntity?
   @State var selectedBudgetName = ""
   
   @State var selectedNotes = ""
   
    var body: some View {
      NavigationView {
         VStack {
            Form {
               // MARK: Description
               TextField("Add description here...", text: $selectedDescription)
                  .foregroundColor(Color.gray)
               
               // MARK: Date
               DatePicker("Date of Transaction: ", selection: $datePickerDate, displayedComponents: .date)
               
               VStack(alignment: .leading) {
                  // MARK: Debit or Credit
                  HStack(spacing: 0) {
                     if debitToggle {
                        Text("Debit to . . .")
                     }
                     else {
                        Text("Credit from . . .")
                     }
                     // MARK: Account
                     Picker(selection: $selectedAccount, label: Text("")) {
                        ForEach(accountModel.savedEntities) { a in
                           Text(a.name ?? "no name").tag(a as AccountEntity?)
                        }
                     }
                     .lineLimit(1)
                     .onChange(of: selectedAccount, perform: { value in
                        selectedAccountName = selectedAccount?.name ?? "no name"
                     })
                     Spacer()
                     if debitToggle {
                        Toggle("", isOn: $debitToggle)
                           .frame(width: 60)
                     }
                     else {
                        Toggle("", isOn: $debitToggle)
                           .frame(width: 60)
                     }
                  }
               }
               
               // MARK: Amount
               HStack {
                  Text("$ ")
                  TextField("Amount", text: $selectedAmount.value)
                     .keyboardType(.decimalPad)
                     .foregroundColor(Color.gray)
               }
               
               // MARK: Budget
               if !debitToggle {
                  HStack {
                     Text("Budget:")
                     Picker(selection: $selectedBudget, label: Text("")) {
                        ForEach(budgetModel.savedEntities) { b in
                           Text(b.name ?? "no name").tag(b as BudgetEntity?)
                        }
                        .lineLimit(1)
                        .onChange(of: selectedBudget, perform: { value in
                           selectedBudgetName = selectedBudget?.name ?? "no name"
                        })
                     }
                  }
               }
               
               //MARK: Notes
               VStack(alignment: .leading, spacing: 0.0) {
                  Text("Notes: ")
                     .padding(.top, 5.0)
                  
                  TextEditor(text: $selectedNotes)
                     .foregroundColor(/*@START_MENU_TOKEN@*/.gray/*@END_MENU_TOKEN@*/)
               }
            }
            
            // MARK: Save Button
            Button(action: {
               
               if selectedDescription == "" || selectedAmount.value == "" || selectedAmount.value.filter({ $0 == "."}).count > 1 || selectedAccountName == "Account                    " {
                  
                  showAlert = true
                  
               }
               // Submit Transaction (Credit)
               else if !debitToggle {
                  model.addTransaction(name: selectedDescription,
                                       date: datePickerDate,
                                       debit: debitToggle,
                                       account: selectedAccountName,
                                       amount: Double(selectedAmount.value) ?? 0.0,
                                       budget: selectedBudgetName,
                                       notes: selectedNotes)
                  
                  updateAccountBalance()
                  updateBudgetBalance()
                  
                  selectedDescription = ""
                  datePickerDate = Date(timeIntervalSinceNow: 0)
                  debitToggle = false
                  selectedAccount = accountModel.savedEntities[0]
                  selectedAccountName = ""
                  selectedBudget = budgetModel.savedEntities[0]
                  selectedAmount.value = ""
                  selectedBudgetName = ""
                  selectedNotes = ""
                  
               }
               // Submit Transaction (Debit)
               else {
                  model.addTransaction(name: selectedDescription,
                                       date: datePickerDate,
                                       debit: debitToggle,
                                       account: selectedAccountName,
                                       amount: Double(selectedAmount.value) ?? 0.0,
                                       budget: "",
                                       notes: selectedNotes)
                  
                  updateAccountBalance()
                  updateBudgetBalance()
                  
                  selectedDescription = ""
                  datePickerDate = Date(timeIntervalSinceNow: 0)
                  debitToggle = false
                  selectedAccount = accountModel.savedEntities[0]
                  selectedAccountName = ""
                  selectedAmount.value = ""
                  selectedBudget = budgetModel.savedEntities[0]
                  selectedBudgetName = ""
                  selectedNotes = ""
                  
                  
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
      .onAppear(perform: {
         if 0 < accountModel.savedEntities.count {
            selectedAccount = accountModel.savedEntities[0]
            selectedAccountName = selectedAccount?.name ?? "no name"
         }
         if 0 < budgetModel.savedEntities.count {
            selectedBudget = budgetModel.savedEntities[0]
            selectedBudgetName = selectedBudget?.name ?? "no name"
         }
      })
    }
   private func updateAccountBalance() {
      for i in accountModel.savedEntities {
         if selectedAccountName == i.name {
            if !debitToggle {
               i.balance -= Double(selectedAmount.value) ?? 0.0
            } else {
               i.balance += Double(selectedAmount.value) ?? 0.0
            }
            accountModel.saveData()
         }
      }
   }
   private func updateBudgetBalance() {
      for i in budgetModel.savedEntities {
         if selectedBudgetName == i.name {
//            print(selectedBudgetName)
//            print(selectedAmount.value)
//            print(i.balance)
            i.balance -= Double(selectedAmount.value) ?? 0.0
//            print(i.balance)
            budgetModel.saveData()
         }
      }
   }
}

struct NewTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        NewTransactionView()
         .environmentObject(TransactionModel())
         .environmentObject(AccountModel())
    }
}
