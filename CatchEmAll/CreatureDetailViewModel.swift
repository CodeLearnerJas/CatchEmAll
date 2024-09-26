//
//  CreatureDetailViewModel.swift
//  CatchEmAll
//
//  Created by GuitarLearnerJas on 25/9/2024.
//

import Foundation

@MainActor
class CreaturesDetailViewModel: ObservableObject {
    private struct Returned: Codable {
        var height: Double
        var weight: Double
        var sprites: Sprite //For poke image
    }
    struct Sprite: Codable {
        var front_default: String?
        var other: Other
    }
    struct Other: Codable {
        var officialArtwork: OffcialArtwork
        
        enum CodingKeys: String, CodingKey {
            case officialArtwork = "official-artwork"
        }
    }
    struct OffcialArtwork: Codable {
        var front_default: String?
    }
    var urlString: String = ""
    @Published var height = 0.0
    @Published var weight = 0.0
    @Published var imageURL: String = ""
    
    func getData() async {
        print("🕸️ Fetching data from url \(urlString)")
        //convert urlString to s special URL type
        guard let url = URL(string: urlString) else {
            print("😡 ERROR: Could not create a URL from \(urlString)")
            return
        }
        do {
            let (data, _) =  try await URLSession.shared.data(from: url)
            //Try to decode JASON data into swift data structures
            guard let returned = try? JSONDecoder().decode(Returned.self, from: data) else {
                print("😡 JSON ERROR: Could not decode data from \(urlString)")
                return
            }
            //Decode JSON into class's properties
            self.height = returned.height
            self.weight = returned.weight
            self.imageURL = returned.sprites.other.officialArtwork.front_default ?? ""
        } catch {
            print("😡 ERROR: Could not fetch data from \(urlString): \(error)")
        }
    }
}
