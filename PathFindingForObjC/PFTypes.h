//
//  PFTypes.h
//
//  Created by JasioWoo on 15/3/13.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#ifndef PathFindingForObjC_PFTypes_h
#define PathFindingForObjC_PFTypes_h

#import "TargetConditionals.h"

#if TARGET_OS_IPHONE
	#import <UIKit/UIKit.h>
	#define PF_CGPointToNSValue(p) [NSValue valueWithCGPoint:p]
	#define PF_NSValueToCGPoint(v) v.CGPointValue
#else
	#import <AppKit/AppKit.h>
	#define PF_CGPointToNSValue(p) [NSValue valueWithPoint:p]
	#define PF_NSValueToCGPoint(v) v.pointValue
#endif

#define PF_ConvertToMatrixPoint(p, t, o) do{ p.x = (int)((p.x+o.x)/t.width); p.y = (int)((p.y+o.y)/t.height);}while(0)
#define PF_ConvertToOriginPoint(p, t, o) do{ p.x = p.x*t.width - o.x + t.width/2.0; p.y = p.y*t.height - o.y + t.height/2.0;}while(0)

#ifndef PF_DEBUG
	#ifdef DEBUG
		#define PF_DEBUG 1
	#else
		#define PF_DEBUG 0
	#endif
#endif

/**
 *  http://qiao.github.io/PathFinding.js/visual/
 */
typedef enum {
	PathfindingAlgorithm_AStar = 0,						// default
	PathfindingAlgorithm_BestFirstSearch,			//
	PathfindingAlgorithm_Dijkstra,					//
	PathfindingAlgorithm_JumpPointSearch,			//
	PathfindingAlgorithm_BreadthFirstSearch,		// queue
	//	PathfindingAlgorithm_DepthFirstSearch,		// stack
	
	PathfindingAlgorithm_BiAStar,					//
	PathfindingAlgorithm_BiBestFirst,				//
	PathfindingAlgorithm_BiDijkstra,				//
	PathfindingAlgorithm_BiBreadthFirst,			//
	
	PathfindingAlgorithm_IDAStar					//
} PathfindingAlgorithm;


typedef enum {
	/**
	 *	On a square grid that allows 4 directions of movement, use Manhattan distance (L1).
	 *	On a square grid that allows 8 directions of movement, use Diagonal distance (L∞).
	 *	On a square grid that allows any direction of movement, you might or might not want Euclidean distance (L2).
	 If A* is finding paths on the grid but you are allowing movement not on the grid, you may want to consider other representations of the map.
	 *	On a hexagon grid that allows 6 directions of movement, use Manhattan distance adapted to hexagonal grids.
	 *
	 *  See http://theory.stanford.edu/~amitp/GameProgramming/Heuristics.html#heuristics-for-grid-maps for more details.
	 */
	HeuristicTypeManhattan = 0,	// default
	HeuristicTypeEuclidean,
	HeuristicTypeOctile,
	HeuristicTypeChebyshev
} HeuristicType;


typedef enum {
	DiagonalMovement_Always = 0,
	DiagonalMovement_Never,
	DiagonalMovement_IfAtMostOneObstacle,
	DiagonalMovement_OnlyWhenNoObstacles
} DiagonalMovement;



















#endif
