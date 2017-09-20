//
//  FotonKeyChain.m
//  BRB
//
//  Created by BASA MyPhone on 03/10/16.
//
//

#import "FotonKeyChain.h"

@implementation FotonKeyChain

@synthesize command;

- (void)armazenar:(CDVInvokedUrlCommand*)command
{
    NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
    NSString* chave = [command argumentAtIndex:0];
    NSString* dado = [command argumentAtIndex:1];

    
    keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassKey; // We specify what kind of keychain item this is.
    keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlocked; // This item can only be accessed when the user unlocks the device.
    keychainItem[(__bridge id)kSecAttrApplicationTag] = chave;
    
    
    self.command = command;
    
    if(SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, NULL) == noErr)
    {
        
        NSMutableDictionary *attributesToUpdate = [NSMutableDictionary dictionary];
        attributesToUpdate[(__bridge id)kSecValueData] = [dado dataUsingEncoding:NSUTF8StringEncoding];
        
        OSStatus sts = SecItemUpdate((__bridge CFDictionaryRef)keychainItem, (__bridge CFDictionaryRef)attributesToUpdate);

        if (sts == noErr)
        {
            [self success];
        }
        else
        {
            [self error:@"Ocorreu um erro na tentativa de salvar a informacao"];
        }
    }
    else
    {
        keychainItem[(__bridge id)kSecValueData] = [dado dataUsingEncoding:NSUTF8StringEncoding];
        
        OSStatus sts = SecItemAdd((__bridge CFDictionaryRef)keychainItem, NULL);
        if (sts == noErr)
        {
            [self success];
        }
        else
        {
            [self error:@"Ocorreu um erro na tentativa de salvar a informacao"];
        }
    }
}

- (void)recuperar:(CDVInvokedUrlCommand*)command
{
    self.command = command;
    
    NSString* chave = [command argumentAtIndex:0];
    
    //Let's create an empty mutable dictionary:
    NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
    
    //Populate it with the data and the attributes we want to use.
    
    keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassKey; // We specify what kind of keychain item this is.
    keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlocked; // This item can only be accessed when the user unlocks the device.
    keychainItem[(__bridge id)kSecAttrApplicationTag] = chave;
    
    //Check if this keychain item already exists.
    
    keychainItem[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanTrue;
    keychainItem[(__bridge id)kSecReturnAttributes] = (__bridge id)kCFBooleanTrue;
    
    CFDictionaryRef resultado = nil;
    
    OSStatus sts = SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, (CFTypeRef *)&resultado);
    
    NSLog(@"Error Code: %d", (int)sts);
    
    if(sts == noErr)
    {
        NSDictionary *resultadoDict = (__bridge_transfer NSDictionary *)resultado;
        NSData *informacaoCript = resultadoDict[(__bridge id)kSecValueData];
        NSString *informacao = [[NSString alloc] initWithData:informacaoCript encoding:NSUTF8StringEncoding];
        
        [self sucessoComObjeto:informacao];
        
    }else
    {
        [self error:@"Nao existe dado para essa chave"];
    }
}

- (void)success
{
    NSString* resultMsg = @"informação armazenada com sucesso";
    NSLog(@"%@",resultMsg);
    
    // create acordova result
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                messageAsString:[resultMsg stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    // send cordova result
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)sucessoComObjeto:resposta
{
    
    // create acordova result
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                            messageAsDictionary:resposta];
    
    // send cordova result
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)error:(NSString*)message
{
    NSString* resultMsg = [NSString stringWithFormat:@"FotonKeyChain: (%@).", message];
    NSLog(@"%@",resultMsg);
    
    // create cordova result
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                messageAsString:[resultMsg stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    // send cordova result
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    
}


@end
