//
//  chain3swiftInquiryTests.swift
//  chain3swift-iOS_Tests
//
//  Created by Георгий Фесенко on 02/07/2018.
//  Copyright © 2018 Bankex Foundation. All rights reserved.
//

import XCTest
import BigInt

@testable import chain3swift

class InquiryTests: XCTestCase {
    var localNodeFound = false
    var provider: Chain3HttpProvider? = nil
    let addrOfBalanceCheck = "0xd04967d333fe17fe2707186608e5fc9d1447310c"
    let hashOfTxToInspect = "0x14138b41d26b2925d3b9b66d916cf41dcd62b37756db98fd1d75b66ef1a122eb"
    override func setUp() {
        let url = URL(string: "http://127.0.0.1:8545")!
        if let p = Chain3HttpProvider(url, network: 101, keystoreManager: nil) {
            provider = p
            localNodeFound = true
            Chain3.default = Chain3(provider: provider!)
        } else {
            localNodeFound = false
            print("local node not found")
        }
    }
    
    func testGetBalance() throws {
        let chain3 = Chain3(provider: provider!)
        let address = Address(addrOfBalanceCheck)
        let balance = try chain3.mc.getBalance(address: address)
        let balString = balance.string(units: .mc, decimals: 3)
        print(balString)
    }
    
    func testGetBalancePromise() {
        do {
            let chain3 = Chain3(provider: provider!)
            let balance = try chain3.mc.getBalancePromise(address: addrOfBalanceCheck).wait()
            print(balance)
        } catch {
            print(error)
        }
    }
    
    func testGetBlockByHash() throws {
        let chain3 = Chain3(provider: provider!)
        let result = try chain3.mc.getBlockByHash("0x99e40371dc496856cb47456422eec3d2576c5076ab7ea799a9dd671745bc8009", fullTransactions: true)
        print(result)
    }
    
    func testGetBlockByNumber1() throws {
        let chain3 = Chain3(provider: provider!)
        let result = try chain3.mc.getBlockByNumber("latest", fullTransactions: true)
        print(result)
    }
    
    func testGetBlockByNumber2() throws {
        let chain3 = Chain3(provider: provider!)
        let result = try chain3.mc.getBlockByNumber(UInt64(1331003), fullTransactions: true)
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
        let chain3 = Chain3(provider: provider!)
        XCTAssertNoThrow(try chain3.mc.getBlockByNumber(UInt64(0x144F3B), fullTransactions: true))
    }
    
    func testGasPrice() throws {
        let chain3 = Chain3(provider: provider!)
        let gasPrice = try chain3.mc.getGasPrice()
        print(gasPrice)
    }
    
    func testTransactionReceipt() throws {
        let chain3 = Chain3(provider: provider!)
        let response = try chain3.mc.getTransactionReceipt(hashOfTxToInspect)
        XCTAssert(response.status == .ok)
    }
    
    func testTransactionDetails() throws {
        let chain3 = Chain3(provider: provider!)
        let response = try chain3.mc.getTransactionDetails(hashOfTxToInspect)
        XCTAssert(response.transaction.gasLimit == BigUInt(7000000))
    }
    
