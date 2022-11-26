//
//  TrollDrop.swift
//  AirTroller
//
//  Created by Анохин Юрий on 25.11.2022.
//

import Foundation
import CoreGraphics
import Foundation

func remLog(_ objs: Any...) {
    for obj in objs {
        let args: [CVarArg] = [ String(describing: obj) ]
        withVaList(args) { RLogv("%@", $0) }
    }
}

public enum TDKSFOperationEvent: CFIndex {
    case unknown = 0
    case newOperation
    case askUser
    case waitForAnswer
    case canceled
    case started
    case preprocess
    case progress
    case postprocess
    case finished
    case errorOccurred
    case connecting
    case information
    case conflict
    case blocked
}

typealias TDKSFBrowserClientContext = (
    version: CFIndex,
    info: UnsafeMutableRawPointer?,
    retain: CFAllocatorRetainCallBack?,
    release: CFAllocatorReleaseCallBack?,
    copyDescription: CFAllocatorCopyDescriptionCallBack?
);

typealias TDKSFOperationClientContext = (
    version: CFIndex,
    info: UnsafeMutableRawPointer?,
    retain: CFAllocatorRetainCallBack?,
    release: CFAllocatorReleaseCallBack?,
    copyDescription: CFAllocatorCopyDescriptionCallBack?
);

typealias TDKSFBrowser = OpaquePointer
typealias TDKSFNode = OpaquePointer
typealias TDKSFOperation = OpaquePointer

private(set) var kTDKSFBrowserKindAirDrop: CFString!
private(set) var kTDKSFOperationKindSender: CFString!
private(set) var kTDKSFOperationFileIconKey: CFString!
private(set) var kTDKSFOperationItemsKey: CFString!
private(set) var kTDKSFOperationNodeKey: CFString!

typealias TDKSFBrowserCreateFunction = @convention(c) (_ alloc: CFAllocator?, _ kind: CFString?) -> TDKSFBrowser
private(set) var TDKSFBrowserCreate: TDKSFBrowserCreateFunction!

typealias TDKSFBrowserCallbackFunction = @convention(c) (_ browser: TDKSFBrowser, _ node: TDKSFNode, _ children: CFArray, _: UnsafeMutableRawPointer?, _: UnsafeMutableRawPointer?, _ context: UnsafeMutableRawPointer?) -> Void
typealias TDKSFBrowserSetClientFunction = @convention(c) (_ browser: TDKSFBrowser, _ callback: TDKSFBrowserCallbackFunction, _ clientContext: UnsafeMutableRawPointer/*<TDKSFBrowserClientContext>*/) -> Void
private(set) var TDKSFBrowserSetClient: TDKSFBrowserSetClientFunction!

typealias TDKSFBrowserSetDispatchQueueFunction = @convention(c) (_ browser: TDKSFBrowser, _ queue: DispatchQueue) -> Void
private(set) var TDKSFBrowserSetDispatchQueue: TDKSFBrowserSetDispatchQueueFunction!

typealias TDKSFBrowserOpenNodeFunction = @convention(c) (_ browser: TDKSFBrowser, _ node: TDKSFNode?, _ protocol: UnsafeMutableRawPointer?, _ flags: CFOptionFlags) -> Void
private(set) var TDKSFBrowserOpenNode: TDKSFBrowserOpenNodeFunction!

typealias TDKSFBrowserCopyChildrenFunction = @convention(c) (_ browser: TDKSFBrowser, _ node: TDKSFNode?) -> CFArray
private(set) var TDKSFBrowserCopyChildren: TDKSFBrowserCopyChildrenFunction!

typealias TDKSFBrowserInvalidateFunction = @convention(c) (_ browser: TDKSFBrowser) -> Void
private(set) var TDKSFBrowserInvalidate: TDKSFBrowserInvalidateFunction!

typealias TDKSFBrowserGetRootNodeFunction = @convention(c) (_ browser: TDKSFBrowser) -> TDKSFNode
private(set) var TDKSFBrowserGetRootNode: TDKSFBrowserGetRootNodeFunction!

typealias TDKSFNodeCopyDisplayNameFunction = @convention(c) (_ node: TDKSFNode) -> CFString?
private(set) var TDKSFNodeCopyDisplayName: TDKSFNodeCopyDisplayNameFunction!

typealias TDKSFNodeCopyComputerNameFunction = @convention(c) (_ node: TDKSFNode) -> CFString?
private(set) var TDKSFNodeCopyComputerName: TDKSFNodeCopyComputerNameFunction!

typealias TDKSFNodeCopySecondaryNameFunction = @convention(c) (_ node: TDKSFNode) -> CFString?
private(set) var TDKSFNodeCopySecondaryName: TDKSFNodeCopySecondaryNameFunction!

