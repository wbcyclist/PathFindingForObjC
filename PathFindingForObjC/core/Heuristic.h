//
//  Heuristic.h
//
//  Created by JasioWoo on 14/10/27.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else

#endif

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

/**
 * @description A collection of heuristic functions.
 */
@interface Heuristic : NSObject
- (float)performAlgorithmWithX:(float)dx andY:(float)dy;
@end

/**
 * Manhattan distance.
 * @param {number} dx - Difference in x.
 * @param {number} dy - Difference in y.
 * @return {number} dx + dy
 */
@interface Manhattan : Heuristic
@end

/**
 * Euclidean distance.
 * @param {number} dx - Difference in x.
 * @param {number} dy - Difference in y.
 * @return {number} sqrt(dx * dx + dy * dy)
 */
@interface Euclidean : Heuristic
@end

/**
 * Octile distance.
 * @param {number} dx - Difference in x.
 * @param {number} dy - Difference in y.
 * @return {number} sqrt(dx * dx + dy * dy) for grids
 */
@interface Octile : Heuristic
@end

/**
 * Chebyshev distance.
 * @param {number} dx - Difference in x.
 * @param {number} dy - Difference in y.
 * @return {number} max(dx, dy)
 */
@interface Chebyshev : Heuristic
@end








