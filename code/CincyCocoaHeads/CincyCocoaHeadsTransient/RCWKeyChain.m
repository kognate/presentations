//
//  RCWKeyChain.m
//  CincyCocoaHeadsTransient
//
//  Created by Josh Smith on 11/1/13.
//  Copyright (c) 2013 Josh Smith. All rights reserved.
//

#import "RCWKeyChain.h"

@interface RCWKeyChain ()
@property (strong, nonatomic) NSString *private_key;

@end

@implementation RCWKeyChain

- (id) initWithKey:(NSString *)key {
    self.private_key = key;
    if (self = [self init]) {
        NSDictionary *findquery = @{
                                    (id)CFBridgingRelease(kSecClass): (id)CFBridgingRelease (kSecClassGenericPassword),
                                    (id)CFBridgingRelease(kSecAttrService): @"my-unique-service-name",
                                    (id)CFBridgingRelease(kSecAttrAccount): key,
                                    (id)CFBridgingRelease(kSecReturnData): @YES };
    
        CFTypeRef data;
        OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)findquery, &data);
    
        if (status == errSecSuccess)
        {
            NSKeyedUnarchiver *unarchive = [[NSKeyedUnarchiver alloc] initForReadingWithData:(NSData *)CFBridgingRelease(data)];
            self = [unarchive decodeObjectForKey:@"result"];
        }
    }
    return self;
}

- (void) save {
    
    NSMutableData *secret = [[NSMutableData alloc] init];
    NSKeyedArchiver *arch = [[NSKeyedArchiver alloc] initForWritingWithMutableData:secret];
    [arch encodeObject:self forKey:@"result"];
    [arch finishEncoding];
    
    NSDictionary* addquery = @{
                               (id)CFBridgingRelease(kSecClass): (id)CFBridgingRelease(kSecClassGenericPassword),
                               (id)CFBridgingRelease(kSecAttrService): @"my-unique-service-name",
                               (id)CFBridgingRelease(kSecAttrAccount): self.private_key,
                               (id)CFBridgingRelease(kSecValueData): secret,
                               };
    
    NSDictionary *updateQuery = @ {
        (id)CFBridgingRelease(kSecValueData): secret,
    };
    
    NSDictionary *findquery = @{
                                (id)CFBridgingRelease(kSecClass): (id)CFBridgingRelease(kSecClassGenericPassword),
                                (id)CFBridgingRelease(kSecAttrService): @"my-unique-service-name",
                                (id)CFBridgingRelease(kSecAttrAccount): self.private_key,
                                (id)CFBridgingRelease(kSecReturnData): @YES };
    
    CFTypeRef data;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)findquery, &data);
    
    if (status == errSecItemNotFound) {
        status = SecItemAdd((__bridge CFDictionaryRef)addquery, NULL);
    }
    else
    {
        status = SecItemUpdate((__bridge CFDictionaryRef)addquery, (__bridge CFDictionaryRef)updateQuery);
    }
    
    NSAssert( status == noErr, @"Couldn't update the Keychain Item." );
}

- (void) remove {
    NSDictionary *findquery = @{
                                (id)CFBridgingRelease(kSecClass): (id)CFBridgingRelease(kSecClassGenericPassword),
                                (id)CFBridgingRelease(kSecAttrService): @"my-unique-service-name",
                                (id)CFBridgingRelease(kSecAttrAccount): self.private_key,
                                (id)CFBridgingRelease(kSecReturnData): @YES };
    
    CFTypeRef data;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)findquery, &data);
    
    if (status == errSecSuccess)
    {
        OSStatus junk = noErr;
        NSDictionary* removequery = @{
                                      (id)CFBridgingRelease(kSecClass): (id)CFBridgingRelease(kSecClassGenericPassword),
                                      (id)CFBridgingRelease(kSecAttrService): @"my-unique-service-name",
                                      (id)CFBridgingRelease(kSecAttrAccount): self.private_key };
        
        junk = SecItemDelete((__bridge CFDictionaryRef)removequery);
        NSAssert( junk == noErr || junk == errSecItemNotFound, @"Problem deleting current dictionary." );
    }
}

- (void) encodeWithCoder:(NSCoder *)aCoder { }
- (id) initWithCoder:(NSCoder *)aDecoder { return self; }
@end
