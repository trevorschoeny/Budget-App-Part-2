//
//  BudgetTabView.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 5/28/21.
//

import SwiftUI

extension UIApplication {
    func addTapGestureRecognizer() {
        guard let window = windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        tapGesture.name = "MyTapGesture"
        window.addGestureRecognizer(tapGesture)
    }
 }

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false // set to `false` if you don't want to detect tap during other gestures
    }
}

struct BudgetTabView: View {
    var body: some View {
      TabView {
         DashboardView()
            .tabItem {
               VStack {
                  Image(systemName: "dollarsign.circle")
                  Text("Dashboard")
               }
            }
         FilteredTransactionListView()
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
//                  Text("Add Transaction")
               }
            }
         AccountView()
            .tabItem {
               VStack {
                  Image(systemName: "rectangle.3.offgrid.fill")
                  Text("Accounts")
               }
            }
         BudgetView()
            .tabItem {
               VStack {
                  Image(systemName: "chart.pie.fill")
                  Text("Budgets")
               }
            }
      }
      .environmentObject(TransactionModel())
      .environmentObject(AccountModel())
      .environmentObject(BudgetModel())
    }
}

extension UIView {
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self }

        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }

        return nil
    }
}

struct BudgetTabView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetTabView()
    }
}
