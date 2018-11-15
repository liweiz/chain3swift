//
//  W3Chain3.swift
//  chain3swift
//
//  Created by Dmitry on 11/9/18.
//  Copyright © 2018 Bankex Foundation. All rights reserved.
//
//  Modifications copyright © 2018 Liwei Zhang. All rights reserved.
//

import Foundation

extension Chain3Provider {
    public var objc: W3Chain3HttpProvider {
		guard let provider = self as? Chain3HttpProvider else { fatalError("\(self) is not convertable to objective-c W3Chain3HttpProvider") }
		return provider.objc
	}
}

extension Chain3 {
    public var objc: W3Chain3 {
		return W3Chain3(self)
	}
}

@objc public class W3Chain3: NSObject, W3OptionsInheritable, SwiftContainer {
	public var swift: Chain3
    var _swiftOptions: Chain3Options {
        get { return swift.options }
        set { swift.options = newValue }
    }
	public required init(_ swift: Chain3) {
		self.swift = swift
		super.init()
		options = W3Options(object: self)
	}
	
	@objc public static var `default`: W3Chain3 {
		get { return Chain3.default.objc }
		set { Chain3.default = newValue.swift }
	}
	@objc public var provider: W3Chain3HttpProvider {
		get { return swift.provider.objc }
		set { swift.provider = newValue.swift }
	}
	@objc public var options: W3Options!
	@objc public var defaultBlock: String {
		get { return swift.defaultBlock }
		set { swift.defaultBlock = newValue }
	}
	@objc public var requestDispatcher: W3JsonRpcRequestDispatcher {
		get { return swift.requestDispatcher.objc }
		set { swift.requestDispatcher = newValue.swift }
	}
	@objc public var keystoreManager: W3KeystoreManager? {
		get { return swift.provider.attachedKeystoreManager?.objc }
		set { swift.provider.attachedKeystoreManager = newValue?.swift }
	}
	@objc public var txpool: W3TxPool {
		return W3TxPool(chain3: self)
	}
	
	@objc public func dispatch(_ request: W3JsonRpcRequest, completion: @escaping (W3JsonRpcResponse?,Error?)->()) {
		swift.dispatch(request.swift).done {
			completion($0.objc,nil)
		}.catch {
			completion(nil,$0)
		}
	}
	
	@objc public init(provider prov: W3Chain3HttpProvider, queue: OperationQueue? = nil) {
		swift = Chain3(provider: prov.swift, queue: queue)
		super.init()
		options = W3Options(object: self)
	}
	
    @objc public lazy var eth = W3Eth(chain3: self)
    @objc public lazy var personal = W3Personal(chain3: self)
    @objc public lazy var wallet = W3Wallet(chain3: self)
	
	@objc public init(infura networkId: W3NetworkId) {
		swift = Chain3(infura: networkId.swift)
		super.init()
		options = W3Options(object: self)
	}
	
	@objc public init(infura networkId: W3NetworkId, accessToken: String) {
		swift = Chain3(infura: networkId.swift, accessToken: accessToken)
		super.init()
		options = W3Options(object: self)
	}
	
	@objc public init?(url: URL) {
		guard let swift = Chain3(url: url) else { return nil }
		self.swift = swift
		super.init()
		options = W3Options(object: self)
	}
}
