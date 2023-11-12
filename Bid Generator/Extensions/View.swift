//
//  View.swift
//  Bid Generator
//
//  Created by Hamza Amin on 29/11/2023.
//

import SwiftUI

extension View {
    /// Navigate to a new view.
    /// - Parameters:
    ///   - view: View to navigate to.
    ///   - binding: Only navigates when this condition is `true`.
    func navigate<NewView: View>(to view: NewView, when binding: Binding<Bool>) -> some View {
        NavigationView {
            ZStack {
                self
                  //  .navigationBarTitle("")
                 //   .navigationBarHidden(true)

                NavigationLink(
                    destination: view,
                     //   .navigationBarTitle("")
                    //    .navigationBarHidden(true),
                    isActive: binding
                )
                {
                    EmptyView()
                }
            }
            .accentColor(.white)
       
        }
        .accentColor(.white)
        .navigationViewStyle(.stack)
    }
    
    @ViewBuilder func isHidden(_ isHidden: Bool) -> some View {
        if isHidden {
            self.hidden()
        }
        else {
            self
        }
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}
