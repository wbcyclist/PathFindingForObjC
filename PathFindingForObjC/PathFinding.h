//
//  PathFinding.h
//
//  Created by JasioWoo on 14/10/26.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//
#import "BaseFinder.h"

/**
 *  http://qiao.github.io/PathFinding.js/visual/
 */
typedef enum {
	PathfindingAlgorithm_AStar,						// default
	PathfindingAlgorithm_IDAStar,					//
	PathfindingAlgorithm_BreadthFirstSearch,		// queue
	PathfindingAlgorithm_DepthFirstSearch,			// stack
	PathfindingAlgorithm_BestFirstSearch,			//
	PathfindingAlgorithm_Dijkstra,					//
	PathfindingAlgorithm_JumpPointSearch,			//
	PathfindingAlgorithm_OrthogonalJumpPointSearch,	//
	PathfindingAlgorithm_Trace						//
} PathfindingAlgorithm;


@interface PathFinding : NSObject

@property (nonatomic) HeuristicType heuristicType;
@property (nonatomic) BOOL allowDiagonal;
@property (nonatomic) BOOL dontCrossCorners;
@property (nonatomic) int weight;
@property (nonatomic) CGSize mapSize;
@property (nonatomic) CGSize tileSize;
@property (nonatomic) CGPoint orginPoint;
@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;

- (instancetype)initWithMapSize:(CGSize)mapSize tileSize:(CGSize)tileSize coordsOrgin:(CGPoint)orginPoint;

- (void)addBlockTilePosition:(CGPoint)point;
/// @param points = @[[NSValue valueWithCGPoint:CGPointMake(x, y)]]
- (void)addBlockTilePositions:(NSArray*)points;
- (void)clearBlockTiles;

- (NSArray *)findPathing:(PathfindingAlgorithm)alg;


@end
