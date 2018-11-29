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


# chain3swift
- Swift implementation of [chain3.js](https://github.com/MOACChain/chain3/) functionality
- Interaction with remote node via JSON RPC
- Smart-contract ABI parsing
- ABI deconding (V2 is supported with return of structures from public functions. Part of 0.4.22 Solidity compiler)
- RLP encoding
- Interactions (read/write to Smart contracts)
- Local keystore management (moac compatible)
- Literally following the standards:
-  [BIP32](https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki) HD Wallets: Deterministic Wallet
-  [BIP39](https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki) (Seed phrases)
-  [BIP44](https://github.com/bitcoin/bips/blob/master/bip-0044.mediawiki) (Key generation prefixes)
-  [EIP-155](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-155.md) (Replay attacks protection) *_enforced!_*


## Requirements
Chain3swift requires Swift 4.2 and deploys to `macOS 10.10`, `iOS 9`, `watchOS 2` and `tvOS 9` and `linux`.

Don't forget to set the iOS version in a Podfile, otherwise you get an error if the deployment target is less than the latest SDK.

## Installation

- **Swift Package Manager:**
  Although the Package Manager is still in its infancy, chain3swift provides full support for it.
  Add this to the dependency section of your `Package.swift` manifest:

    ```Swift
    .package(url: "https://github.com/liweiz/chain3swift.git", from: "2.0.0")
    ```

- **CocoaPods:** Put this in your `Podfile`:

    ```Ruby
    pod 'chain3swift', :git => 'https://github.com/liweiz/chain3swift.git'
    ```

- **Carthage:** Put this in your `Cartfile`:

    ```
    github "liweiz/chain3swift" ~> 2.0
    ```


## Design decisions
- Not every JSON RPC function is exposed yet, priority is given to the ones required for mobile devices
- Functionality was focused on serializing and signing transactions locally on the device to send raw transactions to Ethereum network
- Requirements for password input on every transaction are indeed a design decision. Interface designers can save user passwords with the user's consent
- Public function for private key export is exposed for user convenience, but marked as UNSAFE_ :) Normal workflow takes care of EIP155 compatibility and proper clearing of private key data from memory


## Features
- [x] Create Account
- [x] Import Account
- [x] Sign transactions
- [x] Send transactions, call functions of smart-contracts, estimate gas costs
- [x] Serialize and deserialize transactions and results to native Swift types
- [x] Convenience functions for chain state: block number, gas price
- [x] Check transaction results and get receipt
- [x] Parse event logs for transaction
- [x] Manage user's private keys through encrypted keystore abstractions
- [x] Batched requests in concurrent mode, checks balances of 580 tokens (from the latest MyEtherWallet repo) over 3 seconds


## Usage

Here's a few use cases of our library

### Initializing Ethereum address

```bash
let coldWalletAddress: Address = "0x6394b37Cf80A7358b38068f0CA4760ad49983a1B"
let constractAddress: Address = "0x45245bc59219eeaaf6cd3f382e078a461ff9de7b"
```
Ethereum addresses are checksum checked if they are not lowercased and always length checked

### Setting options

```bash
var options = Web3Options.default
// public var to: Address? = nil - to what address transaction is aimed
// public var from: Address? = nil - form what address it should be sent (either signed locally or on the node)
// public var gasLimit: BigUInt? = BigUInt(90000) - default gas limit
// public var gasPrice: BigUInt? = BigUInt(5000000000) - default gas price, quite small
// public var value: BigUInt? = BigUInt(0) - amount of WEI sent along the transaction
options.gasPrice = gasPrice
options.gasLimit = gasLimit
options.from = "0xE6877A4d8806e9A9F12eB2e8561EA6c1db19978d"
```

### Getting ETH balance

```bash
let address: Address = "0xE6877A4d8806e9A9F12eB2e8561EA6c1db19978d"
let web3Main = Web3(gateway: .mainnet)
let balance: BigUInt = try web3Main.eth.getBalance(address)
```

### Getting gas price

```bash
let web3Main = Web3(gateway: .mainnet)
let gasPrice: BigUInt = try web3Main.eth.getGasPrice()
```

### Getting ERC20 token balance

```bash
let contractAddress: Address = "0x45245bc59219eeaaf6cd3f382e078a461ff9de7b" // BKX token on Ethereum mainnet
let balance = try ERC20(contractAddress).balance(of: "0x6394b37Cf80A7358b38068f0CA4760ad49983a1B")
print("BKX token balance = " + String(bal))
```



### Sending ETH

```bash
let mnemonics = Mnemonics()
let keystore = try BIP32Keystore(mnemonics: mnemonics)
let keystoreManager = KeystoreManager([keystore])
let web3Rinkeby = Web3(gateway: .rinkeby)
web3Rinkeby.addKeystoreManager(keystoreManager) // attach a keystore if you want to sign locally. Otherwise unsigned request will be sent to remote node
var options = Web3Options.default
options.from = keystore.addresses.first! // specify from what address you want to send it
let intermediateSend = try web3Rinkeby.contract(Web3Utils.coldWalletABI, at: coldWalletAddress).method(options: options) // an address with a private key attached in not different from any other address, just has very simple ABI
let sendResultBip32 = try intermediateSend.send(password: "BANKEXFOUNDATION")
```



### Sending ERC20

```bash
let web3 = Web3(gateway: .rinkeby)
let erc20 = ERC20("0xa407dd0cbc9f9d20cdbd557686625e586c85b20a", from: yourAddress)
let result = try erc20.transfer(to: "0x6394b37Cf80A7358b38068f0CA4760ad49983a1B", amount: NaturalUnits("0.0001"))
}
```

## Global plans
- Full reference `chain3js` functionality
- Light Ethereum subprotocol (LES) integration


## License
chain3swift is available under the Apache License 2.0 license. See the [LICENSE](https://github.com/liweiz/chain3swift/blob/master/LICENSE.md) file for more info.
