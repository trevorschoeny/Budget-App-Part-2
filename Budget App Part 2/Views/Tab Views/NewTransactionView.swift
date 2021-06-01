//
//  NewTransactionView.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 5/28/21.
//

import SwiftUI

class NumbersOnly: ObservableObject {
   @Published var value = "" {
      didSet {
         let filtered = value.filter { $0.isNumber || $0 == "." }
         if value != filtered {
             value = filtered
         }
      }
   }
}

struct NewTransactionView: View {
   
   @EnvironmentObject var model:TransactionModel
   @EnvironmentObject var accountModel:AccountModel
   
   
   var accounts:[String] = ["Qapital", "Discover Payable", "Other account"]
   var budgets = ["Rent & Utilities", "Groceries", "Gas", "Spending"]
   
   @State var selectedDescription = ""
   @State var datePickerDate = Date()
   @State var selectedAccount = ""
   @State var debitToggle = false
   @ObservedObject var selectedAmount = NumbersOnly()
   @State var selectedBudgetIndex = 0
   @State var selectedNotes = ""
   @State var showAlert = false
   
    var body: some View {
      NavigationView {
         VStack {
            Form {
               // MARK: Description
               TextField("Add description here...", text: $selectedDescription)
               
               // MARK: Date
               DatePicker("Date of Transaction: ", selection: $datePickerDate, displayedComponents: .date)
               
               VStack(alignment: .leading) {
                  // MARK: Debit or Credit
                  HStack {
                     if debitToggle {
                        Toggle("Debit", isOn: $debitToggle)
                     }
                     else {
                        Toggle("Credit", isOn: $debitToggle)
                     }
                  }
               }
               // MARK: Account
               Picker(selection: $selectedAccount, label: Text("Account: ")) {
                  ForEach(accountModel.savedEntities) { a in
                     Text(a.name ?? "no name").tag(a)
                  }
               }
//               .frame(height: 170)
//               .pickerStyle(InlinePickerStyle())
//               .labelsHidden()
               
               // MARK: Amount
               HStack {
                  Text("$ ")
                  TextField("Amount", text: $selectedAmount.value)
                     .keyboardType(/*@START_MENU_TOKEN@*/.decimalPad/*@END_MENU_TOKEN@*/)
               }
               
               // MARK: Budget
               Picker(selection: $selectedBudgetIndex, label: Text("Budget: ")) {
                  ForEach(0 ..< budgets.count) {
                     Text(self.budgets[$0])
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
            
            VStack(alignment: .leading) {
               
               // MARK: Save Button
               Button(action: {
                  if selectedDescription == "" || selectedAmount.value == "" || selectedAmount.value.filter({ $0 == "."}).count > 1 {
                     
                     showAlert = true
                     
                  }
                  // Submit Transaction (Credit)
                  else if !debitToggle {
                     model.addTransaction(name: selectedDescription,
                                          date: datePickerDate,
                                          debit: debitToggle,
                                          account: selectedAccount,
                                          amount: Double(selectedAmount.value) ?? 0.0,
                                          budget: budgets[selectedBudgetIndex],
                                          notes: selectedNotes)
                     selectedDescription = ""
                     datePickerDate = Date(timeIntervalSinceNow: 0)
                     debitToggle = false
                     selectedAccount = ""
                     selectedAmount.value = ""
                     selectedBudgetIndex = 0
                     selectedNotes = ""
                  }
                  // Submit Transaction (Debit)
                  else {
                     model.addTransaction(name: selectedDescription,
                                          date: datePickerDate,
                                          debit: debitToggle,
                                          account: selectedAccount,
                                          amount: Double(selectedAmount.value) ?? 0.0,
                                          budget: "",
                                          notes: selectedNotes)
                     selectedDescription = ""
                     datePickerDate = Date(timeIntervalSinceNow: 0)
                     debitToggle = false
                     selectedAccount = ""
                     selectedAmount.value = ""
                     selectedBudgetIndex = 0
                     selectedNotes = ""
                  }
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
    }
}

struct NewTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        NewTransactionView()
         .environmentObject(TransactionModel())
         .environmentObject(AccountModel())
    }
}
