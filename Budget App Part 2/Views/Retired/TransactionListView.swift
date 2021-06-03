//
//  TransactionListView.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 5/28/21.
//

import SwiftUI

struct TransactionListView: View {
   @EnvironmentObject var model:TransactionModel
   @EnvironmentObject var accountModel:AccountModel
   @State private var editMode = EditMode.inactive
   @State private var showingPopover = false
   
   var body: some View {
      NavigationView {
         List {
            ForEach(model.savedEntities) { t in
               NavigationLink(
                  destination: TransactionDetailView(transaction: t),
                  label: {
                     TransactionListItemView(t: t)
                  })
            }
            .onDelete(perform: { indexSet in
               updateAccountBalance(indexSet: indexSet)
//               model.deleteTransaction(indexSet: indexSet)
            })
         }
         .navigationBarTitle("Transactions")
         .navigationBarItems(leading: EditButton(), trailing: addButton)
         .environment(\.editMode, $editMode)
      }
      .popover(isPresented: $showingPopover, content: {
         NewTransactionView()
      })
   }
   private var addButton: some View {
           switch editMode {
           case .inactive:
            return AnyView(
               Button(action: {
                  showingPopover = true
               }, label: {
                  Image(systemName: "plus")
               })
            )
           default:
               return AnyView(EmptyView())
           }
       }
   private func updateAccountBalance(indexSet: IndexSet) {
      for i in accountModel.savedEntities {
         if model.savedEntities[indexSet.first ?? 0].account == i.name {
            if !model.savedEntities[indexSet.first ?? 0].debit {
               i.balance += model.savedEntities[indexSet.first ?? 0].amount
            } else {
               i.balance -= model.savedEntities[indexSet.first ?? 0].amount
            }
         }
      }
      accountModel.saveData()
   }
}



struct TransactionListView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionListView()
         .environmentObject(TransactionModel())
    }
}
