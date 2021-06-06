//
//  AccountView.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 5/28/21.
//

import SwiftUI

struct AccountView: View {
   @EnvironmentObject var transactionModel:TransactionModel
   @EnvironmentObject var accountModel:AccountModel
   @State private var editMode = EditMode.inactive
   @State private var showingPopover = false
   
   @State private var showAlert = false
   @State private var selectedAccountIndexSet: IndexSet?
   
   var body: some View {
      NavigationView {
         List {
            ForEach(accountModel.savedEntities) { a in
               AccountListItemView(a: a)
            }
            .onDelete(perform: { indexSet in
               self.selectedAccountIndexSet = indexSet
                self.showAlert = true
            })
            .onMove { (indexSet, index) in
               self.accountModel.savedEntities.move(fromOffsets: indexSet, toOffset: index)
               for i in 0..<accountModel.savedEntities.count {
                  accountModel.savedEntities[i].userOrder = Int16(i)
               }
               accountModel.saveData()
            }
         }
         .navigationTitle("Accounts")
         .navigationBarItems(leading: EditButton(), trailing: addButton)
         .environment(\.editMode, $editMode)
      }
      .popover(isPresented: $showingPopover, content: {
         NewAccountView()
      })
      .alert(isPresented: $showAlert, content: {
         Alert(title: Text("Are you sure?"),
               message: Text("Once deleted, this account is not recoverable."),
               primaryButton: .destructive(Text("Delete")) {
                  for t in transactionModel.savedEntities {
                     if t.account == accountModel.savedEntities[(selectedAccountIndexSet?.first)!].name {
                        t.account! += " (Retired)"
                     }
                  }
                  transactionModel.saveData()
                  self.accountModel.deleteAccount(indexSet: selectedAccountIndexSet ?? IndexSet())
               },
               secondaryButton: .cancel())
      })
      
   }

   private var addButton: some View {
           switch editMode {
           case .inactive:
            return AnyView(
               Button(action: {
                  showingPopover = true
               }, label: {
                  Image(systemName: "plus.circle")
               })
            )
           default:
               return AnyView(EmptyView())
           }
       }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
         .environmentObject(AccountModel())
    }
}
