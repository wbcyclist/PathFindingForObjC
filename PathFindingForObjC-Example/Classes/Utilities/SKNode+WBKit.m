//
//  SKNode+WBKit.m
//  BalloonFight
//
//  Created by JasioWoo on 14/10/15.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import "SKNode+WBKit.h"

@implementation SKNode (WBKit)

- (void)runAction:(SKAction *)action withKey:(NSString *)key completion:(dispatch_block_t)block {
	SKAction *completionAct = [SKAction runBlock:block];
	[self runAction:[SKAction sequence:@[action, completionAct]] withKey:key];
}

@end
