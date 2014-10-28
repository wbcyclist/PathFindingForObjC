//
//  GameScene.m
//  PathFindingForObjC-Example
//
//  Created by JasioWoo on 14/10/28.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

- (instancetype)initWithSize:(CGSize)size {
	NSLog(@"GameScene initWithSize = %@", NSStringFromCGSize(size));
	self = [super initWithSize:size];
	if (self) {
//		self.backgroundColor = [SKColor blackColor];
		
	}
	return self;
}


-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    myLabel.text = @"Hello, World!";
    myLabel.fontSize = 65;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    
    [self addChild:myLabel];
}

#if TARGET_OS_IPHONE
#pragma mark - Event Handling - iOS
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//	for (UITouch *touch in touches) {
//		CGPoint location = [touch locationInNode:self.worldNode];
//		self.targetLocation = CGPointMake((int)location.x, (int)location.y);
//	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//	for (UITouch *touch in touches) {
//		CGPoint location = [touch locationInNode:self.worldNode];
//		self.targetLocation = CGPointMake((int)location.x, (int)location.y);
//	}
}
#else

#pragma mark - Event Handling - OS X
-(void)mouseDown:(NSEvent *)theEvent {
//	CGPoint location = [theEvent locationInNode:self.worldNode];
//	self.targetLocation = CGPointMake((int)location.x, (int)location.y);
}
#endif


#pragma mark - Game update loop
-(void)update:(NSTimeInterval)currentTime {
    /* Called before each frame is rendered */
}











@end
