//
//  NewAccountView.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 5/30/21.
//

import SwiftUI

struct NewAccountView: View {
   
   @EnvironmentObject var accountModel: AccountModel
   @State var newAccount = NewAccount()
   
   @Environment(\.presentationMode) var isPresented
   @State var showAlert = false
   
   
   var body: some View {
      NavigationView {
         VStack {
            
            Form {
               // MARK: Name
               TextField("Add account name here...", text: $newAccount.name.bound)
               
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
                  if !newAccount.debit {
                     Text("$( ")
                     TextField("Starting Amount", text: $newAccount.balance.value)
                        .keyboardType(.decimalPad)
                     Spacer()
                     Text(" )")
                  }
                  else {
                     Text("$ ")
                     TextField("Starting Amount", text: $newAccount.balance.value)
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
               self.isPresented.wrappedValue.dismiss()
            }, label: {
               Text("Cancel ")
                  .foregroundColor(.blue)
            })
            .padding(.top, 5.0)
            
            // MARK: Save Button
            Button(action: {
               if newAccount.balance.value == ""  || newAccount.name == "" || newAccount.name == nil {
                  showAlert = true
               }
               // Save Account
               else {
                  accountModel.addAccount(newAccount: newAccount)
                  newAccount.reset()
                  self.isPresented.wrappedValue.dismiss()
               }
               
            }, label: {
               ZStack {
                  Rectangle()
                     .font(.headline)
                     .foregroundColor(Color(#colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)))
                     .frame(height: 55)
                     .cornerRadius(10)
                     .padding(.horizontal)
                  Text("Add")
                     .font(.headline)
                     .foregroundColor(.white)
               }
            })
            .padding(.bottom)
            .alert(isPresented: $showAlert, content: {
               Alert(title: Text("Invalid Entry"), message: Text("Please enter a valid input."), dismissButton: .default(Text("Ok")))
            })
         }
         .navigationTitle("Add Account")
      }
   }
}

struct NewAccountView_Previews: PreviewProvider {
    static var previews: some View {
        NewAccountView()
    }
}
