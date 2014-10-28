//
//  FNode.h
//
//  Created by JasioWoo on 14/10/27.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else

#endif





/**
 * A node in grid.
 * This class holds some basic information about a node and custom
 * attributes may be added, depending on the algorithms' needs.
 */
@interface PFNode : NSObject

@property (nonatomic) float f;
@property (nonatomic) float g;
@property (nonatomic) float h;

/// The x coordinate of the node on the grid.
@property (nonatomic) int x;
/// The y coordinate of the node on the grid.
@property (nonatomic) int y;
/// Whether this node can be walked through.
@property (nonatomic) BOOL walkable;
@property (nonatomic) BOOL opened;
@property (nonatomic) BOOL closed;

@property (nonatomic, weak) PFNode *parent;

-(NSComparisonResult)descFWeightSort:(PFNode *)anObject;

@end
