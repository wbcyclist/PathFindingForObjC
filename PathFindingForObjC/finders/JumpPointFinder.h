//
//  JumpPointFinder.h
//  PathFindingForObjC-Example
//
//  Created by JasioWoo on 14/11/1.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import "BaseFinder.h"

/**
 * @author zerowidth / https://github.com/zerowidth
 */

/**
 * Path finder using the Jump Point Search algorithm
 * @param {object} opt
 * @param {function} opt.heuristic Heuristic function to estimate the distance
 *     (defaults to manhattan).
 */
@interface JumpPointFinder : BaseFinder

@end
