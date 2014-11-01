//
//  OrthogonalJumpPointFinder.h
//
//  Created by JasioWoo on 14/11/1.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import "JumpPointFinder.h"

/**
 * @author imor / https://github.com/imor
 */

/**
 * Path finder using the Jump Point Search algorithm allowing only horizontal
 * or vertical movements.
 * @param {object} opt
 * @param {function} opt.heuristic Heuristic function to estimate the distance
 *     (defaults to manhattan).
 */
@interface OrthogonalJumpPointFinder : JumpPointFinder

@end
