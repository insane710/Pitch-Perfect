//
//  ipaddress.c
//  Pitch Perfect
//
//  Created by Dheeraj Gembali on 16/12/14.
//  Copyright (c) 2014 Insanity. All rights reserved.
//

#include <stdio.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <ifaddrs.h>
#include <string.h>

char * ipAddressForInterface(char *ifName) {
    if (ifName == NULL) {
        return("Interface name cannot be nil");
    }
    
    
    struct ifaddrs *addrs = NULL;
    if (getifaddrs(&addrs)) {
        return("Failed to enumerate interfaces");
    }
    
    char *addr = NULL;
    struct ifaddrs *curAddr = addrs;
    while (curAddr != NULL) {
        if (AF_INET == curAddr->ifa_addr->sa_family) {
            char *curIfName = curAddr->ifa_name;
            
            if (strcmp(ifName, curIfName) == 0) {
                char* cstring = inet_ntoa(((struct sockaddr_in *)curAddr->ifa_addr)->sin_addr);
                addr = cstring;
                break;
            }
        }
        curAddr = curAddr->ifa_next;
    }
    return addr;
}