//
//  DijkstraFinder.h
//
//  Created by JasioWoo on 14/10/31.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import "AStarFinder.h"


/**
 * Dijkstra path-finder.
 * @constructor
 * @extends AStarFinder
 * @param {object} opt
 * @param {boolean} opt.allowDiagonal Whether diagonal movement is allowed. Deprecated, use diagonalMovement instead.
 * @param {boolean} opt.dontCrossCorners Disallow diagonal movement touching block corners. Deprecated, use diagonalMovement instead.
 * @param {DiagonalMovement} opt.diagonalMovement Allowed diagonal movement.
 */
@interface DijkstraFinder : AStarFinder

@end
