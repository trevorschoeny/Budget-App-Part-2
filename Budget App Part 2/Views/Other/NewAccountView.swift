//
//  NewAccountView.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 5/30/21.
//

import SwiftUI

struct NewAccountView: View {
   
   @EnvironmentObject var accountModel: AccountModel
   
   @Environment(\.presentationMode) var presentationMode
   @State var selectedName = ""
   @State var showAlert = false
   @State var debitToggle = false
   
   var body: some View {
      NavigationView {
         VStack(alignment: .leading, spacing: 20) {
            
            Form {
               // MARK: Name
               TextField("Add account name here...", text: $selectedName)
               
               // MARK: Credit or Debit
               VStack(alignment: .leading) {
                  if !debitToggle {
                     Toggle("Credit Account", isOn: $debitToggle)
                  }
                  else {
                     Toggle("Debit Account", isOn: $debitToggle)
                  }
               }
            }
            
            
            // MARK: Save Button
            Button(action: {
               if selectedName == "" {
                  
                  showAlert = true
                  
               }
               // Save Account
               else {
                  accountModel.addAccount(name: selectedName, debit: debitToggle)
                  selectedName = ""
                  debitToggle = false
                  self.presentationMode.wrappedValue.dismiss() // << behaves the same as below
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