typealias TDKSFNodeCopyIDSDeviceIdentifierFunction = @convention(c) (_ node: TDKSFNode) -> CFString?
private(set) var TDKSFNodeCopyIDSDeviceIdentifier: TDKSFNodeCopySecondaryNameFunction!

typealias TDKSFOperationCreateFunction = @convention(c) (_ alloc: CFAllocator?, _ kind: CFString, _: UnsafeMutableRawPointer?, _: UnsafeMutableRawPointer?) -> TDKSFOperation
private(set) var TDKSFOperationCreate: TDKSFOperationCreateFunction!

typealias TDKSFOperationCallbackFunction = @convention(c) (_ operation: TDKSFOperation, _ event: TDKSFOperationEvent.RawValue, _ results: AnyObject, _ context: UnsafeMutableRawPointer?) -> Void
typealias TDKSFOperationSetClientFunction = @convention(c) (_ operation: TDKSFOperation, _ callback: TDKSFOperationCallbackFunction, _ context: UnsafeMutableRawPointer/*<TDKSFOperationClientContext>*/) -> Void
private(set) var TDKSFOperationSetClient: TDKSFOperationSetClientFunction!

typealias TDKSFOperationSetDispatchQueueFunction = @convention(c) (_ operation: TDKSFOperation, _ queue: DispatchQueue) -> Void
private(set) var TDKSFOperationSetDispatchQueue: TDKSFOperationSetDispatchQueueFunction!

typealias TDKSFOperationCopyPropertyFunction = @convention(c) (_ operation: TDKSFOperation, _ name: CFString) -> AnyObject
private(set) var TDKSFOperationCopyProperty: TDKSFOperationCopyPropertyFunction!

typealias TDKSFOperationSetPropertyFunction = @convention(c) (_ operation: TDKSFOperation, _ name: CFString, _ value: AnyObject) -> Void
private(set) var TDKSFOperationSetProperty: TDKSFOperationSetPropertyFunction!

typealias TDKSFOperationResumeFunction = @convention(c) (_ operation: TDKSFOperation) -> Void
private(set) var TDKSFOperationResume: TDKSFOperationResumeFunction!

typealias TDKSFOperationCancelFunction = @convention(c) (_ operation: TDKSFOperation) -> Void
private(set) var TDKSFOperationCancel: TDKSFOperationCancelFunction!

var TDKIsInitialized = false
func TDKInitialize() {
    guard !TDKIsInitialized else { return }
    TDKIsInitialized = true

    let bundleURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, "/System/Library/PrivateFrameworks/Sharing.framework" as CFString, .cfurlposixPathStyle, false)
    let bundle = CFBundleCreate(kCFAllocatorDefault, bundleURL)
    assert(CFBundleLoadExecutable(bundle))

    let stringSymbolNames = ["kSFBrowserKindAirDrop", "kSFOperationKindSender", "kSFOperationFileIconKey", "kSFOperationItemsKey", "kSFOperationNodeKey"]
    var stringSymbolDestinations = Array<UnsafeMutableRawPointer?>(repeating: nil, count: stringSymbolNames.count)
    stringSymbolDestinations.withUnsafeMutableBufferPointer { bufferPointer in
        CFBundleGetDataPointersForNames(bundle, stringSymbolNames as CFArray, bufferPointer.baseAddress!)
    }

    func stringCast<T>(_ index: Int) -> T {
        return stringSymbolDestinations[index]!.assumingMemoryBound(to: T.self).pointee
    }

    kTDKSFBrowserKindAirDrop = stringCast(0)
    kTDKSFOperationKindSender = stringCast(1)
    kTDKSFOperationFileIconKey = stringCast(2)
    kTDKSFOperationItemsKey = stringCast(3)
    kTDKSFOperationNodeKey = stringCast(4)

    let functionSymbolNames = ["SFBrowserCreate", "SFBrowserSetClient", "SFBrowserSetDispatchQueue", "SFBrowserOpenNode", "SFBrowserCopyChildren", "SFBrowserInvalidate", "SFBrowserGetRootNode", "SFNodeCopyDisplayName", "SFNodeCopyComputerName", "SFNodeCopySecondaryName", "SFNodeCopyIDSDeviceIdentifier", "SFOperationCreate", "SFOperationSetClient", "SFOperationSetDispatchQueue", "SFOperationCopyProperty", "SFOperationSetProperty", "SFOperationResume", "SFOperationCancel"]

    var functionSymbolDestinations = Array<UnsafeMutableRawPointer?>(repeating: nil, count: functionSymbolNames.count)
    functionSymbolDestinations.withUnsafeMutableBufferPointer { bufferPointer in
        CFBundleGetFunctionPointersForNames(bundle, functionSymbolNames as CFArray, bufferPointer.baseAddress!)
    }

    func functionCast<T>(_ index: Int) -> T! {
        return unsafeBitCast(functionSymbolDestinations[index], to: T.self)
    }

    TDKSFBrowserCreate = functionCast(0)
    TDKSFBrowserSetClient = functionCast(1)
    TDKSFBrowserSetDispatchQueue = functionCast(2)
    TDKSFBrowserOpenNode = functionCast(3)
    TDKSFBrowserCopyChildren = functionCast(4)
    TDKSFBrowserInvalidate = functionCast(5)
    TDKSFBrowserGetRootNode = functionCast(6)
    TDKSFNodeCopyDisplayName = functionCast(7)
    TDKSFNodeCopyComputerName = functionCast(8)
    TDKSFNodeCopySecondaryName = functionCast(9)
    TDKSFNodeCopyIDSDeviceIdentifier = functionCast(10)
    TDKSFOperationCreate = functionCast(11)
    TDKSFOperationSetClient = functionCast(12)
    TDKSFOperationSetDispatchQueue = functionCast(13)
    TDKSFOperationCopyProperty = functionCast(14)
    TDKSFOperationSetProperty = functionCast(15)
    TDKSFOperationResume = functionCast(16)
    TDKSFOperationCancel = functionCast(17)
}

