//
//  CreaturesViewModel.swift
//  CatchEmAll
//
//  Created by GuitarLearnerJas on 24/9/2024.
//

import Foundation

@MainActor
class CreaturesViewModel: ObservableObject {
private struct Returned: Codable {
    var count: Int
    var next: String?
    var results: [Creature]
}
    @Published var urlString: String = "https://pokeapi.co/api/v2/pokemon"
    @Published var count: Int = 0
    @Published var creaturesArray: [Creature] = []
    @Published var isLoading: Bool = false
    
    func getData() async {
        print("🕸️ Fetching data from url \(urlString)")
        isLoading = true
        //convert urlString to s special URL type
        guard let url = URL(string: urlString) else {
            print("😡 ERROR: Could not create a URL from \(urlString)")
            isLoading = false
            return
        }
        do {
            let (data, _) =  try await URLSession.shared.data(from: url)
            //Try to decode JASON data into swift data structures
            guard let returned = try? JSONDecoder().decode(Returned.self, from: data) else {
                print("😡 JSON ERROR: Could not decode data from \(urlString)")
                isLoading = false
                return
            }
            //Decode JSON into class's properties
            self.count = returned.count
            self.urlString = returned.next ?? ""
            self.creaturesArray += returned.results
            isLoading = false
        } catch {
            isLoading = false
            print("😡 ERROR: Could not fetch data from \(urlString): \(error)")
        }
    }
    func loadAll() async {
//        guard urlString.hasPrefix("http") else { return }
//        await getData() //get next page of data
//        await loadAll()
        while urlString.hasPrefix("http") {
            await getData()
        }
    }
}
