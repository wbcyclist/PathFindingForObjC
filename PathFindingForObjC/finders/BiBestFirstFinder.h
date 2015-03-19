//
//  BiBestFirstFinder.h
//
//  Created by JasioWoo on 14/10/31.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import "BiAStarFinder.h"

/**
 * Bi-direcitional Best-First-Search path-finder.
 * @constructor
 * @extends BiAStarFinder
 * @param {object} opt
 * @param {boolean} opt.allowDiagonal Whether diagonal movement is allowed. Deprecated, use diagonalMovement instead.
 * @param {boolean} opt.dontCrossCorners Disallow diagonal movement touching block corners. Deprecated, use diagonalMovement instead.
 * @param {DiagonalMovement} opt.diagonalMovement Allowed diagonal movement.
 * @param {function} opt.heuristic Heuristic function to estimate the distance
 *     (defaults to manhattan).
 */
@interface BiBestFirstFinder : BiAStarFinder

@end
