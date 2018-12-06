//
//  Chain3+Vnode.swift
//  chain3swift
//
//  Created by Alexander Vlasov on 22.12.2017.
//  Copyright © 2017 Bankex Foundation. All rights reserved.
//
//  Modifications copyright © 2018 Liwei Zhang. All rights reserved.
//

import BigInt
import Foundation
import PromiseKit

fileprivate func decodeHexToData<T>(_ container: KeyedDecodingContainer<T>, key: KeyedDecodingContainer<T>.Key, allowOptional: Bool = false) throws -> Data? {
    if allowOptional {
        let string = try? container.decode(String.self, forKey: key)
        if string != nil {
            guard let data = Data.fromHex(string!) else { throw Chain3Error.dataError }
            return data
        }
        return nil
    } else {
        let string = try container.decode(String.self, forKey: key)
        guard let data = Data.fromHex(string) else { throw Chain3Error.dataError }
        return data
    }
}

fileprivate func decodeHexToBigUInt<T>(_ container: KeyedDecodingContainer<T>, key: KeyedDecodingContainer<T>.Key, allowOptional: Bool = false) throws -> BigUInt? {
    if allowOptional {
        let string = try? container.decode(String.self, forKey: key)
        if string != nil {
            guard let number = BigUInt(string!.withoutHex, radix: 16) else { throw Chain3Error.dataError }
            return number
        }
        return nil
    } else {
        let string = try container.decode(String.self, forKey: key)
        guard let number = BigUInt(string.withoutHex, radix: 16) else { throw Chain3Error.dataError }
        return number
    }
}

/// Extension located
public class Chain3SCS: Chain3OptionsInheritable {
    /// provider for some functions
    var provider: Chain3Provider
    unowned var chain3: Chain3
    public var options: Chain3Options {
        return chain3.options
    }
    
    public init(provider prov: Chain3Provider, chain3 chain3instance: Chain3) {
        provider = prov
        chain3 = chain3instance
    }
    
    
    public func directCall() -> Promise<Data> {
        let queue = chain3.requestDispatcher.queue
        let request = JsonRpcRequestFabric.prepareRequest(.scsDirectCall, parameters: [])
        let rp = chain3.dispatch(request)
        return rp.map(on: queue) { response in
            guard let value: Data = response.getValue() else {
                if response.error != nil {
                    throw Chain3Error.nodeError(response.error!.message)
                }
                throw Chain3Error.nodeError("Invalid value from MOAC node")
            }
            return value
        }
    }
    
    public func getBlock() -> Promise<SCSBlock> {
        let queue = chain3.requestDispatcher.queue
        let request = JsonRpcRequestFabric.prepareRequest(.scsGetBlock, parameters: [])
        let rp = chain3.dispatch(request)
        return rp.map(on: queue) { response in
            guard let value: SCSBlock = response.getValue() else {
                if response.error != nil {
                    throw Chain3Error.nodeError(response.error!.message)
                }
                throw Chain3Error.nodeError("Invalid value from MOAC node")
            }
            return value
        }
    }
    
    public func getBlockNumber() -> Promise<BigUInt> {
        let queue = chain3.requestDispatcher.queue
        let request = JsonRpcRequestFabric.prepareRequest(.scsGetBlockNumber, parameters: [])
        let rp = chain3.dispatch(request)
        return rp.map(on: queue) { response in
            guard let value: BigUInt = response.getValue() else {
                if response.error != nil {
                    throw Chain3Error.nodeError(response.error!.message)
                }
                throw Chain3Error.nodeError("Invalid value from MOAC node")
            }
            return value
        }
    }
    
    public func getDappState() -> Promise<Int> {
        let queue = chain3.requestDispatcher.queue
        let request = JsonRpcRequestFabric.prepareRequest(.scsGetDappState, parameters: [])
        let rp = chain3.dispatch(request)
        return rp.map(on: queue) { response in
            guard let value: Int = response.getValue() else {
                if response.error != nil {
                    throw Chain3Error.nodeError(response.error!.message)
                }
                throw Chain3Error.nodeError("Invalid value from MOAC node")
            }
            return value
        }
    }
    