func browserCallbackFunction(browser: TDKSFBrowser, node: TDKSFNode, children: CFArray, _: UnsafeMutableRawPointer?, _: UnsafeMutableRawPointer?, context: UnsafeMutableRawPointer?) {
    guard let context = context else { return }
    let controller = Unmanaged.fromOpaque(context).takeUnretainedValue() as TrollController
    controller.handleBrowserCallback(browser: browser, node: node, children: children)
}

func operationCallback(operation: TDKSFOperation, rawEvent: TDKSFOperationEvent.RawValue, results: AnyObject, context: UnsafeMutableRawPointer?) {
    guard let event = TDKSFOperationEvent(rawValue: rawEvent) else { return }
    guard let context = context else { return }
    let controller = Unmanaged.fromOpaque(context).takeUnretainedValue() as TrollController
    controller.handleOperationCallback(operation: operation, event: event, results: results)
}

func dataProviderRelease(_: UnsafeMutableRawPointer?, _: UnsafeRawPointer, _: Int) -> Void {
}

public class TrollController {
    private enum Trolling {
        case operation(TDKSFOperation)
        case workItem(DispatchWorkItem)
        
        func cancel() {
            switch self {
            case .operation(let operation):
                TDKSFOperationCancel(operation)
            case .workItem(let workItem):
                workItem.cancel()
            }
        }
    }
    
    public class Person: Equatable {
        public static func == (lhs: TrollController.Person, rhs: TrollController.Person) -> Bool {
            lhs.node == rhs.node
        }
        
        var displayName: String?
        var node: TDKSFNode
        
        init(node: TDKSFNode) {
            self.displayName = TDKSFNodeCopyDisplayName(node) as? String ?? TDKSFNodeCopyComputerName(node) as? String ?? TDKSFNodeCopySecondaryName(node) as? String
            self.node = node
        }
    }
    
    /// The current browser
    private var browser: TDKSFBrowser?
    
    /// Currently known people
    public var people: [Person]
    
    /// A map between known people and a Trolling (a currently running operation or a delayed work item)
    private var trollings: Dictionary<TDKSFNode, Trolling>
    
    /// The duration to wait after trolling before trolling again.
    public var rechargeDuration: TimeInterval
    
    /// The local file URL with which to troll. Defaults to a troll face image.
    public var sharedURL: URL
    
    /// Whether the scanner is currently active.
    public var isRunning: Bool = false
    
    /// A block handler that allows for fine-grained control of whom to troll.
    public var shouldTrollHandler: (Person) -> Bool
    
    /// A handler to pass data about trolling back to UI
    private var eventHandler: ((TrollEvent) -> Void)?
    
    public enum TrollEvent {
        case cancelled
        case operationEvent(TDKSFOperationEvent)
    }
    
    public init(sharedURL: URL, rechargeDuration: TimeInterval) {
        TDKInitialize()
        people = []
        trollings = [:]
        self.rechargeDuration = rechargeDuration
        self.shouldTrollHandler = { _ in return true }
        self.sharedURL = sharedURL
    }
    
    deinit {
        stopBrowser()
    }
    
