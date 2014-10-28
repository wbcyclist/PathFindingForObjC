//
//  PathFinding.m
//
//  Created by JasioWoo on 14/10/26.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import "PathFinding.h"
#import "PFGrid.h"
#import "AStarFinder.h"

@interface PathFinding ()


@end


@implementation PathFinding {
	PFGrid *grid;
	
	
}

- (instancetype)initWithMap:(CGSize)mapSize tileSize:(CGSize)tileSize systemCoordsOrgin:(CGPoint)orginPoint {
	self = [super init];
	if (self) {
		self.heuristicType = HeuristicTypeManhattan;
		self.allowDiagonal = YES;
		self.dontCrossCorners = NO;
		self.weight = 1;
		
		grid = [[PFGrid alloc] initWithColumn:mapSize.width andRow:mapSize.height];
	}
	return self;
}


- (NSArray *)findPathing:(PathfindingAlgorithm)alg {
	BaseFinder *finder = [self getFinder:alg];
	finder.heuristicType = self.heuristicType;
	finder.allowDiagonal = self.allowDiagonal;
	finder.dontCrossCorners = self.dontCrossCorners;
	finder.weight = self.weight;
	NSArray *result = [finder findPathInStartNode:[grid getNodeAtX:1 andY:1] toEndNode:[grid getNodeAtX:4 andY:3] withGrid:grid];
//	NSLog(@"result=%@", result);
	[grid printFoundPath:result];
	
	return result;
}



- (BaseFinder*)getFinder:(PathfindingAlgorithm)alg{
	BaseFinder *result = nil;
	
	switch (alg) {
		case PathfindingAlgorithm_AStar:
			result = [[AStarFinder alloc] init];
			break;
		case PathfindingAlgorithm_IDAStar:
			result = [[AStarFinder alloc] init];
			break;
		case PathfindingAlgorithm_BreadthFirstSearch:
			result = [[AStarFinder alloc] init];
			break;
		case PathfindingAlgorithm_DepthFirstSearch:
			result = [[AStarFinder alloc] init];
			break;
		case PathfindingAlgorithm_BestFirstSearch:
			result = [[AStarFinder alloc] init];
			break;
		case PathfindingAlgorithm_Dijkstra:
			result = [[AStarFinder alloc] init];
			break;
		case PathfindingAlgorithm_JumpPointSearch:
			result = [[AStarFinder alloc] init];
			break;
		case PathfindingAlgorithm_OrthogonalJumpPointSearch:
			result = [[AStarFinder alloc] init];
			break;
		case PathfindingAlgorithm_Trace:
			result = [[AStarFinder alloc] init];
			break;
		default:
			result = [[AStarFinder alloc] init];
			break;
	}
	return result;
}

@end
