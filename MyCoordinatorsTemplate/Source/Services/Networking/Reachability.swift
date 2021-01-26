//
//  Reachability.swift
//  weather-codesample
//
//  Created by Danyl Timofeyev on 02.11.2020.
//

import SystemConfiguration
import RxSwift
import RxCocoa

enum ReachabilityStatus {
    case offline
    case online
    case unknown
    
    init(reachabilityFlags flags: SCNetworkReachabilityFlags) {
        let connectionRequired = flags.contains(.connectionRequired)
        let isReachable = flags.contains(.reachable)
        self = (!connectionRequired && isReachable) ? .online : .offline
    }
}

protocol ReachabilityType {
    var status: BehaviorRelay<ReachabilityStatus> { get }
}

final class Reachability: ReachabilityType {
    
    var status = BehaviorRelay<ReachabilityStatus>(value: .online)
    
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
    
    private func startMonitor(_ host: String) {
        var context = SCNetworkReachabilityContext(version: 0,
                                                   info: nil,
                                                   retain: nil,
                                                   release: nil,
                                                   copyDescription: nil)
        
        guard let reachability = SCNetworkReachabilityCreateWithName(nil, host) else { return }
        SCNetworkReachabilitySetCallback(reachability, { (_, flags, _) in
            let status = ReachabilityStatus(reachabilityFlags: flags)
            /// static due to unable of self capturing
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
    
    static private var _status = BehaviorRelay<ReachabilityStatus>(value: .unknown)
    private var reachability: SCNetworkReachability?
    private let bag = DisposeBag()
}
