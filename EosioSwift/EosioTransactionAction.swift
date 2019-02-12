//
//  EosioTransactionAction.swift
//  EosioSwift
//
//  Created by Todd Bowden on 2/5/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation
import EosioSwiftFoundation
import EosioSwiftC

public extension EosioTransaction {
    
    /// Action struct for `EosioTransaction`
    public struct Action: Codable {

        /// Contract account name
        public private(set) var account: EosioName
        /// Contract action name
        public private(set) var name: EosioName
        /// Authorization (actor and permission)
        public private(set) var authorization: [Authorization]
        /// Action data
        public private(set) var data: [String:Any]
        
        /// Action data as a json string
        public var dataJson: String? {
            return data.jsonString
        }
        /// Action data in serialized form
        public private(set) var dataSerialized: Data?
        /// Action data in serialized form as a hex string
        public var dataHex: String? {
            return dataSerialized?.hexEncodedString()
        }
        /// Is the action data serialized?
        public var isDataSerialized: Bool {
            return dataSerialized != nil
        }
        
        /// The rendered ricardian contract and metadata for this action
        public private(set) var ricardian: Ricardian?
        
        
        /// Coding keys
        enum CodingKeys: String, CodingKey {
            case account
            case name
            case authorization
            case data
        }
        
        
        /// Init Action struct with strings and an Encodable struct for data. Strings will be used to init EosioNames.
        ///
        /// - Parameters:
        ///   - account: contract account name
        ///   - name: contract action name
        ///   - authorization: authorization (actor and permission)
        ///   - data: action data (codable struct)
        /// - Throws: if the strings are not valid eosio names or data cannot be encoded
        public init(account: String, name: String, authorization: [Authorization], data: Encodable) throws {
            try self.init(account: EosioName(account), name: EosioName(name), authorization: authorization, data: data)
        }

        
        /// Init Action struct with `EosioName`s and an Encodable struct for data.
        ///
        /// - Parameters:
        ///   - account: contract account name
        ///   - name: contract action name
        ///   - authorization: authorization (actor and permission)
        ///   - data: action data (codable struct)
        /// - Throws: if the strings are not valid eosio names or data cannot be encoded
        public init(account: EosioName, name: EosioName, authorization: [Authorization], data: Encodable) throws {
            self.account = account
            self.name = name
            self.authorization = authorization
            self.data = try data.toJsonString().jsonToDictionary()
        }
        
        
        /// Init Action struct with strings and serialized data. Strings will be used to init EosioNames.
        ///
        /// - Parameters:
        ///   - account: contract account name
        ///   - name: contract action name
        ///   - authorization: authorization (actor and permission)
        ///   - dataSerialized: data in serialized form
        /// - Throws: if the strings are not valid eosio names
        public init(account: String, name: String, authorization: [Authorization], dataSerialized: Data) throws {
            try self.init(account: EosioName(account), name: EosioName(name), authorization: authorization, dataSerialized: dataSerialized)
        }
        
        
        /// Init Action struct with `EosioName`s and serialized data.
        ///
        /// - Parameters:
        ///   - account: contract account name
        ///   - name: contract action name
        ///   - authorization: authorization (actor and permission)
        ///   - dataSerialized: data in serialized form
        public init(account: EosioName, name: EosioName, authorization: [Authorization], dataSerialized: Data) {
            self.account = account
            self.name = name
            self.authorization = authorization
            self.dataSerialized = dataSerialized
            self.data = [String:Any]()
        }
        
        
        /// Init with decoder. The data property must be a hex string.
        ///
        /// - Parameter decoder: the decoder
        /// - Throws: if the input cannot be decoded into a Action struct
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            account = try container.decode(EosioName.self, forKey: .account)
            name = try container.decode(EosioName.self, forKey: .name)
            authorization = try container.decode([Authorization].self, forKey: .authorization)
            self.data = [String:Any]()
            
            if let dataString = try? container.decode(String.self, forKey: .data) {
                if let ds = Data(hexString: dataString) {
                    dataSerialized = ds
                } else {
                    throw EosioError(.parsingError, reason: "\(dataString) is not a valid hex string")
                }
            } else {
                throw EosioError(.parsingError, reason: "Data property is not set for action \(account)::\(name)")
            }
        }
        
        
        /// Encode this action using the Encodable protocol
        ///
        /// - Parameter encoder: the encoder
        /// - Throws: if the action cannot be encoded
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(account, forKey: .account)
            try container.encode(name, forKey: .name)
            try container.encode(authorization, forKey: .authorization)
            try container.encode(dataHex ?? "", forKey: .data)
        }
        
        
        /// Serialize the data from the `data` dictionary using Abieos and an abi, then set the `dataSerialized` property
        ///
        /// - Parameter abi: the abi as a json string
        /// - Throws: if the data cannot be serialized
        public mutating func serializeData(abi: String) throws {
            guard let json = dataJson else {
                throw EosioError(.serializationError, reason: "Cannot convert data to json")
            }
            let abieos = AbiEos()
            let hex = try abieos.jsonToHex(contract: account.string, name: name.string, json: json, abi: abi, isReorderable: true)
            guard let binaryData = Data(hexString: hex) else {
                throw EosioError(.serializationError, reason: "Cannot decode hex \(hex)")
            }
            self.dataSerialized = binaryData
        }
        
        
        /// Deserialize the data from the `dataSerialized` property using Abieos and an abi, then set the `data` dictionary
        ///
        /// - Parameter abi: the abi as a json string
        /// - Throws: if the data cannot be deserialized
        public mutating func deserializeData(abi: String) throws {
            let abieos = AbiEos()
            guard let dataHex = dataHex else {
                throw EosioError(.parsingError, reason: "Serialized data not set for action \(account)::\(name)")
            }
            let json = try abieos.hexToJson(contract: account.string, name: name.string, hex: dataHex, abi: abi)
            data = try json.jsonToDictionary()
        }
        
    }
    
}


extension EosioTransaction.Action {
    
    /// Authorization struct for `EosioTransaction.Action`
    public struct Authorization: Codable, Equatable {
        public var actor: EosioName
        public var permission: EosioName
        
        
        /// Init Authorization with EosioNames
        ///
        /// - Parameters:
        ///   - actor: actor as EosioName
        ///   - permission: permission as EosioName
        init(actor: EosioName, permission: EosioName) {
            self.actor = actor
            self.permission = permission
        }
        
        
        /// Init Authorization with strings
        ///
        /// - Parameters:
        ///   - actor: actor as String
        ///   - permission: permission as String
        /// - Throws: if the strings are not valid EosioNames
        init(actor: String, permission: String) throws {
            try self.init(actor: EosioName(actor), permission: EosioName(permission))
        }
        
    }
    
}


extension EosioTransaction.Action {
    
    /// Ricardian struct for `EosioTransaction.Action`
    public struct Ricardian {
        /// Rendered ricardian contract in html format
        public var html = ""
        /// Ricardian metadata (title, summary and icon)
        public var metadata = Metadata()
        /// Error rendering the ricardian contract
        public var error = ""
        
        /// Ricardian metadata (title, summary and icon)
        public struct Metadata {
            /// Action title
            public var title = ""
            /// Action summary
            public var summary = ""
            /// Action icon url
            public var icon = ""
        }
    }
    
}


