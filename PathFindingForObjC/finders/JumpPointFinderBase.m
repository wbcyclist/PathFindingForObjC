//
//  JumpPointFinderBase.m
//
//  Created by JasioWoo on 15/3/17.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "JumpPointFinderBase.h"
#import "PFUtil.h"
#import "JPFNeverMoveDiagonally.h"
#import "JPFAlwaysMoveDiagonally.h"
#import "JPFMoveDiagonallyIfAtMostOneObstacle.h"
#import "JPFMoveDiagonallyIfNoObstacles.h"


@implementation JumpPointFinderBase {
	BOOL trackJumpRecursion;
}

- (instancetype)initWithMovementType:(DiagonalMovement)movementType {
	JumpPointFinderBase *result = nil;
	switch (movementType) {
		case DiagonalMovement_Always:
			result = [[JPFAlwaysMoveDiagonally alloc] init];
			break;
		case DiagonalMovement_Never:
			result = [[JPFNeverMoveDiagonally alloc] init];
			break;
		case DiagonalMovement_OnlyWhenNoObstacles:
			result = [[JPFMoveDiagonallyIfNoObstacles alloc] init];
			break;
		default:
			// DiagonalMovement_IfAtMostOneObstacle
			result = [[JPFMoveDiagonallyIfAtMostOneObstacle alloc] init];
			break;
	}
	return result;
}


- (NSArray *)findPathInStartNode:(PFNode *)startNode toEndNode:(PFNode *)endNode withGrid:(PFGrid *)grid trackFinding:(NSMutableArray *__autoreleasing *)trackArrForTest {
	
	NSMutableArray *openList = [NSMutableArray array];
	PFNode *node = nil;
	
	// set the `g` and `f` value of the start node to be 0
	startNode.g = 0;
	startNode.f = 0;
	
	// push the start node into the open list
	[openList addObject:startNode];
	startNode.opened = 1;
	
	// track
	trackJumpRecursion = NO;
	if (trackArrForTest) {[(*trackArrForTest) addObject:[startNode copy]]; trackJumpRecursion = YES;}
	
	// while the open list is not empty
	while (openList.count>0) {
		// pop the position of node which has the minimum `f` value.
		[openList sortUsingSelector:@selector(descFWeightSort:)];
		node = [openList lastObject];
		[openList removeLastObject];
		node.closed = YES;
		
		// track
		if (trackArrForTest) {[(*trackArrForTest) addObject:[node copy]];}
		
		if (node == endNode) {
			return [PFUtil expandPath:[PFUtil backtrace:endNode]];
		}
		
		[self identifySuccessors:node withEndNode:endNode andGrid:grid andOpenList:openList andTrackFinding:trackArrForTest?(*trackArrForTest):nil];
	}
	
	// fail to find the path
	return nil;
}


/**
 * Identify successors for the given node. Runs a jump point search in the
 * direction of each available neighbor, adding any points found to the open
 * list.
 * @protected
 */
- (void)identifySuccessors:(PFNode*)node withEndNode:(PFNode*)endNode andGrid:(PFGrid *)grid andOpenList:(NSMutableArray *)openList andTrackFinding:(NSMutableArray*)trackArrForTest {
	
	int x=node.x, y=node.y, endX=endNode.x, endY=endNode.y, jx, jy;
	float ng = 0;
	
	Heuristic *octileHeur = [self createHeuristicWithType:HeuristicTypeOctile];
	
	NSArray *neighbors = [self findNeighbors:node withGrid:grid];
	PFNode *neighbor = nil;
	PFNode *jumpNode = nil;
	NSMutableArray *trackArr = nil;
	for(int i = 0; i < neighbors.count; i++) {
		neighbor = neighbors[i];
		
		// track
		if (trackArrForTest) {
			trackArr = [NSMutableArray array];
		}
		
		jumpNode = [self jump:neighbor withNode:node withEndNode:endNode withGrid:grid andTrackArr:trackArr];
		
		if (jumpNode) {
			jx = jumpNode.x;
			jy = jumpNode.y;
			
			if (jumpNode.closed) {
				continue;
			}
			
			// include distance, as parent may not be immediately adjacent:
			int d = [octileHeur performAlgorithmWithX:abs(jx - x) andY:abs(jy - y)];
			ng = node.g + d; // next `g` value
			
			if (jumpNode.opened==0 || ng < jumpNode.g) {
				jumpNode.g = ng;
				jumpNode.h = jumpNode.h==0 ? [self calculateHeuristicValueWithX:abs(jx - endX) andY:abs(jy - endY)] : jumpNode.h;
				jumpNode.f = jumpNode.g + jumpNode.h;
				jumpNode.parent = node;
				
				if (jumpNode.opened==0) {
					[openList addObject:jumpNode];
					jumpNode.opened = 1;
				}
				
				// track
				if (trackArr) {[trackArr addObject:[jumpNode copy]];}
			}
		}
		
		// track
		if (trackArrForTest && trackArr.count>0) { [trackArrForTest addObject:trackArr]; }
	}
}


/**
 * Implemented in children class
 */
- (PFNode *)jump:(PFNode*)nodeA withNode:(PFNode*)nodeB withEndNode:(PFNode*)endNode withGrid:(PFGrid *)grid andTrackArr:(NSMutableArray*)trackArr {
	return nil;
}


/**
 * Implemented in children class
 */
- (NSArray *)findNeighbors:(PFNode *)node withGrid:(PFGrid *)grid {
	return nil;
}




@end
