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
	PathfindingAlgorithm_BestFirstSearch,			//
	PathfindingAlgorithm_Dijkstra,					//
	PathfindingAlgorithm_JumpPointSearch,			//
	PathfindingAlgorithm_BreadthFirstSearch,		// queue
	
	PathfindingAlgorithm_BiAStar,					//
	PathfindingAlgorithm_BiBestFirst,				//
	PathfindingAlgorithm_BiDijkstra,				//
	PathfindingAlgorithm_BiBreadthFirst,			//
	
	PathfindingAlgorithm_IDAStar,					//
	PathfindingAlgorithm_DepthFirstSearch,			// stack
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

/// @return An PFNode Array.
- (NSArray *)findPathing:(PathfindingAlgorithm)alg IsConvertToOriginCoords:(BOOL)isConvert;
- (NSArray *)findPathing:(PathfindingAlgorithm)alg IsConvertToOriginCoords:(BOOL)isConvert traceFinding:(NSMutableArray**)traceArrForTest;


@end
