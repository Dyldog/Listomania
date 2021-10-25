//
//  CheckView.swift
//  Listomania
//
//  Created by Dylan Elliott on 25/10/21.
//

import SwiftUI

struct CheckView: View {
   @State var isChecked:Bool = false
   func toggle(){
       isChecked = !isChecked
       onChange(isChecked)
   }
    let onChange: (Bool) -> Void
   var body: some View {
       GeometryReader { geometry in
           Button(action: toggle){
               ZStack {
//                   RoundedRectangle(cornerRadius: 50)
//                       .foregroundColor(.black.opacity(0.0))
                   
                   Image(systemName: "square")
                       .renderingMode(.template)
                       .resizable()
                       .foregroundColor(.black.opacity(0.1))
                   
                   Image(systemName: "checkmark")
                       .resizable()
                       .font(.title.weight(.heavy))
                       .foregroundColor(.blue)
                       .aspectRatio(1, contentMode: .fit)
                       .frame(width: geometry.size.width * 1/2)
                       .opacity(isChecked ? 1 : 0)
               }
           }
       }
       .aspectRatio(1, contentMode: .fit)
   }

}

struct CheckView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CheckView(isChecked: false, onChange: { _ in })
                .previewLayout(PreviewLayout.sizeThatFits)
            CheckView(isChecked: true, onChange: { _ in })
                .previewLayout(PreviewLayout.sizeThatFits)
        }
    }
}
