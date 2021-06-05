//
//  PeriodsView.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 6/5/21.
//

import SwiftUI

struct PeriodsView: View {
   
   @Environment(\.presentationMode) var isPresented
   @EnvironmentObject var budgetModel:BudgetModel
   @State var budget: BudgetEntity
   @State private var editMode = EditMode.inactive
   @State var periodArr: [Date]
   
   var body: some View {
      NavigationView {
         List {
            if budget.periods != nil {
               ForEach(0..<periodArr.count) { i in
                  HStack {
                     Text(periodArr[i], style: .date)
                     if editMode.isEditing {
                        DatePicker("", selection: $periodArr[i], displayedComponents: .date)
                           .onDisappear {
                              budget.periods![i] = periodArr[i]
                              budget.periods?.sort(by: { $0 > $1 })
                              budgetModel.saveData()
                           }
                     }
                  }
               }
               .onDelete(perform: { indexSet in
                  budget.periods?.remove(at: indexSet.first ?? 0)
                  budgetModel.saveData()
                  self.isPresented.wrappedValue.dismiss()
               })
            }
         }
         .listStyle(InsetGroupedListStyle())
         .navigationTitle("Past Periods")
         .navigationBarItems(trailing: EditButton())
         .environment(\.editMode, $editMode)
      }
   }
}

struct PeriodsView_Previews: PreviewProvider {
   static var previews: some View {
      PeriodsView(budget: BudgetEntity(), periodArr: [Date()])
   }
}
