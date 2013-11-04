//
//  SecretMessage.m
//  CincyCocoaHeadsTransient
//
//  Created by Josh Smith on 8/16/13.
//  Copyright (c) 2013 Josh Smith. All rights reserved.
//

#import "SecretMessage.h"
#import "KeychainItemWrapper.h"
#import <CommonCrypto/CommonCrypto.h>

NSString* kSecretEncryptionKey = @"SECRETKEYFORENCRYPTINGTHEPASSWRD";

NSData* encryptString(NSString* plaintext, NSData* key, NSData* iv)
{
	NSData* result = nil;
    
	NSData* plaintextData = [plaintext dataUsingEncoding: NSUTF8StringEncoding];
    
	size_t bufferSize = [plaintextData length] + [key length];
    
	void *buffer = calloc(bufferSize, sizeof(uint8_t));
	if (buffer != nil)
	{
		size_t dataOutMoved;
        
		CCCryptorStatus cryptStatus = CCCrypt(
                                              kCCEncrypt,
                                              kCCAlgorithmAES128,
                                              kCCOptionPKCS7Padding,
                                              [key bytes],
                                                ,
                                              [iv bytes],
                                              [plaintextData bytes],
                                              [plaintextData length],
                                              buffer,
                                              bufferSize,
                                              &dataOutMoved
                                              );
        
		if (cryptStatus == kCCSuccess) {
			result = [NSData dataWithBytesNoCopy: buffer length: dataOutMoved freeWhenDone: YES];
		} else {
			free(buffer);
		}
	}
    
	return result;
}

NSString* decryptString(NSData* ciphertext, NSData* key, NSData* iv)
{
	NSString* result = nil;
    
	size_t bufferSize = [ciphertext length];
    
	void *buffer = calloc(bufferSize, sizeof(uint8_t));
	if (buffer != nil)
	{
		size_t dataOutMoved = 0;
        
		CCCryptorStatus cryptStatus = CCCrypt(
                                              kCCDecrypt,
                                              kCCAlgorithmAES128,
                                              kCCOptionPKCS7Padding,
                                              [key bytes],
                                              kCCKeySizeAES256,
                                              [iv bytes],
                                              [ciphertext bytes],
                                              [ciphertext length],
                                              buffer,
                                              bufferSize,
                                              &dataOutMoved
                                              );
        
		if (cryptStatus == kCCSuccess) {
			result = [[NSString alloc] initWithBytesNoCopy: buffer length: dataOutMoved encoding: NSUTF8StringEncoding freeWhenDone: YES];
		} else {
			free(buffer);
		}
	}
    
	return result;
}

@implementation SecretMessage

@dynamic messageEncrypted;
@dynamic message;




- (NSString *) decryptMessage {
    KeychainItemWrapper *w = [[KeychainItemWrapper alloc] initWithIdentifier:@"com.cincy.app" accessGroup:nil];
    kSecretEncryptionKey = [w objectForKey:(id)CFBridgingRelease(kSecValueData)];
    return decryptString(self.messageEncrypted, [NSData dataWithBytes:[kSecretEncryptionKey cStringUsingEncoding:NSASCIIStringEncoding] length:[kSecretEncryptionKey length]], nil);
}

- (NSData *) encryptMessage:(NSString *) message {
    KeychainItemWrapper *w = [[KeychainItemWrapper alloc] initWithIdentifier:@"com.cincy.app" accessGroup:nil];
    kSecretEncryptionKey = [w objectForKey:(id)CFBridgingRelease(kSecValueData)];
    self.messageEncrypted = encryptString(message, [NSData dataWithBytes:[kSecretEncryptionKey cStringUsingEncoding:NSASCIIStringEncoding] length:[kSecretEncryptionKey length]], nil);
    return self.messageEncrypted;
}

- (NSString *) message {
    return [self decryptMessage];
}

- (void) setMessage:(NSString *)message {
    self.messageEncrypted = [self encryptMessage:message];
}


@end
