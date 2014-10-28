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



- (instancetype)initWithMap:(CGSize)mapSize tileSize:(CGSize)tileSize systemCoordsOrgin:(CGPoint)orginPoint;

- (NSArray *)findPathing:(PathfindingAlgorithm)alg;


@end
