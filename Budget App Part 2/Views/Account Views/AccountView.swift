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
   
   @State private var showAlert = false
   @State private var selectedAccountIndexSet: IndexSet?
   
   var body: some View {
      NavigationView {
         List {
            ForEach(accountModel.savedEntities) { a in
               NavigationLink(
                  destination: AccountDetailView(account: a),
                  label: {
                     HStack {
                        VStack(alignment: .leading) {
                           Text(a.name ?? "No Name")
                           HStack {
                              if a.debit {
                                 Text("Debit Account")
                              } else {
                                 Text("Credit Account")
                              }
                           }
                           .foregroundColor(.gray)
                           .font(/*@START_MENU_TOKEN@*/.footnote/*@END_MENU_TOKEN@*/)
                        }
                        Spacer()
                        if a.balance >= 0 {
                           Text("$" + String(a.balance) )
                              .foregroundColor(.green)
                              .padding(.trailing)
                        }
                        else {
                           Text("($" + String(abs(a.balance)) + ")")
                              .foregroundColor(.red)
                              .padding(.trailing)
                        }
                     }
                  })
            }
            .onDelete(perform: { indexSet in
               self.selectedAccountIndexSet = indexSet
                self.showAlert = true
//                self.deleteIndexSet = indexSet
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
