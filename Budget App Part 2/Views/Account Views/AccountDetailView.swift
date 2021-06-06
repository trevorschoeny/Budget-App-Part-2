//
//  AccountDetailView.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 6/4/21.
//

import SwiftUI

struct AccountDetailView: View {
   
   @EnvironmentObject var accountModel:AccountModel
   @State var account: AccountEntity
   @State var oldAccount = NewAccount()
   @State var newAccount = NewAccount()
   @State var showingPopover = false
   
   var body: some View {
      VStack {
         List {
            
            // MARK: Description
            VStack(alignment: .leading) {
               Text(account.name ?? "No Name")
                  .font(.largeTitle)
                  .multilineTextAlignment(.leading)
               if account.debit {
                  HStack(spacing: 0) {
                     Text("Debit Account • ")
                        .font(.callout)
                        .foregroundColor(Color.gray)
                     if account.isCurrent {
                        Text("Current")
                           .font(.callout)
                           .foregroundColor(Color.gray)
                     }
                  }
               } else {
                  HStack(spacing: 0) {
                     Text("Credit Account • ")
                        .font(.callout)
                        .foregroundColor(Color.gray)
                     if account.isCurrent {
                        Text("Current")
                           .font(.callout)
                           .foregroundColor(Color.gray)
                     }
                  }
               }
               // MARK: Date
               HStack(spacing: 0) {
                  Text("Created on ")
                     .foregroundColor(.gray)
                  Text(account.date!, style: .date)
                     .foregroundColor(.gray)
               }
               .font(.footnote)
            }
            .padding(.vertical, 5.0)
            
            HStack {
               Spacer()
               VStack {
                  // MARK: Amount
                  if account.balance >= 0.0 {
                     Text("$" + String(account.balance))
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.green)
                  }
                  else {
                     Text("($" + String(abs(account.balance)) + ")")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.red)
                  }
               }
               .padding(.vertical)
               Spacer()
            }
            
            // MARK: Notes
            VStack(alignment: .leading) {
               Text("Notes:")
                  .foregroundColor(Color.gray)
                  .padding(.vertical, 6.0)
               if account.notes != "" && account.notes != nil {
                  Text(account.notes ?? "")
                     .multilineTextAlignment(.leading)
                     .padding(.bottom, 6.0)
               }
            }
         }
         .listStyle(InsetGroupedListStyle())
      }
      .navigationBarItems(trailing: editButton)
      .navigationTitle("Account")
      .popover(isPresented: self.$showingPopover, content: {
         EditAccountView(oldAccount: $oldAccount, newAccount: $newAccount, inputAccount: $account)
      })
   }
   private var editButton: some View {
      Button(action: {
         prepareNewAccount()
         showingPopover = true
      }, label: {
         Text("Edit")
            .foregroundColor(.blue)
      })
   }
   func prepareNewAccount() {
      
      // Old Account
      oldAccount.balance.value = String(account.balance)
      oldAccount.debit = account.debit
      oldAccount.isCurrent = account.isCurrent
      oldAccount.name = account.name
      oldAccount.notes = account.notes
      oldAccount.onDashboard = account.onDashboard
      oldAccount.userOrder = account.userOrder
      
      // New Account
      newAccount.debit = account.debit
      newAccount.isCurrent = account.isCurrent
      newAccount.notes = account.notes
      newAccount.onDashboard = account.onDashboard
      newAccount.userOrder = account.userOrder
   }
}

struct AccountDetailView_Previews: PreviewProvider {
   static var previews: some View {
      AccountDetailView(account: AccountEntity())
   }
}
