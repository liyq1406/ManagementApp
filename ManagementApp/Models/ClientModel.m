//
//  ClientModel.m
//  ManagementApp
//
//  Created by ydd on 15/10/15.
//  Copyright © 2015年 suda_505. All rights reserved.
//

#import "ClientModel.h"

@implementation ClientModel


+ (NSDictionary*)mts_mapping {
    return  @{@"clientId": mts_key(clientId),
              @"clientType": mts_key(clientType),
              @"clientLevel": mts_key(clientLevel),
              
              @"clientName": mts_key(clientName),
              @"clientPhone": mts_key(clientPhone),
              @"clientEmail": mts_key(clientEmail),
              @"clientRemark": mts_key(clientRemark),
              
              @"isPrivate": mts_key(isPrivate),
              @"totalPrice": mts_key(totalPrice)
              
              };
}


+ (BOOL)mts_shouldSetUndefinedKeys {
    return NO;
}

@end
