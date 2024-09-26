//
//  CreatureListView.swift
//  CatchEmAll
//
//  Created by GuitarLearnerJas on 23/9/2024.


import SwiftUI

struct CreaturesListView: View {
    @StateObject var creaturesVM = CreaturesViewModel()
    
    var body: some View {
        NavigationStack{
            ZStack {
               
                List(0..<creaturesVM.creaturesArray.count, id: \.self) { index in
                    LazyVStack {
                        NavigationLink {
                            DetailedView(creature: creaturesVM.creaturesArray[index])
                        } label: {
                            Text("\(index+1). \(creaturesVM.creaturesArray[index].name.capitalized)")
                                .font(.title2)
                        }
                    }
                    .onAppear() {
                        if let lastCreature = creaturesVM.creaturesArray.last {
                            if creaturesVM.creaturesArray[index].name == lastCreature.name && creaturesVM.urlString .contains("http") {
                                Task {
                                    await creaturesVM.getData()
                                }
                            }
                        }
                    }
                }
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
}

#Preview {
    CreaturesListView()
}
