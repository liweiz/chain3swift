//
//  chain3swiftInfuraTests.swift
//  chain3swift-iOS_Tests
//
//  Created by Георгий Фесенко on 02/07/2018.
//  Copyright © 2018 Bankex Foundation. All rights reserved.
//

import XCTest

@testable import chain3swift
class InfuraTests: XCTestCase {
    func testGetBalance() throws {
        let chain3 = Chain3(infura: .mainnet)
        let address = Address("0x6394b37Cf80A7358b38068f0CA4760ad49983a1B")
        let balance = try chain3.mc.getBalance(address: address)
        let balString = balance.string(units: .mc, decimals: 3)
        print(balString)
    }
 
    func testGetBlockByHash() throws {
        let chain3 = Chain3(infura: .mainnet)
        let result = try chain3.mc.getBlockByHash("0x6d05ba24da6b7a1af22dc6cc2a1fe42f58b2a5ea4c406b19c8cf672ed8ec0695", fullTransactions: true)
        print(result)
    }

    func testGetBlockByNumber1() throws {
        let chain3 = Chain3(infura: .mainnet)
        let result = try chain3.mc.getBlockByNumber("latest", fullTransactions: true)
        print(result)
    }

    func testGetBlockByNumber2() throws {
        let chain3 = Chain3(infura: .mainnet)
        let result = try chain3.mc.getBlockByNumber(UInt64(5_184_323), fullTransactions: true)
        print(result)
        let transactions = result.transactions
        for transaction in transactions {
            switch transaction {
            case let .transaction(tx):
                print(String(describing: tx))
            default:
                break
            }
        }
    }

    func testGetBlockByNumber3() {
        let chain3 = Chain3(infura: .mainnet)
        XCTAssertNoThrow(try chain3.mc.getBlockByNumber(UInt64(0x5BAD55), fullTransactions: true))
    }

    func testGasPrice() throws {
        let chain3 = Chain3(infura: .mainnet)
        let gasPrice = try chain3.mc.getGasPrice()
        print(gasPrice)
    }
}
