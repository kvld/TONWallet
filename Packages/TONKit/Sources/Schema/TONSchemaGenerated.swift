import Foundation

public typealias Int53 = Swift.Int64
public typealias Int64 = TLInt64
public typealias Int256 = String
public typealias Bytes = Foundation.Data
public typealias SecureString = Swift.String
public typealias SecureBytes = Foundation.Data
public typealias Object = TLObject
public typealias Function = TLFunction

public struct Error: TLObject {
    public static var _type: String { "error" }

    public let code: Int32
    public let message: String

    public init(
        code: Int32,
        message: String
    ) {
        self.code = code
        self.message = message
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case code = "code"
        case message = "message"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.code = try container.decode(Int32.self, forKey: .code)
        self.message = try container.decode(String.self, forKey: .message)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.code, forKey: .code)
        try container.encode(self.message, forKey: .message)
    }
}

public struct Ok: TLObject {
    public static var _type: String { "ok" }

    public init() { }
}

public struct KeyStoreTypeDirectory: TLObject {
    public static var _type: String { "keyStoreTypeDirectory" }

    public let directory: String

    public init(
        directory: String
    ) {
        self.directory = directory
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case directory = "directory"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.directory = try container.decode(String.self, forKey: .directory)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.directory, forKey: .directory)
    }
}

public struct KeyStoreTypeInMemory: TLObject {
    public static var _type: String { "keyStoreTypeInMemory" }

    public init() { }
}

public struct Config: TLObject {
    public static var _type: String { "config" }

    public let config: String
    public let blockchainName: String
    public let useCallbacksForNetwork: Bool
    public let ignoreCache: Bool

    public init(
        config: String,
        blockchainName: String,
        useCallbacksForNetwork: Bool,
        ignoreCache: Bool
    ) {
        self.config = config
        self.blockchainName = blockchainName
        self.useCallbacksForNetwork = useCallbacksForNetwork
        self.ignoreCache = ignoreCache
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case config = "config"
        case blockchainName = "blockchain_name"
        case useCallbacksForNetwork = "use_callbacks_for_network"
        case ignoreCache = "ignore_cache"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.config = try container.decode(String.self, forKey: .config)
        self.blockchainName = try container.decode(String.self, forKey: .blockchainName)
        self.useCallbacksForNetwork = try container.decode(Bool.self, forKey: .useCallbacksForNetwork)
        self.ignoreCache = try container.decode(Bool.self, forKey: .ignoreCache)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.config, forKey: .config)
        try container.encode(self.blockchainName, forKey: .blockchainName)
        try container.encode(self.useCallbacksForNetwork, forKey: .useCallbacksForNetwork)
        try container.encode(self.ignoreCache, forKey: .ignoreCache)
    }
}

public struct Options: TLObject {
    public static var _type: String { "options" }

    public let config: Config
    public let keystoreType: KeyStoreType

    public init(
        config: Config,
        keystoreType: KeyStoreType
    ) {
        self.config = config
        self.keystoreType = keystoreType
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case config = "config"
        case keystoreType = "keystore_type"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.config = try container.decode(Config.self, forKey: .config)
        self.keystoreType = try container.decode(KeyStoreType.self, forKey: .keystoreType)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.config, forKey: .config)
        try container.encode(self.keystoreType, forKey: .keystoreType)
    }
}

public struct OptionsConfigInfo: TLObject {
    public static var _type: String { "options.configInfo" }

    public let defaultWalletId: Int64
    public let defaultRwalletInitPublicKey: String

    public init(
        defaultWalletId: Int64,
        defaultRwalletInitPublicKey: String
    ) {
        self.defaultWalletId = defaultWalletId
        self.defaultRwalletInitPublicKey = defaultRwalletInitPublicKey
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case defaultWalletId = "default_wallet_id"
        case defaultRwalletInitPublicKey = "default_rwallet_init_public_key"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.defaultWalletId = try container.decode(Int64.self, forKey: .defaultWalletId)
        self.defaultRwalletInitPublicKey = try container.decode(String.self, forKey: .defaultRwalletInitPublicKey)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.defaultWalletId, forKey: .defaultWalletId)
        try container.encode(self.defaultRwalletInitPublicKey, forKey: .defaultRwalletInitPublicKey)
    }
}

public struct OptionsInfo: TLObject {
    public static var _type: String { "options.info" }

    public let configInfo: OptionsConfigInfo

    public init(
        configInfo: OptionsConfigInfo
    ) {
        self.configInfo = configInfo
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case configInfo = "config_info"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.configInfo = try container.decode(OptionsConfigInfo.self, forKey: .configInfo)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.configInfo, forKey: .configInfo)
    }
}

public struct Key: TLObject {
    public static var _type: String { "key" }

    public let publicKey: String
    public let secret: SecureBytes

    public init(
        publicKey: String,
        secret: SecureBytes
    ) {
        self.publicKey = publicKey
        self.secret = secret
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case publicKey = "public_key"
        case secret = "secret"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.publicKey = try container.decode(String.self, forKey: .publicKey)
        self.secret = try container.decode(SecureBytes.self, forKey: .secret)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.publicKey, forKey: .publicKey)
        try container.encode(self.secret, forKey: .secret)
    }
}

public struct InputKeyRegular: TLObject {
    public static var _type: String { "inputKeyRegular" }

    public let key: Key
    public let localPassword: SecureBytes

    public init(
        key: Key,
        localPassword: SecureBytes
    ) {
        self.key = key
        self.localPassword = localPassword
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case key = "key"
        case localPassword = "local_password"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.key = try container.decode(Key.self, forKey: .key)
        self.localPassword = try container.decode(SecureBytes.self, forKey: .localPassword)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.key, forKey: .key)
        try container.encode(self.localPassword, forKey: .localPassword)
    }
}

public struct InputKeyFake: TLObject {
    public static var _type: String { "inputKeyFake" }

    public init() { }
}

public struct ExportedKey: TLObject {
    public static var _type: String { "exportedKey" }

    public let wordList: [SecureString]

    public init(
        wordList: [SecureString]
    ) {
        self.wordList = wordList
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case wordList = "word_list"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.wordList = try container.decode([SecureString].self, forKey: .wordList)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.wordList, forKey: .wordList)
    }
}

public struct ExportedPemKey: TLObject {
    public static var _type: String { "exportedPemKey" }

    public let pem: SecureString

    public init(
        pem: SecureString
    ) {
        self.pem = pem
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case pem = "pem"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.pem = try container.decode(SecureString.self, forKey: .pem)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.pem, forKey: .pem)
    }
}

public struct ExportedEncryptedKey: TLObject {
    public static var _type: String { "exportedEncryptedKey" }

    public let data: SecureBytes

    public init(
        data: SecureBytes
    ) {
        self.data = data
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case data = "data"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.data = try container.decode(SecureBytes.self, forKey: .data)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.data, forKey: .data)
    }
}

public struct ExportedUnencryptedKey: TLObject {
    public static var _type: String { "exportedUnencryptedKey" }

    public let data: SecureBytes

    public init(
        data: SecureBytes
    ) {
        self.data = data
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case data = "data"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.data = try container.decode(SecureBytes.self, forKey: .data)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.data, forKey: .data)
    }
}

public struct Bip39Hints: TLObject {
    public static var _type: String { "bip39Hints" }

    public let words: [String]

    public init(
        words: [String]
    ) {
        self.words = words
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case words = "words"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.words = try container.decode([String].self, forKey: .words)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.words, forKey: .words)
    }
}

public struct AdnlAddress: TLObject {
    public static var _type: String { "adnlAddress" }

    public let adnlAddress: String

    public init(
        adnlAddress: String
    ) {
        self.adnlAddress = adnlAddress
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case adnlAddress = "adnl_address"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.adnlAddress = try container.decode(String.self, forKey: .adnlAddress)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.adnlAddress, forKey: .adnlAddress)
    }
}

public struct AccountAddress: TLObject {
    public static var _type: String { "accountAddress" }

    public let accountAddress: String

    public init(
        accountAddress: String
    ) {
        self.accountAddress = accountAddress
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case accountAddress = "account_address"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.accountAddress = try container.decode(String.self, forKey: .accountAddress)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.accountAddress, forKey: .accountAddress)
    }
}

public struct UnpackedAccountAddress: TLObject {
    public static var _type: String { "unpackedAccountAddress" }

    public let workchainId: Int32
    public let bounceable: Bool
    public let testnet: Bool
    public let addr: Bytes

    public init(
        workchainId: Int32,
        bounceable: Bool,
        testnet: Bool,
        addr: Bytes
    ) {
        self.workchainId = workchainId
        self.bounceable = bounceable
        self.testnet = testnet
        self.addr = addr
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case workchainId = "workchain_id"
        case bounceable = "bounceable"
        case testnet = "testnet"
        case addr = "addr"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.workchainId = try container.decode(Int32.self, forKey: .workchainId)
        self.bounceable = try container.decode(Bool.self, forKey: .bounceable)
        self.testnet = try container.decode(Bool.self, forKey: .testnet)
        self.addr = try container.decode(Bytes.self, forKey: .addr)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.workchainId, forKey: .workchainId)
        try container.encode(self.bounceable, forKey: .bounceable)
        try container.encode(self.testnet, forKey: .testnet)
        try container.encode(self.addr, forKey: .addr)
    }
}

public struct InternalTransactionId: TLObject {
    public static var _type: String { "internal.transactionId" }

    public let lt: Int64
    public let hash: Bytes

    public init(
        lt: Int64,
        hash: Bytes
    ) {
        self.lt = lt
        self.hash = hash
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case lt = "lt"
        case hash = "hash"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.lt = try container.decode(Int64.self, forKey: .lt)
        self.hash = try container.decode(Bytes.self, forKey: .hash)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.lt, forKey: .lt)
        try container.encode(self.hash, forKey: .hash)
    }
}

public struct TonBlockId: TLObject {
    public static var _type: String { "ton.blockId" }

    public let workchain: Int32
    public let shard: Int64
    public let seqno: Int32

    public init(
        workchain: Int32,
        shard: Int64,
        seqno: Int32
    ) {
        self.workchain = workchain
        self.shard = shard
        self.seqno = seqno
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case workchain = "workchain"
        case shard = "shard"
        case seqno = "seqno"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.workchain = try container.decode(Int32.self, forKey: .workchain)
        self.shard = try container.decode(Int64.self, forKey: .shard)
        self.seqno = try container.decode(Int32.self, forKey: .seqno)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.workchain, forKey: .workchain)
        try container.encode(self.shard, forKey: .shard)
        try container.encode(self.seqno, forKey: .seqno)
    }
}

public struct TonBlockIdExt: TLObject {
    public static var _type: String { "ton.blockIdExt" }

    public let workchain: Int32
    public let shard: Int64
    public let seqno: Int32
    public let rootHash: Bytes
    public let fileHash: Bytes

    public init(
        workchain: Int32,
        shard: Int64,
        seqno: Int32,
        rootHash: Bytes,
        fileHash: Bytes
    ) {
        self.workchain = workchain
        self.shard = shard
        self.seqno = seqno
        self.rootHash = rootHash
        self.fileHash = fileHash
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case workchain = "workchain"
        case shard = "shard"
        case seqno = "seqno"
        case rootHash = "root_hash"
        case fileHash = "file_hash"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.workchain = try container.decode(Int32.self, forKey: .workchain)
        self.shard = try container.decode(Int64.self, forKey: .shard)
        self.seqno = try container.decode(Int32.self, forKey: .seqno)
        self.rootHash = try container.decode(Bytes.self, forKey: .rootHash)
        self.fileHash = try container.decode(Bytes.self, forKey: .fileHash)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.workchain, forKey: .workchain)
        try container.encode(self.shard, forKey: .shard)
        try container.encode(self.seqno, forKey: .seqno)
        try container.encode(self.rootHash, forKey: .rootHash)
        try container.encode(self.fileHash, forKey: .fileHash)
    }
}

public struct RawFullAccountState: TLObject {
    public static var _type: String { "raw.fullAccountState" }

    public let balance: Int64
    public let code: Bytes
    public let data: Bytes
    public let lastTransactionId: InternalTransactionId
    public let blockId: TonBlockIdExt
    public let frozenHash: Bytes
    public let syncUtime: Int53

    public init(
        balance: Int64,
        code: Bytes,
        data: Bytes,
        lastTransactionId: InternalTransactionId,
        blockId: TonBlockIdExt,
        frozenHash: Bytes,
        syncUtime: Int53
    ) {
        self.balance = balance
        self.code = code
        self.data = data
        self.lastTransactionId = lastTransactionId
        self.blockId = blockId
        self.frozenHash = frozenHash
        self.syncUtime = syncUtime
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case balance = "balance"
        case code = "code"
        case data = "data"
        case lastTransactionId = "last_transaction_id"
        case blockId = "block_id"
        case frozenHash = "frozen_hash"
        case syncUtime = "sync_utime"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.balance = try container.decode(Int64.self, forKey: .balance)
        self.code = try container.decode(Bytes.self, forKey: .code)
        self.data = try container.decode(Bytes.self, forKey: .data)
        self.lastTransactionId = try container.decode(InternalTransactionId.self, forKey: .lastTransactionId)
        self.blockId = try container.decode(TonBlockIdExt.self, forKey: .blockId)
        self.frozenHash = try container.decode(Bytes.self, forKey: .frozenHash)
        self.syncUtime = try container.decode(Int53.self, forKey: .syncUtime)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.balance, forKey: .balance)
        try container.encode(self.code, forKey: .code)
        try container.encode(self.data, forKey: .data)
        try container.encode(self.lastTransactionId, forKey: .lastTransactionId)
        try container.encode(self.blockId, forKey: .blockId)
        try container.encode(self.frozenHash, forKey: .frozenHash)
        try container.encode(self.syncUtime, forKey: .syncUtime)
    }
}

public struct RawMessage: TLObject {
    public static var _type: String { "raw.message" }

    public let source: AccountAddress
    public let destination: AccountAddress
    public let value: Int64
    public let fwdFee: Int64
    public let ihrFee: Int64
    public let createdLt: Int64
    public let bodyHash: Bytes
    public let msgData: MsgData

    public init(
        source: AccountAddress,
        destination: AccountAddress,
        value: Int64,
        fwdFee: Int64,
        ihrFee: Int64,
        createdLt: Int64,
        bodyHash: Bytes,
        msgData: MsgData
    ) {
        self.source = source
        self.destination = destination
        self.value = value
        self.fwdFee = fwdFee
        self.ihrFee = ihrFee
        self.createdLt = createdLt
        self.bodyHash = bodyHash
        self.msgData = msgData
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case source = "source"
        case destination = "destination"
        case value = "value"
        case fwdFee = "fwd_fee"
        case ihrFee = "ihr_fee"
        case createdLt = "created_lt"
        case bodyHash = "body_hash"
        case msgData = "msg_data"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.source = try container.decode(AccountAddress.self, forKey: .source)
        self.destination = try container.decode(AccountAddress.self, forKey: .destination)
        self.value = try container.decode(Int64.self, forKey: .value)
        self.fwdFee = try container.decode(Int64.self, forKey: .fwdFee)
        self.ihrFee = try container.decode(Int64.self, forKey: .ihrFee)
        self.createdLt = try container.decode(Int64.self, forKey: .createdLt)
        self.bodyHash = try container.decode(Bytes.self, forKey: .bodyHash)
        self.msgData = try container.decode(MsgData.self, forKey: .msgData)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.source, forKey: .source)
        try container.encode(self.destination, forKey: .destination)
        try container.encode(self.value, forKey: .value)
        try container.encode(self.fwdFee, forKey: .fwdFee)
        try container.encode(self.ihrFee, forKey: .ihrFee)
        try container.encode(self.createdLt, forKey: .createdLt)
        try container.encode(self.bodyHash, forKey: .bodyHash)
        try container.encode(self.msgData, forKey: .msgData)
    }
}

public struct RawTransaction: TLObject {
    public static var _type: String { "raw.transaction" }

    public let address: AccountAddress
    public let utime: Int53
    public let data: Bytes
    public let transactionId: InternalTransactionId
    public let fee: Int64
    public let storageFee: Int64
    public let otherFee: Int64
    public let inMsg: RawMessage
    public let outMsgs: [RawMessage]

    public init(
        address: AccountAddress,
        utime: Int53,
        data: Bytes,
        transactionId: InternalTransactionId,
        fee: Int64,
        storageFee: Int64,
        otherFee: Int64,
        inMsg: RawMessage,
        outMsgs: [RawMessage]
    ) {
        self.address = address
        self.utime = utime
        self.data = data
        self.transactionId = transactionId
        self.fee = fee
        self.storageFee = storageFee
        self.otherFee = otherFee
        self.inMsg = inMsg
        self.outMsgs = outMsgs
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case address = "address"
        case utime = "utime"
        case data = "data"
        case transactionId = "transaction_id"
        case fee = "fee"
        case storageFee = "storage_fee"
        case otherFee = "other_fee"
        case inMsg = "in_msg"
        case outMsgs = "out_msgs"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.address = try container.decode(AccountAddress.self, forKey: .address)
        self.utime = try container.decode(Int53.self, forKey: .utime)
        self.data = try container.decode(Bytes.self, forKey: .data)
        self.transactionId = try container.decode(InternalTransactionId.self, forKey: .transactionId)
        self.fee = try container.decode(Int64.self, forKey: .fee)
        self.storageFee = try container.decode(Int64.self, forKey: .storageFee)
        self.otherFee = try container.decode(Int64.self, forKey: .otherFee)
        self.inMsg = try container.decode(RawMessage.self, forKey: .inMsg)
        self.outMsgs = try container.decode([RawMessage].self, forKey: .outMsgs)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.address, forKey: .address)
        try container.encode(self.utime, forKey: .utime)
        try container.encode(self.data, forKey: .data)
        try container.encode(self.transactionId, forKey: .transactionId)
        try container.encode(self.fee, forKey: .fee)
        try container.encode(self.storageFee, forKey: .storageFee)
        try container.encode(self.otherFee, forKey: .otherFee)
        try container.encode(self.inMsg, forKey: .inMsg)
        try container.encode(self.outMsgs, forKey: .outMsgs)
    }
}

