//
//  IPAddress.m
//  Pitch Perfect
//
//  Created by Dheeraj Gembali on 16/12/14.
//  Copyright (c) 2014 Insanity. All rights reserved.
//

#import "IPAddress.h"
#include <sys/socket.h>
#include <arpa/inet.h>
#include <ifaddrs.h>

@implementation IPAddress

+ (NSString *)ipAddressForInterface:(NSString *)ifName {
    NSAssert(nil != ifName, @"Interface name cannot be nil");
    
    struct ifaddrs *addrs = NULL;
    if (getifaddrs(&addrs)) {
        NSLog(@"Failed to enumerate interfaces: %@", [NSString stringWithCString:strerror(errno) encoding:NSUTF8StringEncoding]);
        return nil;
    }
    
    /* walk the linked-list of interfaces until we find the desired one */
    NSString *addr = nil;
    struct ifaddrs *curAddr = addrs;
    while (curAddr != NULL) {
        if (AF_INET == curAddr->ifa_addr->sa_family) {
            NSString *curName = [NSString stringWithCString:curAddr->ifa_name encoding:NSUTF8StringEncoding];
            if ([ifName isEqualToString:curName]) {
                char* cstring = inet_ntoa(((struct sockaddr_in *)curAddr->ifa_addr)->sin_addr);
                addr = [NSString stringWithCString:cstring encoding:NSUTF8StringEncoding];
                break;
            }
        }
        curAddr = curAddr->ifa_next;
    }
    
    /* clean up, return what we found */
    freeifaddrs(addrs);
    return addr;
}

@end
