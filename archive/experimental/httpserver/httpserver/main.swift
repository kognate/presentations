//
//  main.swift
//  httpserver
//
//  Created by Josh Smith on 8/27/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation

func accept_connection(socketfd: Int32) {
    let buffer = UnsafeMutablePointer<Void>.alloc(sizeof(Character)*255)
    read(socketfd, buffer, 255)
    let data = NSData(bytes: buffer, length: 255)
    if let strdata = NSString(data: data, encoding: NSUTF8StringEncoding) {
        let parts = strdata.componentsSeparatedByString(" ")
        let filepath = parts[1]
        let action = parts[0]

        switch action {
            case "GET":
                do {
                    let fdata = try String(contentsOfFile: "/tmp\(filepath)", encoding: NSUTF8StringEncoding)
                    fdata.withCString { cstr in
                       write(socketfd, UnsafePointer(cstr), fdata.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
                    }
                } catch {
                    
            }
            default:
                write(socketfd, buffer, 255)
        }
    }
    free(buffer)
    close(socketfd)
    sleep(100)
    exit(0)
}

func server() {
    let sockfd = socket(AF_INET, SOCK_STREAM, 0)
    
    if (sockfd < 0) {
        perror("Error opening Socket")
    } else {
        let server_address: UnsafeMutablePointer<sockaddr_in> = UnsafeMutablePointer<sockaddr_in>(malloc(sizeof(sockaddr_in)))
        memset(server_address, 0, sizeof(sockaddr_in))
        
        server_address.memory.sin_family = sa_family_t(AF_INET)
        server_address.memory.sin_port = UInt16(8883).byteSwapped
        server_address.memory.sin_addr.s_addr = UInt32(0).byteSwapped
        
        let saddr = UnsafeMutablePointer<sockaddr>(server_address)
        
        let client_address: UnsafeMutablePointer<sockaddr_in> = UnsafeMutablePointer<sockaddr_in>(malloc(sizeof(sockaddr_in)))
        memset(client_address, 0, sizeof(sockaddr_in))
        let caddr = UnsafeMutablePointer<sockaddr>(client_address)
        let client_socklen: UnsafeMutablePointer<socklen_t> = UnsafeMutablePointer<socklen_t>(malloc(sizeof(sockaddr_in)))
        
        if (bind(sockfd, saddr, socklen_t(sizeof(sockaddr_in))) >= 0) {
            let lres = listen(sockfd, 5)
            print("Listing: %d",lres)
            let current_socklen: UnsafeMutablePointer<socklen_t> = UnsafeMutablePointer<socklen_t>(malloc(sizeof(sockaddr_in)))
            let res = getsockname(sockfd, saddr, current_socklen)
            print("well",res)

            print(server_address.memory.sin_port.byteSwapped)
            
            while (true) {
                let newsocket = accept(sockfd, caddr, client_socklen)

                let pid = UnsafeMutablePointer<pid_t>.alloc(sizeof(pid_t))
                
                let spawn_result = posix_spawn(pid, nil, nil, nil, nil, nil)
                if spawn_result == 0 && pid.memory != 0 {
                    accept_connection(newsocket)
                }
            }
        }
    }
}

print("Hello, World!")
server()
print("Hello, World!")