public struct RawTransactions: TLObject {
    public static var _type: String { "raw.transactions" }

    public let transactions: [RawTransaction]
    public let previousTransactionId: InternalTransactionId

    public init(
        transactions: [RawTransaction],
        previousTransactionId: InternalTransactionId
    ) {
        self.transactions = transactions
        self.previousTransactionId = previousTransactionId
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case transactions = "transactions"
        case previousTransactionId = "previous_transaction_id"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.transactions = try container.decode([RawTransaction].self, forKey: .transactions)
        self.previousTransactionId = try container.decode(InternalTransactionId.self, forKey: .previousTransactionId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.transactions, forKey: .transactions)
        try container.encode(self.previousTransactionId, forKey: .previousTransactionId)
    }
}

public struct RawExtMessageInfo: TLObject {
    public static var _type: String { "raw.extMessageInfo" }

    public let hash: Bytes

    public init(
        hash: Bytes
    ) {
        self.hash = hash
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case hash = "hash"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.hash = try container.decode(Bytes.self, forKey: .hash)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.hash, forKey: .hash)
    }
}

public struct PchanConfig: TLObject {
    public static var _type: String { "pchan.config" }

    public let alicePublicKey: String
    public let aliceAddress: AccountAddress
    public let bobPublicKey: String
    public let bobAddress: AccountAddress
    public let initTimeout: Int32
    public let closeTimeout: Int32
    public let channelId: Int64

    public init(
        alicePublicKey: String,
        aliceAddress: AccountAddress,
        bobPublicKey: String,
        bobAddress: AccountAddress,
        initTimeout: Int32,
        closeTimeout: Int32,
        channelId: Int64
    ) {
        self.alicePublicKey = alicePublicKey
        self.aliceAddress = aliceAddress
        self.bobPublicKey = bobPublicKey
        self.bobAddress = bobAddress
        self.initTimeout = initTimeout
        self.closeTimeout = closeTimeout
        self.channelId = channelId
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case alicePublicKey = "alice_public_key"
        case aliceAddress = "alice_address"
        case bobPublicKey = "bob_public_key"
        case bobAddress = "bob_address"
        case initTimeout = "init_timeout"
        case closeTimeout = "close_timeout"
        case channelId = "channel_id"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.alicePublicKey = try container.decode(String.self, forKey: .alicePublicKey)
        self.aliceAddress = try container.decode(AccountAddress.self, forKey: .aliceAddress)
        self.bobPublicKey = try container.decode(String.self, forKey: .bobPublicKey)
        self.bobAddress = try container.decode(AccountAddress.self, forKey: .bobAddress)
        self.initTimeout = try container.decode(Int32.self, forKey: .initTimeout)
        self.closeTimeout = try container.decode(Int32.self, forKey: .closeTimeout)
        self.channelId = try container.decode(Int64.self, forKey: .channelId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.alicePublicKey, forKey: .alicePublicKey)
        try container.encode(self.aliceAddress, forKey: .aliceAddress)
        try container.encode(self.bobPublicKey, forKey: .bobPublicKey)
        try container.encode(self.bobAddress, forKey: .bobAddress)
        try container.encode(self.initTimeout, forKey: .initTimeout)
        try container.encode(self.closeTimeout, forKey: .closeTimeout)
        try container.encode(self.channelId, forKey: .channelId)
    }
}

public struct RawInitialAccountState: TLObject {
    public static var _type: String { "raw.initialAccountState" }

    public let code: Bytes
    public let data: Bytes

    public init(
        code: Bytes,
        data: Bytes
    ) {
        self.code = code
        self.data = data
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case code = "code"
        case data = "data"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.code = try container.decode(Bytes.self, forKey: .code)
        self.data = try container.decode(Bytes.self, forKey: .data)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.code, forKey: .code)
        try container.encode(self.data, forKey: .data)
    }
}

public struct WalletV3InitialAccountState: TLObject {
    public static var _type: String { "wallet.v3.initialAccountState" }

    public let publicKey: String
    public let walletId: Int64

    public init(
        publicKey: String,
        walletId: Int64
    ) {
        self.publicKey = publicKey
        self.walletId = walletId
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case publicKey = "public_key"
        case walletId = "wallet_id"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.publicKey = try container.decode(String.self, forKey: .publicKey)
        self.walletId = try container.decode(Int64.self, forKey: .walletId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.publicKey, forKey: .publicKey)
        try container.encode(self.walletId, forKey: .walletId)
    }
}

public struct WalletHighloadV1InitialAccountState: TLObject {
    public static var _type: String { "wallet.highload.v1.initialAccountState" }

    public let publicKey: String
    public let walletId: Int64

    public init(
        publicKey: String,
        walletId: Int64
    ) {
        self.publicKey = publicKey
        self.walletId = walletId
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case publicKey = "public_key"
        case walletId = "wallet_id"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.publicKey = try container.decode(String.self, forKey: .publicKey)
        self.walletId = try container.decode(Int64.self, forKey: .walletId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.publicKey, forKey: .publicKey)
        try container.encode(self.walletId, forKey: .walletId)
    }
}

public struct WalletHighloadV2InitialAccountState: TLObject {
    public static var _type: String { "wallet.highload.v2.initialAccountState" }

    public let publicKey: String
    public let walletId: Int64

    public init(
        publicKey: String,
        walletId: Int64
    ) {
        self.publicKey = publicKey
        self.walletId = walletId
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case publicKey = "public_key"
        case walletId = "wallet_id"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.publicKey = try container.decode(String.self, forKey: .publicKey)
        self.walletId = try container.decode(Int64.self, forKey: .walletId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.publicKey, forKey: .publicKey)
        try container.encode(self.walletId, forKey: .walletId)
    }
}

public struct RwalletLimit: TLObject {
    public static var _type: String { "rwallet.limit" }

    public let seconds: Int32
    public let value: Int64

    public init(
        seconds: Int32,
        value: Int64
    ) {
        self.seconds = seconds
        self.value = value
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case seconds = "seconds"
        case value = "value"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.seconds = try container.decode(Int32.self, forKey: .seconds)
        self.value = try container.decode(Int64.self, forKey: .value)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.seconds, forKey: .seconds)
        try container.encode(self.value, forKey: .value)
    }
}

public struct RwalletConfig: TLObject {
    public static var _type: String { "rwallet.config" }

    public let startAt: Int53
    public let limits: [RwalletLimit]

    public init(
        startAt: Int53,
        limits: [RwalletLimit]
    ) {
        self.startAt = startAt
        self.limits = limits
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case startAt = "start_at"
        case limits = "limits"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.startAt = try container.decode(Int53.self, forKey: .startAt)
        self.limits = try container.decode([RwalletLimit].self, forKey: .limits)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.startAt, forKey: .startAt)
        try container.encode(self.limits, forKey: .limits)
    }
}

public struct RwalletInitialAccountState: TLObject {
    public static var _type: String { "rwallet.initialAccountState" }

    public let initPublicKey: String
    public let publicKey: String
    public let walletId: Int64

    public init(
        initPublicKey: String,
        publicKey: String,
        walletId: Int64
    ) {
        self.initPublicKey = initPublicKey
        self.publicKey = publicKey
        self.walletId = walletId
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case initPublicKey = "init_public_key"
        case publicKey = "public_key"
        case walletId = "wallet_id"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.initPublicKey = try container.decode(String.self, forKey: .initPublicKey)
        self.publicKey = try container.decode(String.self, forKey: .publicKey)
        self.walletId = try container.decode(Int64.self, forKey: .walletId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.initPublicKey, forKey: .initPublicKey)
        try container.encode(self.publicKey, forKey: .publicKey)
        try container.encode(self.walletId, forKey: .walletId)
    }
}

public struct DnsInitialAccountState: TLObject {
    public static var _type: String { "dns.initialAccountState" }

    public let publicKey: String
    public let walletId: Int64

    public init(
        publicKey: String,
        walletId: Int64
    ) {
        self.publicKey = publicKey
        self.walletId = walletId
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case publicKey = "public_key"
        case walletId = "wallet_id"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.publicKey = try container.decode(String.self, forKey: .publicKey)
        self.walletId = try container.decode(Int64.self, forKey: .walletId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.publicKey, forKey: .publicKey)
        try container.encode(self.walletId, forKey: .walletId)
    }
}

public struct PchanInitialAccountState: TLObject {
    public static var _type: String { "pchan.initialAccountState" }

    public let config: PchanConfig

    public init(
        config: PchanConfig
    ) {
        self.config = config
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case config = "config"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.config = try container.decode(PchanConfig.self, forKey: .config)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.config, forKey: .config)
    }
}

public struct RawAccountState: TLObject {
    public static var _type: String { "raw.accountState" }

    public let code: Bytes
    public let data: Bytes
    public let frozenHash: Bytes

    public init(
        code: Bytes,
        data: Bytes,
        frozenHash: Bytes
    ) {
        self.code = code
        self.data = data
        self.frozenHash = frozenHash
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case code = "code"
        case data = "data"
        case frozenHash = "frozen_hash"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.code = try container.decode(Bytes.self, forKey: .code)
        self.data = try container.decode(Bytes.self, forKey: .data)
        self.frozenHash = try container.decode(Bytes.self, forKey: .frozenHash)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.code, forKey: .code)
        try container.encode(self.data, forKey: .data)
        try container.encode(self.frozenHash, forKey: .frozenHash)
    }
}

public struct WalletV3AccountState: TLObject {
    public static var _type: String { "wallet.v3.accountState" }

    public let walletId: Int64
    public let seqno: Int32

    public init(
        walletId: Int64,
        seqno: Int32
    ) {
        self.walletId = walletId
        self.seqno = seqno
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case walletId = "wallet_id"
        case seqno = "seqno"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.walletId = try container.decode(Int64.self, forKey: .walletId)
        self.seqno = try container.decode(Int32.self, forKey: .seqno)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.walletId, forKey: .walletId)
        try container.encode(self.seqno, forKey: .seqno)
    }
}

public struct WalletHighloadV1AccountState: TLObject {
    public static var _type: String { "wallet.highload.v1.accountState" }

    public let walletId: Int64
    public let seqno: Int32

    public init(
        walletId: Int64,
        seqno: Int32
    ) {
        self.walletId = walletId
        self.seqno = seqno
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case walletId = "wallet_id"
        case seqno = "seqno"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.walletId = try container.decode(Int64.self, forKey: .walletId)
        self.seqno = try container.decode(Int32.self, forKey: .seqno)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.walletId, forKey: .walletId)
        try container.encode(self.seqno, forKey: .seqno)
    }
}

public struct WalletHighloadV2AccountState: TLObject {
    public static var _type: String { "wallet.highload.v2.accountState" }

    public let walletId: Int64

    public init(
        walletId: Int64
    ) {
        self.walletId = walletId
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case walletId = "wallet_id"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.walletId = try container.decode(Int64.self, forKey: .walletId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.walletId, forKey: .walletId)
    }
}

public struct DnsAccountState: TLObject {
    public static var _type: String { "dns.accountState" }

    public let walletId: Int64

    public init(
        walletId: Int64
    ) {
        self.walletId = walletId
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case walletId = "wallet_id"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.walletId = try container.decode(Int64.self, forKey: .walletId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.walletId, forKey: .walletId)
    }
}

public struct RwalletAccountState: TLObject {
    public static var _type: String { "rwallet.accountState" }

    public let walletId: Int64
    public let seqno: Int32
    public let unlockedBalance: Int64
    public let config: RwalletConfig

    public init(
        walletId: Int64,
        seqno: Int32,
        unlockedBalance: Int64,
        config: RwalletConfig
    ) {
        self.walletId = walletId
        self.seqno = seqno
        self.unlockedBalance = unlockedBalance
        self.config = config
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case walletId = "wallet_id"
        case seqno = "seqno"
        case unlockedBalance = "unlocked_balance"
        case config = "config"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.walletId = try container.decode(Int64.self, forKey: .walletId)
        self.seqno = try container.decode(Int32.self, forKey: .seqno)
        self.unlockedBalance = try container.decode(Int64.self, forKey: .unlockedBalance)
        self.config = try container.decode(RwalletConfig.self, forKey: .config)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.walletId, forKey: .walletId)
        try container.encode(self.seqno, forKey: .seqno)
        try container.encode(self.unlockedBalance, forKey: .unlockedBalance)
        try container.encode(self.config, forKey: .config)
    }
}

public struct PchanStateInit: TLObject {
    public static var _type: String { "pchan.stateInit" }

    public let signedA: Bool
    public let signedB: Bool
    public let minA: Int64
    public let minB: Int64
    public let expireAt: Int53
    public let a: Int64
    public let b: Int64

    public init(
        signedA: Bool,
        signedB: Bool,
        minA: Int64,
        minB: Int64,
        expireAt: Int53,
        a: Int64,
        b: Int64
    ) {
        self.signedA = signedA
        self.signedB = signedB
        self.minA = minA
        self.minB = minB
        self.expireAt = expireAt
        self.a = a
        self.b = b
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case signedA = "signed_a"
        case signedB = "signed_b"
        case minA = "min_a"
        case minB = "min_b"
        case expireAt = "expire_at"
        case a = "a"
        case b = "b"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.signedA = try container.decode(Bool.self, forKey: .signedA)
        self.signedB = try container.decode(Bool.self, forKey: .signedB)
        self.minA = try container.decode(Int64.self, forKey: .minA)
        self.minB = try container.decode(Int64.self, forKey: .minB)
        self.expireAt = try container.decode(Int53.self, forKey: .expireAt)
        self.a = try container.decode(Int64.self, forKey: .a)
        self.b = try container.decode(Int64.self, forKey: .b)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.signedA, forKey: .signedA)
        try container.encode(self.signedB, forKey: .signedB)
        try container.encode(self.minA, forKey: .minA)
        try container.encode(self.minB, forKey: .minB)
        try container.encode(self.expireAt, forKey: .expireAt)
        try container.encode(self.a, forKey: .a)
        try container.encode(self.b, forKey: .b)
    }
}

public struct PchanStateClose: TLObject {
    public static var _type: String { "pchan.stateClose" }

    public let signedA: Bool
    public let signedB: Bool
    public let minA: Int64
    public let minB: Int64
    public let expireAt: Int53
    public let a: Int64
    public let b: Int64

    public init(
        signedA: Bool,
        signedB: Bool,
        minA: Int64,
        minB: Int64,
        expireAt: Int53,
        a: Int64,
        b: Int64
    ) {
        self.signedA = signedA
        self.signedB = signedB
        self.minA = minA
        self.minB = minB
        self.expireAt = expireAt
        self.a = a
        self.b = b
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case signedA = "signed_a"
        case signedB = "signed_b"
        case minA = "min_a"
        case minB = "min_b"
        case expireAt = "expire_at"
        case a = "a"
        case b = "b"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.signedA = try container.decode(Bool.self, forKey: .signedA)
        self.signedB = try container.decode(Bool.self, forKey: .signedB)
        self.minA = try container.decode(Int64.self, forKey: .minA)
        self.minB = try container.decode(Int64.self, forKey: .minB)
        self.expireAt = try container.decode(Int53.self, forKey: .expireAt)
        self.a = try container.decode(Int64.self, forKey: .a)
        self.b = try container.decode(Int64.self, forKey: .b)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.signedA, forKey: .signedA)
        try container.encode(self.signedB, forKey: .signedB)
        try container.encode(self.minA, forKey: .minA)
        try container.encode(self.minB, forKey: .minB)
        try container.encode(self.expireAt, forKey: .expireAt)
        try container.encode(self.a, forKey: .a)
        try container.encode(self.b, forKey: .b)
    }
}

public struct PchanStatePayout: TLObject {
    public static var _type: String { "pchan.statePayout" }

    public let a: Int64
    public let b: Int64

    public init(
        a: Int64,
        b: Int64
    ) {
        self.a = a
        self.b = b
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case a = "a"
        case b = "b"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.a = try container.decode(Int64.self, forKey: .a)
        self.b = try container.decode(Int64.self, forKey: .b)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.a, forKey: .a)
        try container.encode(self.b, forKey: .b)
    }
}

public struct PchanAccountState: TLObject {
    public static var _type: String { "pchan.accountState" }

    public let config: PchanConfig
    public let state: PchanState
    public let description: String

    public init(
        config: PchanConfig,
        state: PchanState,
        description: String
    ) {
        self.config = config
        self.state = state
        self.description = description
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case config = "config"
        case state = "state"
        case description = "description"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.config = try container.decode(PchanConfig.self, forKey: .config)
        self.state = try container.decode(PchanState.self, forKey: .state)
        self.description = try container.decode(String.self, forKey: .description)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.config, forKey: .config)
        try container.encode(self.state, forKey: .state)
        try container.encode(self.description, forKey: .description)
    }
}

public struct UninitedAccountState: TLObject {
    public static var _type: String { "uninited.accountState" }

    public let frozenHash: Bytes

    public init(
        frozenHash: Bytes
    ) {
        self.frozenHash = frozenHash
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case frozenHash = "frozen_hash"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.frozenHash = try container.decode(Bytes.self, forKey: .frozenHash)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.frozenHash, forKey: .frozenHash)
    }
}

public struct FullAccountState: TLObject {
    public static var _type: String { "fullAccountState" }

    public let address: AccountAddress
    public let balance: Int64
    public let lastTransactionId: InternalTransactionId
    public let blockId: TonBlockIdExt
    public let syncUtime: Int53
    public let accountState: AccountState
    public let revision: Int32

