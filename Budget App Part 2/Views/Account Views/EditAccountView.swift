//
//  EditAccountView.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 6/4/21.
//

import SwiftUI

struct EditAccountView: View {
   
   @EnvironmentObject var transactionModel: TransactionModel
   @EnvironmentObject var accountModel: AccountModel
   @Binding var oldAccount: NewAccount
   @Binding var newAccount: NewAccount
   @Binding var inputAccount: AccountEntity
   
   @Environment(\.presentationMode) var isPresented
   @State var showAlert = false
   
   var body: some View {
      NavigationView {
         VStack {
            
            Form {
               // MARK: Name
               TextField(oldAccount.name.bound, text: $newAccount.name.bound)
               
               // MARK: onDashboard
               Toggle("Include on Dashboard", isOn: $newAccount.onDashboard)
               
               // MARK: isCurrent
               VStack(alignment: .leading) {
                  if !newAccount.isCurrent {
                     Toggle("Long-term", isOn: $newAccount.isCurrent)
                  }
                  else {
                     Toggle("Current", isOn: $newAccount.isCurrent)
                  }
               }
               
               // MARK: Credit or Debit
               VStack(alignment: .leading) {
                  if !newAccount.debit {
                     Toggle("Credit Account", isOn: $newAccount.debit)
                  }
                  else {
                     Toggle("Debit Account", isOn: $newAccount.debit)
                  }
               }
               
               // MARK: Amount
               HStack {
                  Text("Balance: ")
                  if !newAccount.debit {
                     Text("$( ")
                     TextField(oldAccount.balance.value, text: $newAccount.balance.value)
                        .keyboardType(.decimalPad)
                     Spacer()
                     Text(" )")
                  }
                  else {
                     Text("$ ")
                     TextField(oldAccount.balance.value, text: $newAccount.balance.value)
                        .keyboardType(.decimalPad)
                  }
               }
               
               //MARK: Notes
               VStack(alignment: .leading, spacing: 0.0) {
                  Text("Notes: ")
                     .padding(.top, 5.0)
                  TextEditor(text: $newAccount.notes.bound)
               }
            }
            
            // MARK: Cancel Button
            Button(action: {
               newAccount.reset()
               newAccount.date = oldAccount.date 
               newAccount.debit = oldAccount.debit
               newAccount.isCurrent = oldAccount.isCurrent
               newAccount.notes = oldAccount.notes
               newAccount.onDashboard = oldAccount.onDashboard
               newAccount.userOrder = oldAccount.userOrder
               self.isPresented.wrappedValue.dismiss()
            }, label: {
               Text("Cancel ")
                  .foregroundColor(.blue)
            })
            .padding(.top, 5.0)
            
            // MARK: Save Button
            Button(action: {
               if newAccount.balance.value.filter({ $0 == "."}).count > 1 {
                  showAlert = true
               }
               
               // Update Account
               accountModel.updateAccount(account: inputAccount, newAccount: newAccount, oldAccount: oldAccount)
               updateNames()
               oldAccount = newAccount
               newAccount.reset()
               newAccount.date = oldAccount.date 
               newAccount.debit = oldAccount.debit
               newAccount.isCurrent = oldAccount.isCurrent
               newAccount.notes = oldAccount.notes
               newAccount.onDashboard = oldAccount.onDashboard
               newAccount.userOrder = oldAccount.userOrder
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
            .padding(.bottom)
            .alert(isPresented: $showAlert, content: {
               Alert(title: Text("Invalid Entry"), message: Text("Please enter a valid input."), dismissButton: .default(Text("Ok")))
            })
         }
         .navigationTitle("Edit Account")
      }
   }
   private func updateNames() {
      if newAccount.name != "" && newAccount.name != nil {
         for t in transactionModel.savedEntities {
            if t.account == oldAccount.name {
               t.account = newAccount.name
            }
         }
      }
   }
}

//struct EditAccountView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditAccountView(oldAccount: NewAccount(), newAccount: NewAccount(), inputAccount: AccountEntity())
//    }
//}
