//
//  SummaryView.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 5/28/21.
//

import SwiftUI

struct DashboardView: View {
   @EnvironmentObject var transactionModel:TransactionModel
   @EnvironmentObject var accountModel:AccountModel
   @EnvironmentObject var budgetModel:BudgetModel
   
//   @State private var editMode = EditMode.inactive
   @State private var showingPopover = false
   
   init() {
      
   }
   
   var body: some View {
      NavigationView {
         VStack {
            List {
               Section(header: Text("Accounts")) {
                  ForEach (accountModel.savedEntities.filter({ a in
                     a.onDashboard
                  }), id: \.self) { a in
                     AccountListItemView(a: a)
                  }
               }
               Section(header: Text("Budgets")) {
                  ForEach (budgetModel.savedEntities.filter({ b in
                     b.onDashboard
                  })) { b in
                     Text(b.name ?? "")
                  }
               }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Dashboard")
//            .navigationBarItems(leading: EditButton(), trailing: addButton)
//            .environment(\.editMode, $editMode)
         }
      }
   }
//   private var addButton: some View {
//      switch editMode {
//      case .inactive:
//         return AnyView(
//            Button(action: {
//               showingPopover = true
//            }, label: {
//               Image(systemName: "plus.circle")
//            })
//         )
//      default:
//         return AnyView(EmptyView())
//      }
//   }
}

struct SummaryView_Previews: PreviewProvider {
   static var previews: some View {
      DashboardView()
   }
}
