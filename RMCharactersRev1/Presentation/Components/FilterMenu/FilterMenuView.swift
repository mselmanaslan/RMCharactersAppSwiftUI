//
//  FilterMenuView.swift
//  RMCharactersRev1
//
//  Created by Selman Aslan on 9.03.2024.
//
import SwiftUI

struct FilterMenuView: View {
    @ObservedObject var viewModel: FilterMenuViewModel
    
    var body: some View {
        VStack {
            if viewModel.isFilterMenuOpen {
                HStack {
                    Text("Filter By")
                        .padding(.leading)
                        .font(.title)
                        .bold()
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    Spacer()
                }
                HStack {
                    Text("Name   ")
                        .padding(.leading)
                    TextField("Character Name", text: $viewModel.filter.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .foregroundColor(.black)
                }
                HStack {
                    Text("Status")
                        .padding(.leading)
                    Spacer()
                    Picker("", selection: $viewModel.filter.status) {
                        Text("All").tag("")
                        Text("Dead").tag("Dead")
                        Text("Alive").tag("Alive")
                        Text("Unknown").tag("unknown")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .colorMultiply(.white).colorInvert()
                    .colorMultiply(.orange).colorInvert()
                }
                HStack {
                    Text("Species")
                        .padding(.leading)
                    TextField("Species", text: $viewModel.filter.species)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .foregroundColor(.black)
                }
                HStack {
                    Text("Gender")
                        .padding(.leading)
                    Spacer()
                    Picker("", selection: $viewModel.filter.gender) {
                        Text("All").tag("")
                        Text("Male").tag("Male")
                        Text("Female").tag("Female")
                        Text("Genderless").tag("Genderless")
                        Text("Unknown").tag("unknown")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .colorMultiply(.white).colorInvert()
                    .colorMultiply(.orange).colorInvert()
                }
            } else {
                HStack {
                    filterButton(for: viewModel.filter.name, action: { viewModel.filter.name = "" })
                    filterButton(for: viewModel.filter.status, action: { viewModel.filter.status = "" })
                    filterButton(for: viewModel.filter.species, action: { viewModel.filter.species = "" })
                    filterButton(for: viewModel.filter.gender, action: { viewModel.filter.gender = "" })
                    Spacer()
                }
            }
        }
        .onChange(of: viewModel.filter, {
            viewModel.setFilterParameters(viewModel.filter)
        })
    }

    private func filterButton(for text: String, action: @escaping () -> Void) -> AnyView {
        if !text.isEmpty {
            return AnyView(
                Button(action: action) {
                    HStack {
                        Image(systemName: "xmark.circle")
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                        Text(text)
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                    }
                    .frame(width: 75, height: 30)
                    .background(Color.blue)
                    .cornerRadius(25)
                    .padding(.leading)
                }
            )
        } else {
            return AnyView(EmptyView())
        }
    }
}
