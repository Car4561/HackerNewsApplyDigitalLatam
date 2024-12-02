//
//  NewWebViewEvent.swift
//  HackerNewsWebView
//
//  Created by Carlos Llerena on 2/12/24.
//

import Foundation

struct WebViewEvent: Decodable {
    
    // MARK: - Properties
    
    let event: WebViewData
    
}

/// Object to parse from webview calls
struct WebViewData: Decodable {
    
    // MARK: - Properties
    
    let action: String
    let currentStep: String
    let data: ActionData
    
    enum CodingKeys: String, CodingKey {
        
        case action
        case currentStep = "where"
        case data
        
    }
    
}

/// Object to set different actions for webview
struct ActionData: Decodable {
    
    // MARK: - Properties
    
    let isVisible: Bool?
    let goTo: String?
    let base64Img: String?
    let type: String?
    let error: WebViewError?
    let base64File: String?
    let hideBackButton: Bool?
    let cardDelivery: [String: Any]?
    
    enum CodingKeys: String, CodingKey {
        
        case isVisible
        case goTo
        case base64Img
        case type
        case error
        case base64File
        case hideBackButton
        case cardDelivery
        
    }
    
    // MARK: - Lifecycle
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isVisible = try container.decodeIfPresent(Bool.self, forKey: .isVisible)
        goTo = try container.decodeIfPresent(String.self, forKey: .goTo)
        base64Img = try container.decodeIfPresent(String.self, forKey: .base64Img)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        error = try container.decodeIfPresent(WebViewError.self, forKey: .error)
        base64File = try container.decodeIfPresent(String.self, forKey: .base64File)
        hideBackButton = try container.decodeIfPresent(Bool.self, forKey: .hideBackButton)
        cardDelivery = try container.decodeIfPresent([String: Any].self, forKey: .cardDelivery)
    }
    
}

/// Object to setup different available error codes
struct WebViewError: Codable {
    
    // MARK: - Properties
    
    let type: String
    let code: String
    
}

/// Object to setup different available actions for webview
enum ActionType: String {
    
    /// Indicates the loading of the MFE.
    case loader
    /// Indicates a page change within the same microfront.
    case navigation
    /// Indicates the channel should proceed to its native flow.
    case navigationChannel = "navigation-channel"
    /// Indicates the channel should redirect to a third-party channel
    case redirect
    /// Indicates the user has seen an error modal, and the channel should handle the redirection.
    case errorModalChannel = "error-modal-click-channel"
    /// Indicates the user pressed a button and the channel can handle the action.
    case understandButton = "btnEntendido_Click"
    /// Indicates that the channel will receive a base64Img type string
    case downloadPdf = "download-pdf"
    /// Indicates that the channel will receive a base64File type string
    case downloadFile = "download-file"
    /// Indicates that the channel will receive a boolean to modify the header
    case hideBackButton = "custom-header"

}

/// `JSONCodingKeys` is a custom coding key structure that enables the decoding
/// of keys as `String` or `Int`, providing flexibility for working with
/// JSON objects with dynamic or mixed-type keys.
private struct JSONCodingKeys: CodingKey {
    
    // MARK: - Properties
    
    /// The string representation of the key.
    var stringValue: String
    /// The integer representation of the key, if available.
    var intValue: Int?

    // MARK: - Lifecycle
    
    /// Initializes a `JSONCodingKeys` instance with a string value.
    /// - Parameter stringValue: The string representation of the key.
    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    /// Initializes a `JSONCodingKeys` instance with an integer value.
    /// This converts the integer to a string and sets `intValue`.
    /// - Parameter intValue: The integer representation of the key.
    init?(intValue: Int) {
        self.init(stringValue: "\(intValue)")
        self.intValue = intValue
    }
    
}

/// Extension on `KeyedDecodingContainer` to decode JSON data with dynamic key types,
/// enabling decoding of dictionaries with values of mixed types, such as `[String: Any]`.
private extension KeyedDecodingContainer {
    
    /// Decodes an optional dictionary with `String` keys and `Any` values if the key is present.
    /// - Parameters:
    ///   - type: The type to decode, specified as `[String: Any].self`.
    ///   - key: The key that identifies the nested container to decode.
    /// - Returns: A dictionary containing the decoded values if the key is present, otherwise `nil`.
    func decodeIfPresent(_ type: Dictionary<String, Any>.Type, forKey key: K) throws -> Dictionary<String, Any>? {
        guard contains(key) else { return nil }
        guard try decodeNil(forKey: key) == false else { return nil }
        return try decode(type, forKey: key)
    }

    /// Decodes a nested dictionary with `String` keys and `Any` values.
    /// - Parameters:
    ///   - type: The type to decode, specified as `[String: Any].self`.
    ///   - key: The key that identifies the nested container to decode.
    /// - Returns: A dictionary containing the decoded values.
    private func decode(_ type: Dictionary<String, Any>.Type, forKey key: K) throws -> Dictionary<String, Any> {
        let container = try nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
        return try container.decode(type)
    }

    /// Decodes a dictionary with `String` keys and `Any` values from the container.
    /// This method iterates over each key in the container and attempts to decode
    /// each value as a specific type (`Bool`, `String`, `Int`, `Double`, or nested dictionary).
    /// - Parameter type: The type to decode, specified as `[String: Any].self`.
    /// - Returns: A dictionary containing the decoded key-value pairs.
    private func decode(_ type: Dictionary<String, Any>.Type) throws -> Dictionary<String, Any> {
        var dictionary = Dictionary<String, Any>()
        for key in allKeys {
            if let boolValue = try? decode(Bool.self, forKey: key) {
                dictionary[key.stringValue] = boolValue
            } else if let stringValue = try? decode(String.self, forKey: key) {
                dictionary[key.stringValue] = stringValue
            } else if let intValue = try? decode(Int.self, forKey: key) {
                dictionary[key.stringValue] = intValue
            } else if let doubleValue = try? decode(Double.self, forKey: key) {
                dictionary[key.stringValue] = doubleValue
            } else if let nestedDictionary = try? decode(Dictionary<String, Any>.self, forKey: key) {
                dictionary[key.stringValue] = nestedDictionary
            }
        }
        return dictionary
    }
    
}
