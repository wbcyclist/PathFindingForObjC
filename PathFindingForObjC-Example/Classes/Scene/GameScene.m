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
#import "PFNode.h"
#import "VectorFieldGrid.h"

@interface GameScene ()

@property (nonatomic,strong)VectorFieldGrid *fieldGrid;


@property (nonatomic, strong)NSMutableDictionary *gridsDic;

@end

@implementation GameScene {
	BOOL isContentCreated;
	BOOL isRunSearch;
	int row, column;
	
	SKNode *pathLinesLayer;
	
	SKNode *gridLayer;
	PFGridNode *selectGrid;
	GridNodeState selectState;
	
	PathFinding *pathFinding;
	NSArray *foundPaths;
	NSMutableArray *trackArr;
	NSUInteger currentTrackIndex;
	BOOL isPlayTrack;
	NSUInteger trackSpeed;
}

- (instancetype)initWithSize:(CGSize)size {
	NSLog(@"GameScene initWithSize = %@", NSStringFromCGSize(size));
	self = [super initWithSize:size];
	if (self) {
		self.backgroundColor = [SKColor whiteColor];
		#if TARGET_OS_IPHONE
		self.gridSize =  CGSizeMake(64, 64);
		#else
		self.gridSize =  CGSizeMake(32, 32);
		#endif
		
		trackSpeed = 1;//(the larger the slow)
	}
	return self;
}

- (void)didChangeSize:(CGSize)oldSize {
	if (CGSizeEqualToSize(oldSize, self.size)) {
		return;
	}
	if (isContentCreated) {
		[self clearFindingAction];
		[self updateGridNodes];
	}
}


-(void)didMoveToView:(SKView *)view {
	
	if (!isContentCreated) {
		isContentCreated = YES;
		self.gridsDic = [NSMutableDictionary dictionary];
		gridLayer = [SKNode node];
		[self addChild:gridLayer];
		
		pathLinesLayer = [SKNode node];
		pathLinesLayer.zPosition = 1;
		[self addChild:pathLinesLayer];
		
		[self updateGridNodes];
		
	}
}


- (void)updateGridNodes {
	if (!gridLayer) {
		return;
	}
	column = CGRectGetWidth(self.frame)/self.gridSize.width;
	row = CGRectGetHeight(self.frame)/self.gridSize.height;
	
	SKTexture *tex = [SKTexture textureWithImageNamed:@"grid"];
	tex.filteringMode = SKTextureFilteringNearest;
	for (int i=0; i<row; i++) {
		for (int j=0; j<column; j++) {
			NSString *dicKey = [NSString stringWithFormat:@"%d,%d", j, i];
			if ([self.gridsDic objectForKey:dicKey]) {
				continue;
			}
			PFGridNode *grid = [PFGridNode spriteNodeWithTexture:tex size:self.gridSize];
			grid.colorFactor = 0.7;
			grid.position = CGPointMake(j*self.gridSize.width + self.gridSize.width/2.0, i*self.gridSize.height + self.gridSize.height/2.0);
			grid.name = dicKey;
			grid.x = j;
			grid.y = i;
			grid.showWeightValue = YES;
			[gridLayer addChild:grid];
			[self.gridsDic setObject:grid forKey:dicKey];
		}
	}
	
	PFGridNode *startNode, *endNode;
	// remove outside grid
	NSArray *allkeys = self.gridsDic.allKeys;
	for (NSString *dicKey in allkeys) {
		PFGridNode *grid = [self.gridsDic objectForKey:dicKey];
		grid.editState==kGState_Start ? startNode=grid : NO;
		grid.editState==kGState_End ? endNode=grid : NO;
		
		if (grid.x >= column || grid.y >= row) {
			[grid removeFromParent];
			[self.gridsDic removeObjectForKey:dicKey];
		}
	}
	
	// setup startNode
	if (startNode == nil) {
		// init startNode
		startNode = [self.gridsDic objectForKey:@"0,0"];
		[startNode setupEditGridState:kGState_Start runAnimate:YES];
	} else {
		if (startNode.x >= column || startNode.y >= row) {
			// new startNode
			NSString *dicKey = [NSString stringWithFormat:@"%d,%d", startNode.x>=column?(column-1):startNode.x, startNode.y>=row?(row-1):startNode.y];
			startNode = [self.gridsDic objectForKey:dicKey];
			if (startNode.editState == kGState_End) {
				dicKey = [NSString stringWithFormat:@"%d,%d", startNode.x-1, startNode.y];
				startNode = [self.gridsDic objectForKey:dicKey];
			}
			if (startNode.editState == kGState_Block) {
				[startNode setupEditGridState:kGState_Walkable runAnimate:NO];
			}
			[startNode setupEditGridState:kGState_Start runAnimate:YES];
		}
	}
	
	// setup endNode
	if (endNode == nil) {
		// init endNode
		endNode = [self.gridsDic objectForKey:@"1,0"];
		[endNode setupEditGridState:kGState_End runAnimate:YES];
	} else {
		if (endNode.x >= column || endNode.y >= row) {
			// new endNode
			NSString *dicKey = [NSString stringWithFormat:@"%d,%d", endNode.x>=column?(column-1):endNode.x, endNode.y>=row?(row-1):endNode.y];
			endNode = [self.gridsDic objectForKey:dicKey];
			if (endNode.editState == kGState_Start) {
				dicKey = [NSString stringWithFormat:@"%d,%d", endNode.x-1, endNode.y];
				endNode = [self.gridsDic objectForKey:dicKey];
			}
			if (endNode.editState == kGState_Block) {
				[endNode setupEditGridState:kGState_Walkable runAnimate:NO];
			}
			[endNode setupEditGridState:kGState_End runAnimate:YES];
		}
	}
}