    public func getMicroChainList() -> Promise<[Address]> {
        let queue = chain3.requestDispatcher.queue
        let request = JsonRpcRequestFabric.prepareRequest(.scsGetMicroChainList, parameters: [])
        let rp = chain3.dispatch(request)
        return rp.map(on: queue) { response in
            guard let value: [Address] = response.getValue() else {
                if response.error != nil {
                    throw Chain3Error.nodeError(response.error!.message)
                }
                throw Chain3Error.nodeError("Invalid value from MOAC node")
            }
            return value
        }
    }
    
    public func getMicroChainInfo() -> Promise<MicroChainInfo> {
        let queue = chain3.requestDispatcher.queue
        let request = JsonRpcRequestFabric.prepareRequest(.scsGetMicroChainInfo, parameters: [])
        let rp = chain3.dispatch(request)
        return rp.map(on: queue) { response in
            guard let value: MicroChainInfo = response.getValue() else {
                if response.error != nil {
                    throw Chain3Error.nodeError(response.error!.message)
                }
                throw Chain3Error.nodeError("Invalid value from MOAC node")
            }
            return value
        }
    }
    
    public func getNonce() -> Promise<BigUInt> {
        let queue = chain3.requestDispatcher.queue
        let request = JsonRpcRequestFabric.prepareRequest(.scsGetNonce, parameters: [])
        let rp = chain3.dispatch(request)
        return rp.map(on: queue) { response in
            guard let value: BigUInt = response.getValue() else {
                if response.error != nil {
                    throw Chain3Error.nodeError(response.error!.message)
                }
                throw Chain3Error.nodeError("Invalid value from MOAC node")
            }
            return value
        }
    }
    
    public func getSCSId() -> Promise<Address> {
        let queue = chain3.requestDispatcher.queue
        let request = JsonRpcRequestFabric.prepareRequest(.scsGetSCSId, parameters: [])
        let rp = chain3.dispatch(request)
        return rp.map(on: queue) { response in
            guard let value: Address = response.getValue() else {
                if response.error != nil {
                    throw Chain3Error.nodeError(response.error!.message)
                }
                throw Chain3Error.nodeError("Invalid value from MOAC node")
            }
            return value
        }
    }
    
    public func getTransactionReceipt() -> Promise<SCSTransactionReceipt> {
        let queue = chain3.requestDispatcher.queue
        let request = JsonRpcRequestFabric.prepareRequest(.scsGetTransactionReceipt, parameters: [])
        let rp = chain3.dispatch(request)
        return rp.map(on: queue) { response in
            guard let value: SCSTransactionReceipt = response.getValue() else {
                if response.error != nil {
                    throw Chain3Error.nodeError(response.error!.message)
                }
                throw Chain3Error.nodeError("Invalid value from MOAC node")
            }
            return value
        }
    }
    
}

public struct SCSBlock: Decodable {
    public var extraData: Data?
    public var hash: Data?
    public var number: BigUInt?
    public var parentHash: Data?
    public var receiptsRoot: Data?
    public var stateRoot: Data?
    public var timestamp: BigUInt?
    public var transactions: [String]?
    public var transactionsRoot: Data?
    
    enum CodingKeys: String, CodingKey {
        case extraData
        case hash
        case number
        case parentHash
        case receiptsRoot
        case stateRoot
        case timestamp
        case transactions
        case transactionsRoot
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let number = try decodeHexToBigUInt(container, key: .number, allowOptional: true)
        self.number = number
        
        let timestamp = try decodeHexToBigUInt(container, key: .timestamp, allowOptional: true)
        self.timestamp = timestamp
        
        let extraData = try decodeHexToData(container, key: .extraData, allowOptional: true)
        self.extraData = extraData
        
        let hash = try decodeHexToData(container, key: .hash, allowOptional: true)
        self.hash = hash
        
        let parentHash = try decodeHexToData(container, key: .parentHash, allowOptional: true)
        self.parentHash = parentHash
        
        let receiptsRoot = try decodeHexToData(container, key: .receiptsRoot, allowOptional: true)
        self.receiptsRoot = receiptsRoot
        
        let stateRoot = try decodeHexToData(container, key: .stateRoot, allowOptional: true)
        self.stateRoot = stateRoot
        
