//
//  DDSSample.swift
//  Test-DDS-iOS-NoRoute2Host
//
//  Created by Yaoyu Hu on 12/21/23.
//

import Foundation
import FastRTPSBridge

// https://stackoverflow.com/questions/30748480/swift-get-devices-wifi-ip-address
enum NetworkInterface: String {
    case wifi = "en0"
    case cellular = "pdp_ip0"
    //... case ipv4 = "ipv4"
    //... case ipv6 = "ipv6"
}

func getInterfaceIP(for networkInterface: NetworkInterface) -> String? {
    var address: String?

    // Get list of all interfaces on the local machine:
    var ifaddr: UnsafeMutablePointer<ifaddrs>?
    guard getifaddrs(&ifaddr) == 0 else { return nil }
    guard let firstAddr = ifaddr else { return nil }

    // For each interface ...
    for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
        let interface = ifptr.pointee

        // Check for IPv4 or IPv6 interface:
        let addrFamily = interface.ifa_addr.pointee.sa_family
        if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

            // Check interface name:
            let name = String(cString: interface.ifa_name)
            if name == networkInterface.rawValue {

                // Convert interface address to a human readable string:
                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                            &hostname, socklen_t(hostname.count),
                            nil, socklen_t(0), NI_NUMERICHOST)
                address = String(cString: hostname)
            }
        }
    }
    freeifaddrs(ifaddr)

    return address
}

class DDSSample {
    var context: FastRTPSBridge
    
    init(name: String, domainID: UInt32) {
        
        let ipAddress: String = getInterfaceIP(for: .wifi )!
        print("IP is \(ipAddress)")
        
        self.context = FastRTPSBridge()
        self.context.setlogLevel(.info)
        self.context.setPartition(name: "")
        
        do {
            try self.context.createParticipant(
                name: name,
                domainID: domainID,
                localAddress: ipAddress )
        } catch {
            print("\(name) failed with unexpected error.")
        }
    }
}
