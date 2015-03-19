//
//  BaseFinder.h
//
//  Created by JasioWoo on 14/10/28.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import "PFTypes.h"

#import "PFNode.h"
#import "PFGrid.h"
#import "Heuristic.h"


@interface BaseFinder : NSObject

@property (nonatomic) HeuristicType heuristicType;
@property (nonatomic) DiagonalMovement movementType;
@property (nonatomic) Heuristic *heuristic;
@property (nonatomic) int weight;

@property (nonatomic, readonly) NSArray *resultPath;

- (NSArray *)findPathInStartNode:(PFNode*)startNode toEndNode:(PFNode*)endNode withGrid:(PFGrid*)grid trackFinding:(NSMutableArray**)trackArrForTest;

- (float)calculateHeuristicValueWithX:(float)dx andY:(float)dy;

- (Heuristic *)createHeuristicWithType:(HeuristicType)type;

@end