    public init(
        address: AccountAddress,
        balance: Int64,
        lastTransactionId: InternalTransactionId,
        blockId: TonBlockIdExt,
        syncUtime: Int53,
        accountState: AccountState,
        revision: Int32
    ) {
        self.address = address
        self.balance = balance
        self.lastTransactionId = lastTransactionId
        self.blockId = blockId
        self.syncUtime = syncUtime
        self.accountState = accountState
        self.revision = revision
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case address = "address"
        case balance = "balance"
        case lastTransactionId = "last_transaction_id"
        case blockId = "block_id"
        case syncUtime = "sync_utime"
        case accountState = "account_state"
        case revision = "revision"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.address = try container.decode(AccountAddress.self, forKey: .address)
        self.balance = try container.decode(Int64.self, forKey: .balance)
        self.lastTransactionId = try container.decode(InternalTransactionId.self, forKey: .lastTransactionId)
        self.blockId = try container.decode(TonBlockIdExt.self, forKey: .blockId)
        self.syncUtime = try container.decode(Int53.self, forKey: .syncUtime)
        self.accountState = try container.decode(AccountState.self, forKey: .accountState)
        self.revision = try container.decode(Int32.self, forKey: .revision)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.address, forKey: .address)
        try container.encode(self.balance, forKey: .balance)
        try container.encode(self.lastTransactionId, forKey: .lastTransactionId)
        try container.encode(self.blockId, forKey: .blockId)
        try container.encode(self.syncUtime, forKey: .syncUtime)
        try container.encode(self.accountState, forKey: .accountState)
        try container.encode(self.revision, forKey: .revision)
    }
}

public struct AccountRevisionList: TLObject {
    public static var _type: String { "accountRevisionList" }

    public let revisions: [FullAccountState]

    public init(
        revisions: [FullAccountState]
    ) {
        self.revisions = revisions
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case revisions = "revisions"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.revisions = try container.decode([FullAccountState].self, forKey: .revisions)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.revisions, forKey: .revisions)
    }
}

public struct AccountList: TLObject {
    public static var _type: String { "accountList" }

    public let accounts: [FullAccountState]

    public init(
        accounts: [FullAccountState]
    ) {
        self.accounts = accounts
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case accounts = "accounts"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.accounts = try container.decode([FullAccountState].self, forKey: .accounts)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.accounts, forKey: .accounts)
    }
}

public struct SyncStateDone: TLObject {
    public static var _type: String { "syncStateDone" }

    public init() { }
}

public struct SyncStateInProgress: TLObject {
    public static var _type: String { "syncStateInProgress" }

    public let fromSeqno: Int32
    public let toSeqno: Int32
    public let currentSeqno: Int32

    public init(
        fromSeqno: Int32,
        toSeqno: Int32,
        currentSeqno: Int32
    ) {
        self.fromSeqno = fromSeqno
        self.toSeqno = toSeqno
        self.currentSeqno = currentSeqno
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case fromSeqno = "from_seqno"
        case toSeqno = "to_seqno"
        case currentSeqno = "current_seqno"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.fromSeqno = try container.decode(Int32.self, forKey: .fromSeqno)
        self.toSeqno = try container.decode(Int32.self, forKey: .toSeqno)
        self.currentSeqno = try container.decode(Int32.self, forKey: .currentSeqno)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.fromSeqno, forKey: .fromSeqno)
        try container.encode(self.toSeqno, forKey: .toSeqno)
        try container.encode(self.currentSeqno, forKey: .currentSeqno)
    }
}

public struct MsgDataRaw: TLObject {
    public static var _type: String { "msg.dataRaw" }

    public let body: Bytes
    public let initState: Bytes

    public init(
        body: Bytes,
        initState: Bytes
    ) {
        self.body = body
        self.initState = initState
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case body = "body"
        case initState = "init_state"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.body = try container.decode(Bytes.self, forKey: .body)
        self.initState = try container.decode(Bytes.self, forKey: .initState)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.body, forKey: .body)
        try container.encode(self.initState, forKey: .initState)
    }
}

public struct MsgDataText: TLObject {
    public static var _type: String { "msg.dataText" }

    public let text: Bytes

    public init(
        text: Bytes
    ) {
        self.text = text
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case text = "text"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.text = try container.decode(Bytes.self, forKey: .text)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.text, forKey: .text)
    }
}

public struct MsgDataDecryptedText: TLObject {
    public static var _type: String { "msg.dataDecryptedText" }

    public let text: Bytes

    public init(
        text: Bytes
    ) {
        self.text = text
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case text = "text"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.text = try container.decode(Bytes.self, forKey: .text)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.text, forKey: .text)
    }
}

public struct MsgDataEncryptedText: TLObject {
    public static var _type: String { "msg.dataEncryptedText" }

    public let text: Bytes

    public init(
        text: Bytes
    ) {
        self.text = text
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case text = "text"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.text = try container.decode(Bytes.self, forKey: .text)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.text, forKey: .text)
    }
}

public struct MsgDataEncrypted: TLObject {
    public static var _type: String { "msg.dataEncrypted" }

    public let source: AccountAddress
    public let data: MsgData

    public init(
        source: AccountAddress,
        data: MsgData
    ) {
        self.source = source
        self.data = data
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case source = "source"
        case data = "data"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.source = try container.decode(AccountAddress.self, forKey: .source)
        self.data = try container.decode(MsgData.self, forKey: .data)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.source, forKey: .source)
        try container.encode(self.data, forKey: .data)
    }
}

public struct MsgDataDecrypted: TLObject {
    public static var _type: String { "msg.dataDecrypted" }

    public let proof: Bytes
    public let data: MsgData

    public init(
        proof: Bytes,
        data: MsgData
    ) {
        self.proof = proof
        self.data = data
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case proof = "proof"
        case data = "data"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.proof = try container.decode(Bytes.self, forKey: .proof)
        self.data = try container.decode(MsgData.self, forKey: .data)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.proof, forKey: .proof)
        try container.encode(self.data, forKey: .data)
    }
}

public struct MsgDataEncryptedArray: TLObject {
    public static var _type: String { "msg.dataEncryptedArray" }

    public let elements: [MsgDataEncrypted]

    public init(
        elements: [MsgDataEncrypted]
    ) {
        self.elements = elements
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case elements = "elements"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.elements = try container.decode([MsgDataEncrypted].self, forKey: .elements)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.elements, forKey: .elements)
    }
}

public struct MsgDataDecryptedArray: TLObject {
    public static var _type: String { "msg.dataDecryptedArray" }

    public let elements: [MsgDataDecrypted]

    public init(
        elements: [MsgDataDecrypted]
    ) {
        self.elements = elements
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case elements = "elements"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.elements = try container.decode([MsgDataDecrypted].self, forKey: .elements)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.elements, forKey: .elements)
    }
}

public struct MsgMessage: TLObject {
    public static var _type: String { "msg.message" }

    public let destination: AccountAddress
    public let publicKey: String
    public let amount: Int64
    public let data: MsgData
    public let sendMode: Int32

    public init(
        destination: AccountAddress,
        publicKey: String,
        amount: Int64,
        data: MsgData,
        sendMode: Int32
    ) {
        self.destination = destination
        self.publicKey = publicKey
        self.amount = amount
        self.data = data
        self.sendMode = sendMode
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case destination = "destination"
        case publicKey = "public_key"
        case amount = "amount"
        case data = "data"
        case sendMode = "send_mode"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.destination = try container.decode(AccountAddress.self, forKey: .destination)
        self.publicKey = try container.decode(String.self, forKey: .publicKey)
        self.amount = try container.decode(Int64.self, forKey: .amount)
        self.data = try container.decode(MsgData.self, forKey: .data)
        self.sendMode = try container.decode(Int32.self, forKey: .sendMode)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.destination, forKey: .destination)
        try container.encode(self.publicKey, forKey: .publicKey)
        try container.encode(self.amount, forKey: .amount)
        try container.encode(self.data, forKey: .data)
        try container.encode(self.sendMode, forKey: .sendMode)
    }
}

public struct DnsEntryDataUnknown: TLObject {
    public static var _type: String { "dns.entryDataUnknown" }

    public let bytes: Bytes

    public init(
        bytes: Bytes
    ) {
        self.bytes = bytes
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case bytes = "bytes"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.bytes = try container.decode(Bytes.self, forKey: .bytes)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.bytes, forKey: .bytes)
    }
}

public struct DnsEntryDataText: TLObject {
    public static var _type: String { "dns.entryDataText" }

    public let text: String

    public init(
        text: String
    ) {
        self.text = text
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case text = "text"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.text = try container.decode(String.self, forKey: .text)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.text, forKey: .text)
    }
}

public struct DnsEntryDataNextResolver: TLObject {
    public static var _type: String { "dns.entryDataNextResolver" }

    public let resolver: AccountAddress

    public init(
        resolver: AccountAddress
    ) {
        self.resolver = resolver
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case resolver = "resolver"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.resolver = try container.decode(AccountAddress.self, forKey: .resolver)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.resolver, forKey: .resolver)
    }
}

public struct DnsEntryDataSmcAddress: TLObject {
    public static var _type: String { "dns.entryDataSmcAddress" }

    public let smcAddress: AccountAddress

    public init(
        smcAddress: AccountAddress
    ) {
        self.smcAddress = smcAddress
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case smcAddress = "smc_address"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.smcAddress = try container.decode(AccountAddress.self, forKey: .smcAddress)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.smcAddress, forKey: .smcAddress)
    }
}

public struct DnsEntryDataAdnlAddress: TLObject {
    public static var _type: String { "dns.entryDataAdnlAddress" }

    public let adnlAddress: AdnlAddress

    public init(
        adnlAddress: AdnlAddress
    ) {
        self.adnlAddress = adnlAddress
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case adnlAddress = "adnl_address"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.adnlAddress = try container.decode(AdnlAddress.self, forKey: .adnlAddress)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.adnlAddress, forKey: .adnlAddress)
    }
}

public struct DnsEntryDataStorageAddress: TLObject {
    public static var _type: String { "dns.entryDataStorageAddress" }

    public let bagId: Int256

    public init(
        bagId: Int256
    ) {
        self.bagId = bagId
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case bagId = "bag_id"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.bagId = try container.decode(Int256.self, forKey: .bagId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.bagId, forKey: .bagId)
    }
}

public struct DnsEntry: TLObject {
    public static var _type: String { "dns.entry" }

    public let name: String
    public let category: Int256
    public let entry: DnsEntryData

    public init(
        name: String,
        category: Int256,
        entry: DnsEntryData
    ) {
        self.name = name
        self.category = category
        self.entry = entry
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case name = "name"
        case category = "category"
        case entry = "entry"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.category = try container.decode(Int256.self, forKey: .category)
        self.entry = try container.decode(DnsEntryData.self, forKey: .entry)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.category, forKey: .category)
        try container.encode(self.entry, forKey: .entry)
    }
}

public struct DnsActionDeleteAll: TLObject {
    public static var _type: String { "dns.actionDeleteAll" }

    public init() { }
}

public struct DnsActionDelete: TLObject {
    public static var _type: String { "dns.actionDelete" }

    public let name: String
    public let category: Int256

    public init(
        name: String,
        category: Int256
    ) {
        self.name = name
        self.category = category
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case name = "name"
        case category = "category"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.category = try container.decode(Int256.self, forKey: .category)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.category, forKey: .category)
    }
}

public struct DnsActionSet: TLObject {
    public static var _type: String { "dns.actionSet" }

    public let entry: DnsEntry

    public init(
        entry: DnsEntry
    ) {
        self.entry = entry
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case entry = "entry"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.entry = try container.decode(DnsEntry.self, forKey: .entry)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.entry, forKey: .entry)
    }
}

public struct DnsResolved: TLObject {
    public static var _type: String { "dns.resolved" }

    public let entries: [DnsEntry]

    public init(
        entries: [DnsEntry]
    ) {
        self.entries = entries
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case entries = "entries"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.entries = try container.decode([DnsEntry].self, forKey: .entries)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.entries, forKey: .entries)
    }
}

public struct PchanPromise: TLObject {
    public static var _type: String { "pchan.promise" }

    public let signature: Bytes
    public let promiseA: Int64
    public let promiseB: Int64
    public let channelId: Int64

    public init(
        signature: Bytes,
        promiseA: Int64,
        promiseB: Int64,
        channelId: Int64
    ) {
        self.signature = signature
        self.promiseA = promiseA
        self.promiseB = promiseB
        self.channelId = channelId
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case signature = "signature"
        case promiseA = "promise_a"
        case promiseB = "promise_b"
        case channelId = "channel_id"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.signature = try container.decode(Bytes.self, forKey: .signature)
        self.promiseA = try container.decode(Int64.self, forKey: .promiseA)
        self.promiseB = try container.decode(Int64.self, forKey: .promiseB)
        self.channelId = try container.decode(Int64.self, forKey: .channelId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.signature, forKey: .signature)
        try container.encode(self.promiseA, forKey: .promiseA)
        try container.encode(self.promiseB, forKey: .promiseB)
        try container.encode(self.channelId, forKey: .channelId)
    }
}

public struct PchanActionInit: TLObject {
    public static var _type: String { "pchan.actionInit" }

    public let incA: Int64
    public let incB: Int64
    public let minA: Int64
    public let minB: Int64

    public init(
        incA: Int64,
        incB: Int64,
        minA: Int64,
        minB: Int64
    ) {
        self.incA = incA
        self.incB = incB
        self.minA = minA
        self.minB = minB
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case incA = "inc_a"
        case incB = "inc_b"
        case minA = "min_a"
        case minB = "min_b"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.incA = try container.decode(Int64.self, forKey: .incA)
        self.incB = try container.decode(Int64.self, forKey: .incB)
        self.minA = try container.decode(Int64.self, forKey: .minA)
        self.minB = try container.decode(Int64.self, forKey: .minB)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.incA, forKey: .incA)
        try container.encode(self.incB, forKey: .incB)
        try container.encode(self.minA, forKey: .minA)
        try container.encode(self.minB, forKey: .minB)
    }
}

public struct PchanActionClose: TLObject {
    public static var _type: String { "pchan.actionClose" }

    public let extraA: Int64
    public let extraB: Int64
    public let promise: PchanPromise

    public init(
        extraA: Int64,
        extraB: Int64,
        promise: PchanPromise
    ) {
        self.extraA = extraA
        self.extraB = extraB
        self.promise = promise
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case extraA = "extra_a"
        case extraB = "extra_b"
        case promise = "promise"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.extraA = try container.decode(Int64.self, forKey: .extraA)
        self.extraB = try container.decode(Int64.self, forKey: .extraB)
        self.promise = try container.decode(PchanPromise.self, forKey: .promise)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.extraA, forKey: .extraA)
        try container.encode(self.extraB, forKey: .extraB)
        try container.encode(self.promise, forKey: .promise)
    }
}

public struct PchanActionTimeout: TLObject {
    public static var _type: String { "pchan.actionTimeout" }

    public init() { }
}

public struct RwalletActionInit: TLObject {
    public static var _type: String { "rwallet.actionInit" }

    public let config: RwalletConfig

    public init(
        config: RwalletConfig
    ) {
        self.config = config
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case config = "config"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.config = try container.decode(RwalletConfig.self, forKey: .config)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.config, forKey: .config)
    }
}

public struct ActionNoop: TLObject {
    public static var _type: String { "actionNoop" }

    public init() { }
}

public struct ActionMsg: TLObject {
    public static var _type: String { "actionMsg" }

    public let messages: [MsgMessage]
    public let allowSendToUninited: Bool

    public init(
        messages: [MsgMessage],
        allowSendToUninited: Bool
    ) {
        self.messages = messages
        self.allowSendToUninited = allowSendToUninited
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case messages = "messages"
        case allowSendToUninited = "allow_send_to_uninited"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.messages = try container.decode([MsgMessage].self, forKey: .messages)
        self.allowSendToUninited = try container.decode(Bool.self, forKey: .allowSendToUninited)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.messages, forKey: .messages)
        try container.encode(self.allowSendToUninited, forKey: .allowSendToUninited)
    }
}

public struct ActionDns: TLObject {
    public static var _type: String { "actionDns" }

    public let actions: [DnsAction]

    public init(
        actions: [DnsAction]
    ) {
        self.actions = actions
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case actions = "actions"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.actions = try container.decode([DnsAction].self, forKey: .actions)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.actions, forKey: .actions)
    }
}

public struct ActionPchan: TLObject {
    public static var _type: String { "actionPchan" }

    public let action: PchanAction

    public init(
        action: PchanAction
    ) {
        self.action = action
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case action = "action"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.action = try container.decode(PchanAction.self, forKey: .action)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.action, forKey: .action)
    }
}

public struct ActionRwallet: TLObject {
    public static var _type: String { "actionRwallet" }

    public let action: RwalletActionInit

    public init(
        action: RwalletActionInit
    ) {
        self.action = action
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case action = "action"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.action = try container.decode(RwalletActionInit.self, forKey: .action)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.action, forKey: .action)
    }
}

public struct Fees: TLObject {
    public static var _type: String { "fees" }

    public let inFwdFee: Int53
    public let storageFee: Int53
    public let gasFee: Int53
    public let fwdFee: Int53

    public init(
        inFwdFee: Int53,
        storageFee: Int53,
        gasFee: Int53,
        fwdFee: Int53
    ) {
        self.inFwdFee = inFwdFee
        self.storageFee = storageFee
        self.gasFee = gasFee
        self.fwdFee = fwdFee
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case inFwdFee = "in_fwd_fee"
        case storageFee = "storage_fee"
        case gasFee = "gas_fee"
        case fwdFee = "fwd_fee"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.inFwdFee = try container.decode(Int53.self, forKey: .inFwdFee)
        self.storageFee = try container.decode(Int53.self, forKey: .storageFee)
        self.gasFee = try container.decode(Int53.self, forKey: .gasFee)
        self.fwdFee = try container.decode(Int53.self, forKey: .fwdFee)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.inFwdFee, forKey: .inFwdFee)
        try container.encode(self.storageFee, forKey: .storageFee)
        try container.encode(self.gasFee, forKey: .gasFee)
        try container.encode(self.fwdFee, forKey: .fwdFee)
    }
}

public struct QueryFees: TLObject {
    public static var _type: String { "query.fees" }

    public let sourceFees: Fees
    public let destinationFees: [Fees]

    public init(
        sourceFees: Fees,
        destinationFees: [Fees]
    ) {
        self.sourceFees = sourceFees
        self.destinationFees = destinationFees
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case sourceFees = "source_fees"
        case destinationFees = "destination_fees"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.sourceFees = try container.decode(Fees.self, forKey: .sourceFees)
        self.destinationFees = try container.decode([Fees].self, forKey: .destinationFees)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.sourceFees, forKey: .sourceFees)
        try container.encode(self.destinationFees, forKey: .destinationFees)
    }
}

public struct QueryInfo: TLObject {
    public static var _type: String { "query.info" }

