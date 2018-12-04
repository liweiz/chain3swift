# chain3swift

<p align="center">
<a href="https://developer.apple.com/swift/" target="_blank">
<img src="https://img.shields.io/badge/Swift-4.2-orange.svg?style=flat" alt="Swift 4.2">
</a>
<a href="https://developer.apple.com/swift/" target="_blank">
<img src="https://img.shields.io/badge/Platforms-iOS%20%7C%20macOS%20%7C%20watchOS%20%7C%20tvOS%20%7C%20Linux%20-lightgray.svg?style=flat" alt="Platforms iOS | macOS">
</a>
<a target="_blank">
<img src="https://img.shields.io/badge/Supports-CocoaPods%20%7C%20Carthage%20%7C%20SwiftPM%20-orange.svg?style=flat" alt="Compatible">
</a>
<a target="_blank">
<img src="https://img.shields.io/badge/Supports-Objective%20C-blue.svg?style=flat" alt="Compatible">
</a>
</p>

- Swift implementation of [chain3.js](https://github.com/MOACChain/chain3/) functionality
- This project was forked from [web3swift](https://github.com/BANKEX/web3swift) v2.0.4
- Interaction with remote node via JSON RPC
- Smart-contract ABI parsing
- ABI deconding (V2 is supported with return of structures from public functions. Part of 0.4.22 Solidity compiler)
- RLP encoding
- Interactions (read/write to Smart contracts)
- Local keystore management (moac compatible)

## Requirements

Chain3swift requires Swift 4.2 and deploys to `macOS 10.10`, `iOS 9`, `watchOS 2` and `tvOS 9` and `linux`.

Don't forget to set the iOS version in a Podfile, otherwise you get an error if the deployment target is less than the latest SDK.

## Installation

- **CocoaPods:** Put this in your `Podfile`:

  ```Ruby
  pod 'chain3swift', :git => 'https://github.com/liweiz/chain3swift.git'
  ```

## Design decisions

- Not every JSON RPC function is exposed yet, priority is given to the ones required for mobile devices
- Functionality was focused on serializing and signing transactions locally on the device to send raw transactions to Ethereum network
- Requirements for password input on every transaction are indeed a design decision. Interface designers can save user passwords with the user's consent
- Public function for private key export is exposed for user convenience, but marked as UNSAFE\_ :) Normal workflow takes care of EIP155 compatibility and proper clearing of private key data from memory

## Available functions

- [Chain3 instance with RPC connection](#chain3-instance-with-rpc-connection)
- [mc.getBalance](#mcgetbalance)
- [mc.getBlockByHash](#mcgetblockbyhash)
- [mc.getBlockByNumber](#mcgetblockbynumber)
- [mc.getGasPrice](#mcgetgasprice)
- [mc.getTransactionReceipt](#mcgettransactionreceipt)
- [mc.getTransactionDetails](#mcgettransactiondetails)
- [mc.getAccounts](#mcgetaccounts)
- [personal.unlockAccountPromise](#personalunlockaccountpromise)
- [Send unsigned MC transaction](#send-unsigned-mc-transaction)
- [Send signed MC transaction](#send-signed-mc-transaction)
- [Call unsigned state-changing method on deployed contract](#call-unsigned-state-changing-method-on-deployed-contract)
- [Call signed state-changing method on deployed contract](#call-signed-state-changing-method-on-deployed-contract)
- [Call unsigned non-state-changing method on deployed contract](#call-unsigned-non-state-changing-method-on-deployed-contract)

### Chain3 instance with RPC connection

```swift
let url = URL(string: "http://127.0.0.1:8545")!  // vnode rpc url to connect
var provider: Chain3HttpProvider? = nil
if let p = Chain3HttpProvider(url, network: 101, keystoreManager: nil) {
    provider = p
    let chain3 = Chain3(provider: provider!)
} else {
    // Handle error
}
```

### mc.getBalance

```swift
let address = Address(moacAddressString)
let balance = try chain3.mc.getBalance(address: address)
```

### mc.getBlockByHash

```swift
let result = try chain3.mc.getBlockByHash(hashString, fullTransactions: true)
```

### mc.getBlockByNumber

```swift
let result = try chain3.mc.getBlockByNumber("latest", fullTransactions: true)
// OR
let result = try chain3.mc.getBlockByNumber(UInt64(blockNumberInt), fullTransactions: true)
// OR
let result = try chain3.mc.getBlockByNumber(UInt64(blockNumberHex), fullTransactions: true)
```

### mc.getGasPrice

```swift
let gasPrice = try chain3.mc.getGasPrice()
```

### mc.getTransactionReceipt

```swift
let response = try chain3.mc.getTransactionReceipt(hashStringOfTxToInspect)
```

### mc.getTransactionDetails

```swift
let response = try chain3.mc.getTransactionDetails(hashStringOfTxToInspect)
switch response {
case let .transaction(x):
    // process MOACTransaction instance x
default:
    // other situations
}
```

### mc.getAccounts

```swift
let accounts = try chain3.mc.getAccounts()
```

### personal.unlockAccountPromise

```swift
let response = try chain3.personal.unlockAccountPromise(account: Address(addressString), password: passwordString).wait()
```

### Send unsigned MC transaction

```swift
let fromAddr = Address(addrString)
// Have to use personal.unlock seperately first since the sendPromise's password param only works under signed tx
_ = try chain3.personal.unlockAccountPromise(account: fromAddr, password: passwordString).wait()
let gasPrice = try chain3.mc.getGasPrice()
let sendToAddress = Address(receivingAddrString)
let intermediate = try chain3.mc.sendMC(to: sendToAddress, amount: BigUInt(1))
var options = Chain3Options.default
options.from = fromAddr
options.gasPrice = gasPrice
let result = try intermediate.sendPromise(options: options).wait()
```

### Send signed MC transaction

```swift
let json = keystoreJSONString
guard let keystoreV3 = MOACKeystoreV3(json) else { // handle error }
let keystoreManager = KeystoreManager([keystoreV3])
chain3.addKeystoreManager(keystoreManager)
let gasPrice = try chain3.mc.getGasPrice()
let fromAddr = Address(addrString)
let sendToAddress = Address(receivingAddrString)
let intermediate = try chain3.mc.sendMC(to: sendToAddress, amount: BigUInt(1))
var options = Chain3Options.default
options.from = fromAddr
options.gasPrice = gasPrice
let result = try intermediate.sendPromise(password: passwordString, options: options).wait()
```

### Call unsigned state-changing method on deployed contract

```swift
let contractAddress = Address(contractAddrStringToCall)
let contract = try chain3.contract(contractABIJsonString, at: contractAddress)
var options = Chain3Options.default
options.from = Address(addrString)
// Have to use personal.unlock seperately first since the sendPromise's password param only works under signed tx
_ = try chain3.personal.unlockAccountPromise(account: Address(addrString), password: passwordString).wait()
let transactionIntermediateForSet = try contract.method(setterNameString, args: inputsArray, options: options)
let result = try transactionIntermediateForSet.sendPromise(options: options).wait()
```

### Call signed state-changing method on deployed contract

Manually and explicitly setting gas limit for the signed call is necessary here.

```swift
var options = Chain3Options.default
options.from = Address(addrString)
options.gasLimit = BigUInt(90000)
let json = keystoreJSONString
guard let keystoreV3 = MOACKeystoreV3(json) else { // Handle error }
let keystoreManager = KeystoreManager([keystoreV3])
chain3.addKeystoreManager(keystoreManager)
let contractAddress = Address(contractAddrStringToCall)
let contract = try chain3.contract(contractABIJsonString, at: contractAddress)
let transactionIntermediateForSet = try contract.method(setterNameString, args: inputsArray, options: options)
let result = try transactionIntermediateForSet.sendPromise(password: passwordString, options: options).wait()
```

### Call unsigned non-state-changing method on deployed contract

```swift
let contractAddress = Address(contractAddrStringToCall)
let contract = try chain3.contract(contractABIJsonString, at: contractAddress)
var options = Chain3Options.default
options.from = Address(addrString)
let transactionIntermediateForGet = try contract.method(getterNameString, options: options)
let value = try transactionIntermediateForGet.call(options: options)
```

## Future plans

- Full reference `chain3js` functionality

## License

chain3swift is available under the Apache License 2.0 license. See the [LICENSE](https://github.com/liweiz/chain3swift/blob/master/LICENSE.md) file for more info.
