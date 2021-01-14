//
//  Reachability.swift
//  weather-codesample
//
//  Created by Danyl Timofeyev on 02.11.2020.
//

import SystemConfiguration
import RxSwift
import RxCocoa

extension Reachability {
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
}


final class Reachability {
    /// static private due to unable capturing self here
    static private var _status = BehaviorRelay<Status>(value: .unknown)
    private var reachability: SCNetworkReachability?
    private let bag = DisposeBag()

    /// API
    public var status = BehaviorRelay<Status>(value: .online)
    
    init() {
        Reachability._status
            .skip(1)
            .bind(to: status)
            .disposed(by: bag)
        
        startMonitor("google.com")
    }
    /// 

    deinit {
        stopMonitor()
    }
    
    /// Internal
    private func startMonitor(_ host: String) {
        var context = SCNetworkReachabilityContext(version: 0,
                                                   info: nil,
                                                   retain: nil,
                                                   release: nil,
                                                   copyDescription: nil)
        
        guard let reachability = SCNetworkReachabilityCreateWithName(nil, host) else { return }
        SCNetworkReachabilitySetCallback(reachability, { (_, flags, _) in
            let status = Status(reachabilityFlags: flags)
            /// static due to unable capturing self
            Reachability._status.accept(status)
        }, &context)
        SCNetworkReachabilityScheduleWithRunLoop(reachability,
                                                 CFRunLoopGetMain(),
                                                 CFRunLoopMode.commonModes.rawValue)
        self.reachability = reachability
    }
    
    private func stopMonitor() {
        if let reachability = self.reachability {
            SCNetworkReachabilityUnscheduleFromRunLoop(reachability,
                                                       CFRunLoopGetMain(),
                                                       CFRunLoopMode.commonModes.rawValue)
            self.reachability = nil
        }
    }
}
