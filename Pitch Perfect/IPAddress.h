//
//  IPAddress.h
//  Pitch Perfect
//
//  Created by Dheeraj Gembali on 16/12/14.
//  Copyright (c) 2014 Insanity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPAddress : NSObject

+ (NSString *)ipAddressForInterface:(NSString *)ifName;

@end