    public let id: Int53
    public let validUntil: Int53
    public let bodyHash: Bytes
    public let body: Bytes
    public let initState: Bytes

    public init(
        id: Int53,
        validUntil: Int53,
        bodyHash: Bytes,
        body: Bytes,
        initState: Bytes
    ) {
        self.id = id
        self.validUntil = validUntil
        self.bodyHash = bodyHash
        self.body = body
        self.initState = initState
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case id = "id"
        case validUntil = "valid_until"
        case bodyHash = "body_hash"
        case body = "body"
        case initState = "init_state"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.id = try container.decode(Int53.self, forKey: .id)
        self.validUntil = try container.decode(Int53.self, forKey: .validUntil)
        self.bodyHash = try container.decode(Bytes.self, forKey: .bodyHash)
        self.body = try container.decode(Bytes.self, forKey: .body)
        self.initState = try container.decode(Bytes.self, forKey: .initState)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.validUntil, forKey: .validUntil)
        try container.encode(self.bodyHash, forKey: .bodyHash)
        try container.encode(self.body, forKey: .body)
        try container.encode(self.initState, forKey: .initState)
    }
}

public struct TvmSlice: TLObject {
    public static var _type: String { "tvm.slice" }

    public let bytes: Bytes

    public init(
        bytes: Bytes
    ) {
        self.bytes = bytes
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case bytes = "bytes"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.bytes = try container.decode(Bytes.self, forKey: .bytes)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.bytes, forKey: .bytes)
    }
}

public struct TvmCell: TLObject {
    public static var _type: String { "tvm.cell" }

    public let bytes: Bytes

    public init(
        bytes: Bytes
    ) {
        self.bytes = bytes
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case bytes = "bytes"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.bytes = try container.decode(Bytes.self, forKey: .bytes)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.bytes, forKey: .bytes)
    }
}

public struct TvmNumberDecimal: TLObject {
    public static var _type: String { "tvm.numberDecimal" }

    public let number: String

    public init(
        number: String
    ) {
        self.number = number
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case number = "number"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.number = try container.decode(String.self, forKey: .number)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.number, forKey: .number)
    }
}

public struct TvmTuple: TLObject {
    public static var _type: String { "tvm.tuple" }

    public let elements: [TvmStackEntry]

    public init(
        elements: [TvmStackEntry]
    ) {
        self.elements = elements
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case elements = "elements"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.elements = try container.decode([TvmStackEntry].self, forKey: .elements)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.elements, forKey: .elements)
    }
}

public struct TvmList: TLObject {
    public static var _type: String { "tvm.list" }

    public let elements: [TvmStackEntry]

    public init(
        elements: [TvmStackEntry]
    ) {
        self.elements = elements
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case elements = "elements"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.elements = try container.decode([TvmStackEntry].self, forKey: .elements)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.elements, forKey: .elements)
    }
}

public struct TvmStackEntrySlice: TLObject {
    public static var _type: String { "tvm.stackEntrySlice" }

    public let slice: TvmSlice

    public init(
        slice: TvmSlice
    ) {
        self.slice = slice
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case slice = "slice"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.slice = try container.decode(TvmSlice.self, forKey: .slice)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.slice, forKey: .slice)
    }
}

public struct TvmStackEntryCell: TLObject {
    public static var _type: String { "tvm.stackEntryCell" }

    public let cell: TvmCell

    public init(
        cell: TvmCell
    ) {
        self.cell = cell
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case cell = "cell"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.cell = try container.decode(TvmCell.self, forKey: .cell)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.cell, forKey: .cell)
    }
}

public struct TvmStackEntryNumber: TLObject {
    public static var _type: String { "tvm.stackEntryNumber" }

    public let number: TvmNumber

    public init(
        number: TvmNumber
    ) {
        self.number = number
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case number = "number"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.number = try container.decode(TvmNumber.self, forKey: .number)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.number, forKey: .number)
    }
}

public struct TvmStackEntryTuple: TLObject {
    public static var _type: String { "tvm.stackEntryTuple" }

    public let tuple: TvmTuple

    public init(
        tuple: TvmTuple
    ) {
        self.tuple = tuple
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case tuple = "tuple"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.tuple = try container.decode(TvmTuple.self, forKey: .tuple)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.tuple, forKey: .tuple)
    }
}

public struct TvmStackEntryList: TLObject {
    public static var _type: String { "tvm.stackEntryList" }

    public let list: TvmList

    public init(
        list: TvmList
    ) {
        self.list = list
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case list = "list"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.list = try container.decode(TvmList.self, forKey: .list)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.list, forKey: .list)
    }
}

public struct TvmStackEntryUnsupported: TLObject {
    public static var _type: String { "tvm.stackEntryUnsupported" }

    public init() { }
}

public struct SmcInfo: TLObject {
    public static var _type: String { "smc.info" }

    public let id: Int53

    public init(
        id: Int53
    ) {
        self.id = id
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case id = "id"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.id = try container.decode(Int53.self, forKey: .id)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.id, forKey: .id)
    }
}

public struct SmcMethodIdNumber: TLObject {
    public static var _type: String { "smc.methodIdNumber" }

    public let number: Int32

    public init(
        number: Int32
    ) {
        self.number = number
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case number = "number"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.number = try container.decode(Int32.self, forKey: .number)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.number, forKey: .number)
    }
}

public struct SmcMethodIdName: TLObject {
    public static var _type: String { "smc.methodIdName" }

    public let name: String

    public init(
        name: String
    ) {
        self.name = name
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case name = "name"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.name = try container.decode(String.self, forKey: .name)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.name, forKey: .name)
    }
}

public struct SmcRunResult: TLObject {
    public static var _type: String { "smc.runResult" }

    public let gasUsed: Int53
    public let stack: [TvmStackEntry]
    public let exitCode: Int32

    public init(
        gasUsed: Int53,
        stack: [TvmStackEntry],
        exitCode: Int32
    ) {
        self.gasUsed = gasUsed
        self.stack = stack
        self.exitCode = exitCode
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case gasUsed = "gas_used"
        case stack = "stack"
        case exitCode = "exit_code"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.gasUsed = try container.decode(Int53.self, forKey: .gasUsed)
        self.stack = try container.decode([TvmStackEntry].self, forKey: .stack)
        self.exitCode = try container.decode(Int32.self, forKey: .exitCode)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.gasUsed, forKey: .gasUsed)
        try container.encode(self.stack, forKey: .stack)
        try container.encode(self.exitCode, forKey: .exitCode)
    }
}

public struct SmcLibraryEntry: TLObject {
    public static var _type: String { "smc.libraryEntry" }

    public let hash: Int256
    public let data: Bytes

    public init(
        hash: Int256,
        data: Bytes
    ) {
        self.hash = hash
        self.data = data
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case hash = "hash"
        case data = "data"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.hash = try container.decode(Int256.self, forKey: .hash)
        self.data = try container.decode(Bytes.self, forKey: .data)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.hash, forKey: .hash)
        try container.encode(self.data, forKey: .data)
    }
}

public struct SmcLibraryResult: TLObject {
    public static var _type: String { "smc.libraryResult" }

    public let result: [SmcLibraryEntry]

    public init(
        result: [SmcLibraryEntry]
    ) {
        self.result = result
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case result = "result"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.result = try container.decode([SmcLibraryEntry].self, forKey: .result)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.result, forKey: .result)
    }
}

public struct UpdateSendLiteServerQuery: TLObject {
    public static var _type: String { "updateSendLiteServerQuery" }

    public let id: Int64
    public let data: Bytes

    public init(
        id: Int64,
        data: Bytes
    ) {
        self.id = id
        self.data = data
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case id = "id"
        case data = "data"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.id = try container.decode(Int64.self, forKey: .id)
        self.data = try container.decode(Bytes.self, forKey: .data)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.data, forKey: .data)
    }
}

public struct UpdateSyncState: TLObject {
    public static var _type: String { "updateSyncState" }

    public let syncState: SyncState

    public init(
        syncState: SyncState
    ) {
        self.syncState = syncState
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case syncState = "sync_state"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.syncState = try container.decode(SyncState.self, forKey: .syncState)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.syncState, forKey: .syncState)
    }
}

public struct LogStreamDefault: TLObject {
    public static var _type: String { "logStreamDefault" }

    public init() { }
}

public struct LogStreamFile: TLObject {
    public static var _type: String { "logStreamFile" }

    public let path: String
    public let maxFileSize: Int53

    public init(
        path: String,
        maxFileSize: Int53
    ) {
        self.path = path
        self.maxFileSize = maxFileSize
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case path = "path"
        case maxFileSize = "max_file_size"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.path = try container.decode(String.self, forKey: .path)
        self.maxFileSize = try container.decode(Int53.self, forKey: .maxFileSize)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.path, forKey: .path)
        try container.encode(self.maxFileSize, forKey: .maxFileSize)
    }
}

public struct LogStreamEmpty: TLObject {
    public static var _type: String { "logStreamEmpty" }

    public init() { }
}

public struct LogVerbosityLevel: TLObject {
    public static var _type: String { "logVerbosityLevel" }

    public let verbosityLevel: Int32

    public init(
        verbosityLevel: Int32
    ) {
        self.verbosityLevel = verbosityLevel
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case verbosityLevel = "verbosity_level"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.verbosityLevel = try container.decode(Int32.self, forKey: .verbosityLevel)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.verbosityLevel, forKey: .verbosityLevel)
    }
}

public struct LogTags: TLObject {
    public static var _type: String { "logTags" }

    public let tags: [String]

    public init(
        tags: [String]
    ) {
        self.tags = tags
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case tags = "tags"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.tags = try container.decode([String].self, forKey: .tags)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.tags, forKey: .tags)
    }
}

public struct Data: TLObject {
    public static var _type: String { "data" }

    public let bytes: SecureBytes

    public init(
        bytes: SecureBytes
    ) {
        self.bytes = bytes
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case bytes = "bytes"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.bytes = try container.decode(SecureBytes.self, forKey: .bytes)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.bytes, forKey: .bytes)
    }
}

public struct LiteServerInfo: TLObject {
    public static var _type: String { "liteServer.info" }

    public let now: Int53
    public let version: Int32
    public let capabilities: Int64

    public init(
        now: Int53,
        version: Int32,
        capabilities: Int64
    ) {
        self.now = now
        self.version = version
        self.capabilities = capabilities
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case now = "now"
        case version = "version"
        case capabilities = "capabilities"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.now = try container.decode(Int53.self, forKey: .now)
        self.version = try container.decode(Int32.self, forKey: .version)
        self.capabilities = try container.decode(Int64.self, forKey: .capabilities)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.now, forKey: .now)
        try container.encode(self.version, forKey: .version)
        try container.encode(self.capabilities, forKey: .capabilities)
    }
}

public struct BlocksMasterchainInfo: TLObject {
    public static var _type: String { "blocks.masterchainInfo" }

    public let last: TonBlockIdExt
    public let stateRootHash: Bytes
    public let `init`: TonBlockIdExt

    public init(
        last: TonBlockIdExt,
        stateRootHash: Bytes,
        `init`: TonBlockIdExt
    ) {
        self.last = last
        self.stateRootHash = stateRootHash
        self.`init` = `init`
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case last = "last"
        case stateRootHash = "state_root_hash"
        case `init` = "init"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.last = try container.decode(TonBlockIdExt.self, forKey: .last)
        self.stateRootHash = try container.decode(Bytes.self, forKey: .stateRootHash)
        self.`init` = try container.decode(TonBlockIdExt.self, forKey: .`init`)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.last, forKey: .last)
        try container.encode(self.stateRootHash, forKey: .stateRootHash)
        try container.encode(self.`init`, forKey: .`init`)
    }
}

public struct BlocksShards: TLObject {
    public static var _type: String { "blocks.shards" }

    public let shards: [TonBlockIdExt]

    public init(
        shards: [TonBlockIdExt]
    ) {
        self.shards = shards
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case shards = "shards"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.shards = try container.decode([TonBlockIdExt].self, forKey: .shards)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.shards, forKey: .shards)
    }
}

public struct BlocksAccountTransactionId: TLObject {
    public static var _type: String { "blocks.accountTransactionId" }

    public let account: Bytes
    public let lt: Int64

    public init(
        account: Bytes,
        lt: Int64
    ) {
        self.account = account
        self.lt = lt
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case account = "account"
        case lt = "lt"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.account = try container.decode(Bytes.self, forKey: .account)
        self.lt = try container.decode(Int64.self, forKey: .lt)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.account, forKey: .account)
        try container.encode(self.lt, forKey: .lt)
    }
}

public struct BlocksShortTxId: TLObject {
    public static var _type: String { "blocks.shortTxId" }
}

public struct BlocksTransactions: TLObject {
    public static var _type: String { "blocks.transactions" }

    public let id: TonBlockIdExt
    public let reqCount: Int32
    public let incomplete: Bool
    public let transactions: [BlocksShortTxId]

    public init(
        id: TonBlockIdExt,
        reqCount: Int32,
        incomplete: Bool,
        transactions: [BlocksShortTxId]
    ) {
        self.id = id
        self.reqCount = reqCount
        self.incomplete = incomplete
        self.transactions = transactions
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case id = "id"
        case reqCount = "req_count"
        case incomplete = "incomplete"
        case transactions = "transactions"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.id = try container.decode(TonBlockIdExt.self, forKey: .id)
        self.reqCount = try container.decode(Int32.self, forKey: .reqCount)
        self.incomplete = try container.decode(Bool.self, forKey: .incomplete)
        self.transactions = try container.decode([BlocksShortTxId].self, forKey: .transactions)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.reqCount, forKey: .reqCount)
        try container.encode(self.incomplete, forKey: .incomplete)
        try container.encode(self.transactions, forKey: .transactions)
    }
}

public struct BlocksTransactionsExt: TLObject {
    public static var _type: String { "blocks.transactionsExt" }

    public let id: TonBlockIdExt
    public let reqCount: Int32
    public let incomplete: Bool
    public let transactions: [RawTransaction]

    public init(
        id: TonBlockIdExt,
        reqCount: Int32,
        incomplete: Bool,
        transactions: [RawTransaction]
    ) {
        self.id = id
        self.reqCount = reqCount
        self.incomplete = incomplete
        self.transactions = transactions
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case id = "id"
        case reqCount = "req_count"
        case incomplete = "incomplete"
        case transactions = "transactions"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.id = try container.decode(TonBlockIdExt.self, forKey: .id)
        self.reqCount = try container.decode(Int32.self, forKey: .reqCount)
        self.incomplete = try container.decode(Bool.self, forKey: .incomplete)
        self.transactions = try container.decode([RawTransaction].self, forKey: .transactions)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.reqCount, forKey: .reqCount)
        try container.encode(self.incomplete, forKey: .incomplete)
        try container.encode(self.transactions, forKey: .transactions)
    }
}

public struct BlocksHeader: TLObject {
    public static var _type: String { "blocks.header" }

    public let id: TonBlockIdExt
    public let globalId: Int32
    public let version: Int32
    public let flags: Int32
    public let afterMerge: Bool
    public let afterSplit: Bool
    public let beforeSplit: Bool
    public let wantMerge: Bool
    public let wantSplit: Bool
    public let validatorListHashShort: Int32
    public let catchainSeqno: Int32
    public let minRefMcSeqno: Int32
    public let isKeyBlock: Bool
    public let prevKeyBlockSeqno: Int32
    public let startLt: Int64
    public let endLt: Int64
    public let genUtime: Int53
    public let vertSeqno: Int32
    public let prevBlocks: [TonBlockIdExt]

    public init(
        id: TonBlockIdExt,
        globalId: Int32,
        version: Int32,
        flags: Int32,
        afterMerge: Bool,
        afterSplit: Bool,
        beforeSplit: Bool,
        wantMerge: Bool,
        wantSplit: Bool,
        validatorListHashShort: Int32,
        catchainSeqno: Int32,
        minRefMcSeqno: Int32,
        isKeyBlock: Bool,
        prevKeyBlockSeqno: Int32,
        startLt: Int64,
        endLt: Int64,
        genUtime: Int53,
        vertSeqno: Int32,
        prevBlocks: [TonBlockIdExt]
    ) {
        self.id = id
        self.globalId = globalId
        self.version = version
        self.flags = flags
        self.afterMerge = afterMerge
        self.afterSplit = afterSplit
        self.beforeSplit = beforeSplit
        self.wantMerge = wantMerge
        self.wantSplit = wantSplit
        self.validatorListHashShort = validatorListHashShort
        self.catchainSeqno = catchainSeqno
        self.minRefMcSeqno = minRefMcSeqno
        self.isKeyBlock = isKeyBlock
        self.prevKeyBlockSeqno = prevKeyBlockSeqno
        self.startLt = startLt
        self.endLt = endLt
        self.genUtime = genUtime
        self.vertSeqno = vertSeqno
        self.prevBlocks = prevBlocks
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case id = "id"
        case globalId = "global_id"
        case version = "version"
        case flags = "flags"
        case afterMerge = "after_merge"
        case afterSplit = "after_split"
        case beforeSplit = "before_split"
        case wantMerge = "want_merge"
        case wantSplit = "want_split"
        case validatorListHashShort = "validator_list_hash_short"
        case catchainSeqno = "catchain_seqno"
        case minRefMcSeqno = "min_ref_mc_seqno"
        case isKeyBlock = "is_key_block"
        case prevKeyBlockSeqno = "prev_key_block_seqno"
        case startLt = "start_lt"
        case endLt = "end_lt"
        case genUtime = "gen_utime"
        case vertSeqno = "vert_seqno"
        case prevBlocks = "prev_blocks"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.id = try container.decode(TonBlockIdExt.self, forKey: .id)
        self.globalId = try container.decode(Int32.self, forKey: .globalId)
        self.version = try container.decode(Int32.self, forKey: .version)
        self.flags = try container.decode(Int32.self, forKey: .flags)
        self.afterMerge = try container.decode(Bool.self, forKey: .afterMerge)
        self.afterSplit = try container.decode(Bool.self, forKey: .afterSplit)
        self.beforeSplit = try container.decode(Bool.self, forKey: .beforeSplit)
        self.wantMerge = try container.decode(Bool.self, forKey: .wantMerge)
        self.wantSplit = try container.decode(Bool.self, forKey: .wantSplit)
        self.validatorListHashShort = try container.decode(Int32.self, forKey: .validatorListHashShort)
        self.catchainSeqno = try container.decode(Int32.self, forKey: .catchainSeqno)
        self.minRefMcSeqno = try container.decode(Int32.self, forKey: .minRefMcSeqno)
        self.isKeyBlock = try container.decode(Bool.self, forKey: .isKeyBlock)
        self.prevKeyBlockSeqno = try container.decode(Int32.self, forKey: .prevKeyBlockSeqno)
        self.startLt = try container.decode(Int64.self, forKey: .startLt)
        self.endLt = try container.decode(Int64.self, forKey: .endLt)
        self.genUtime = try container.decode(Int53.self, forKey: .genUtime)
        self.vertSeqno = try container.decode(Int32.self, forKey: .vertSeqno)
        self.prevBlocks = try container.decode([TonBlockIdExt].self, forKey: .prevBlocks)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.globalId, forKey: .globalId)
        try container.encode(self.version, forKey: .version)
        try container.encode(self.flags, forKey: .flags)
        try container.encode(self.afterMerge, forKey: .afterMerge)
        try container.encode(self.afterSplit, forKey: .afterSplit)
        try container.encode(self.beforeSplit, forKey: .beforeSplit)
        try container.encode(self.wantMerge, forKey: .wantMerge)
        try container.encode(self.wantSplit, forKey: .wantSplit)
        try container.encode(self.validatorListHashShort, forKey: .validatorListHashShort)
        try container.encode(self.catchainSeqno, forKey: .catchainSeqno)
        try container.encode(self.minRefMcSeqno, forKey: .minRefMcSeqno)
        try container.encode(self.isKeyBlock, forKey: .isKeyBlock)
        try container.encode(self.prevKeyBlockSeqno, forKey: .prevKeyBlockSeqno)
        try container.encode(self.startLt, forKey: .startLt)
        try container.encode(self.endLt, forKey: .endLt)
        try container.encode(self.genUtime, forKey: .genUtime)
        try container.encode(self.vertSeqno, forKey: .vertSeqno)
        try container.encode(self.prevBlocks, forKey: .prevBlocks)
    }
}

