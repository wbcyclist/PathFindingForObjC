//
//  FNode.h
//
//  Created by JasioWoo on 14/10/27.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

/**
 * A node in grid.
 * This class holds some basic information about a node and custom
 * attributes may be added, depending on the algorithms' needs.
 */
@interface PFNode : NSObject <NSCopying>

@property (nonatomic) float f;
@property (nonatomic) float g;
@property (nonatomic) float h;

/// special costWeight of pass through.
@property (nonatomic) float cost;

/// The x coordinate of the node on the grid. (X-axis In Matrix Coords)
@property (nonatomic) int x;
/// The y coordinate of the node on the grid. (Y-axis In Matrix Coords)
@property (nonatomic) int y;
/// Whether this node can be walked through.
@property (nonatomic) BOOL walkable;
/**
 * @param 0 is out of the OpenList
 * @param 1 is in the startOpenList
 * @param 2 is in the endOpenList
 */
@property (nonatomic) uint8_t opened;
@property (nonatomic) BOOL closed;
@property (nonatomic) BOOL tested;

/**
 * direction for vectorFieldGrid
 *
 *  +---+---+---+
 *  | 1 | 2 | 3 |
 *  +---+---+---+
 *  | 8 | 0 | 4 |
 *  +---+---+---+
 *  | 7 | 6 | 5 |
 *  +---+---+---+
 *
 */
@property (nonatomic) int direction;
/**
 * vector for vectorFieldGrid
 */
@property (nonatomic, assign) CGVector vector;

/// Point In Origin Coords
@property (nonatomic) CGPoint originPoint;

@property (nonatomic, weak) PFNode *parent;

- (instancetype)initWithX:(int)x andY:(int)y;
- (NSComparisonResult)descFWeightSort:(PFNode *)anObject;








@end
