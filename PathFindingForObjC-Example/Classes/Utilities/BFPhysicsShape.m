//
//  BFPhysicsShape.m
//  BalloonFight
//
//  Created by JasioWoo on 14/10/18.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import "BFPhysicsShape.h"
#import "WBGameUtilities.h"

#define kPhysicsShapeFrames 2

@interface BFPhysicsShape ()

@property (nonatomic, strong) NSArray *physicsShapeFrames;

@end


@implementation BFPhysicsShape

+ (BFPhysicsShape *)sharedInstance {
	static BFPhysicsShape *sharedInstanceObj = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		if (sharedInstanceObj == nil)
			sharedInstanceObj = [[self alloc] init];
	});
	
	return sharedInstanceObj;
}

- (id)init {
	if ((self = [super init])) {
		// init something
		(void)self.physicsShapeFrames;
		
	}
	return self;
}


- (NSArray *)physicsShapeFrames {
	if (!_physicsShapeFrames) {
		_physicsShapeFrames = WB_LoadFramesFromAtlas(@"PhysicsTX", @"shape", kPhysicsShapeFrames);
	}
	return _physicsShapeFrames;
}



- (SKPhysicsBody *)getPhysicsBodyAtIndex:(int)index {
	SKTexture *texture = [self getPhysicsShapeTXAtIndex:index];
	return [SKPhysicsBody bodyWithTexture:texture size:texture.size];
}

- (SKTexture *)getPhysicsShapeTXAtIndex:(int)index {
	SKTexture *texture = self.physicsShapeFrames[index];
	return texture;
}


























@end