public struct BlocksSignature: TLObject {
    public static var _type: String { "blocks.signature" }

    public let nodeIdShort: Int256
    public let signature: Bytes

    public init(
        nodeIdShort: Int256,
        signature: Bytes
    ) {
        self.nodeIdShort = nodeIdShort
        self.signature = signature
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case nodeIdShort = "node_id_short"
        case signature = "signature"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.nodeIdShort = try container.decode(Int256.self, forKey: .nodeIdShort)
        self.signature = try container.decode(Bytes.self, forKey: .signature)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.nodeIdShort, forKey: .nodeIdShort)
        try container.encode(self.signature, forKey: .signature)
    }
}

public struct BlocksBlockSignatures: TLObject {
    public static var _type: String { "blocks.blockSignatures" }

    public let id: TonBlockIdExt
    public let signatures: [BlocksSignature]

    public init(
        id: TonBlockIdExt,
        signatures: [BlocksSignature]
    ) {
        self.id = id
        self.signatures = signatures
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case id = "id"
        case signatures = "signatures"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.id = try container.decode(TonBlockIdExt.self, forKey: .id)
        self.signatures = try container.decode([BlocksSignature].self, forKey: .signatures)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.signatures, forKey: .signatures)
    }
}

public struct BlocksShardBlockLink: TLObject {
    public static var _type: String { "blocks.shardBlockLink" }

    public let id: TonBlockIdExt
    public let proof: Bytes

    public init(
        id: TonBlockIdExt,
        proof: Bytes
    ) {
        self.id = id
        self.proof = proof
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case id = "id"
        case proof = "proof"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.id = try container.decode(TonBlockIdExt.self, forKey: .id)
        self.proof = try container.decode(Bytes.self, forKey: .proof)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.proof, forKey: .proof)
    }
}

public struct BlocksBlockLinkBack: TLObject {
    public static var _type: String { "blocks.blockLinkBack" }

    public let toKeyBlock: Bool
    public let from: TonBlockIdExt
    public let to: TonBlockIdExt
    public let destProof: Bytes
    public let proof: Bytes
    public let stateProof: Bytes

    public init(
        toKeyBlock: Bool,
        from: TonBlockIdExt,
        to: TonBlockIdExt,
        destProof: Bytes,
        proof: Bytes,
        stateProof: Bytes
    ) {
        self.toKeyBlock = toKeyBlock
        self.from = from
        self.to = to
        self.destProof = destProof
        self.proof = proof
        self.stateProof = stateProof
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case toKeyBlock = "to_key_block"
        case from = "from"
        case to = "to"
        case destProof = "dest_proof"
        case proof = "proof"
        case stateProof = "state_proof"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.toKeyBlock = try container.decode(Bool.self, forKey: .toKeyBlock)
        self.from = try container.decode(TonBlockIdExt.self, forKey: .from)
        self.to = try container.decode(TonBlockIdExt.self, forKey: .to)
        self.destProof = try container.decode(Bytes.self, forKey: .destProof)
        self.proof = try container.decode(Bytes.self, forKey: .proof)
        self.stateProof = try container.decode(Bytes.self, forKey: .stateProof)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.toKeyBlock, forKey: .toKeyBlock)
        try container.encode(self.from, forKey: .from)
        try container.encode(self.to, forKey: .to)
        try container.encode(self.destProof, forKey: .destProof)
        try container.encode(self.proof, forKey: .proof)
        try container.encode(self.stateProof, forKey: .stateProof)
    }
}

public struct BlocksShardBlockProof: TLObject {
    public static var _type: String { "blocks.shardBlockProof" }

    public let from: TonBlockIdExt
    public let mcId: TonBlockIdExt
    public let links: [BlocksShardBlockLink]
    public let mcProof: [BlocksBlockLinkBack]

    public init(
        from: TonBlockIdExt,
        mcId: TonBlockIdExt,
        links: [BlocksShardBlockLink],
        mcProof: [BlocksBlockLinkBack]
    ) {
        self.from = from
        self.mcId = mcId
        self.links = links
        self.mcProof = mcProof
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case from = "from"
        case mcId = "mc_id"
        case links = "links"
        case mcProof = "mc_proof"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.from = try container.decode(TonBlockIdExt.self, forKey: .from)
        self.mcId = try container.decode(TonBlockIdExt.self, forKey: .mcId)
        self.links = try container.decode([BlocksShardBlockLink].self, forKey: .links)
        self.mcProof = try container.decode([BlocksBlockLinkBack].self, forKey: .mcProof)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.from, forKey: .from)
        try container.encode(self.mcId, forKey: .mcId)
        try container.encode(self.links, forKey: .links)
        try container.encode(self.mcProof, forKey: .mcProof)
    }
}

public struct ConfigInfo: TLObject {
    public static var _type: String { "configInfo" }

    public let config: TvmCell

    public init(
        config: TvmCell
    ) {
        self.config = config
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case config = "config"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.config = try container.decode(TvmCell.self, forKey: .config)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.config, forKey: .config)
    }
}

public enum RwalletAction: TDEnum {
    case rwalletActionInit(RwalletActionInit)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TLTypedCodingKey.self)
        let type = try container.decode(String.self, forKey: ._type)

        switch type {
        case RwalletActionInit._type:
            self = .rwalletActionInit(try RwalletActionInit(from: decoder))
        default: throw TLTypedUnknownTypeError()
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: TLTypedCodingKey.self)

        switch self {
        case let .rwalletActionInit(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        }
    }
}

public enum InputKey: TDEnum {
    case inputKeyRegular(InputKeyRegular)
    case inputKeyFake(InputKeyFake)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TLTypedCodingKey.self)
        let type = try container.decode(String.self, forKey: ._type)

        switch type {
        case InputKeyRegular._type:
            self = .inputKeyRegular(try InputKeyRegular(from: decoder))
        case InputKeyFake._type:
            self = .inputKeyFake(try InputKeyFake(from: decoder))
        default: throw TLTypedUnknownTypeError()
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: TLTypedCodingKey.self)

        switch self {
        case let .inputKeyRegular(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .inputKeyFake(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        }
    }
}

public enum KeyStoreType: TDEnum {
    case keyStoreTypeDirectory(KeyStoreTypeDirectory)
    case keyStoreTypeInMemory(KeyStoreTypeInMemory)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TLTypedCodingKey.self)
        let type = try container.decode(String.self, forKey: ._type)

        switch type {
        case KeyStoreTypeDirectory._type:
            self = .keyStoreTypeDirectory(try KeyStoreTypeDirectory(from: decoder))
        case KeyStoreTypeInMemory._type:
            self = .keyStoreTypeInMemory(try KeyStoreTypeInMemory(from: decoder))
        default: throw TLTypedUnknownTypeError()
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: TLTypedCodingKey.self)

        switch self {
        case let .keyStoreTypeDirectory(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .keyStoreTypeInMemory(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        }
    }
}

public enum PchanState: TDEnum {
    case pchanStateInit(PchanStateInit)
    case pchanStateClose(PchanStateClose)
    case pchanStatePayout(PchanStatePayout)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TLTypedCodingKey.self)
        let type = try container.decode(String.self, forKey: ._type)

        switch type {
        case PchanStateInit._type:
            self = .pchanStateInit(try PchanStateInit(from: decoder))
        case PchanStateClose._type:
            self = .pchanStateClose(try PchanStateClose(from: decoder))
        case PchanStatePayout._type:
            self = .pchanStatePayout(try PchanStatePayout(from: decoder))
        default: throw TLTypedUnknownTypeError()
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: TLTypedCodingKey.self)

        switch self {
        case let .pchanStateInit(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .pchanStateClose(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .pchanStatePayout(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        }
    }
}

public enum InternalBlockId: TDEnum {
    case tonBlockId(TonBlockId)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TLTypedCodingKey.self)
        let type = try container.decode(String.self, forKey: ._type)

        switch type {
        case TonBlockId._type:
            self = .tonBlockId(try TonBlockId(from: decoder))
        default: throw TLTypedUnknownTypeError()
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: TLTypedCodingKey.self)

        switch self {
        case let .tonBlockId(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        }
    }
}

