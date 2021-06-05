//
//  BudgetView.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 5/28/21.
//

import SwiftUI

struct BudgetView: View {
   @EnvironmentObject var budgetModel:BudgetModel
   @State private var editMode = EditMode.inactive
   @State private var showingPopover = false
   
   @State private var showAlert = false
   @State private var selectedBudgetIndexSet: IndexSet?
   
   var body: some View {
      NavigationView {
         List {
            ForEach(budgetModel.savedEntities) { a in
               NavigationLink(destination: DashboardView()) {
                  HStack(spacing: 0) {
                     Text(a.name ?? "No Name")
                     Spacer()
                     if a.balance < 0 {
                        Text("($" + String(a.balance) + ")")
                           .foregroundColor(.red)
                     }
                     else if a.balance == 0 {
                        Text("$" + String(abs(a.balance)))
                           .foregroundColor(.red)
                     }
                     else if a.balance <= (a.budgetAmount * 0.25) {
                        Text("$" + String(abs(a.balance)))
                           .foregroundColor(.orange)
                     }
                     else if a.balance <= (a.budgetAmount * 0.5) {
                        Text("$" + String(abs(a.balance)))
                           .foregroundColor(.yellow)
                     }
                     else {
                        Text("$" + String(abs(a.balance)))
                           .foregroundColor(.green)
                     }
                     Text(" left of ")
                        .foregroundColor(.gray)
                        .font(.footnote)
                        .offset(y: 2)
                     Text("$" + String(a.budgetAmount))
                  }
               }
            }
            .onDelete(perform: { indexSet in
               self.selectedBudgetIndexSet = indexSet
               self.showAlert = true
            })
            .onMove { (indexSet, index) in
               self.budgetModel.savedEntities.move(fromOffsets: indexSet, toOffset: index)
               for i in 0..<budgetModel.savedEntities.count {
                  budgetModel.savedEntities[i].userOrder = Int16(i)
               }
               budgetModel.saveData()
            }
         }
         .navigationTitle("Budgets")
         .navigationBarItems(leading: EditButton(), trailing: addButton)
         .environment(\.editMode, $editMode)
      }
      .popover(isPresented: $showingPopover, content: {
         NewBudgetView()
      })
      .alert(isPresented: $showAlert, content: {
         Alert(title: Text("Are you sure?"),
               message: Text("Once deleted, this account is not recoverable."),
               primaryButton: .destructive(Text("Delete")) {
                  if budgetModel.savedEntities.count > 0 {
                     self.budgetModel.deleteBudget(indexSet: selectedBudgetIndexSet ?? IndexSet())
                  }
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

struct BudgetView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetView()
         .environmentObject(BudgetModel())
    }
}