    /// Start the browser.
    public func startBrowser() {
        guard !isRunning else { return }
        
        var clientContext: TDKSFBrowserClientContext = (
            version: 0,
            info: Unmanaged.passUnretained(self).toOpaque(),
            retain: nil,
            release: nil,
            copyDescription: nil
        )
        
        let browser = TDKSFBrowserCreate(kCFAllocatorDefault, kTDKSFBrowserKindAirDrop)
        TDKSFBrowserSetClient(browser, browserCallbackFunction, &clientContext)
        TDKSFBrowserSetDispatchQueue(browser, .main)
        TDKSFBrowserOpenNode(browser, nil, nil, 0)
        self.browser = browser
    }
    
    /// Start trolling nodes
    public func startTrolling(shouldTrollHandler: @escaping (Person) -> Bool, eventHandler: @escaping (TrollEvent) -> Void) {
        self.eventHandler = eventHandler
        remLog("start")
        for person in people {
            if shouldTrollHandler(person) {
                troll(node: person.node)
            }
        }
    }
    
    /// Stop the browser and clean up browsing state.
    public func stopBrowser() {
        guard isRunning else { return }
        
        // Cancel pending operations.
        stopTrollings()
        
        // Invalidate the browser.
        TDKSFBrowserInvalidate(browser!)
        browser = nil
    }
    
    public func stopTrollings() {
        for trolling in trollings.values {
            trolling.cancel()
        }
        
        // Empty operations map.
        trollings.removeAll()
    }
    
    /// Troll the person/device identified by \c node (\c TDKSFNodeRef)
    func troll(node: TDKSFNode) {
        remLog("trolling \(node)")
        
        var fileIcon: CGImage?
        if let dataProvider = CGDataProvider(url: sharedURL as CFURL), let image = CGImage(jpegDataProviderSource: dataProvider, decode: nil, shouldInterpolate: false, intent: .defaultIntent) {
            fileIcon = image
        }
        
        var clientContext: TDKSFBrowserClientContext = (
            version: 0,
            info: Unmanaged.passUnretained(self).toOpaque(),
            retain: nil,
            release: nil,
            copyDescription: nil
        )
        
        // Create airdrop request
        let operation = TDKSFOperationCreate(kCFAllocatorDefault, kTDKSFOperationKindSender, nil, nil)
        TDKSFOperationSetClient(operation, operationCallback, &clientContext)
        TDKSFOperationSetProperty(operation, kTDKSFOperationItemsKey, [sharedURL] as AnyObject)
        if let fileIcon = fileIcon {
            TDKSFOperationSetProperty(operation, kTDKSFOperationFileIconKey, fileIcon)
        }
        TDKSFOperationSetProperty(operation, kTDKSFOperationNodeKey, Unmanaged.fromOpaque(UnsafeRawPointer(node)).takeUnretainedValue())
        TDKSFOperationSetDispatchQueue(operation, .main)
        TDKSFOperationResume(operation)
        
        // Add airdrop request to trollings to allow its cancellation later
        trollings[node] = .operation(operation)
    }
    
    func handleBrowserCallback(browser: TDKSFBrowser, node: TDKSFNode, children: CFArray) {
        let nodes = TDKSFBrowserCopyChildren(browser, nil) as [AnyObject]
        var currentNodes = Set<TDKSFNode>(minimumCapacity: nodes.count)
        
        for nodeObject in nodes {
            let node = OpaquePointer(Unmanaged.passUnretained(nodeObject).toOpaque())
            currentNodes.insert(node)
        }
        
        // If we no longer know about a person, cancel their trolling.
        for oldID in Set(self.people.map { $0.node }).subtracting(currentNodes) {
            if let trolling = trollings.removeValue(forKey: oldID) {
                trolling.cancel()
            }
        }
        
        self.people = currentNodes.map { .init(node: $0 )}
    }
    
    func handleOperationCallback(operation: TDKSFOperation, event: TDKSFOperationEvent, results: CFTypeRef) {
        eventHandler?(.operationEvent(event))
        remLog(event)
        switch event {
        case .askUser:
            // Seems that .askUser requires the operation to be resumed.
            TDKSFOperationResume(operation)
            
        case .waitForAnswer:
            // user started received data from attacker
            let nodeObject = TDKSFOperationCopyProperty(operation, kTDKSFOperationNodeKey)
            let node = OpaquePointer(Unmanaged.passUnretained(nodeObject).toOpaque())
            
            let workItem = DispatchWorkItem { [weak self] in
                self?.eventHandler?(.cancelled)
                self?.trollings[node]?.cancel() // cancelation of airdrop request
                
                if self?.isRunning ?? false { // dumb fix of a bug
                    self?.troll(node: node) // troll again :troll:
                }
            }
            // wait for airdrop to appear on target device. afaik there isn't a way to know when the alert appeared.
            DispatchQueue.main.asyncAfter(deadline: .now() + rechargeDuration, execute: workItem) // rechargeDuration is controlled via UI
        default:
            break
        }
    }
}
