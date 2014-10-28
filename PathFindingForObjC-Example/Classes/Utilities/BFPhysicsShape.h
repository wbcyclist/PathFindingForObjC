//
//  BFPhysicsShape.h
//  BalloonFight
//
//  Created by JasioWoo on 14/10/18.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BFPhysicsShape : NSObject

+ (instancetype)sharedInstance;

- (SKTexture *)getPhysicsShapeTXAtIndex:(int)index;
- (SKPhysicsBody *)getPhysicsBodyAtIndex:(int)index;


@end
