//
//  Reachability.swift
//  weather-codesample
//
//  Created by Danyl Timofeyev on 02.11.2020.
//

import SystemConfiguration
import RxSwift
import RxCocoa

final class Reachability {
    
    enum Status {
        case offline
        case online
        case unknown
        
        init(reachabilityFlags flags: SCNetworkReachabilityFlags) {
            let connectionRequired = flags.contains(.connectionRequired)
            let isReachable = flags.contains(.reachable)
            self = (!connectionRequired && isReachable) ? .online : .offline
        }
    }
    
    public var status = BehaviorRelay<Status>(value: .online)
    
    init() {
        Reachability._status
            .skip(1)
            .bind(to: status)
            .disposed(by: bag)
        
        startMonitor("google.com")
    }
    
    deinit {
        stopMonitor()
    }
    
    func startMonitor(_ host: String) {
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        if let reachability = SCNetworkReachabilityCreateWithName(nil, host) {
            SCNetworkReachabilitySetCallback(reachability, { (_, flags, _) in
                let status = Status(reachabilityFlags: flags)
                /// unable to capture self here
                Reachability._status.accept(status)
            }, &context)
            
            SCNetworkReachabilityScheduleWithRunLoop(reachability, CFRunLoopGetMain(), CFRunLoopMode.commonModes.rawValue)
            self.reachability = reachability
        }
    }
    
    func stopMonitor() {
        if let _reachability = reachability {
            SCNetworkReachabilityUnscheduleFromRunLoop(_reachability, CFRunLoopGetMain(), CFRunLoopMode.commonModes.rawValue);
            reachability = nil
        }
    }
    
    static private var _status = BehaviorRelay<Status>(value: .unknown)
    private var reachability: SCNetworkReachability?
    private let bag = DisposeBag()
}
