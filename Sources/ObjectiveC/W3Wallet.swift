//
//  W3Wallet.swift
//  chain3swift
//
//  Created by Dmitry on 10/11/2018.
//  Copyright © 2018 Bankex Foundation. All rights reserved.
//

import Foundation

/// Wallet functions
@objc public class W3Wallet: NSObject {
    public var swift: Chain3Wallet {
        return chain3.swift.wallet
    }
    unowned var chain3: W3Chain3
    @objc public init(chain3: W3Chain3) {
        self.chain3 = chain3
    }
    
    /// - throws: Chain3WalletError.attachadKeystoreNotFound
    @objc public func getAccounts() throws -> [W3Address] {
        return try swift.getAccounts().map { $0.objc }
    }
    
    /// - throws:
    /// Chain3WalletError.attachadKeystoreNotFound
    /// Chain3WalletError.noAccounts
    @objc public func getCoinbase() throws -> W3Address {
        return try swift.getCoinbase().objc
    }
    
    /// - throws:
    /// Chain3WalletError.attachadKeystoreNotFound
    /// AbstractKeystoreError
    /// Error
    @objc public func sign(transaction: W3MOACTransaction, account: W3Address, password: String = "BANKEXFOUNDATION") throws {
        try swift.signTX(transaction: &transaction.swift, account: account.swift, password: password)
    }
    
    /// - throws: SECP256K1Error
    @objc public func sign(personalMessageData: Data, account: W3Address, password: String = "BANKEXFOUNDATION") throws -> Data {
        return try swift.signPersonalMessage(personalMessageData, account: account.swift, password: password)
    }
}
