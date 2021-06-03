//
//  SearchBarView.swift
//  Budget App Part 2
//
//  Created by Trevor Schoeny on 6/3/21.
//

import SwiftUI

struct SearchBarView: View {
   @Binding var text: String
   
   @Binding var isSearching: Bool
   
   var body: some View {
      HStack {
         
         TextField("Search ...", text: $text)
            .padding(7)
            .padding(.horizontal, 25)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .overlay(
               HStack {
                  Image(systemName: "magnifyingglass")
                     .foregroundColor(.gray)
                     .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                     .padding(.leading, 8)
                  
                  if isSearching {
                     Button(action: {
                        self.text = ""
                        self.isSearching = false
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                     }) {
                        Image(systemName: "multiply.circle.fill")
                           .foregroundColor(.gray)
                           .padding(.trailing, 8)
                     }
                  }
               }
            )
            .padding(.horizontal, 10)
            .onTapGesture {
               self.isSearching = true
            }
      }
   }
}
//
//struct SearchBarView_Previews: PreviewProvider {
//   static var previews: some View {
//      SearchBarView(text: .constant(""), isEditing: $false)
//   }
//}
