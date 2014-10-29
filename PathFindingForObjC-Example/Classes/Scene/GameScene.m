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
	BOOL isRunSearch;
	SKNode *gridLayer;
	PFGridNode *selectGrid;
	GridNodeState selectState;
	
	PathFinding *pathFinding;
}

- (instancetype)initWithSize:(CGSize)size {
	NSLog(@"GameScene initWithSize = %@", NSStringFromCGSize(size));
	self = [super initWithSize:size];
	if (self) {
		self.backgroundColor = [SKColor whiteColor];
		self.gridSize =  CGSizeMake(64, 64);
	}
	return self;
}


-(void)didMoveToView:(SKView *)view {
	
	if (!isContentCreated) {
		isContentCreated = YES;
		
		gridLayer = [SKNode node];
		[self addChild:gridLayer];
		
		[self createGridNodes];
		
	}
}

- (void)createGridNodes {
	if (self.gridSize.width<1 || self.gridSize.height<1 || !gridLayer) {
		return;
	}
	[gridLayer removeAllChildren];
	
	int column = CGRectGetWidth(self.frame)/self.gridSize.width;
	int row = CGRectGetHeight(self.frame)/self.gridSize.height;
	for (int i=0; i<row; i++) {
		for (int j=0; j<column; j++) {
			PFGridNode *grid = [PFGridNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"grid"] size:self.gridSize];
			grid.colorBlendFactor = 0.7;
			grid.position = CGPointMake(j*self.gridSize.width + self.gridSize.width/2.0, i*self.gridSize.height + self.gridSize.height/2.0);
			grid.name = [NSString stringWithFormat:@"%d",i*column + j];
			grid.x = j;
			grid.y = i;
			grid.showWeightValue = NO;
			if (i==0 && j==0) {
				[grid setupEditGridState:kGState_Start runAnimate:NO];
			} else if (i==0 && j==1) {
				[grid setupEditGridState:kGState_End runAnimate:NO];
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
}


- (void)startFindingPath {
	if (!pathFinding) {
		pathFinding = [[PathFinding alloc] initWithMapSize:CGSizeMake(0, 0)
												  tileSize:CGSizeMake(1, 1)
											   coordsOrgin:CGPointMake(0, 0)];
		pathFinding.heuristicType = HeuristicTypeManhattan;
		pathFinding.allowDiagonal = YES;
		pathFinding.dontCrossCorners = YES;
	}
	int column = CGRectGetWidth(self.frame)/self.gridSize.width;
	int row = CGRectGetHeight(self.frame)/self.gridSize.height;
	CGSize mapSize = CGSizeMake(column*self.gridSize.width, row*self.gridSize.height);
	pathFinding.mapSize = mapSize;
	pathFinding.tileSize = self.gridSize;
	pathFinding.orginPoint = CGPointZero;
	
	[pathFinding clearBlockTiles];
	for (PFGridNode *node in gridLayer.children) {
		if (node.editState==kGState_Block) {
			[pathFinding addBlockTilePosition:node.position];
		} else if (node.editState==kGState_Start) {
			pathFinding.startPoint = node.position;
		} else if (node.editState==kGState_End) {
			pathFinding.endPoint = node.position;
		}
	}
	NSArray *path = [pathFinding findPathing:PathfindingAlgorithm_AStar];
}


- (void)clearGrid {
	for (PFGridNode *grid in gridLayer.children) {
		grid.searchState = kGState_None;
		grid.fValue = 0;
		grid.gValue = 0;
		grid.hValue = 0;
		
		if (grid.editState!=kGState_Start && grid.editState!=kGState_End) {
			[grid setupEditGridState:kGState_Walkable runAnimate:NO];
		}
	}
}

- (void)clearPath {
	for (PFGridNode *grid in gridLayer.children) {
		grid.searchState = kGState_None;
		grid.fValue = 0;
		grid.gValue = 0;
		grid.hValue = 0;
	}
}


#if TARGET_OS_IPHONE
#pragma mark - Event Handling - iOS
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint touchPoint = [touch locationInNode:gridLayer];
	[self gridTouchIn:touchPoint];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint touchPoint = [touch locationInNode:gridLayer];
	[self gridTouchMoved:touchPoint];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[self gridTouchEnd];
}

// phone call or back home screen
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[self gridTouchEnd];
}

#else

#pragma mark - Event Handling - OS X
-(void)mouseDown:(NSEvent *)theEvent {
//	NSLog(@"mouseDown");
	CGPoint location = [theEvent locationInNode:gridLayer];
	[self gridTouchIn:location];
}

- (void)mouseDragged:(NSEvent *)theEvent {
//	NSLog(@"mouseDragged");
	CGPoint location = [theEvent locationInNode:gridLayer];
	[self gridTouchMoved:location];
}

- (void)mouseUp:(NSEvent *)theEvent {
//	NSLog(@"mouseUp");
	[self gridTouchEnd];
}
#endif


#pragma mark - 
- (void)gridTouchIn:(CGPoint)point {
	point = CGPointMake((int)point.x, (int)point.y);
	SKNode *node = [gridLayer nodeAtPoint:point];
	PFGridNode *grid;
	if ([node isKindOfClass:[PFGridNode class]]) {
		grid = (PFGridNode *)node;
	} else if ([node isKindOfClass:[SKLabelNode class]] && [node.parent isKindOfClass:[PFGridNode class]]) {
		grid = (PFGridNode *)node.parent;
	}
	if (grid) {
		GridNodeState state = grid.editState;
		if (state==kGState_Walkable) {
			[grid setupEditGridState:kGState_Block runAnimate:YES];
		} else if (state==kGState_Block) {
			[grid setupEditGridState:kGState_Walkable runAnimate:YES];
		}
		selectState = grid.editState;
		selectGrid = grid;
	} else {
		selectState = kGState_None;
		selectGrid = nil;
	}
}

- (void)gridTouchMoved:(CGPoint)point {
	point = CGPointMake((int)point.x, (int)point.y);
	SKNode *node = [gridLayer nodeAtPoint:point];
	if ([node isKindOfClass:[PFGridNode class]] && selectState!=kGState_None) {
		PFGridNode *grid = (PFGridNode *)node;
		BOOL result = [grid setupEditGridState:selectState runAnimate:!(selectState==kGState_Start||selectState==kGState_End)];
		if (result) {
			if (selectState==kGState_Start || selectState==kGState_End) {
				selectGrid.editState = kGState_Block;
				[selectGrid setupEditGridState:kGState_Walkable runAnimate:NO];
				selectGrid = grid;
			}
		}
	}
}

- (void)gridTouchEnd {
	selectGrid = nil;
	selectState = kGState_None;
	
	[self startFindingPath];
}


#pragma mark - Game update loop
-(void)update:(NSTimeInterval)currentTime {
	
	
	
}










@end
