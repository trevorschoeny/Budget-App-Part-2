//
//  BudgetListItemView.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 6/5/21.
//

import SwiftUI

struct BudgetListItemView: View {
   @ObservedObject var b: BudgetEntity
    var body: some View {
      NavigationLink(destination: BudgetDetailView(budget: b)) {
         HStack(spacing: 0) {
            Text(b.name ?? "No Name")
            Spacer()
            if b.balance < 0 {
               Text("($" + String(b.balance) + ")")
                  .foregroundColor(.red)
            }
            else if b.balance == 0 {
               Text("$" + String(abs(b.balance)))
                  .foregroundColor(.red)
            }
            else if b.balance <= (b.budgetAmount * 0.25) {
               Text("$" + String(abs(b.balance)))
                  .foregroundColor(.orange)
            }
            else if b.balance <= (b.budgetAmount * 0.5) {
               Text("$" + String(abs(b.balance)))
                  .foregroundColor(.yellow)
            }
            else {
               Text("$" + String(abs(b.balance)))
                  .foregroundColor(.green)
            }
            Text(" left of ")
               .foregroundColor(.gray)
               .font(.footnote)
               .offset(y: 2)
            Text("$" + String(b.budgetAmount))
         }
      }
    }
}

//struct BudgetListItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        BudgetListItemView()
//    }
//}
