//
//  BudgetView.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 5/28/21.
//

import SwiftUI

struct BudgetView: View {
   @EnvironmentObject var transactionModel:TransactionModel
   @EnvironmentObject var budgetModel:BudgetModel
   @State private var editMode = EditMode.inactive
   @State private var showingPopover = false
   
   @State private var showAlert = false
   @State private var showAlertPeriod = false
   @State private var selectedBudgetIndexSet: IndexSet?
   
   var body: some View {
      NavigationView {
         VStack {
            List {
               ForEach(budgetModel.savedEntities) { b in
                  BudgetListItemView(b: b)
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
            
            // MARK: New Period
            Button(action: {
               showAlertPeriod = true
            }, label: {
               ZStack {
                  Rectangle()
                     .font(.headline)
                     .foregroundColor(Color(#colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)))
                     .frame(height: 55)
                     .cornerRadius(10)
                     .padding(.horizontal)
                  Text("New Period")
                     .font(.headline)
                     .foregroundColor(.white)
               }
            })
            .alert(isPresented: $showAlertPeriod, content: {
               Alert(title: Text("Would you like to start a new period?"),
                     primaryButton: .default(Text("Yes")) {
                        for b in budgetModel.savedEntities {
                           b.balance = b.budgetAmount
                           b.periods?.append(Date())
                           budgetModel.saveData()
                        }
                     },
                     secondaryButton: .cancel())
            })
         }
      }
      .popover(isPresented: $showingPopover, content: {
         NewBudgetView()
      })
      .alert(isPresented: $showAlert, content: {
         Alert(title: Text("Are you sure?"),
               message: Text("Once deleted, this account is not recoverable."),
               primaryButton: .destructive(Text("Delete")) {
                  if budgetModel.savedEntities.count > 0 {
                     for t in transactionModel.savedEntities {
                        if t.budget == budgetModel.savedEntities[selectedBudgetIndexSet?.first ?? 0].name {
                           t.budget! += " (Retired)"
                        }
                     }
                     transactionModel.saveData()
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
                  Image(systemName: "plus.circle")
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
