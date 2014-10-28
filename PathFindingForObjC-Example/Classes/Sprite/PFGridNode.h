//
//  PFGridNode.h
//  PathFindingForObjC-Example
//
//  Created by JasioWoo on 14/10/29.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface PFGridNode : SKSpriteNode

@property (nonatomic) BOOL showWeightValue;
@property (nonatomic) BOOL isStart;
@property (nonatomic) BOOL isEnd;
@property (nonatomic) BOOL isBlock;

@property (nonatomic) CGFloat fValue;
@property (nonatomic) CGFloat gValue;
@property (nonatomic) CGFloat hValue;

@property (nonatomic) int x;
@property (nonatomic) int y;

@property (nonatomic, strong) SKColor *startColor;
@property (nonatomic, strong) SKColor *endColor;
@property (nonatomic, strong) SKColor *blockColor;
@property (nonatomic, strong) SKColor *openColor;
@property (nonatomic, strong) SKColor *closeColor;

@end
