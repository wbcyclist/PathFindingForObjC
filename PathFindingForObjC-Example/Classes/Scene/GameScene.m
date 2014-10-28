//
//  GameScene.m
//  PathFindingForObjC-Example
//
//  Created by JasioWoo on 14/10/28.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import "GameScene.h"
#import "PathFinding.h"
#import "PFGridNode.h"


@implementation GameScene {
	BOOL isContentCreated;
	SKNode *gridLayer;
	
}

- (instancetype)initWithSize:(CGSize)size {
	NSLog(@"GameScene initWithSize = %@", NSStringFromCGSize(size));
	self = [super initWithSize:size];
	if (self) {
		self.backgroundColor = [SKColor whiteColor];
		
	}
	return self;
}


-(void)didMoveToView:(SKView *)view {
	
	if (!isContentCreated) {
		isContentCreated = YES;
//		gridLayer = [SKSpriteNode spriteNodeWithColor:[SKColor purpleColor] size:CGSizeMake(400, 400)];
		gridLayer = [SKNode node];
//		gridLayer.position = CGPointMake(10, 10);
		[self addChild:gridLayer];
		[self createGridNodes];
		
		
	}
//	PathFinding *pathFinding = [[PathFinding alloc] initWithMap:CGSizeMake(8, 6)
//													   tileSize:CGSizeMake(32, 32)
//											  systemCoordsOrgin:CGPointMake(0, 560)];
//	pathFinding.heuristicType = HeuristicTypeManhattan;
//	pathFinding.allowDiagonal = NO;
//	pathFinding.dontCrossCorners = YES;
//	NSArray *path = [pathFinding findPathing:PathfindingAlgorithm_AStar];
	
}

- (void)createGridNodes {
	CGSize gridSize = CGSizeMake(64, 64);
	int column = CGRectGetWidth(self.frame)/gridSize.width;
	int row = CGRectGetHeight(self.frame)/gridSize.height;

	for (int i=0; i<row; i++) {
		for (int j=0; j<column; j++) {
			PFGridNode *grid = [PFGridNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"grid"] size:gridSize];
			grid.anchorPoint = CGPointZero;
			grid.colorBlendFactor = 0.7;
			grid.position = CGPointMake(j*gridSize.width, i*gridSize.height);
			grid.x = j;
			grid.y = i;
			grid.name = [NSString stringWithFormat:@"%d",i+j];
			grid.showWeightValue = YES;
			if (i+j==0) {
				grid.isStart = YES;
			} else if (i+j==1) {
				grid.isEnd = YES;
			}
			
			[gridLayer addChild:grid];
			
			// SKShapeNode Class it looks awful (1 instance 2 node 2 draws)
//			CGRect gridRect = (CGRect){0,0, .size=gridSize};
//			SKShapeNode *grid = [SKShapeNode shapeNodeWithRect:gridRect];
//			grid.fillColor = [SKColor lightGrayColor];
//			grid.strokeColor = [SKColor blackColor];
//			grid.position = CGPointMake(j*gridSize.width, i*gridSize.height);
//			[gridLayer addChild:grid];
		}
	}
	
	// test
	PFGridNode *node = (PFGridNode*)[gridLayer childNodeWithName:@"4"];
	((SKSpriteNode*)[gridLayer childNodeWithName:@"4"]).color = node.startColor;
	((SKSpriteNode*)[gridLayer childNodeWithName:@"5"]).color = node.endColor;
	((SKSpriteNode*)[gridLayer childNodeWithName:@"6"]).color = node.blockColor;
	((SKSpriteNode*)[gridLayer childNodeWithName:@"7"]).color = node.openColor;
	((SKSpriteNode*)[gridLayer childNodeWithName:@"8"]).color = node.closeColor;
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
	NSLog(@"mouseDown");
//	CGPoint location = [theEvent locationInNode:self.worldNode];
//	self.targetLocation = CGPointMake((int)location.x, (int)location.y);
}

- (void)mouseDragged:(NSEvent *)theEvent {
	NSLog(@"mouseDragged");
	
}

- (void)mouseUp:(NSEvent *)theEvent {
	NSLog(@"mouseUp");
	
}
#endif



#pragma mark - Game update loop
-(void)update:(NSTimeInterval)currentTime {
	
	
	
}










@end
