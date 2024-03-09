//
//  HeaderView.swift
//  RMCharactersRev1
//
//  Created by Selman Aslan on 8.03.2024.
//

import SwiftUI

struct HeaderView: View {
    @ObservedObject var viewModel: HeaderViewModel

    var body: some View {
        HStack {
            Text(viewModel.headerTitle)
                .font(.title)
                .fontWeight(.bold)
                .lineLimit(2)
                .shadow(color: .black, radius: 0.5)
                .foregroundColor(.black)
                .padding(.leading, 20)
            Spacer()
            Button {
                viewModel.isFilterMenuOpen()
            } label: {
                Text("Filter")
                    .font(.system(size: 26))
                    .bold()
                    .padding()
            }
        }
    }
}
