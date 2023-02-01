//
//  AddTaskToManifestView.swift
//  Listomania
//
//  Created by Dylan Elliott on 25/10/21.
//

import Foundation
import SwiftUI

struct AddTaskToManifestView: View {
    @State var title: String = ""
    @State var addToManifest: Bool = false
    @State var completion: ((String, Bool)?) -> Void
    @FocusState private var focusTextField: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black)
                .opacity(0.3)
            VStack {
                ZStack {
                    Text("Add Task")
                        .font(.title)
                        .fontWeight(.bold)
                        .focused($focusTextField)
                    
                    HStack {
                        Button {
                            completion(nil)
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                        .frame(alignment: .leading)
                        Spacer()
                    }

                }
                
                TextField("Task title", text: $title, prompt: Text("Title"))
                    .multilineTextAlignment(.center)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                HStack {
                    Toggle("Add to manifest", isOn: $addToManifest)
                }
                Button("Add") {
                    completion((title, addToManifest))
                }
                .buttonStyle(RaisedButtonStyle())
            }
            .padding()
            .background(Color.white)
            .frame(width: 300)
            .cornerRadius(10)
            .offset(y: -100)
        }
        .background(BackgroundBlurView())
        .edgesIgnoringSafeArea(.all)
    }
}

struct AddTaskToManifestView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskToManifestView { _ in
            //
        }
    }
}
