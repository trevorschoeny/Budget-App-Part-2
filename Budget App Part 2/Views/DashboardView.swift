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
   
   var body: some View {
      NavigationView {
         VStack {
            List {
               VStack(alignment: .leading, spacing: 3) {
                  HStack(spacing: 0) {
                     Text("Total Balance: ")
                     if Balances().totalBalance >= 0 {
                        Text("$" + String(Balances().totalBalance))
                           .foregroundColor(.green)
                     } else {
                        Text("($" + String(Balances().totalBalance) + ")")
                           .foregroundColor(.red)
                     }
                  }
                  HStack(spacing: 0) {
                     Text("Total Assets: ")
                        .foregroundColor(.gray)
                     Text("$" + String(Balances().totalAssets))
                        .foregroundColor(.green)
                  }
                  .font(.footnote)
                  HStack(spacing: 0) {
                     Text("Total Liabilities: ")
                        .foregroundColor(.gray)
                     Text("($" + String(Balances().totalLiabilities) + ")")
                        .foregroundColor(.red)
                  }
                  .font(.footnote)
               }
               .padding(.vertical, 5)
               VStack(alignment: .leading, spacing: 3) {
                  HStack(spacing: 0) {
                     Text("Current Balance: ")
                     if Balances().currentBalance >= 0 {
                        Text("$" + String(Balances().currentBalance))
                           .foregroundColor(.green)
                     } else {
                        Text("($" + String(Balances().currentBalance) + ")")
                           .foregroundColor(.red)
                     }
                  }
                  HStack(spacing: 0) {
                     Text("Current Assets: ")
                        .foregroundColor(.gray)
                     Text("$" + String(Balances().currentAssets))
                        .foregroundColor(.green)
                  }
                  .font(.footnote)
                  HStack(spacing: 0) {
                     Text("Current Liabilities: ")
                        .foregroundColor(.gray)
                     Text("($" + String(Balances().currentLiabilities) + ")")
                        .foregroundColor(.red)
                  }
                  .font(.footnote)
               }
               .padding(.vertical, 5)
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