public enum InitialAccountState: TDEnum {
    case rawInitialAccountState(RawInitialAccountState)
    case walletV3InitialAccountState(WalletV3InitialAccountState)
    case walletHighloadV1InitialAccountState(WalletHighloadV1InitialAccountState)
    case walletHighloadV2InitialAccountState(WalletHighloadV2InitialAccountState)
    case rwalletInitialAccountState(RwalletInitialAccountState)
    case dnsInitialAccountState(DnsInitialAccountState)
    case pchanInitialAccountState(PchanInitialAccountState)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TLTypedCodingKey.self)
        let type = try container.decode(String.self, forKey: ._type)

        switch type {
        case RawInitialAccountState._type:
            self = .rawInitialAccountState(try RawInitialAccountState(from: decoder))
        case WalletV3InitialAccountState._type:
            self = .walletV3InitialAccountState(try WalletV3InitialAccountState(from: decoder))
        case WalletHighloadV1InitialAccountState._type:
            self = .walletHighloadV1InitialAccountState(try WalletHighloadV1InitialAccountState(from: decoder))
        case WalletHighloadV2InitialAccountState._type:
            self = .walletHighloadV2InitialAccountState(try WalletHighloadV2InitialAccountState(from: decoder))
        case RwalletInitialAccountState._type:
            self = .rwalletInitialAccountState(try RwalletInitialAccountState(from: decoder))
        case DnsInitialAccountState._type:
            self = .dnsInitialAccountState(try DnsInitialAccountState(from: decoder))
        case PchanInitialAccountState._type:
            self = .pchanInitialAccountState(try PchanInitialAccountState(from: decoder))
        default: throw TLTypedUnknownTypeError()
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: TLTypedCodingKey.self)

        switch self {
        case let .rawInitialAccountState(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .walletV3InitialAccountState(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .walletHighloadV1InitialAccountState(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .walletHighloadV2InitialAccountState(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .rwalletInitialAccountState(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .dnsInitialAccountState(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .pchanInitialAccountState(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        }
    }
}

public enum AccountState: TDEnum {
    case rawAccountState(RawAccountState)
    case walletV3AccountState(WalletV3AccountState)
    case walletHighloadV1AccountState(WalletHighloadV1AccountState)
    case walletHighloadV2AccountState(WalletHighloadV2AccountState)
    case dnsAccountState(DnsAccountState)
    case rwalletAccountState(RwalletAccountState)
    case pchanAccountState(PchanAccountState)
    case uninitedAccountState(UninitedAccountState)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TLTypedCodingKey.self)
        let type = try container.decode(String.self, forKey: ._type)

        switch type {
        case RawAccountState._type:
            self = .rawAccountState(try RawAccountState(from: decoder))
        case WalletV3AccountState._type:
            self = .walletV3AccountState(try WalletV3AccountState(from: decoder))
        case WalletHighloadV1AccountState._type:
            self = .walletHighloadV1AccountState(try WalletHighloadV1AccountState(from: decoder))
        case WalletHighloadV2AccountState._type:
            self = .walletHighloadV2AccountState(try WalletHighloadV2AccountState(from: decoder))
        case DnsAccountState._type:
            self = .dnsAccountState(try DnsAccountState(from: decoder))
        case RwalletAccountState._type:
            self = .rwalletAccountState(try RwalletAccountState(from: decoder))
        case PchanAccountState._type:
            self = .pchanAccountState(try PchanAccountState(from: decoder))
        case UninitedAccountState._type:
            self = .uninitedAccountState(try UninitedAccountState(from: decoder))
        default: throw TLTypedUnknownTypeError()
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: TLTypedCodingKey.self)

        switch self {
        case let .rawAccountState(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .walletV3AccountState(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .walletHighloadV1AccountState(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .walletHighloadV2AccountState(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .dnsAccountState(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .rwalletAccountState(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .pchanAccountState(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .uninitedAccountState(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        }
    }
}

public enum SyncState: TDEnum {
    case syncStateDone(SyncStateDone)
    case syncStateInProgress(SyncStateInProgress)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TLTypedCodingKey.self)
        let type = try container.decode(String.self, forKey: ._type)

        switch type {
        case SyncStateDone._type:
            self = .syncStateDone(try SyncStateDone(from: decoder))
        case SyncStateInProgress._type:
            self = .syncStateInProgress(try SyncStateInProgress(from: decoder))
        default: throw TLTypedUnknownTypeError()
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: TLTypedCodingKey.self)

        switch self {
        case let .syncStateDone(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .syncStateInProgress(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        }
    }
}

public enum TvmNumber: TDEnum {
    case tvmNumberDecimal(TvmNumberDecimal)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TLTypedCodingKey.self)
        let type = try container.decode(String.self, forKey: ._type)

        switch type {
        case TvmNumberDecimal._type:
            self = .tvmNumberDecimal(try TvmNumberDecimal(from: decoder))
        default: throw TLTypedUnknownTypeError()
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: TLTypedCodingKey.self)

        switch self {
        case let .tvmNumberDecimal(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        }
    }
}

public enum TvmStackEntry: TDEnum {
    case tvmStackEntrySlice(TvmStackEntrySlice)
    case tvmStackEntryCell(TvmStackEntryCell)
    case tvmStackEntryNumber(TvmStackEntryNumber)
    case tvmStackEntryTuple(TvmStackEntryTuple)
    case tvmStackEntryList(TvmStackEntryList)
    case tvmStackEntryUnsupported(TvmStackEntryUnsupported)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TLTypedCodingKey.self)
        let type = try container.decode(String.self, forKey: ._type)

        switch type {
        case TvmStackEntrySlice._type:
            self = .tvmStackEntrySlice(try TvmStackEntrySlice(from: decoder))
        case TvmStackEntryCell._type:
            self = .tvmStackEntryCell(try TvmStackEntryCell(from: decoder))
        case TvmStackEntryNumber._type:
            self = .tvmStackEntryNumber(try TvmStackEntryNumber(from: decoder))
        case TvmStackEntryTuple._type:
            self = .tvmStackEntryTuple(try TvmStackEntryTuple(from: decoder))
        case TvmStackEntryList._type:
            self = .tvmStackEntryList(try TvmStackEntryList(from: decoder))
        case TvmStackEntryUnsupported._type:
            self = .tvmStackEntryUnsupported(try TvmStackEntryUnsupported(from: decoder))
        default: throw TLTypedUnknownTypeError()
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: TLTypedCodingKey.self)

        switch self {
        case let .tvmStackEntrySlice(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .tvmStackEntryCell(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .tvmStackEntryNumber(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .tvmStackEntryTuple(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .tvmStackEntryList(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .tvmStackEntryUnsupported(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        }
    }
}

public enum SmcMethodId: TDEnum {
    case smcMethodIdNumber(SmcMethodIdNumber)
    case smcMethodIdName(SmcMethodIdName)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TLTypedCodingKey.self)
        let type = try container.decode(String.self, forKey: ._type)

        switch type {
        case SmcMethodIdNumber._type:
            self = .smcMethodIdNumber(try SmcMethodIdNumber(from: decoder))
        case SmcMethodIdName._type:
            self = .smcMethodIdName(try SmcMethodIdName(from: decoder))
        default: throw TLTypedUnknownTypeError()
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: TLTypedCodingKey.self)

        switch self {
        case let .smcMethodIdNumber(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .smcMethodIdName(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        }
    }
}

public enum LogStream: TDEnum {
    case logStreamDefault(LogStreamDefault)
    case logStreamFile(LogStreamFile)
    case logStreamEmpty(LogStreamEmpty)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TLTypedCodingKey.self)
        let type = try container.decode(String.self, forKey: ._type)

        switch type {
        case LogStreamDefault._type:
            self = .logStreamDefault(try LogStreamDefault(from: decoder))
        case LogStreamFile._type:
            self = .logStreamFile(try LogStreamFile(from: decoder))
        case LogStreamEmpty._type:
            self = .logStreamEmpty(try LogStreamEmpty(from: decoder))
        default: throw TLTypedUnknownTypeError()
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: TLTypedCodingKey.self)

        switch self {
        case let .logStreamDefault(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .logStreamFile(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .logStreamEmpty(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        }
    }
}

public enum PchanAction: TDEnum {
    case pchanActionInit(PchanActionInit)
    case pchanActionClose(PchanActionClose)
    case pchanActionTimeout(PchanActionTimeout)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TLTypedCodingKey.self)
        let type = try container.decode(String.self, forKey: ._type)

        switch type {
        case PchanActionInit._type:
            self = .pchanActionInit(try PchanActionInit(from: decoder))
        case PchanActionClose._type:
            self = .pchanActionClose(try PchanActionClose(from: decoder))
        case PchanActionTimeout._type:
            self = .pchanActionTimeout(try PchanActionTimeout(from: decoder))
        default: throw TLTypedUnknownTypeError()
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: TLTypedCodingKey.self)

        switch self {
        case let .pchanActionInit(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .pchanActionClose(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .pchanActionTimeout(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        }
    }
}

public enum DnsAction: TDEnum {
    case dnsActionDeleteAll(DnsActionDeleteAll)
    case dnsActionDelete(DnsActionDelete)
    case dnsActionSet(DnsActionSet)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TLTypedCodingKey.self)
        let type = try container.decode(String.self, forKey: ._type)

        switch type {
        case DnsActionDeleteAll._type:
            self = .dnsActionDeleteAll(try DnsActionDeleteAll(from: decoder))
        case DnsActionDelete._type:
            self = .dnsActionDelete(try DnsActionDelete(from: decoder))
        case DnsActionSet._type:
            self = .dnsActionSet(try DnsActionSet(from: decoder))
        default: throw TLTypedUnknownTypeError()
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: TLTypedCodingKey.self)

        switch self {
        case let .dnsActionDeleteAll(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .dnsActionDelete(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .dnsActionSet(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        }
    }
}

public enum MsgData: TDEnum {
    case msgDataRaw(MsgDataRaw)
    case msgDataText(MsgDataText)
    case msgDataDecryptedText(MsgDataDecryptedText)
    case msgDataEncryptedText(MsgDataEncryptedText)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TLTypedCodingKey.self)
        let type = try container.decode(String.self, forKey: ._type)

        switch type {
        case MsgDataRaw._type:
            self = .msgDataRaw(try MsgDataRaw(from: decoder))
        case MsgDataText._type:
            self = .msgDataText(try MsgDataText(from: decoder))
        case MsgDataDecryptedText._type:
            self = .msgDataDecryptedText(try MsgDataDecryptedText(from: decoder))
        case MsgDataEncryptedText._type:
            self = .msgDataEncryptedText(try MsgDataEncryptedText(from: decoder))
        default: throw TLTypedUnknownTypeError()
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: TLTypedCodingKey.self)

        switch self {
        case let .msgDataRaw(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .msgDataText(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .msgDataDecryptedText(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .msgDataEncryptedText(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        }
    }
}

public enum LiteServerTransactionId: TDEnum {
    case blocksShortTxId(BlocksShortTxId)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TLTypedCodingKey.self)
        let type = try container.decode(String.self, forKey: ._type)

        switch type {
        case BlocksShortTxId._type:
            self = .blocksShortTxId(try BlocksShortTxId(from: decoder))
        default: throw TLTypedUnknownTypeError()
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: TLTypedCodingKey.self)

        switch self {
        case let .blocksShortTxId(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        }
    }
}

public enum DnsEntryData: TDEnum {
    case dnsEntryDataUnknown(DnsEntryDataUnknown)
    case dnsEntryDataText(DnsEntryDataText)
    case dnsEntryDataNextResolver(DnsEntryDataNextResolver)
    case dnsEntryDataSmcAddress(DnsEntryDataSmcAddress)
    case dnsEntryDataAdnlAddress(DnsEntryDataAdnlAddress)
    case dnsEntryDataStorageAddress(DnsEntryDataStorageAddress)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TLTypedCodingKey.self)
        let type = try container.decode(String.self, forKey: ._type)

        switch type {
        case DnsEntryDataUnknown._type:
            self = .dnsEntryDataUnknown(try DnsEntryDataUnknown(from: decoder))
        case DnsEntryDataText._type:
            self = .dnsEntryDataText(try DnsEntryDataText(from: decoder))
        case DnsEntryDataNextResolver._type:
            self = .dnsEntryDataNextResolver(try DnsEntryDataNextResolver(from: decoder))
        case DnsEntryDataSmcAddress._type:
            self = .dnsEntryDataSmcAddress(try DnsEntryDataSmcAddress(from: decoder))
        case DnsEntryDataAdnlAddress._type:
            self = .dnsEntryDataAdnlAddress(try DnsEntryDataAdnlAddress(from: decoder))
        case DnsEntryDataStorageAddress._type:
            self = .dnsEntryDataStorageAddress(try DnsEntryDataStorageAddress(from: decoder))
        default: throw TLTypedUnknownTypeError()
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: TLTypedCodingKey.self)

        switch self {
        case let .dnsEntryDataUnknown(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .dnsEntryDataText(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .dnsEntryDataNextResolver(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .dnsEntryDataSmcAddress(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .dnsEntryDataAdnlAddress(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .dnsEntryDataStorageAddress(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        }
    }
}

public enum Action: TDEnum {
    case actionNoop(ActionNoop)
    case actionMsg(ActionMsg)
    case actionDns(ActionDns)
    case actionPchan(ActionPchan)
    case actionRwallet(ActionRwallet)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TLTypedCodingKey.self)
        let type = try container.decode(String.self, forKey: ._type)

        switch type {
        case ActionNoop._type:
            self = .actionNoop(try ActionNoop(from: decoder))
        case ActionMsg._type:
            self = .actionMsg(try ActionMsg(from: decoder))
        case ActionDns._type:
            self = .actionDns(try ActionDns(from: decoder))
        case ActionPchan._type:
            self = .actionPchan(try ActionPchan(from: decoder))
        case ActionRwallet._type:
            self = .actionRwallet(try ActionRwallet(from: decoder))
        default: throw TLTypedUnknownTypeError()
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: TLTypedCodingKey.self)

        switch self {
        case let .actionNoop(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .actionMsg(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .actionDns(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .actionPchan(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .actionRwallet(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        }
    }
}

public enum Update: TDEnum {
    case updateSendLiteServerQuery(UpdateSendLiteServerQuery)
    case updateSyncState(UpdateSyncState)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TLTypedCodingKey.self)
        let type = try container.decode(String.self, forKey: ._type)

        switch type {
        case UpdateSendLiteServerQuery._type:
            self = .updateSendLiteServerQuery(try UpdateSendLiteServerQuery(from: decoder))
        case UpdateSyncState._type:
            self = .updateSyncState(try UpdateSyncState(from: decoder))
        default: throw TLTypedUnknownTypeError()
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: TLTypedCodingKey.self)

        switch self {
        case let .updateSendLiteServerQuery(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        case let .updateSyncState(value):
            try container.encode(type(of: value)._type, forKey: ._type)
            try value.encode(to: encoder)
        }
    }
}

public struct Init: TLFunction {
    public typealias ReturnType = OptionsInfo

    public static var _type: String { "init" }

    public let options: Options

    public init(
        options: Options
    ) {
        self.options = options
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case options = "options"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.options = try container.decode(Options.self, forKey: .options)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.options, forKey: .options)
    }
}

public struct Close: TLFunction {
    public typealias ReturnType = Ok

    public static var _type: String { "close" }

    public init() { }

    public enum _Key: String, CodingKey {
        case _type = "@type"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
    }
}

public struct OptionsSetConfig: TLFunction {
    public typealias ReturnType = OptionsConfigInfo

    public static var _type: String { "options.setConfig" }

    public let config: Config

    public init(
        config: Config
    ) {
        self.config = config
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case config = "config"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.config = try container.decode(Config.self, forKey: .config)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.config, forKey: .config)
    }
}

public struct OptionsValidateConfig: TLFunction {
    public typealias ReturnType = OptionsConfigInfo

    public static var _type: String { "options.validateConfig" }

    public let config: Config

    public init(
        config: Config
    ) {
        self.config = config
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case config = "config"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.config = try container.decode(Config.self, forKey: .config)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.config, forKey: .config)
    }
}

public struct CreateNewKey: TLFunction {
    public typealias ReturnType = Key

    public static var _type: String { "createNewKey" }

    public let localPassword: SecureBytes
    public let mnemonicPassword: SecureBytes
    public let randomExtraSeed: SecureBytes

    public init(
        localPassword: SecureBytes,
        mnemonicPassword: SecureBytes,
        randomExtraSeed: SecureBytes
    ) {
        self.localPassword = localPassword
        self.mnemonicPassword = mnemonicPassword
        self.randomExtraSeed = randomExtraSeed
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case localPassword = "local_password"
        case mnemonicPassword = "mnemonic_password"
        case randomExtraSeed = "random_extra_seed"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.localPassword = try container.decode(SecureBytes.self, forKey: .localPassword)
        self.mnemonicPassword = try container.decode(SecureBytes.self, forKey: .mnemonicPassword)
        self.randomExtraSeed = try container.decode(SecureBytes.self, forKey: .randomExtraSeed)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.localPassword, forKey: .localPassword)
        try container.encode(self.mnemonicPassword, forKey: .mnemonicPassword)
        try container.encode(self.randomExtraSeed, forKey: .randomExtraSeed)
    }
}

public struct DeleteKey: TLFunction {
    public typealias ReturnType = Ok

    public static var _type: String { "deleteKey" }

    public let key: Key

    public init(
        key: Key
    ) {
        self.key = key
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case key = "key"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.key = try container.decode(Key.self, forKey: .key)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.key, forKey: .key)
    }
}

public struct DeleteAllKeys: TLFunction {
    public typealias ReturnType = Ok

    public static var _type: String { "deleteAllKeys" }

    public init() { }

    public enum _Key: String, CodingKey {
        case _type = "@type"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
    }
}

public struct ExportKey: TLFunction {
    public typealias ReturnType = ExportedKey

    public static var _type: String { "exportKey" }

    public let inputKey: InputKey

    public init(
        inputKey: InputKey
    ) {
        self.inputKey = inputKey
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case inputKey = "input_key"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.inputKey = try container.decode(InputKey.self, forKey: .inputKey)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.inputKey, forKey: .inputKey)
    }
}

public struct ExportPemKey: TLFunction {
    public typealias ReturnType = ExportedPemKey

    public static var _type: String { "exportPemKey" }

    public let inputKey: InputKey
    public let keyPassword: SecureBytes

    public init(
        inputKey: InputKey,
        keyPassword: SecureBytes
    ) {
        self.inputKey = inputKey
        self.keyPassword = keyPassword
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case inputKey = "input_key"
        case keyPassword = "key_password"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.inputKey = try container.decode(InputKey.self, forKey: .inputKey)
        self.keyPassword = try container.decode(SecureBytes.self, forKey: .keyPassword)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.inputKey, forKey: .inputKey)
        try container.encode(self.keyPassword, forKey: .keyPassword)
    }
}

public struct ExportEncryptedKey: TLFunction {
    public typealias ReturnType = ExportedEncryptedKey

    public static var _type: String { "exportEncryptedKey" }

    public let inputKey: InputKey
    public let keyPassword: SecureBytes

    public init(
        inputKey: InputKey,
        keyPassword: SecureBytes
    ) {
        self.inputKey = inputKey
        self.keyPassword = keyPassword
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case inputKey = "input_key"
        case keyPassword = "key_password"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.inputKey = try container.decode(InputKey.self, forKey: .inputKey)
        self.keyPassword = try container.decode(SecureBytes.self, forKey: .keyPassword)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.inputKey, forKey: .inputKey)
        try container.encode(self.keyPassword, forKey: .keyPassword)
    }
}

public struct ExportUnencryptedKey: TLFunction {
    public typealias ReturnType = ExportedUnencryptedKey

    public static var _type: String { "exportUnencryptedKey" }

    public let inputKey: InputKey

    public init(
        inputKey: InputKey
    ) {
        self.inputKey = inputKey
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case inputKey = "input_key"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.inputKey = try container.decode(InputKey.self, forKey: .inputKey)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.inputKey, forKey: .inputKey)
    }
}

public struct ImportKey: TLFunction {
    public typealias ReturnType = Key

    public static var _type: String { "importKey" }

    public let localPassword: SecureBytes
    public let mnemonicPassword: SecureBytes
    public let exportedKey: ExportedKey

    public init(
        localPassword: SecureBytes,
        mnemonicPassword: SecureBytes,
        exportedKey: ExportedKey
    ) {
        self.localPassword = localPassword
        self.mnemonicPassword = mnemonicPassword
        self.exportedKey = exportedKey
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case localPassword = "local_password"
        case mnemonicPassword = "mnemonic_password"
        case exportedKey = "exported_key"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.localPassword = try container.decode(SecureBytes.self, forKey: .localPassword)
        self.mnemonicPassword = try container.decode(SecureBytes.self, forKey: .mnemonicPassword)
        self.exportedKey = try container.decode(ExportedKey.self, forKey: .exportedKey)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.localPassword, forKey: .localPassword)
        try container.encode(self.mnemonicPassword, forKey: .mnemonicPassword)
        try container.encode(self.exportedKey, forKey: .exportedKey)
    }
}

public struct ImportPemKey: TLFunction {
    public typealias ReturnType = Key

    public static var _type: String { "importPemKey" }

    public let localPassword: SecureBytes
    public let keyPassword: SecureBytes
    public let exportedKey: ExportedPemKey

    public init(
        localPassword: SecureBytes,
        keyPassword: SecureBytes,
        exportedKey: ExportedPemKey
    ) {
        self.localPassword = localPassword
        self.keyPassword = keyPassword
        self.exportedKey = exportedKey
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case localPassword = "local_password"
        case keyPassword = "key_password"
        case exportedKey = "exported_key"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.localPassword = try container.decode(SecureBytes.self, forKey: .localPassword)
        self.keyPassword = try container.decode(SecureBytes.self, forKey: .keyPassword)
        self.exportedKey = try container.decode(ExportedPemKey.self, forKey: .exportedKey)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.localPassword, forKey: .localPassword)
        try container.encode(self.keyPassword, forKey: .keyPassword)
        try container.encode(self.exportedKey, forKey: .exportedKey)
    }
}

public struct ImportEncryptedKey: TLFunction {
    public typealias ReturnType = Key

    public static var _type: String { "importEncryptedKey" }

    public let localPassword: SecureBytes
    public let keyPassword: SecureBytes
    public let exportedEncryptedKey: ExportedEncryptedKey

    public init(
        localPassword: SecureBytes,
        keyPassword: SecureBytes,
        exportedEncryptedKey: ExportedEncryptedKey
    ) {
        self.localPassword = localPassword
        self.keyPassword = keyPassword
        self.exportedEncryptedKey = exportedEncryptedKey
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case localPassword = "local_password"
        case keyPassword = "key_password"
        case exportedEncryptedKey = "exported_encrypted_key"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.localPassword = try container.decode(SecureBytes.self, forKey: .localPassword)
        self.keyPassword = try container.decode(SecureBytes.self, forKey: .keyPassword)
        self.exportedEncryptedKey = try container.decode(ExportedEncryptedKey.self, forKey: .exportedEncryptedKey)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.localPassword, forKey: .localPassword)
        try container.encode(self.keyPassword, forKey: .keyPassword)
        try container.encode(self.exportedEncryptedKey, forKey: .exportedEncryptedKey)
    }
}

public struct ImportUnencryptedKey: TLFunction {
    public typealias ReturnType = Key

    public static var _type: String { "importUnencryptedKey" }

    public let localPassword: SecureBytes
    public let exportedUnencryptedKey: ExportedUnencryptedKey

    public init(
        localPassword: SecureBytes,
        exportedUnencryptedKey: ExportedUnencryptedKey
    ) {
        self.localPassword = localPassword
        self.exportedUnencryptedKey = exportedUnencryptedKey
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case localPassword = "local_password"
        case exportedUnencryptedKey = "exported_unencrypted_key"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.localPassword = try container.decode(SecureBytes.self, forKey: .localPassword)
        self.exportedUnencryptedKey = try container.decode(ExportedUnencryptedKey.self, forKey: .exportedUnencryptedKey)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.localPassword, forKey: .localPassword)
        try container.encode(self.exportedUnencryptedKey, forKey: .exportedUnencryptedKey)
    }
}

public struct ChangeLocalPassword: TLFunction {
    public typealias ReturnType = Key

    public static var _type: String { "changeLocalPassword" }

    public let inputKey: InputKey
    public let newLocalPassword: SecureBytes

    public init(
        inputKey: InputKey,
        newLocalPassword: SecureBytes
    ) {
        self.inputKey = inputKey
        self.newLocalPassword = newLocalPassword
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case inputKey = "input_key"
        case newLocalPassword = "new_local_password"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.inputKey = try container.decode(InputKey.self, forKey: .inputKey)
        self.newLocalPassword = try container.decode(SecureBytes.self, forKey: .newLocalPassword)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.inputKey, forKey: .inputKey)
        try container.encode(self.newLocalPassword, forKey: .newLocalPassword)
    }
}

public struct Encrypt: TLFunction {
    public typealias ReturnType = Data

    public static var _type: String { "encrypt" }

    public let decryptedData: SecureBytes
    public let secret: SecureBytes

    public init(
        decryptedData: SecureBytes,
        secret: SecureBytes
    ) {
        self.decryptedData = decryptedData
        self.secret = secret
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case decryptedData = "decrypted_data"
        case secret = "secret"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.decryptedData = try container.decode(SecureBytes.self, forKey: .decryptedData)
        self.secret = try container.decode(SecureBytes.self, forKey: .secret)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.decryptedData, forKey: .decryptedData)
        try container.encode(self.secret, forKey: .secret)
    }
}

public struct Decrypt: TLFunction {
    public typealias ReturnType = Data

    public static var _type: String { "decrypt" }

    public let encryptedData: SecureBytes
    public let secret: SecureBytes

    public init(
        encryptedData: SecureBytes,
        secret: SecureBytes
    ) {
        self.encryptedData = encryptedData
        self.secret = secret
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case encryptedData = "encrypted_data"
        case secret = "secret"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.encryptedData = try container.decode(SecureBytes.self, forKey: .encryptedData)
        self.secret = try container.decode(SecureBytes.self, forKey: .secret)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.encryptedData, forKey: .encryptedData)
        try container.encode(self.secret, forKey: .secret)
    }
}

public struct Kdf: TLFunction {
    public typealias ReturnType = Data

    public static var _type: String { "kdf" }

    public let password: SecureBytes
    public let salt: SecureBytes
    public let iterations: Int32

    public init(
        password: SecureBytes,
        salt: SecureBytes,
        iterations: Int32
    ) {
        self.password = password
        self.salt = salt
        self.iterations = iterations
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case password = "password"
        case salt = "salt"
        case iterations = "iterations"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.password = try container.decode(SecureBytes.self, forKey: .password)
        self.salt = try container.decode(SecureBytes.self, forKey: .salt)
        self.iterations = try container.decode(Int32.self, forKey: .iterations)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.password, forKey: .password)
        try container.encode(self.salt, forKey: .salt)
        try container.encode(self.iterations, forKey: .iterations)
    }
}

public struct UnpackAccountAddress: TLFunction {
    public typealias ReturnType = UnpackedAccountAddress

    public static var _type: String { "unpackAccountAddress" }

    public let accountAddress: String

    public init(
        accountAddress: String
    ) {
        self.accountAddress = accountAddress
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case accountAddress = "account_address"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.accountAddress = try container.decode(String.self, forKey: .accountAddress)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.accountAddress, forKey: .accountAddress)
    }
}

public struct PackAccountAddress: TLFunction {
    public typealias ReturnType = AccountAddress

    public static var _type: String { "packAccountAddress" }

    public let accountAddress: UnpackedAccountAddress

    public init(
        accountAddress: UnpackedAccountAddress
    ) {
        self.accountAddress = accountAddress
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case accountAddress = "account_address"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.accountAddress = try container.decode(UnpackedAccountAddress.self, forKey: .accountAddress)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.accountAddress, forKey: .accountAddress)
    }
}

public struct GetBip39Hints: TLFunction {
    public typealias ReturnType = Bip39Hints

    public static var _type: String { "getBip39Hints" }

    public let prefix: String

    public init(
        prefix: String
    ) {
        self.prefix = prefix
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case prefix = "prefix"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.prefix = try container.decode(String.self, forKey: .prefix)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.prefix, forKey: .prefix)
    }
}

public struct RawGetAccountState: TLFunction {
    public typealias ReturnType = RawFullAccountState

    public static var _type: String { "raw.getAccountState" }

    public let accountAddress: AccountAddress

    public init(
        accountAddress: AccountAddress
    ) {
        self.accountAddress = accountAddress
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case accountAddress = "account_address"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.accountAddress = try container.decode(AccountAddress.self, forKey: .accountAddress)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.accountAddress, forKey: .accountAddress)
    }
}

public struct RawGetAccountStateByTransaction: TLFunction {
    public typealias ReturnType = RawFullAccountState

    public static var _type: String { "raw.getAccountStateByTransaction" }

    public let accountAddress: AccountAddress
    public let transactionId: InternalTransactionId

    public init(
        accountAddress: AccountAddress,
        transactionId: InternalTransactionId
    ) {
        self.accountAddress = accountAddress
        self.transactionId = transactionId
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case accountAddress = "account_address"
        case transactionId = "transaction_id"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.accountAddress = try container.decode(AccountAddress.self, forKey: .accountAddress)
        self.transactionId = try container.decode(InternalTransactionId.self, forKey: .transactionId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.accountAddress, forKey: .accountAddress)
        try container.encode(self.transactionId, forKey: .transactionId)
    }
}

public struct RawGetTransactions: TLFunction {
    public typealias ReturnType = RawTransactions

    public static var _type: String { "raw.getTransactions" }

    public let privateKey: InputKey
    public let accountAddress: AccountAddress
    public let fromTransactionId: InternalTransactionId

    public init(
        privateKey: InputKey,
        accountAddress: AccountAddress,
        fromTransactionId: InternalTransactionId
    ) {
        self.privateKey = privateKey
        self.accountAddress = accountAddress
        self.fromTransactionId = fromTransactionId
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case privateKey = "private_key"
        case accountAddress = "account_address"
        case fromTransactionId = "from_transaction_id"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.privateKey = try container.decode(InputKey.self, forKey: .privateKey)
        self.accountAddress = try container.decode(AccountAddress.self, forKey: .accountAddress)
        self.fromTransactionId = try container.decode(InternalTransactionId.self, forKey: .fromTransactionId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.privateKey, forKey: .privateKey)
        try container.encode(self.accountAddress, forKey: .accountAddress)
        try container.encode(self.fromTransactionId, forKey: .fromTransactionId)
    }
}

public struct RawGetTransactionsV2: TLFunction {
    public typealias ReturnType = RawTransactions

    public static var _type: String { "raw.getTransactionsV2" }

    public let privateKey: InputKey
    public let accountAddress: AccountAddress
    public let fromTransactionId: InternalTransactionId
    public let count: Int32
    public let tryDecodeMessages: Bool

    public init(
        privateKey: InputKey,
        accountAddress: AccountAddress,
        fromTransactionId: InternalTransactionId,
        count: Int32,
        tryDecodeMessages: Bool
    ) {
        self.privateKey = privateKey
        self.accountAddress = accountAddress
        self.fromTransactionId = fromTransactionId
        self.count = count
        self.tryDecodeMessages = tryDecodeMessages
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case privateKey = "private_key"
        case accountAddress = "account_address"
        case fromTransactionId = "from_transaction_id"
        case count = "count"
        case tryDecodeMessages = "try_decode_messages"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.privateKey = try container.decode(InputKey.self, forKey: .privateKey)
        self.accountAddress = try container.decode(AccountAddress.self, forKey: .accountAddress)
        self.fromTransactionId = try container.decode(InternalTransactionId.self, forKey: .fromTransactionId)
        self.count = try container.decode(Int32.self, forKey: .count)
        self.tryDecodeMessages = try container.decode(Bool.self, forKey: .tryDecodeMessages)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.privateKey, forKey: .privateKey)
        try container.encode(self.accountAddress, forKey: .accountAddress)
        try container.encode(self.fromTransactionId, forKey: .fromTransactionId)
        try container.encode(self.count, forKey: .count)
        try container.encode(self.tryDecodeMessages, forKey: .tryDecodeMessages)
    }
}

public struct RawSendMessage: TLFunction {
    public typealias ReturnType = Ok

    public static var _type: String { "raw.sendMessage" }

    public let body: Bytes

    public init(
        body: Bytes
    ) {
        self.body = body
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case body = "body"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.body = try container.decode(Bytes.self, forKey: .body)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.body, forKey: .body)
    }
}

public struct RawSendMessageReturnHash: TLFunction {
    public typealias ReturnType = RawExtMessageInfo

    public static var _type: String { "raw.sendMessageReturnHash" }

    public let body: Bytes

    public init(
        body: Bytes
    ) {
        self.body = body
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case body = "body"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.body = try container.decode(Bytes.self, forKey: .body)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.body, forKey: .body)
    }
}

