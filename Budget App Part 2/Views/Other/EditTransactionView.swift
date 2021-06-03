//
//  NewTransactionView.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 5/28/21.
//

import SwiftUI

struct EditTransactionView: View {
   
   @Environment(\.presentationMode) var isPresented
   
   @EnvironmentObject var model:TransactionModel
   @EnvironmentObject var accountModel:AccountModel
   
   @State var inputTransaction: TransactionEntity
   var budgets = ["Rent & Utilities", "Groceries", "Gas", "Spending"]
   
   @State var selectedDescription = ""
   @State var datePickerDate = Date()
   @State var selectedAccount: AccountEntity?
   @State var selectedAccountName = "Account                    "
   @State var debitToggle = false
   @ObservedObject var selectedAmount = NumbersOnly()
   @State var selectedBudgetIndex = 0
   @State var selectedNotes = ""
   @State var showAlert = false
   
   @State var oldAmount = NumbersOnly()
   @State var oldDebit = false
   
    var body: some View {
      NavigationView {
         VStack {
            Button(action: {
               self.isPresented.wrappedValue.dismiss()
            }, label: {
               /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
            })
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
//                     .pickerStyle(MenuPickerStyle())
//                     .labelsHidden()
//                     .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
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
                     .keyboardType(/*@START_MENU_TOKEN@*/.decimalPad/*@END_MENU_TOKEN@*/)
                     .foregroundColor(Color.gray)
               }
               
               // MARK: Budget
               if !debitToggle {
                  Picker(selection: $selectedBudgetIndex, label: Text("Budget: ")) {
                     ForEach(0 ..< budgets.count) {
                        Text(self.budgets[$0])
                     }
                  }
               }
//               .frame(height: 170)
//               .pickerStyle(InlinePickerStyle())
//               .labelsHidden()
               
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
                  model.updateTransaction(transaction: inputTransaction,
                                       name: selectedDescription,
                                       date: datePickerDate,
                                       debit: debitToggle,
                                       account: selectedAccountName,
                                       amount: Double(selectedAmount.value) ?? 0.0,
                                       budget: budgets[selectedBudgetIndex],
                                       notes: selectedNotes)
                  
                  updateAccountBalance()
               }
               // Submit Transaction (Debit)
               else {
                  model.updateTransaction(transaction: inputTransaction,
                                          name: selectedDescription,
                                       date: datePickerDate,
                                       debit: debitToggle,
                                       account: selectedAccountName,
                                       amount: Double(selectedAmount.value) ?? 0.0,
                                       budget: "",
                                       notes: selectedNotes)
                  
                  updateAccountBalance()
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
                  Text("Update")
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
      .onAppear(perform: {
         if 0 < accountModel.savedEntities.count {
            for i in 0..<accountModel.savedEntities.count {
               if inputTransaction.account == accountModel.savedEntities[i].name {
                  selectedAccount = accountModel.savedEntities[i]
               }
            }
            selectedAccountName = selectedAccount?.name ?? "no name"
            selectedDescription = inputTransaction.name ?? "No Name"
            datePickerDate = inputTransaction.date ?? Date()
            debitToggle = inputTransaction.debit
            selectedAmount.value = String(inputTransaction.amount)
            for i in 0..<budgets.count {
               if inputTransaction.budget == budgets[i] {
                  selectedBudgetIndex = i
               }
            }
            selectedNotes = inputTransaction.notes ?? "No Notes"
            
            oldAmount.value = String(inputTransaction.amount)
            oldDebit = inputTransaction.debit
            
            
         }
      })
    }
   private func updateAccountBalance() {
      for i in accountModel.savedEntities {
         if selectedAccountName == i.name {
            if !oldDebit {
               i.balance += Double(oldAmount.value) ?? 0.0
            } else {
               i.balance -= Double(oldAmount.value) ?? 0.0
            }
            accountModel.saveData()
            if !debitToggle {
               i.balance -= Double(selectedAmount.value) ?? 0.0
            } else {
               i.balance += Double(selectedAmount.value) ?? 0.0
            }
            accountModel.saveData()
         }
      }
   }
}

struct EditTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        NewTransactionView()
         .environmentObject(TransactionModel())
         .environmentObject(AccountModel())
    }
}
