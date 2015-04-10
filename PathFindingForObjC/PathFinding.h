//
//  PathFinding.h
//
//  Created by JasioWoo on 14/10/26.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import "PFTypes.h"
#import "PFNode.h"
#import "PFGrid.h"

@interface PathFinding : NSObject

@property (nonatomic) HeuristicType heuristicType;
@property (nonatomic) DiagonalMovement movementType;

@property (nonatomic) int weight;
@property (nonatomic) CGSize mapSize;
@property (nonatomic) CGSize tileSize;
@property (nonatomic) CGPoint orginPoint;
@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;

- (instancetype)initWithMapSize:(CGSize)mapSize tileSize:(CGSize)tileSize coordsOrgin:(CGPoint)orginPoint;

/**
 * position of the immobile obstacle, like a wall.
 */
- (void)addBlockTilePosition:(CGPoint)point;
/// @param points = @[[NSValue valueWithCGPoint:CGPointMake(x, y)]]
- (void)addBlockTilePositions:(NSArray*)points;

/**
 * position of the mobile obstacle, like a moving car. (! Clear DynamicBlock after each invoke findPathing:IsConvertToOriginCoords: )
 */
- (void)addDynamicBlockTilePosition:(CGPoint)point;


- (void)clearBlockTiles;

/// @return An PFNode Array.
- (NSArray *)findPathing:(PathfindingAlgorithm)alg IsConvertToOriginCoords:(BOOL)isConvert;
- (NSArray *)findPathing:(PathfindingAlgorithm)alg IsConvertToOriginCoords:(BOOL)isConvert trackFinding:(NSMutableArray**)trackArrForTest;


@end
