//
//  DetailedView.swift
//  CatchEmAll
//
//  Created by GuitarLearnerJas on 25/9/2024.
//

import SwiftUI

struct DetailedView: View {
    @StateObject var creatureDetailVM = CreaturesDetailViewModel()
    var creature: Creature
    
    var body: some View {
        VStack (alignment: .leading, spacing: 3) {
            Text("\(creature.name.capitalized)")
                .font(Font.custom("Avenir Next Condensed", size: 60))
                .bold()
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray)
                .padding(.bottom)
            HStack {
                
                creatureImage
                
                VStack (alignment: .leading) {
                    HStack (alignment: .top){
                        Text("Height:")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.red)
                        Text(String(format: "%.1f", creatureDetailVM.height))
                            .font(.largeTitle)
                            .bold()
                            .minimumScaleFactor(0.5)
                            .frame(maxHeight: 30)
                    }
                    
                    HStack (alignment: .top){
                        Text("Weight:")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.red)
                        Text(String(format: "%.1f", creatureDetailVM.weight))
                            .font(.largeTitle)
                            .bold()
                            .minimumScaleFactor(0.5)
                            .frame(maxHeight: 30)
                    }
                }
            }
            Spacer()
        }
        .padding()
        .task {
            creatureDetailVM.urlString = creature.url
            //Assign the pokemon url here, dont assign url in CreatureDetailViewModel because 'creature' is not in that scope
            await creatureDetailVM.getData()
        }
    }
}
extension DetailedView {
    var creatureImage: some View {
        AsyncImage(url: URL(string: creatureDetailVM.imageURL)) { phase in
            if let image = phase.image {
                //valid
                image
                    .resizable()
                    .scaledToFit()
                    .background(.white)
                    .frame(width: 96, height: 96)
                    .cornerRadius(16)
                    .shadow(radius: 8, x: 5, y: 5)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    }
                    .padding(.trailing)
            } else if phase.error != nil {
                //error
                Image(systemName: "questionmark.square.dashed")
                    .resizable()
                    .scaledToFit()
                    .background(.white)
                    .frame(width: 96, height: 96)
                    .cornerRadius(16)
                    .shadow(radius: 8, x: 5, y: 5)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    }
            } else {
                //use a placeholder
                Rectangle()
                    .background(.clear)
                    .frame(width: 96, height: 96)
                    .padding(.trailing)
            }
        }
    }
}

#Preview {
    DetailedView(creature: Creature(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"))
}