        let transactionsRoot = try decodeHexToData(container, key: .transactionsRoot, allowOptional: true)
        self.transactionsRoot = transactionsRoot
        
//        let scsStrings = try container.decode([String].self, forKey: .scsList)
//        var scsList = [Address]()
//        for scsString in scsStrings {
//            let scs = Address(scsString)
//            scsList.append(scs)
//        }
//        self.transactions = scsList
        
        self.transactions = []
    }
    
    public init(balance: BigUInt, blockReward: BigUInt, bondLimit: BigUInt, owner: Address, scsList: [Address], txReward: BigUInt, viaReward: BigUInt) {
        self.balance = balance
        self.blockReward = blockReward
        self.bondLimit = bondLimit
        self.owner = owner
        self.scsList = scsList
        self.txReward = txReward
        self.viaReward = viaReward
    }
}

public struct MicroChainInfo: Decodable {
    public var balance: BigUInt?
    public var blockReward: BigUInt?
    public var bondLimit: BigUInt?
    public var owner: Address?
    public var scsList: [Address]?
    public var txReward: BigUInt?
    public var viaReward: BigUInt?
    
    enum CodingKeys: String, CodingKey {
        case balance
        case blockReward
        case bondLimit
        case owner
        case scsList
        case txReward
        case viaReward
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let balance = try decodeHexToBigUInt(container, key: .balance, allowOptional: true)
        self.balance = balance
        
        let blockReward = try decodeHexToBigUInt(container, key: .blockReward, allowOptional: true)
        self.blockReward = blockReward
        
        let bondLimit = try decodeHexToBigUInt(container, key: .bondLimit, allowOptional: true)
        self.bondLimit = bondLimit
        
        let owner = try container.decode(Address.self, forKey: .owner)
        self.owner = owner
        
        let scsStrings = try container.decode([String].self, forKey: .scsList)
        var scsList = [Address]()
        for scsString in scsStrings {
            let scs = Address(scsString)
            scsList.append(scs)
        }
        self.scsList = scsList
        
        let txReward = try decodeHexToBigUInt(container, key: .txReward, allowOptional: true)
        self.txReward = txReward
        
        let viaReward = try decodeHexToBigUInt(container, key: .viaReward, allowOptional: true)
        self.viaReward = viaReward
    }
    
    public init(balance: BigUInt, blockReward: BigUInt, bondLimit: BigUInt, owner: Address, scsList: [Address], txReward: BigUInt, viaReward: BigUInt) {
        self.balance = balance
        self.blockReward = blockReward
        self.bondLimit = bondLimit
        self.owner = owner
        self.scsList = scsList
        self.txReward = txReward
        self.viaReward = viaReward
    }
}

public struct SCSTransactionReceipt: Decodable {
    public var logs: [EventLog]
    public var logsBloom: MOACBloomFilter?
    public var status: TXStatus
    public var transactionHash: Data
    
    public enum TXStatus {
        case ok
        case failed
        case notYetProcessed
    }
    
    enum CodingKeys: String, CodingKey {
        case transactionHash
        case logs
        case logsBloom
        case status
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let status = try decodeHexToBigUInt(container, key: .status, allowOptional: true)
        if status == nil {
            self.status = TXStatus.notYetProcessed
        } else if status == 1 {
            self.status = TXStatus.ok
        } else {
            self.status = TXStatus.failed
        }
        
        let logsData = try decodeHexToData(container, key: .logsBloom, allowOptional: true)
        if logsData != nil && logsData!.count > 0 {
            logsBloom = MOACBloomFilter(logsData!)
        }
        
        let logs = try container.decode([EventLog].self, forKey: .logs)
        self.logs = logs
    }
    
    public init(transactionHash: Data, logs: [EventLog], status: TXStatus, logsBloom: MOACBloomFilter?) {
        self.transactionHash = transactionHash
        self.logs = logs
        self.status = status
        self.logsBloom = logsBloom
    }
    
    static func notProcessed(transactionHash: Data) -> SCSTransactionReceipt {
        let receipt = SCSTransactionReceipt(transactionHash: transactionHash, logs: [EventLog](), status: .notYetProcessed, logsBloom: nil)
        return receipt
    }
}
