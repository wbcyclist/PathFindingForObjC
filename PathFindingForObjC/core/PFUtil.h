//
//  PFUtil.h
//
//  Created by JasioWoo on 14/10/27.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else

#endif

@class PFGrid;
@class PFNode;

#if TARGET_OS_IPHONE
	#define CGPointToNSValue(p) [NSValue valueWithCGPoint:p]
	#define NSValueToCGPoint(v) v.CGPointValue
#else
	#define CGPointToNSValue(p) [NSValue valueWithPoint:p]
	#define NSValueToCGPoint(v) v.pointValue
#endif


@interface PFUtil : NSObject

/**
 * Backtrace according to the parent records and return the path.
 * (including both start and end nodes)
 * @param {Node} node End node
 * @return {Array.<Array.<number>>} the path
 */
+ (NSArray *)backtrace:(PFNode*)node;

/**
 * Backtrace from start and end node, and return the path.
 * (including both start and end nodes)
 * @param {Node}
 * @param {Node}
 */
+ (NSArray *)biBacktraceWithNodeA:(PFNode*)nodeA andNodeB:(PFNode*)nodeB;

/**
 * Compute the length of the path.
 * @param {Array.<Array.<number>>} path The path
 * @return {number} The length of the path
 */
+ (float)pathLength:(NSArray*)path;

/**
 * Given the start and end coordinates, return all the coordinates lying
 * on the line formed by these coordinates, based on Bresenham's algorithm.
 * http://en.wikipedia.org/wiki/Bresenham's_line_algorithm#Simplification
 * @param {number} x0 Start x coordinate
 * @param {number} y0 Start y coordinate
 * @param {number} x1 End x coordinate
 * @param {number} y1 End y coordinate
 * @return {Array.<Array.<number>>} The coordinates on the line
 */
+ (NSArray *)interpolate:(int)x0 :(int)y0 :(int)x1 :(int)y1;

/**
 * Given a compressed path, return a new path that has all the segments
 * in it interpolated.
 * @param {Array.<Array.<number>>} path The path
 * @return {Array.<Array.<number>>} expanded path
 */
+ (NSArray *)expandPath:(NSArray*)path;

/**
 * Smoothen the give path.
 * The original path will not be modified; a new path will be returned.
 * @param {PF.Grid} grid
 * @param {Array.<Array.<number>>} path The path
 */
+ (NSArray *)smoothenPathWithGrid:(PFGrid*)grid andPath:(NSArray*)path;

/**
 * Compress a path, remove redundant nodes without altering the shape
 * The original path is not modified
 * @param {Array.<Array.<number>>} path The path
 * @return {Array.<Array.<number>>} The compressed path
 */
+ (NSArray *)compressPath:(NSArray*)path;


@end
