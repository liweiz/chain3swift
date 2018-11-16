//
//  Chain3+Methods.swift
//  chain3swift
//
//  Created by Alexander Vlasov on 21.12.2017.
//  Copyright © 2017 Bankex Foundation. All rights reserved.
//
//  Modifications copyright © 2018 Liwei Zhang. All rights reserved.
//

import Foundation

public struct JsonRpcMethod: Encodable, Equatable {
    public var api: String
    public var parameters: Int
    public init(api: String, parameters: Int) {
        self.api = api
        self.parameters = parameters
    }
    public static let gasPrice = JsonRpcMethod(api: "mc_gasPrice", parameters: 0)
    public static let blockNumber = JsonRpcMethod(api: "mc_blockNumber", parameters: 0)
    public static let getNetwork = JsonRpcMethod(api: "net_version", parameters: 0)
    public static let sendRawTransaction = JsonRpcMethod(api: "mc_sendRawTransaction", parameters: 1)
    public static let sendTransaction = JsonRpcMethod(api: "mc_sendTransaction", parameters: 1)
    public static let estimateGas = JsonRpcMethod(api: "mc_estimateGas", parameters: 1)
    public static let call = JsonRpcMethod(api: "mc_call", parameters: 2)
    public static let getTransactionCount = JsonRpcMethod(api: "mc_getTransactionCount", parameters: 2)
    public static let getBalance = JsonRpcMethod(api: "mc_getBalance", parameters: 2)
    public static let getCode = JsonRpcMethod(api: "mc_getCode", parameters: 2)
    public static let getStorageAt = JsonRpcMethod(api: "mc_getStorageAt", parameters: 2)
    public static let getTransactionByHash = JsonRpcMethod(api: "mc_getTransactionByHash", parameters: 1)
    public static let getTransactionReceipt = JsonRpcMethod(api: "mc_getTransactionReceipt", parameters: 1)
    public static let getAccounts = JsonRpcMethod(api: "mc_accounts", parameters: 0)
    public static let getBlockByHash = JsonRpcMethod(api: "mc_getBlockByHash", parameters: 2)
    public static let getBlockByNumber = JsonRpcMethod(api: "mc_getBlockByNumber", parameters: 2)
    public static let personalSign = JsonRpcMethod(api: "mc_sign", parameters: 1)
    public static let unlockAccount = JsonRpcMethod(api: "personal_unlockAccount", parameters: 1)
    public static let getLogs = JsonRpcMethod(api: "mc_getLogs", parameters: 1)
    public static let txPoolStatus = JsonRpcMethod(api: "txpool_status", parameters: 0)
    public static let txPoolInspect = JsonRpcMethod(api: "txpool_inspect", parameters: 0)
    public static let txPoolContent = JsonRpcMethod(api: "txpool_content", parameters: 0)
}

public struct JsonRpcRequestFabric {
    public static func prepareRequest(_ method: JsonRpcMethod, parameters: [Encodable]) -> JsonRpcRequest {
        var request = JsonRpcRequest(method: method)
        let pars = JsonRpcParams(params: parameters)
        request.params = pars
        return request
    }
}