    func testGetTransactionDetailsPromise() {
        do {
            let chain3 = Chain3(provider: provider!)
            let result = try chain3.mc.getTransactionDetailsPromise(hashOfTxToInspect).wait()
            print(result)
            XCTAssert(result.transaction.gasLimit == BigUInt(7000000))
        } catch {
            print(error)
        }
    }
    
//    func testEstimateGasPromise() throws {
//        let chain3 = Chain3(provider: provider!)
//        let sendToAddress = Address("0x6394b37Cf80A7358b38068f0CA4760ad49983a1B")
//        let tempKeystore = try MOACKeystoreV3(password: "")
//        let keystoreManager = KeystoreManager([tempKeystore!])
//        chain3.addKeystoreManager(keystoreManager)
//        let contract = try chain3.contract(Chain3Utils.coldWalletABI, at: sendToAddress)
//        var options = Chain3Options.default
//        options.value = Chain3Utils.parseToBigUInt("1.0", units: .mc)
//        options.from = keystoreManager.addresses.first
//        let intermediate = try contract.method("fallback", options: options)
//        let esimate = try intermediate.estimateGasPromise(options: nil).wait()
//        print(esimate)
//        XCTAssert(esimate == 21000)
//    }
    
//    func testSendETHPromise() throws {
//        guard let keystoreData = getKeystoreData() else { return }
//        guard let keystoreV3 = MOACKeystoreV3(keystoreData) else { return XCTFail() }
//        let chain3Rinkeby = Chain3(provider: provider!)
//        let keystoreManager = KeystoreManager([keystoreV3])
//        chain3Rinkeby.addKeystoreManager(keystoreManager)
//        let gasPrice = try chain3Rinkeby.mc.getGasPrice()
//        let sendToAddress = Address("0x6394b37Cf80A7358b38068f0CA4760ad49983a1B")
//        let intermediate = try chain3Rinkeby.mc.sendETH(to: sendToAddress, amount: "0.001")
//        var options = Chain3Options.default
//        options.from = keystoreV3.addresses.first
//        options.gasPrice = gasPrice
//        let result = try intermediate.sendPromise(options: options).wait()
//        print(result)
//    }
    
    
//    func testGetIndexedEventsPromise() {
//        do {
//            let jsonString = "[{\"constant\":true,\"inputs\":[],\"name\":\"name\",\"outputs\":[{\"name\":\"\",\"type\":\"string\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_spender\",\"type\":\"address\"},{\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"approve\",\"outputs\":[{\"name\":\"success\",\"type\":\"bool\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"totalSupply\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_from\",\"type\":\"address\"},{\"name\":\"_to\",\"type\":\"address\"},{\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"transferFrom\",\"outputs\":[{\"name\":\"success\",\"type\":\"bool\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"decimals\",\"outputs\":[{\"name\":\"\",\"type\":\"uint8\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"version\",\"outputs\":[{\"name\":\"\",\"type\":\"string\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"_owner\",\"type\":\"address\"}],\"name\":\"balanceOf\",\"outputs\":[{\"name\":\"balance\",\"type\":\"uint256\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"symbol\",\"outputs\":[{\"name\":\"\",\"type\":\"string\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_to\",\"type\":\"address\"},{\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"transfer\",\"outputs\":[{\"name\":\"success\",\"type\":\"bool\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_spender\",\"type\":\"address\"},{\"name\":\"_value\",\"type\":\"uint256\"},{\"name\":\"_extraData\",\"type\":\"bytes\"}],\"name\":\"approveAndCall\",\"outputs\":[{\"name\":\"success\",\"type\":\"bool\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"_owner\",\"type\":\"address\"},{\"name\":\"_spender\",\"type\":\"address\"}],\"name\":\"allowance\",\"outputs\":[{\"name\":\"remaining\",\"type\":\"uint256\"}],\"payable\":false,\"type\":\"function\"},{\"inputs\":[{\"name\":\"_initialAmount\",\"type\":\"uint256\"},{\"name\":\"_tokenName\",\"type\":\"string\"},{\"name\":\"_decimalUnits\",\"type\":\"uint8\"},{\"name\":\"_tokenSymbol\",\"type\":\"string\"}],\"type\":\"constructor\"},{\"payable\":false,\"type\":\"fallback\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"_from\",\"type\":\"address\"},{\"indexed\":true,\"name\":\"_to\",\"type\":\"address\"},{\"indexed\":false,\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"Transfer\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"_owner\",\"type\":\"address\"},{\"indexed\":true,\"name\":\"_spender\",\"type\":\"address\"},{\"indexed\":false,\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"Approval\",\"type\":\"event\"},]"
//            let chain3 = Chain3(provider: provider!)
//            let contract = try chain3.contract(jsonString, at: nil)
//            var filter = EventFilter()
//            filter.fromBlock = .blockNumber(UInt64(5_200_120))
//            filter.toBlock = .blockNumber(UInt64(5_200_120))
//            filter.addresses = ["0x53066cddbc0099eb6c96785d9b3df2aaeede5da3"]
//            filter.parameterFilters = [([Address("0xefdcf2c36f3756ce7247628afdb632fa4ee12ec5")] as [EventFilterable]), (nil as [EventFilterable]?)]
//            let eventParserResult = try contract.getIndexedEventsPromise(eventName: "Transfer", filter: filter, joinWithReceipts: true).wait()
//            print(eventParserResult)
//            XCTAssert(eventParserResult.count == 2)
//            XCTAssert(eventParserResult[0].transactionReceipt != nil)
//            XCTAssert(eventParserResult[0].eventLog != nil)
//        } catch {
//            print(error)
//            XCTFail()
//        }
//    }
    
//    func testEventParsingBlockByNumberPromise() throws {
//        let jsonString = "[{\"constant\":true,\"inputs\":[],\"name\":\"name\",\"outputs\":[{\"name\":\"\",\"type\":\"string\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_spender\",\"type\":\"address\"},{\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"approve\",\"outputs\":[{\"name\":\"success\",\"type\":\"bool\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"totalSupply\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_from\",\"type\":\"address\"},{\"name\":\"_to\",\"type\":\"address\"},{\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"transferFrom\",\"outputs\":[{\"name\":\"success\",\"type\":\"bool\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"decimals\",\"outputs\":[{\"name\":\"\",\"type\":\"uint8\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"version\",\"outputs\":[{\"name\":\"\",\"type\":\"string\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"_owner\",\"type\":\"address\"}],\"name\":\"balanceOf\",\"outputs\":[{\"name\":\"balance\",\"type\":\"uint256\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"symbol\",\"outputs\":[{\"name\":\"\",\"type\":\"string\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_to\",\"type\":\"address\"},{\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"transfer\",\"outputs\":[{\"name\":\"success\",\"type\":\"bool\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_spender\",\"type\":\"address\"},{\"name\":\"_value\",\"type\":\"uint256\"},{\"name\":\"_extraData\",\"type\":\"bytes\"}],\"name\":\"approveAndCall\",\"outputs\":[{\"name\":\"success\",\"type\":\"bool\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"_owner\",\"type\":\"address\"},{\"name\":\"_spender\",\"type\":\"address\"}],\"name\":\"allowance\",\"outputs\":[{\"name\":\"remaining\",\"type\":\"uint256\"}],\"payable\":false,\"type\":\"function\"},{\"inputs\":[{\"name\":\"_initialAmount\",\"type\":\"uint256\"},{\"name\":\"_tokenName\",\"type\":\"string\"},{\"name\":\"_decimalUnits\",\"type\":\"uint8\"},{\"name\":\"_tokenSymbol\",\"type\":\"string\"}],\"type\":\"constructor\"},{\"payable\":false,\"type\":\"fallback\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"_from\",\"type\":\"address\"},{\"indexed\":true,\"name\":\"_to\",\"type\":\"address\"},{\"indexed\":false,\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"Transfer\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"_owner\",\"type\":\"address\"},{\"indexed\":true,\"name\":\"_spender\",\"type\":\"address\"},{\"indexed\":false,\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"Approval\",\"type\":\"event\"},]"
//        let chain3 = Chain3(provider: provider!)
//        let contract = try chain3.contract(jsonString, at: nil)
//        var filter = EventFilter()
//        filter.addresses = ["0x53066cddbc0099eb6c96785d9b3df2aaeede5da3"]
//        filter.parameterFilters = [([Address("0xefdcf2c36f3756ce7247628afdb632fa4ee12ec5")] as [EventFilterable]), ([Address("0xd5395c132c791a7f46fa8fc27f0ab6bacd824484")] as [EventFilterable])]
//        guard let eventParser = contract.createEventParser("Transfer", filter: filter) else { return XCTFail() }
//        let present = try eventParser.parseBlockByNumberPromise(UInt64(5_200_120)).wait()
//        print(present)
//        XCTAssert(present.count == 1)
//    }
    
//    func getKeystoreData() -> Data? {
//        let bundle = Bundle(for: type(of: self))
//        guard let path = bundle.path(forResource: "key", ofType: "json") else { return nil }
//        guard let data = NSData(contentsOfFile: path) else { return nil }
//        return data as Data
//    }
    
}


