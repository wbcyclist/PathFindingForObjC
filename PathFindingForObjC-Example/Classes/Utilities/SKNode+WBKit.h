//
//  SKNode+WBKit.h
//  BalloonFight
//
//  Created by JasioWoo on 14/10/15.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKNode (WBKit)

- (void)runAction:(SKAction *)action withKey:(NSString *)key completion:(dispatch_block_t)block;

@end
