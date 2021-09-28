//
//  TextEntryModal.swift
//  Turtles
//
//  Created by Dylan Elliott on 27/9/21.
//

import SwiftUI

struct TextEntryModal: View {
    @State var value: String = ""
    var completion: (String?) -> Void
    var body: some View {
        VStack {
            Spacer()
            
            VStack {
                Text("Title")
                    .font(.largeTitle)
                TextField("Text", text: $value, prompt: Text("Placeholder"))
                    .multilineTextAlignment(.center)
                HStack {
                    Button {
                        completion(nil)
                    } label: {
                        Text("Cancel")
                    }
                    .frame(maxWidth: .infinity)
                    .buttonStyle(BorderedButtonStyle())
                    
                    Button {
                        completion(value)
                    } label: {
                        Text("OK")
                    }
                    .frame(maxWidth: .infinity)
                    .buttonStyle(BorderedProminentButtonStyle())

                }
            }
            .padding()
            .background(Color.white)
        }
        .background(Color.blue)
    }
}

struct TextEntryModal_Previews: PreviewProvider {
    static var previews: some View {
        TextEntryModal(completion: {
            print("Text: \($0 ?? "None")")
        })
    }
}
