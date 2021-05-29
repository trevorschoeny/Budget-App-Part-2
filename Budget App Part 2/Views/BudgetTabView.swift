//
//  BudgetTabView.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 5/28/21.
//

import SwiftUI

struct BudgetTabView: View {
    var body: some View {
      TabView {
         SummaryView()
            .tabItem {
               VStack {
                  Image(systemName: "dollarsign.circle")
                  Text("Summary")
               }
            }
         TransactionListView()
            .tabItem {
               VStack {
                  Image(systemName: "list.bullet")
                  Text("Transactions")
               }
            }
         NewTransactionView()
            .tabItem {
               VStack {
                  Image(systemName: "plus.circle.fill")
               }
            }
         AccountView()
            .tabItem {
               VStack {
                  Image(systemName: "rectangle.3.offgrid.fill")
                  Text("Accounts")
               }
            }
         AnalyticsView()
            .tabItem {
               VStack {
                  Image(systemName: "chart.bar.xaxis")
                  Text("Analytics")
               }
            }
      }
      .environmentObject(TransactionModel())
    }
}

struct BudgetTabView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetTabView()
    }
}
