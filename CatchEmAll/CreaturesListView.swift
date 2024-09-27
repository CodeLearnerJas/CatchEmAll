//
//  CreatureListView.swift
//  CatchEmAll
//
//  Created by GuitarLearnerJas on 23/9/2024.


import SwiftUI

struct CreaturesListView: View {
    @StateObject var creaturesVM = CreaturesViewModel()
    @State var searchText: String = ""
    
    var body: some View {
        NavigationStack{
            ZStack {
                
                List(searchResults) { creature in
                    LazyVStack {
                        NavigationLink {
                            DetailedView(creature: creature)
                        } label: {
                            Text(creature.name.capitalized)
                                .font(.title2)
                        }
                    }
                    .onAppear() {
                        Task {
                            await creaturesVM.loadNextIfNeeded(creature: creature)
                        }
                    }
                }
                .searchable(text: $searchText)
                .listStyle(PlainListStyle())
                .navigationTitle("Pokemon")
                .toolbar {
                    ToolbarItem (placement: .bottomBar) {
                        Button("Load All") {
                            Task{
                                await creaturesVM.loadAll()
                            }
                        }
                    }
                    ToolbarItem (placement: .status) {
                        Text("\(creaturesVM.creaturesArray.count) of \(creaturesVM.count) creatures")
                    }
                }
                
                if creaturesVM.isLoading == true {
                    ProgressView()
                        .tint(.red)
                        .scaleEffect(4)
                }
            }
        }
        .task {
            await creaturesVM.getData()
        }
    }
    var searchResults: [Creature] {
        if searchText.isEmpty {
            return creaturesVM.creaturesArray
        } else {
            return creaturesVM.creaturesArray.filter
            {$0.name.capitalized.contains(searchText)}
        }
    }
}
#Preview {
    CreaturesListView()
}
