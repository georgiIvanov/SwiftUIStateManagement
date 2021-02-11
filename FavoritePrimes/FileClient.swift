//
//  FileClient.swift
//  FavoritePrimes
//
//  Created by Voro on 11.02.21.
//

import Foundation
import ComposableArchitecture

struct FileClient {
    var load: (String) -> Effect<Data?>
    
    /// We want an effect that can never produce a value and send an action back to the system
    var save: (String, Data) -> Effect<Never>
}

extension FileClient {
    static let live = FileClient { (fileName) -> Effect<Data?> in
        .sync {
            guard let data = try? Data(contentsOf: getFavoritePrimesUrl(fileName: fileName)),
                  let favoritePrimes = try? JSONDecoder().decode([Int].self, from: data) else {
                return nil
            }
            
            return data
        }
    } save: { (fileName, data) -> Effect<Never> in
        .fireAndForget {
            let data = try! JSONEncoder().encode(data)
            try! data.write(to: getFavoritePrimesUrl(fileName: fileName))
        }
    }

    private static func getFavoritePrimesUrl(fileName: String) -> URL {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                               .userDomainMask,
                                                               true)[0]
        
        let documentsUrl = URL(fileURLWithPath: documentPath)
        let favoritePrimesUrl = documentsUrl.appendingPathComponent(fileName)
        return favoritePrimesUrl
    }
}