- (void)clearFindingAction {
	[self clearPath];
	[pathLinesLayer removeAllActions];
	[pathLinesLayer removeAllChildren];
	
	isPlayTrack = NO;
	[trackArr removeAllObjects];
	trackArr = nil;
	currentTrackIndex = 0;
}


- (void)startFindingPath {
	if (!pathFinding) {
		pathFinding = [[PathFinding alloc] initWithMapSize:CGSizeMake(0, 0)
												  tileSize:CGSizeMake(1, 1)
											   coordsOrgin:CGPointMake(0, 0)];
		pathFinding.heuristicType = HeuristicTypeManhattan;
		pathFinding.movementType = DiagonalMovement_OnlyWhenNoObstacles;
		
		pathFinding.weight = 1;
	}
	
	[self clearFindingAction];
	
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
	
	NSMutableArray *trackArrHook = [NSMutableArray array];
//	NSMutableArray *trackArrHook = nil;
	
	NSDate* tmpStartData = [NSDate date];
	
	foundPaths = nil;
//	foundPaths = [pathFinding findPathing:PathfindingAlgorithm_BestFirstSearch IsConvertToOriginCoords:YES trackFinding:&trackArrHook];
	foundPaths = [pathFinding findPathing:PathfindingAlgorithm_AStar IsConvertToOriginCoords:YES trackFinding:&trackArrHook];
//	foundPaths = [pathFinding findPathing:PathfindingAlgorithm_BiAStar IsConvertToOriginCoords:YES trackFinding:&trackArrHook];
//	foundPaths = [pathFinding findPathing:PathfindingAlgorithm_BiBestFirst IsConvertToOriginCoords:YES trackFinding:&trackArrHook];
//	foundPaths = [pathFinding findPathing:PathfindingAlgorithm_Dijkstra IsConvertToOriginCoords:YES trackFinding:&trackArrHook];
//	foundPaths = [pathFinding findPathing:PathfindingAlgorithm_BiDijkstra IsConvertToOriginCoords:YES trackFinding:&trackArrHook];
//	foundPaths = [pathFinding findPathing:PathfindingAlgorithm_BreadthFirstSearch IsConvertToOriginCoords:YES trackFinding:&trackArrHook];
//	foundPaths = [pathFinding findPathing:PathfindingAlgorithm_BiBreadthFirst IsConvertToOriginCoords:YES trackFinding:&trackArrHook];
//	foundPaths = [pathFinding findPathing:PathfindingAlgorithm_JumpPointSearch IsConvertToOriginCoords:YES trackFinding:&trackArrHook];
	
	/*
	if (!_fieldGrid) {
		self.fieldGrid = [[VectorFieldGrid alloc] initWithMapSize:mapSize tileSize:self.gridSize coordsOrgin:CGPointZero];
	}
	[self.fieldGrid clearBlockTiles];
	for (PFGridNode *node in gridLayer.children) {
		if (node.editState==kGState_Block) {
			[self.fieldGrid addBlockTilePosition:node.position];
		}
	}
	self.fieldGrid.targetPoint = pathFinding.startPoint;
	
	double costTime = [[NSDate date] timeIntervalSinceDate:tmpStartData];
	NSLog(@"costTime = %fms", costTime*1000);
	
	NSArray *result = self.fieldGrid.nodes;
	for (NSArray *rowArr in result) {
		for (PFNode *node in rowArr) {
			[self playTrackFinding:node];
		}
	}
	 */
	
	if ([trackArrHook count]>0) {
		trackArr = trackArrHook;
		isPlayTrack = YES;
	} else {
		[self drawPathLines:foundPaths];
	}
	
}

