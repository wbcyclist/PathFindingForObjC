//
//  JumpPointFinderBase.h
//
//  Created by JasioWoo on 15/3/17.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "BaseFinder.h"



/**
 * @author imor / https://github.com/imor
 */

/**
 * Base class for the Jump Point Search algorithm
 * @param {object} opt
 * @param {function} opt.heuristic Heuristic function to estimate the distance
 *     (defaults to manhattan).
 */
@interface JumpPointFinderBase : BaseFinder

- (instancetype)initWithMovementType:(DiagonalMovement)movementType;

- (PFNode *)jump:(PFNode*)nodeA withNode:(PFNode*)nodeB withEndNode:(PFNode*)endNode withGrid:(PFGrid *)grid andTrackArr:(NSMutableArray*)trackArr;
- (NSArray *)findNeighbors:(PFNode *)node withGrid:(PFGrid *)grid;

@end
