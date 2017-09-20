//
//  FotonKeyChain.h
//  BRB
//
//  Created by BASA MyPhone on 03/10/16.
//
//

#import <Cordova/CDV.h>

@interface FotonKeyChain : CDVPlugin

- (void) armazenar:(CDVInvokedUrlCommand*)command;
- (void) recuperar:(CDVInvokedUrlCommand*)command;

// retain command for async repsonses
@property (nonatomic, strong) CDVInvokedUrlCommand* command;

@end
