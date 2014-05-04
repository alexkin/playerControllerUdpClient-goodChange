//
//  dateDelegate.h
//  playerControllerUdpClient
//
//  Created by stone on 14-4-18.
//  Copyright (c) 2014年 stone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dateDelegate : NSObject{
    NSString *textIp;
    NSString *textPort;
}

@property(nonatomic,strong)NSString *textIp;
@property(nonatomic,strong)NSString *textPort;

@end
