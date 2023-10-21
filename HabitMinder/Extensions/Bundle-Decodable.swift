//
//  Bundle-Decodable.swift
//  HabitMinder
//
//  Created by Timothy on 27/06/2023.
//

import Foundation

extension Bundle {
    // swiftlint:disable line_length
    /// Acts as the method signature for Bundle.
    /// - Parameters:
    ///   - file: A file name that exists in whatever bundle is used here, so we know which file to load.
    ///   - type: Any type, as long as it conforms to the Decodable protocol. (Yes, really. Which means we can load any kind of decodable data.) Basically, "tell me what type of data to decode, and if possible, attempt to figure it out based on context."
    ///   - dateDecodingStrategy: A date decoding strategy to handle dates in whatever way makes sense for this JSON file. Defaults to `.deferredToDate`, the default behaviour for `Codable`.``
    ///   - keyDecodingStrategy: A key decoding strategy to convert between snake_case and camelCase. (Again, this has a default value that matches `Codable`.)
    /// - Returns: a T.
    func decode<T: Decodable>(
        _ file: String,
        as type: T.Type = T.self,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
    ) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy

        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing key '\(key.stringValue) - \(context.debugDescription)'")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("Failed to decode \(file) from bundle due to type mismatch - \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing \(type) value - \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            fatalError("Failed to decode \(file) from bundle because it appears to be invalid JSON")
        } catch {
            fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription)")
        }
    }
}
// swiftlint:enable line_length