- (void)clearBlockGrid {
	for (PFGridNode *grid in gridLayer.children) {
		grid.searchState = kGState_None;
		grid.fValue = 0;
		grid.gValue = 0;
		grid.hValue = 0;
		grid.direction = 0;
		
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
		grid.direction = 0;
	}
}

- (PFGridNode*)getGridNodeWithName:(NSString *)name {
	return (PFGridNode*)[gridLayer childNodeWithName:name];
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
	} else if ([node isKindOfClass:[SKSpriteNode class]] && [node.parent isKindOfClass:[PFGridNode class]]) {
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
	SKNode *touchNode = [gridLayer nodeAtPoint:point];
	SKNode *node = nil;
//	NSLog(@"%@", touchNode);
	if ([touchNode isKindOfClass:[PFGridNode class]]) {
		node = touchNode;
	} else if ([touchNode isKindOfClass:[SKLabelNode class]] || [touchNode isKindOfClass:[SKSpriteNode class]]) {
		node = touchNode.parent;
	}
	
	if ([node isKindOfClass:[PFGridNode class]]) {
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
static int timeCount = 0;
-(void)update:(NSTimeInterval)currentTime {
	timeCount++;
	if (timeCount==trackSpeed) {
		timeCount = 0;
		if (isPlayTrack) {
			if (currentTrackIndex>=trackArr.count) {
				isPlayTrack = NO;
				[self drawPathLines:foundPaths];
			} else {
				[self playTrackFinding:trackArr[currentTrackIndex++]];
			}
		}
	}
}

- (void)drawPathLines:(NSArray *)pathArr {
	[pathLinesLayer removeAllActions];
	[pathLinesLayer removeAllChildren];
	if ([pathArr count]==0) {
		return;
	}
	
	CGMutablePathRef pathRef = CGPathCreateMutable();
	PFNode *firstNode = [pathArr firstObject];
	CGPathMoveToPoint(pathRef, NULL, firstNode.originPoint.x, firstNode.originPoint.y);
	for (int i=1; i<pathArr.count; i++) {
		PFNode *node = pathArr[i];
		CGPathAddLineToPoint(pathRef, NULL, node.originPoint.x, node.originPoint.y);
	}
	SKShapeNode *shapeNode = [SKShapeNode shapeNodeWithPath:pathRef];
	shapeNode.lineWidth = 5*self.gridSize.width/64.0;
	shapeNode.strokeColor = [SKColor orangeColor];
	CGPathRelease(pathRef);
	[pathLinesLayer addChild:shapeNode];
	
	//	[SKAction ]
}

- (void)playTrackFinding:(NSObject*)trackObj {
	if (!trackObj) {
		return;
	}
	if ([trackObj isKindOfClass:[PFNode class]]) {
		PFNode *node = (PFNode *)trackObj;
		PFGridNode *gridNode = [self getGridNodeWithName:[NSString stringWithFormat:@"%d,%d", node.x, node.y]];
		[self updateGridNodeState:gridNode usePFNode:node];
	} else if ([trackObj isKindOfClass:[NSArray class]]) {
		NSArray *arr = (NSArray*)trackObj;
		for (PFNode *node in arr) {
			PFGridNode *gridNode = [self getGridNodeWithName:[NSString stringWithFormat:@"%d,%d", node.x, node.y]];
			[self updateGridNodeState:gridNode usePFNode:node];
		}
	}
}

- (void)updateGridNodeState:(PFGridNode*)gridNode usePFNode:(PFNode*)node {
	if (gridNode && node) {
		if (node.cost>0) {
			gridNode.costValue = node.cost;
			[gridNode setDirection:node.direction vector:node.vector];
		} else {
			gridNode.fValue = node.f;
			gridNode.gValue = node.g;
			gridNode.hValue = node.h;
			if (node.tested) {
				gridNode.searchState = kGState_Tested;
			}
			if (node.closed) {
				gridNode.searchState = kGState_Close;
			} else if (node.opened!=0) {
				gridNode.searchState = kGState_Open;
			}
		}
	}
}


@end
