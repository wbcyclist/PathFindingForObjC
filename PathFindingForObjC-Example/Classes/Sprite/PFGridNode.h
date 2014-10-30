//
//  PFGridNode.h
//  PathFindingForObjC-Example
//
//  Created by JasioWoo on 14/10/29.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum {
	kGState_None = 0,
	kGState_Walkable,
	kGState_Start,
	kGState_End,
	kGState_Block,
	kGState_Open,
	kGState_Close
} GridNodeState;

@interface PFGridNode : SKSpriteNode

@property (nonatomic) BOOL showWeightValue;
@property (nonatomic) GridNodeState editState;		// ( kGState_Walkable \ kGState_Start \ kGState_End \ kGState_Block )
@property (nonatomic) GridNodeState searchState;	// ( kGState_None \ kGState_Open \ kGState_Close )

@property (nonatomic) CGFloat fValue;
@property (nonatomic) CGFloat gValue;
@property (nonatomic) CGFloat hValue;

@property (nonatomic) int x;
@property (nonatomic) int y;

@property (nonatomic, strong) SKColor *walkableColor;
@property (nonatomic, strong) SKColor *startColor;
@property (nonatomic, strong) SKColor *endColor;
@property (nonatomic, strong) SKColor *blockColor;
@property (nonatomic, strong) SKColor *openColor;
@property (nonatomic, strong) SKColor *closeColor;

- (BOOL)setupEditGridState:(GridNodeState)editState runAnimate:(BOOL)animate;

@end
