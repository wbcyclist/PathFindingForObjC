//
//  PFGridNode.m
//  PathFindingForObjC-Example
//
//  Created by JasioWoo on 14/10/29.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import "PFGridNode.h"

#define OFFSET (self.size.width*0.05)

@interface PFGridNode()
@property (nonatomic, retain) SKLabelNode *fLab;
@property (nonatomic, retain) SKLabelNode *gLab;
@property (nonatomic, retain) SKLabelNode *hLab;

@end

@implementation PFGridNode {
	
}

- (instancetype)initWithTexture:(SKTexture *)texture {
	self = [super initWithTexture:texture];
	if (self) {
		self.searchState = kGState_None;
		self.editState = kGState_Walkable;
		
		self.walkableColor = [SKColor colorWithRed:1 green:1 blue:1 alpha:0];
		self.startColor = [SKColor colorWithRed:51/255.0 green:218/255.0 blue:0 alpha:1];
		self.endColor = [SKColor colorWithRed:226/255.0 green:43/255.0 blue:0 alpha:1];
		self.blockColor = [SKColor colorWithRed:109/255.0 green:109/255.0 blue:109/255.0 alpha:1];
		self.openColor = [SKColor colorWithRed:145/255.0 green:254/255.0 blue:129/255.0 alpha:1];
		self.closeColor = [SKColor colorWithRed:165/255.0 green:235/255.0 blue:234/255.0 alpha:1];
	}
	return self;
}


-(SKLabelNode *)fLab {
	if (!_fLab) {
		SKLabelNode *lab = [SKLabelNode labelNodeWithFontNamed:@"Avenir-LightOblique"];
		lab.text = @"0";
		lab.fontColor = [SKColor blackColor];
		lab.fontSize = self.size.width*0.3;
		lab.hidden = YES;
		lab.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
		lab.position = CGPointMake(OFFSET-self.size.width/2.0, self.size.height-CGRectGetHeight(lab.frame)-OFFSET-self.size.height/2.0);
		[self addChild:lab];
		_fLab = lab;
	}
	return _fLab;
}

- (SKLabelNode *)gLab {
	if (!_gLab) {
		SKLabelNode *lab = [SKLabelNode labelNodeWithFontNamed:@"Avenir-LightOblique"];
		lab.text = @"0";
		lab.fontColor = [SKColor blackColor];
		lab.fontSize = self.size.width*0.3;
		lab.hidden = YES;
		lab.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
		lab.position = CGPointMake(OFFSET-self.size.width/2.0, CGRectGetHeight(lab.frame)+OFFSET-self.size.height/2.0);
		[self addChild:lab];
		_gLab = lab;
	}
	return _gLab;
}

-(SKLabelNode *)hLab {
	if (!_hLab) {
		SKLabelNode *lab = [SKLabelNode labelNodeWithFontNamed:@"Avenir-LightOblique"];
		lab.text = @"0";
		lab.fontColor = [SKColor blackColor];
		lab.fontSize = self.size.width*0.3;
		lab.hidden = YES;
		lab.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
		lab.position = CGPointMake(OFFSET-self.size.width/2.0, OFFSET-self.size.height/2.0);
		[self addChild:lab];
		_hLab = lab;
	}
	return _hLab;
}

- (void)setShowWeightValue:(BOOL)showWeightValue {
	if (_showWeightValue != showWeightValue) {
		_showWeightValue = showWeightValue;
		if (showWeightValue) {
			self.fLab.text = [NSString stringWithFormat:@"%d", (int)(_fValue*10)];
			self.gLab.text = [NSString stringWithFormat:@"%d", (int)(_gValue*10)];
			self.hLab.text = [NSString stringWithFormat:@"%d", (int)(_hValue*10)];
		}
		
		if (_searchState==kGState_Close || _searchState==kGState_Open) {
			self.fLab.hidden = !showWeightValue;
			self.gLab.hidden = !showWeightValue;
			self.hLab.hidden = !showWeightValue;
		} else {
			self.fLab.hidden = YES;
			self.gLab.hidden = YES;
			self.hLab.hidden = YES;
		}
	}
}

- (void)setFValue:(CGFloat)fValue {
	_fValue = fValue;
	self.fLab.text = [NSString stringWithFormat:@"%d", (int)(_fValue*10)];
}
- (void)setGValue:(CGFloat)gValue {
	_gValue = gValue;
	self.gLab.text = [NSString stringWithFormat:@"%d", (int)(_gValue*10)];
}
- (void)setHValue:(CGFloat)hValue {
	_hValue = hValue;
	self.hLab.text = [NSString stringWithFormat:@"%d", (int)(_hValue*10)];
}

- (void)updateGridColor:(GridNodeState)state runAnimate:(BOOL)animate {
	BOOL showWeightValue = NO;
	if (_searchState==kGState_Close || _searchState==kGState_Open) {
		showWeightValue = _showWeightValue;
	}
	
	SKColor *color;
	if (state==kGState_Walkable) {
		color = self.walkableColor;
		
	} else if (state==kGState_Start) {
		color = self.startColor;
		
	} else if (state==kGState_End) {
		color = self.endColor;
		
	} else if (state==kGState_Block) {
		showWeightValue = NO;
		color = self.blockColor;
		
	} else if (state==kGState_Open) {
		color = self.openColor;
		
	} else if (state==kGState_Close) {
		color = self.closeColor;
		
	} else {
		color = self.walkableColor;
	}
	
	self.fLab.hidden = !showWeightValue;
	self.gLab.hidden = !showWeightValue;
	self.hLab.hidden = !showWeightValue;
	[self removeAllActions];
	if (animate) {
		SKAction *colorAct = [SKAction colorizeWithColor:color colorBlendFactor:self.colorBlendFactor duration:0.1];
		SKAction *scaleAct = [SKAction sequence:@[[SKAction scaleTo:1.1 duration:0.1], [SKAction scaleTo:1 duration:0.1]]];
		[self runAction:[SKAction group:@[colorAct, scaleAct]]];
	} else {
		self.color = color;
		[self runAction:[SKAction scaleTo:1 duration:0]];
	}
}

- (void)setSearchState:(GridNodeState)searchState{
	if (_searchState!=searchState) {
		_searchState = searchState;
		if (_editState==kGState_Walkable) {
			[self updateGridColor:searchState runAnimate:YES];
		}
	}
}


- (BOOL)setupEditGridState:(GridNodeState)editState runAnimate:(BOOL)animate {
	if (_editState != editState) {
		if (_editState!=kGState_Walkable) {
			if (_editState==kGState_Block && editState==kGState_Walkable) {
				
			} else {
				return NO;
			}
		}
		
		_editState = editState;
		if (editState==kGState_Walkable) {
			[self updateGridColor:_searchState runAnimate:animate];
			
		} else if (editState==kGState_Start) {
			[self updateGridColor:editState runAnimate:animate];
			
		} else if (editState==kGState_End) {
			[self updateGridColor:editState runAnimate:animate];
			
		} else if (editState==kGState_Block) {
			[self updateGridColor:editState runAnimate:animate];
		}
		return YES;
	}
	return NO;
}




























@end
