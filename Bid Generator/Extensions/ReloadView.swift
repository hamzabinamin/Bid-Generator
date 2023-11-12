//
//  ReloadView.swift
//  Bid Generator
//
//  Created by Hamza Amin on 24/12/2023.
//

import Foundation

class ReloadView: ObservableObject {
    func reloadView() {
        objectWillChange.send()
    }
}
