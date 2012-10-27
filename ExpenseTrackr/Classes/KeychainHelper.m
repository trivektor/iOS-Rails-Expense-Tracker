//
//  KeychainHelper.m
//  ExpenseTrackr
//
//  Created by Tri Vuong on 10/27/12.
//  Copyright (c) 2012 Crafted By Tri. All rights reserved.
//

#import "KeychainHelper.h"
#import "KeychainItemWrapper.h"
#import "AppConfig.h"

@implementation KeychainHelper

+ (NSString *)getAuthenticationToken
{
    NSString *keychainName = [AppConfig getConfigValue:@"KeychainName"];
    
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:keychainName accessGroup:nil];
    
    return [keychain objectForKey:(__bridge id)kSecValueData];
}

+ (void)setAuthenticationToken:(NSString *)authToken
{
    NSString *keychainName = [AppConfig getConfigValue:@"KeychainName"];
    
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:keychainName accessGroup:nil];
    
    [keychain setObject:authToken forKey:(__bridge id)(kSecValueData)];
}

@end
