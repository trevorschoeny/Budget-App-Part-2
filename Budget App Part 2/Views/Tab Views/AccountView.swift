//
//  AccountView.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 5/28/21.
//

import SwiftUI

struct AccountView: View {
   @EnvironmentObject var accountModel:AccountModel
   @State private var editMode = EditMode.inactive
   @State private var showingPopover = false
   
   var body: some View {
      NavigationView {
         List {
            ForEach(accountModel.savedEntities) { a in
               HStack {
                  if a.debit {
                     Text(a.name ?? "No Name")
                        .foregroundColor(.green)
                     Text("•")
                        .foregroundColor(.green)
                     Text("$" + String(a.balance) )
                        .foregroundColor(.green)
//                     Text("• \(a.userOrder)")
//                        .foregroundColor(.green)
                  }
                  else {
                     Text(a.name ?? "No Name")
                        .foregroundColor(.red)
                     Text("•")
                        .foregroundColor(.red)
                     Text("$" + String(a.balance) )
                        .foregroundColor(.red)
//                     Text("• \(a.userOrder)")
//                        .foregroundColor(.red)
                  }
               }
            }
            .onDelete(perform: { indexSet in
               accountModel.deleteAccount(indexSet: indexSet)
            })
            .onMove(perform: move)
         }
         .navigationTitle("Accounts")
         .navigationBarItems(leading: EditButton(), trailing: addButton)
         .environment(\.editMode, $editMode)
      }
      .popover(isPresented: $showingPopover, content: {
         NewAccountView()
      })
   }
   private func move(from source: IndexSet, to destination: Int) {
      accountModel.savedEntities.move(fromOffsets: source, toOffset: destination)
      //accountModel.savedEntities[IndexSet.first ?? 0].index = Int64(destination)
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
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
         .environmentObject(AccountModel())
    }
}