public struct RawCreateAndSendMessage: TLFunction {
    public typealias ReturnType = Ok

    public static var _type: String { "raw.createAndSendMessage" }

    public let destination: AccountAddress
    public let initialAccountState: Bytes
    public let data: Bytes

    public init(
        destination: AccountAddress,
        initialAccountState: Bytes,
        data: Bytes
    ) {
        self.destination = destination
        self.initialAccountState = initialAccountState
        self.data = data
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case destination = "destination"
        case initialAccountState = "initial_account_state"
        case data = "data"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.destination = try container.decode(AccountAddress.self, forKey: .destination)
        self.initialAccountState = try container.decode(Bytes.self, forKey: .initialAccountState)
        self.data = try container.decode(Bytes.self, forKey: .data)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.destination, forKey: .destination)
        try container.encode(self.initialAccountState, forKey: .initialAccountState)
        try container.encode(self.data, forKey: .data)
    }
}

public struct RawCreateQuery: TLFunction {
    public typealias ReturnType = QueryInfo

    public static var _type: String { "raw.createQuery" }

    public let destination: AccountAddress
    public let initCode: Bytes
    public let initData: Bytes
    public let body: Bytes

    public init(
        destination: AccountAddress,
        initCode: Bytes,
        initData: Bytes,
        body: Bytes
    ) {
        self.destination = destination
        self.initCode = initCode
        self.initData = initData
        self.body = body
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case destination = "destination"
        case initCode = "init_code"
        case initData = "init_data"
        case body = "body"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.destination = try container.decode(AccountAddress.self, forKey: .destination)
        self.initCode = try container.decode(Bytes.self, forKey: .initCode)
        self.initData = try container.decode(Bytes.self, forKey: .initData)
        self.body = try container.decode(Bytes.self, forKey: .body)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.destination, forKey: .destination)
        try container.encode(self.initCode, forKey: .initCode)
        try container.encode(self.initData, forKey: .initData)
        try container.encode(self.body, forKey: .body)
    }
}

public struct Sync: TLFunction {
    public typealias ReturnType = TonBlockIdExt

    public static var _type: String { "sync" }

    public init() { }

    public enum _Key: String, CodingKey {
        case _type = "@type"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
    }
}

public struct GetAccountAddress: TLFunction {
    public typealias ReturnType = AccountAddress

    public static var _type: String { "getAccountAddress" }

    public let initialAccountState: InitialAccountState
    public let revision: Int32
    public let workchainId: Int32

    public init(
        initialAccountState: InitialAccountState,
        revision: Int32,
        workchainId: Int32
    ) {
        self.initialAccountState = initialAccountState
        self.revision = revision
        self.workchainId = workchainId
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case initialAccountState = "initial_account_state"
        case revision = "revision"
        case workchainId = "workchain_id"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.initialAccountState = try container.decode(InitialAccountState.self, forKey: .initialAccountState)
        self.revision = try container.decode(Int32.self, forKey: .revision)
        self.workchainId = try container.decode(Int32.self, forKey: .workchainId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.initialAccountState, forKey: .initialAccountState)
        try container.encode(self.revision, forKey: .revision)
        try container.encode(self.workchainId, forKey: .workchainId)
    }
}

public struct GuessAccountRevision: TLFunction {
    public typealias ReturnType = AccountRevisionList

    public static var _type: String { "guessAccountRevision" }

    public let initialAccountState: InitialAccountState
    public let workchainId: Int32

    public init(
        initialAccountState: InitialAccountState,
        workchainId: Int32
    ) {
        self.initialAccountState = initialAccountState
        self.workchainId = workchainId
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case initialAccountState = "initial_account_state"
        case workchainId = "workchain_id"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.initialAccountState = try container.decode(InitialAccountState.self, forKey: .initialAccountState)
        self.workchainId = try container.decode(Int32.self, forKey: .workchainId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.initialAccountState, forKey: .initialAccountState)
        try container.encode(self.workchainId, forKey: .workchainId)
    }
}

public struct GuessAccount: TLFunction {
    public typealias ReturnType = AccountRevisionList

    public static var _type: String { "guessAccount" }

    public let publicKey: String
    public let rwalletInitPublicKey: String

    public init(
        publicKey: String,
        rwalletInitPublicKey: String
    ) {
        self.publicKey = publicKey
        self.rwalletInitPublicKey = rwalletInitPublicKey
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case publicKey = "public_key"
        case rwalletInitPublicKey = "rwallet_init_public_key"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.publicKey = try container.decode(String.self, forKey: .publicKey)
        self.rwalletInitPublicKey = try container.decode(String.self, forKey: .rwalletInitPublicKey)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.publicKey, forKey: .publicKey)
        try container.encode(self.rwalletInitPublicKey, forKey: .rwalletInitPublicKey)
    }
}

public struct GetAccountState: TLFunction {
    public typealias ReturnType = FullAccountState

    public static var _type: String { "getAccountState" }

    public let accountAddress: AccountAddress

    public init(
        accountAddress: AccountAddress
    ) {
        self.accountAddress = accountAddress
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case accountAddress = "account_address"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.accountAddress = try container.decode(AccountAddress.self, forKey: .accountAddress)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.accountAddress, forKey: .accountAddress)
    }
}

public struct GetAccountStateByTransaction: TLFunction {
    public typealias ReturnType = FullAccountState

    public static var _type: String { "getAccountStateByTransaction" }

    public let accountAddress: AccountAddress
    public let transactionId: InternalTransactionId

    public init(
        accountAddress: AccountAddress,
        transactionId: InternalTransactionId
    ) {
        self.accountAddress = accountAddress
        self.transactionId = transactionId
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case accountAddress = "account_address"
        case transactionId = "transaction_id"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.accountAddress = try container.decode(AccountAddress.self, forKey: .accountAddress)
        self.transactionId = try container.decode(InternalTransactionId.self, forKey: .transactionId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.accountAddress, forKey: .accountAddress)
        try container.encode(self.transactionId, forKey: .transactionId)
    }
}

public struct GetShardAccountCell: TLFunction {
    public typealias ReturnType = TvmCell

    public static var _type: String { "getShardAccountCell" }

    public let accountAddress: AccountAddress

    public init(
        accountAddress: AccountAddress
    ) {
        self.accountAddress = accountAddress
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case accountAddress = "account_address"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.accountAddress = try container.decode(AccountAddress.self, forKey: .accountAddress)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.accountAddress, forKey: .accountAddress)
    }
}

public struct GetShardAccountCellByTransaction: TLFunction {
    public typealias ReturnType = TvmCell

    public static var _type: String { "getShardAccountCellByTransaction" }

    public let accountAddress: AccountAddress
    public let transactionId: InternalTransactionId

    public init(
        accountAddress: AccountAddress,
        transactionId: InternalTransactionId
    ) {
        self.accountAddress = accountAddress
        self.transactionId = transactionId
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case accountAddress = "account_address"
        case transactionId = "transaction_id"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.accountAddress = try container.decode(AccountAddress.self, forKey: .accountAddress)
        self.transactionId = try container.decode(InternalTransactionId.self, forKey: .transactionId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.accountAddress, forKey: .accountAddress)
        try container.encode(self.transactionId, forKey: .transactionId)
    }
}

public struct CreateQuery: TLFunction {
    public typealias ReturnType = QueryInfo

    public static var _type: String { "createQuery" }

    public let privateKey: InputKey
    public let address: AccountAddress
    public let timeout: Int32
    public let action: Action
    public let initialAccountState: InitialAccountState

    public init(
        privateKey: InputKey,
        address: AccountAddress,
        timeout: Int32,
        action: Action,
        initialAccountState: InitialAccountState
    ) {
        self.privateKey = privateKey
        self.address = address
        self.timeout = timeout
        self.action = action
        self.initialAccountState = initialAccountState
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case privateKey = "private_key"
        case address = "address"
        case timeout = "timeout"
        case action = "action"
        case initialAccountState = "initial_account_state"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.privateKey = try container.decode(InputKey.self, forKey: .privateKey)
        self.address = try container.decode(AccountAddress.self, forKey: .address)
        self.timeout = try container.decode(Int32.self, forKey: .timeout)
        self.action = try container.decode(Action.self, forKey: .action)
        self.initialAccountState = try container.decode(InitialAccountState.self, forKey: .initialAccountState)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.privateKey, forKey: .privateKey)
        try container.encode(self.address, forKey: .address)
        try container.encode(self.timeout, forKey: .timeout)
        try container.encode(self.action, forKey: .action)
        try container.encode(self.initialAccountState, forKey: .initialAccountState)
    }
}

public struct GetConfigParam: TLFunction {
    public typealias ReturnType = ConfigInfo

    public static var _type: String { "getConfigParam" }

    public let mode: Int32
    public let param: Int32

    public init(
        mode: Int32,
        param: Int32
    ) {
        self.mode = mode
        self.param = param
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case mode = "mode"
        case param = "param"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.mode = try container.decode(Int32.self, forKey: .mode)
        self.param = try container.decode(Int32.self, forKey: .param)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.mode, forKey: .mode)
        try container.encode(self.param, forKey: .param)
    }
}

public struct GetConfigAll: TLFunction {
    public typealias ReturnType = ConfigInfo

    public static var _type: String { "getConfigAll" }

    public let mode: Int32

    public init(
        mode: Int32
    ) {
        self.mode = mode
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case mode = "mode"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.mode = try container.decode(Int32.self, forKey: .mode)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.mode, forKey: .mode)
    }
}

public struct MsgDecrypt: TLFunction {
    public typealias ReturnType = MsgDataDecryptedArray

    public static var _type: String { "msg.decrypt" }

    public let inputKey: InputKey
    public let data: MsgDataEncryptedArray

    public init(
        inputKey: InputKey,
        data: MsgDataEncryptedArray
    ) {
        self.inputKey = inputKey
        self.data = data
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case inputKey = "input_key"
        case data = "data"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.inputKey = try container.decode(InputKey.self, forKey: .inputKey)
        self.data = try container.decode(MsgDataEncryptedArray.self, forKey: .data)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.inputKey, forKey: .inputKey)
        try container.encode(self.data, forKey: .data)
    }
}

public struct MsgDecryptWithProof: TLFunction {
    public typealias ReturnType = MsgData

    public static var _type: String { "msg.decryptWithProof" }

    public let proof: Bytes
    public let data: MsgDataEncrypted

    public init(
        proof: Bytes,
        data: MsgDataEncrypted
    ) {
        self.proof = proof
        self.data = data
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case proof = "proof"
        case data = "data"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.proof = try container.decode(Bytes.self, forKey: .proof)
        self.data = try container.decode(MsgDataEncrypted.self, forKey: .data)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.proof, forKey: .proof)
        try container.encode(self.data, forKey: .data)
    }
}

public struct QuerySend: TLFunction {
    public typealias ReturnType = Ok

    public static var _type: String { "query.send" }

    public let id: Int53

    public init(
        id: Int53
    ) {
        self.id = id
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case id = "id"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.id = try container.decode(Int53.self, forKey: .id)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.id, forKey: .id)
    }
}

public struct QueryForget: TLFunction {
    public typealias ReturnType = Ok

    public static var _type: String { "query.forget" }

    public let id: Int53

