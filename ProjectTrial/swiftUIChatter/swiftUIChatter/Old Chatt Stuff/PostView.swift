//
//  PostView.swift
//  swiftUIChatter
//
//  Created by Jason Obrycki on 10/18/22.
//

import SwiftUI

struct PostView: View {
    let username = "obryckij"
    @State var message = "Some short sample text."
    @Binding var isPresented: Bool
    @State private var isPresenting = false
    
    var body: some View {
        NavigationView{
            VStack {
                Text(username)
                    .padding(.top, 30.0)
                TextEditor(text: $message)
                    .padding(EdgeInsets(top: 10, leading: 18, bottom: 0, trailing: 4))
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                ToolbarItem(placement: .principal) {
                    Text("Post")
                }
                ToolbarItem(placement:.navigationBarTrailing) {
                    Button(action: {
                        

                        
                        isPresented.toggle()
                    }) {
                        Image(systemName: "paperplane")
                    }
                }
            }
        }
    }
}
