//
//  chain3swiftTransactionsTests.swift
//  chain3swift-iOS_Tests
//
//  Created by Георгий Фесенко on 02/07/2018.
//  Copyright © 2018 Bankex Foundation. All rights reserved.
//

import BigInt
import CryptoSwift
import XCTest

@testable import chain3swift

class TransactionsTests: XCTestCase {
    func testTransaction() throws {
        do {
            var transaction = MOACTransaction(nonce: 9,
                                                  gasPrice: 20_000_000_000,
                                                  gasLimit: 21000,
                                                  to: "0x3535353535353535353535353535353535353535",
                                                  value: "1000000000000000000",
                                                  data: Data(),
                                                  v: 0,
                                                  r: 0,
                                                  s: 0)
            let privateKeyData = Data.fromHex("0x4646464646464646464646464646464646464646464646464646464646464646")!
            let publicKey = try Chain3Utils.privateToPublic(privateKeyData, compressed: false)
            let sender = try Chain3Utils.publicToAddress(publicKey)
            transaction.chainID = 1
            print(transaction)
            let hash = transaction.hashForSignature(chainID: 1)
            let expectedHash = "0xdaf5a779ae972f972197303d7b574746c7ef83eadac0f2791ad23db92e4c8e53".withoutHex
            XCTAssert(hash!.toHexString() == expectedHash, "Transaction signature failed")
            try Chain3Signer.EIP155Signer.sign(transaction: &transaction, privateKey: privateKeyData, useExtraEntropy: false)
            print(transaction)
            XCTAssert(transaction.v == 37, "Transaction signature failed")
            XCTAssert(sender == transaction.sender)
        } catch {
            print(error)
            XCTFail()
        }
    }

    func testEthSendExample() throws {
        let chain3 = Chain3(infura: .mainnet)
        let sendToAddress = Address("0x6394b37Cf80A7358b38068f0CA4760ad49983a1B")
        let tempKeystore = try! MOACKeystoreV3(password: "")
        let keystoreManager = KeystoreManager([tempKeystore!])
        chain3.addKeystoreManager(keystoreManager)
        let contract = try chain3.contract(Chain3Utils.coldWalletABI, at: sendToAddress)
        var options = Chain3Options.default
        options.value = Chain3Utils.parseToBigUInt("1.0", units: .mc)
        options.from = keystoreManager.addresses.first
        let intermediate = try contract.method("fallback", options: options)
        do {
            try intermediate.send(password: "")
            XCTFail("Shouldn't be sended")
        } catch let Chain3Error.nodeError(descr) {
            XCTAssertEqual(descr, "insufficient funds for gas * price + value")
        } catch {
            XCTFail("\(error)")
        }
    }

    func testTransactionReceipt() throws {
        let chain3 = Chain3(infura: .mainnet)
        let response = try chain3.mc.getTransactionReceipt("0x83b2433606779fd756417a863f26707cf6d7b2b55f5d744a39ecddb8ca01056e")
        XCTAssert(response.status == .ok)
    }

    func testTransactionDetails() throws {
        let chain3 = Chain3(infura: .mainnet)
        let response = try chain3.mc.getTransactionDetails("0x127519412cefd773b952a5413a4467e9119654f59a34eca309c187bd9f3a195a")
        XCTAssert(response.transaction.gasLimit == BigUInt(78423))
    }

    func getKeystoreData() -> Data? {
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.path(forResource: "key", ofType: "json") else { return nil }
        guard let data = NSData(contentsOfFile: path) else { return nil }
        return data as Data
    }

    func testSendETH() throws {
        guard let keystoreData = getKeystoreData() else { return }
        guard let keystoreV3 = MOACKeystoreV3(keystoreData) else { return XCTFail() }
        let chain3Rinkeby = Chain3(infura: .rinkeby)
        let keystoreManager = KeystoreManager([keystoreV3])
        chain3Rinkeby.addKeystoreManager(keystoreManager)
        let gasPriceRinkeby = try chain3Rinkeby.mc.getGasPrice()
        let sendToAddress = Address("0x6394b37Cf80A7358b38068f0CA4760ad49983a1B")
        let intermediate = try chain3Rinkeby.mc.sendETH(to: sendToAddress, amount: "0.001")
        var options = Chain3Options.default
        options.from = keystoreV3.addresses.first
        options.gasPrice = gasPriceRinkeby
        try intermediate.send(password: "BANKEXFOUNDATION", options: options)
    }

    func testTokenBalanceTransferOnMainNet() throws {
        // BKX TOKEN
        let chain3 = Chain3(infura: .mainnet)
        let coldWalletAddress = Address("0x6394b37Cf80A7358b38068f0CA4760ad49983a1B")
        let contractAddress = Address("0x45245bc59219eeaaf6cd3f382e078a461ff9de7b")
        var options = Chain3Options()
        options.from = coldWalletAddress
        let tempKeystore = try! MOACKeystoreV3(password: "")
        let keystoreManager = KeystoreManager([tempKeystore!])
        chain3.addKeystoreManager(keystoreManager)
        let contract = try chain3.contract(Chain3Utils.erc20ABI, at: contractAddress)
        try contract.method("transfer", args: coldWalletAddress, BigUInt(1), options: options).call(options: nil)
    }
    
    func testRawTransaction() {
        let transactionString = "0xa9059cbb00000000000000000000000083b0b52a887a4c05429ee6d4619afeb8007c1a330000000000000000000000000000000000000000000000000001c6bf52634000"
        let transactionData = Data.fromHex(transactionString)!
        let rawTransaction = MOACTransaction.fromRaw(transactionData)
        XCTAssertNil(rawTransaction)
    }

//    func testTokenBalanceTransferOnMainNetUsingConvenience() throws {
//        // BKX TOKEN
//        let chain3 = Chain3(infura: .mainnet)
//        let coldWalletAddress = Address("0x6394b37Cf80A7358b38068f0CA4760ad49983a1B")
//        let contractAddress = Address("0x45245bc59219eeaaf6cd3f382e078a461ff9de7b")
//        let tempKeystore = try! MOACKeystoreV3(password: "")
//        let keystoreManager = KeystoreManager([tempKeystore!])
//        chain3.addKeystoreManager(keystoreManager)
//        let intermediate = try chain3.mc.sendERC20tokensWithNaturalUnits(tokenAddress:contractAddress, from: coldWalletAddress, to: coldWalletAddress, amount: "1.0")
//        let gasLimit = try intermediate.estimateGas(options: nil)
//        var options = Chain3Options();
//        options.gasLimit = gasLimit
//        try intermediate.call(options: options)
//    }
}