    public init(
        id: Int53
    ) {
        self.id = id
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case id = "id"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.id = try container.decode(Int53.self, forKey: .id)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.id, forKey: .id)
    }
}

public struct QueryEstimateFees: TLFunction {
    public typealias ReturnType = QueryFees

    public static var _type: String { "query.estimateFees" }

    public let id: Int53
    public let ignoreChksig: Bool

    public init(
        id: Int53,
        ignoreChksig: Bool
    ) {
        self.id = id
        self.ignoreChksig = ignoreChksig
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case id = "id"
        case ignoreChksig = "ignore_chksig"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.id = try container.decode(Int53.self, forKey: .id)
        self.ignoreChksig = try container.decode(Bool.self, forKey: .ignoreChksig)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.ignoreChksig, forKey: .ignoreChksig)
    }
}

public struct QueryGetInfo: TLFunction {
    public typealias ReturnType = QueryInfo

    public static var _type: String { "query.getInfo" }

    public let id: Int53

    public init(
        id: Int53
    ) {
        self.id = id
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case id = "id"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.id = try container.decode(Int53.self, forKey: .id)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.id, forKey: .id)
    }
}

public struct SmcLoad: TLFunction {
    public typealias ReturnType = SmcInfo

    public static var _type: String { "smc.load" }

    public let accountAddress: AccountAddress

    public init(
        accountAddress: AccountAddress
    ) {
        self.accountAddress = accountAddress
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case accountAddress = "account_address"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.accountAddress = try container.decode(AccountAddress.self, forKey: .accountAddress)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.accountAddress, forKey: .accountAddress)
    }
}

public struct SmcLoadByTransaction: TLFunction {
    public typealias ReturnType = SmcInfo

    public static var _type: String { "smc.loadByTransaction" }

    public let accountAddress: AccountAddress
    public let transactionId: InternalTransactionId

    public init(
        accountAddress: AccountAddress,
        transactionId: InternalTransactionId
    ) {
        self.accountAddress = accountAddress
        self.transactionId = transactionId
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case accountAddress = "account_address"
        case transactionId = "transaction_id"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.accountAddress = try container.decode(AccountAddress.self, forKey: .accountAddress)
        self.transactionId = try container.decode(InternalTransactionId.self, forKey: .transactionId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.accountAddress, forKey: .accountAddress)
        try container.encode(self.transactionId, forKey: .transactionId)
    }
}

public struct SmcForget: TLFunction {
    public typealias ReturnType = Ok

    public static var _type: String { "smc.forget" }

    public let id: Int53

    public init(
        id: Int53
    ) {
        self.id = id
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case id = "id"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.id = try container.decode(Int53.self, forKey: .id)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.id, forKey: .id)
    }
}

public struct SmcGetCode: TLFunction {
    public typealias ReturnType = TvmCell

    public static var _type: String { "smc.getCode" }

    public let id: Int53

    public init(
        id: Int53
    ) {
        self.id = id
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case id = "id"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.id = try container.decode(Int53.self, forKey: .id)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.id, forKey: .id)
    }
}

public struct SmcGetData: TLFunction {
    public typealias ReturnType = TvmCell

    public static var _type: String { "smc.getData" }

    public let id: Int53

    public init(
        id: Int53
    ) {
        self.id = id
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case id = "id"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.id = try container.decode(Int53.self, forKey: .id)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.id, forKey: .id)
    }
}

public struct SmcGetState: TLFunction {
    public typealias ReturnType = TvmCell

    public static var _type: String { "smc.getState" }

    public let id: Int53

    public init(
        id: Int53
    ) {
        self.id = id
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case id = "id"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.id = try container.decode(Int53.self, forKey: .id)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.id, forKey: .id)
    }
}

public struct SmcRunGetMethod: TLFunction {
    public typealias ReturnType = SmcRunResult

    public static var _type: String { "smc.runGetMethod" }

    public let id: Int53
    public let method: SmcMethodId
    public let stack: [TvmStackEntry]

    public init(
        id: Int53,
        method: SmcMethodId,
        stack: [TvmStackEntry]
    ) {
        self.id = id
        self.method = method
        self.stack = stack
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case id = "id"
        case method = "method"
        case stack = "stack"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.id = try container.decode(Int53.self, forKey: .id)
        self.method = try container.decode(SmcMethodId.self, forKey: .method)
        self.stack = try container.decode([TvmStackEntry].self, forKey: .stack)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.method, forKey: .method)
        try container.encode(self.stack, forKey: .stack)
    }
}

public struct SmcGetLibraries: TLFunction {
    public typealias ReturnType = SmcLibraryResult

    public static var _type: String { "smc.getLibraries" }

    public let libraryList: [Int256]

    public init(
        libraryList: [Int256]
    ) {
        self.libraryList = libraryList
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case libraryList = "library_list"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.libraryList = try container.decode([Int256].self, forKey: .libraryList)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.libraryList, forKey: .libraryList)
    }
}

public struct DnsResolve: TLFunction {
    public typealias ReturnType = DnsResolved

    public static var _type: String { "dns.resolve" }

    public let accountAddress: AccountAddress
    public let name: String
    public let category: Int256
    public let ttl: Int32

    public init(
        accountAddress: AccountAddress,
        name: String,
        category: Int256,
        ttl: Int32
    ) {
        self.accountAddress = accountAddress
        self.name = name
        self.category = category
        self.ttl = ttl
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case accountAddress = "account_address"
        case name = "name"
        case category = "category"
        case ttl = "ttl"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.accountAddress = try container.decode(AccountAddress.self, forKey: .accountAddress)
        self.name = try container.decode(String.self, forKey: .name)
        self.category = try container.decode(Int256.self, forKey: .category)
        self.ttl = try container.decode(Int32.self, forKey: .ttl)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.accountAddress, forKey: .accountAddress)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.category, forKey: .category)
        try container.encode(self.ttl, forKey: .ttl)
    }
}

public struct PchanSignPromise: TLFunction {
    public typealias ReturnType = PchanPromise

    public static var _type: String { "pchan.signPromise" }

    public let inputKey: InputKey
    public let promise: PchanPromise

    public init(
        inputKey: InputKey,
        promise: PchanPromise
    ) {
        self.inputKey = inputKey
        self.promise = promise
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case inputKey = "input_key"
        case promise = "promise"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.inputKey = try container.decode(InputKey.self, forKey: .inputKey)
        self.promise = try container.decode(PchanPromise.self, forKey: .promise)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.inputKey, forKey: .inputKey)
        try container.encode(self.promise, forKey: .promise)
    }
}

public struct PchanValidatePromise: TLFunction {
    public typealias ReturnType = Ok

    public static var _type: String { "pchan.validatePromise" }

    public let publicKey: Bytes
    public let promise: PchanPromise

    public init(
        publicKey: Bytes,
        promise: PchanPromise
    ) {
        self.publicKey = publicKey
        self.promise = promise
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case publicKey = "public_key"
        case promise = "promise"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.publicKey = try container.decode(Bytes.self, forKey: .publicKey)
        self.promise = try container.decode(PchanPromise.self, forKey: .promise)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.publicKey, forKey: .publicKey)
        try container.encode(self.promise, forKey: .promise)
    }
}

public struct PchanPackPromise: TLFunction {
    public typealias ReturnType = Data

    public static var _type: String { "pchan.packPromise" }

    public let promise: PchanPromise

    public init(
        promise: PchanPromise
    ) {
        self.promise = promise
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case promise = "promise"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.promise = try container.decode(PchanPromise.self, forKey: .promise)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.promise, forKey: .promise)
    }
}

public struct PchanUnpackPromise: TLFunction {
    public typealias ReturnType = PchanPromise

    public static var _type: String { "pchan.unpackPromise" }

    public let data: SecureBytes

    public init(
        data: SecureBytes
    ) {
        self.data = data
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case data = "data"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.data = try container.decode(SecureBytes.self, forKey: .data)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.data, forKey: .data)
    }
}

public struct BlocksGetMasterchainInfo: TLFunction {
    public typealias ReturnType = BlocksMasterchainInfo

    public static var _type: String { "blocks.getMasterchainInfo" }

    public init() { }

    public enum _Key: String, CodingKey {
        case _type = "@type"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
    }
}

public struct BlocksGetShards: TLFunction {
    public typealias ReturnType = BlocksShards

    public static var _type: String { "blocks.getShards" }

    public let id: TonBlockIdExt

    public init(
        id: TonBlockIdExt
    ) {
        self.id = id
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case id = "id"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.id = try container.decode(TonBlockIdExt.self, forKey: .id)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.id, forKey: .id)
    }
}

public struct BlocksLookupBlock: TLFunction {
    public typealias ReturnType = TonBlockIdExt

    public static var _type: String { "blocks.lookupBlock" }

    public let mode: Int32
    public let id: TonBlockId
    public let lt: Int64
    public let utime: Int32

    public init(
        mode: Int32,
        id: TonBlockId,
        lt: Int64,
        utime: Int32
    ) {
        self.mode = mode
        self.id = id
        self.lt = lt
        self.utime = utime
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case mode = "mode"
        case id = "id"
        case lt = "lt"
        case utime = "utime"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.mode = try container.decode(Int32.self, forKey: .mode)
        self.id = try container.decode(TonBlockId.self, forKey: .id)
        self.lt = try container.decode(Int64.self, forKey: .lt)
        self.utime = try container.decode(Int32.self, forKey: .utime)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.mode, forKey: .mode)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.lt, forKey: .lt)
        try container.encode(self.utime, forKey: .utime)
    }
}

public struct BlocksGetTransactions: TLFunction {
    public typealias ReturnType = BlocksTransactions

    public static var _type: String { "blocks.getTransactions" }

    public let id: TonBlockIdExt
    public let mode: Int32
    public let count: Int32
    public let after: BlocksAccountTransactionId

    public init(
        id: TonBlockIdExt,
        mode: Int32,
        count: Int32,
        after: BlocksAccountTransactionId
    ) {
        self.id = id
        self.mode = mode
        self.count = count
        self.after = after
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case id = "id"
        case mode = "mode"
        case count = "count"
        case after = "after"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.id = try container.decode(TonBlockIdExt.self, forKey: .id)
        self.mode = try container.decode(Int32.self, forKey: .mode)
        self.count = try container.decode(Int32.self, forKey: .count)
        self.after = try container.decode(BlocksAccountTransactionId.self, forKey: .after)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.mode, forKey: .mode)
        try container.encode(self.count, forKey: .count)
        try container.encode(self.after, forKey: .after)
    }
}

public struct BlocksGetTransactionsExt: TLFunction {
    public typealias ReturnType = BlocksTransactionsExt

    public static var _type: String { "blocks.getTransactionsExt" }

    public let id: TonBlockIdExt
    public let mode: Int32
    public let count: Int32
    public let after: BlocksAccountTransactionId

    public init(
        id: TonBlockIdExt,
        mode: Int32,
        count: Int32,
        after: BlocksAccountTransactionId
    ) {
        self.id = id
        self.mode = mode
        self.count = count
        self.after = after
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case id = "id"
        case mode = "mode"
        case count = "count"
        case after = "after"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.id = try container.decode(TonBlockIdExt.self, forKey: .id)
        self.mode = try container.decode(Int32.self, forKey: .mode)
        self.count = try container.decode(Int32.self, forKey: .count)
        self.after = try container.decode(BlocksAccountTransactionId.self, forKey: .after)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.mode, forKey: .mode)
        try container.encode(self.count, forKey: .count)
        try container.encode(self.after, forKey: .after)
    }
}

public struct BlocksGetBlockHeader: TLFunction {
    public typealias ReturnType = BlocksHeader

    public static var _type: String { "blocks.getBlockHeader" }

    public let id: TonBlockIdExt

    public init(
        id: TonBlockIdExt
    ) {
        self.id = id
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case id = "id"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.id = try container.decode(TonBlockIdExt.self, forKey: .id)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.id, forKey: .id)
    }
}

public struct BlocksGetMasterchainBlockSignatures: TLFunction {
    public typealias ReturnType = BlocksBlockSignatures

    public static var _type: String { "blocks.getMasterchainBlockSignatures" }

    public let seqno: Int32

    public init(
        seqno: Int32
    ) {
        self.seqno = seqno
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case seqno = "seqno"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.seqno = try container.decode(Int32.self, forKey: .seqno)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.seqno, forKey: .seqno)
    }
}

public struct BlocksGetShardBlockProof: TLFunction {
    public typealias ReturnType = BlocksShardBlockProof

    public static var _type: String { "blocks.getShardBlockProof" }

}

public struct OnLiteServerQueryResult: TLFunction {
    public typealias ReturnType = Ok

    public static var _type: String { "onLiteServerQueryResult" }

    public let id: Int64
    public let bytes: Bytes

    public init(
        id: Int64,
        bytes: Bytes
    ) {
        self.id = id
        self.bytes = bytes
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case id = "id"
        case bytes = "bytes"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.id = try container.decode(Int64.self, forKey: .id)
        self.bytes = try container.decode(Bytes.self, forKey: .bytes)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.bytes, forKey: .bytes)
    }
}

public struct OnLiteServerQueryError: TLFunction {
    public typealias ReturnType = Ok

    public static var _type: String { "onLiteServerQueryError" }

    public let id: Int64
    public let error: Error

    public init(
        id: Int64,
        error: Error
    ) {
        self.id = id
        self.error = error
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case id = "id"
        case error = "error"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.id = try container.decode(Int64.self, forKey: .id)
        self.error = try container.decode(Error.self, forKey: .error)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.error, forKey: .error)
    }
}

public struct WithBlock<Function: TLFunction, Object: TLType>: TLFunction {
    public typealias ReturnType = Object

    public static var _type: String { "withBlock" }

    public let id: TonBlockIdExt
    public let function: Function

    public init(
        id: TonBlockIdExt,
        function: Function
    ) {
        self.id = id
        self.function = function
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case id = "id"
        case function = "function"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.id = try container.decode(TonBlockIdExt.self, forKey: .id)
        self.function = try container.decode(Function.self, forKey: .function)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.function, forKey: .function)
    }
}

public struct RunTests: TLFunction {
    public typealias ReturnType = Ok

    public static var _type: String { "runTests" }

    public let dir: String

    public init(
        dir: String
    ) {
        self.dir = dir
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case dir = "dir"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.dir = try container.decode(String.self, forKey: .dir)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.dir, forKey: .dir)
    }
}

public struct LiteServerGetInfo: TLFunction {
    public typealias ReturnType = LiteServerInfo

    public static var _type: String { "liteServer.getInfo" }

    public init() { }

    public enum _Key: String, CodingKey {
        case _type = "@type"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
    }
}

public struct SetLogStream: TLFunction {
    public typealias ReturnType = Ok

    public static var _type: String { "setLogStream" }

    public let logStream: LogStream

    public init(
        logStream: LogStream
    ) {
        self.logStream = logStream
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case logStream = "log_stream"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.logStream = try container.decode(LogStream.self, forKey: .logStream)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.logStream, forKey: .logStream)
    }
}

public struct GetLogStream: TLFunction {
    public typealias ReturnType = LogStream

    public static var _type: String { "getLogStream" }

    public init() { }

    public enum _Key: String, CodingKey {
        case _type = "@type"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
    }
}

public struct SetLogVerbosityLevel: TLFunction {
    public typealias ReturnType = Ok

    public static var _type: String { "setLogVerbosityLevel" }

    public let newVerbosityLevel: Int32

    public init(
        newVerbosityLevel: Int32
    ) {
        self.newVerbosityLevel = newVerbosityLevel
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case newVerbosityLevel = "new_verbosity_level"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.newVerbosityLevel = try container.decode(Int32.self, forKey: .newVerbosityLevel)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.newVerbosityLevel, forKey: .newVerbosityLevel)
    }
}

public struct GetLogVerbosityLevel: TLFunction {
    public typealias ReturnType = LogVerbosityLevel

    public static var _type: String { "getLogVerbosityLevel" }

    public init() { }

    public enum _Key: String, CodingKey {
        case _type = "@type"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
    }
}

public struct GetLogTags: TLFunction {
    public typealias ReturnType = LogTags

    public static var _type: String { "getLogTags" }

    public init() { }

    public enum _Key: String, CodingKey {
        case _type = "@type"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
    }
}

public struct SetLogTagVerbosityLevel: TLFunction {
    public typealias ReturnType = Ok

    public static var _type: String { "setLogTagVerbosityLevel" }

    public let tag: String
    public let newVerbosityLevel: Int32

    public init(
        tag: String,
        newVerbosityLevel: Int32
    ) {
        self.tag = tag
        self.newVerbosityLevel = newVerbosityLevel
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case tag = "tag"
        case newVerbosityLevel = "new_verbosity_level"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.tag = try container.decode(String.self, forKey: .tag)
        self.newVerbosityLevel = try container.decode(Int32.self, forKey: .newVerbosityLevel)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.tag, forKey: .tag)
        try container.encode(self.newVerbosityLevel, forKey: .newVerbosityLevel)
    }
}

public struct GetLogTagVerbosityLevel: TLFunction {
    public typealias ReturnType = LogVerbosityLevel

    public static var _type: String { "getLogTagVerbosityLevel" }

    public let tag: String

    public init(
        tag: String
    ) {
        self.tag = tag
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case tag = "tag"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.tag = try container.decode(String.self, forKey: .tag)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.tag, forKey: .tag)
    }
}

public struct AddLogMessage: TLFunction {
    public typealias ReturnType = Ok

    public static var _type: String { "addLogMessage" }

    public let verbosityLevel: Int32
    public let text: String

    public init(
        verbosityLevel: Int32,
        text: String
    ) {
        self.verbosityLevel = verbosityLevel
        self.text = text
    }

    public enum _Key: String, CodingKey {
        case _type = "@type"
        case verbosityLevel = "verbosity_level"
        case text = "text"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: _Key.self)
        self.verbosityLevel = try container.decode(Int32.self, forKey: .verbosityLevel)
        self.text = try container.decode(String.self, forKey: .text)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: _Key.self)
        try container.encode(Self._type, forKey: ._type)
        try container.encode(self.verbosityLevel, forKey: .verbosityLevel)
        try container.encode(self.text, forKey: .text)
    }
}
