//
//  VectorFieldGrid.h
//
//  Created by JasioWoo on 14/11/4.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFTypes.h"
#import "PFNode.h"


@interface VectorFieldGrid : NSObject
/// The number of columns of the grid.
@property (nonatomic) unsigned int column;
/// The number of rows of the grid.
@property (nonatomic) unsigned int row;
/// A 2D array of nodes.
@property (nonatomic, retain, readonly) NSArray *nodes;

@property (nonatomic) CGSize mapSize;
@property (nonatomic) CGSize tileSize;
@property (nonatomic) CGPoint orginPoint;

@property (nonatomic, assign) CGPoint targetPoint;

- (instancetype)initWithMapSize:(CGSize)mapSize tileSize:(CGSize)tileSize coordsOrgin:(CGPoint)orginPoint;

- (BOOL)isWalkableAtX:(int)x andY:(int)y;
- (PFNode *)getNodeAtX:(int)x andY:(int)y;
- (void)setWalkableAtX:(int)x andY:(int)y andWalkable:(BOOL)walkable;

- (void)clearBlockTiles;
- (void)addBlockTilePosition:(CGPoint)point;


@end
