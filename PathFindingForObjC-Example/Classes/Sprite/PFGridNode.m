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
@property (nonatomic, retain) SKSpriteNode *arrow;

@end

@implementation PFGridNode {
	
}

- (instancetype)initWithTexture:(SKTexture *)texture {
	self = [super initWithTexture:texture];
	if (self) {
		_direction = 0;
		self.searchState = kGState_None;
		self.editState = kGState_Walkable;
		
		self.walkableColor	= [SKColor colorWithRed:1 green:1 blue:1 alpha:0];
		self.startColor		= [SKColor colorWithRed:25/255.0 green:117/255.0 blue:248/255.0 alpha:1];
		self.endColor		= [SKColor colorWithRed:226/255.0 green:43/255.0 blue:0 alpha:1];
		self.blockColor		= [SKColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1];
		self.openColor		= [SKColor colorWithRed:145/255.0 green:254/255.0 blue:129/255.0 alpha:1];
		self.closeColor		= [SKColor colorWithRed:165/255.0 green:235/255.0 blue:234/255.0 alpha:1];
		self.testedColor	= [SKColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1];
	}
	return self;
}

//static int COLOR_MAX = 222235247;
//static int COLOR_MIN = 49130189;
//static int COLOR_DIF = COLOR_MAX-COLOR_MIN;
//- (SKColor*)getColorBrewerRange:(CGFloat)rate {
//	
//	
//}

- (SKSpriteNode *)arrow {
	if (!_arrow) {
		_arrow = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"arrow"] size:self.size];
		_arrow.texture.filteringMode = SKTextureFilteringNearest;
		_arrow.userInteractionEnabled = NO;
		[self addChild:_arrow];
	}
	return _arrow;
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

-(void)setCostValue:(CGFloat)costValue {
	_costValue = costValue;
	if (costValue==0) {
		return;
	}
	_searchState = kGState_Close;
	self.fLab.text = [NSString stringWithFormat:@"%d", (int)costValue];
	self.fLab.hidden = !_showWeightValue;
	
	[self removeAllActions];
	costValue = MIN(costValue*20, 255);
	SKColor *color = [SKColor colorWithRed:costValue/255.0 green:117/255.0 blue:248/255.0 alpha:1];;
	
	SKAction *colorAct = [SKAction colorizeWithColor:color colorBlendFactor:1 duration:0.1];
	SKAction *scaleAct = [SKAction sequence:@[[SKAction scaleTo:1.1 duration:0.1], [SKAction scaleTo:1 duration:0.1]]];
	[self runAction:[SKAction group:@[colorAct, scaleAct]]];
	
	
}

- (void)setColorFactor:(CGFloat)colorFactor {
	_colorFactor = colorFactor;
	self.colorBlendFactor = colorFactor;
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
		
	} else if (state==kGState_Tested) {
		color = self.testedColor;
		
	} else {
		color = self.walkableColor;
	}
	
	self.fLab.hidden = !showWeightValue;
	self.gLab.hidden = !showWeightValue;
	self.hLab.hidden = !showWeightValue;
	[self removeAllActions];
	if (animate) {
		SKAction *colorAct = [SKAction colorizeWithColor:color colorBlendFactor:self.colorFactor duration:0.1];
		SKAction *scaleAct = [SKAction sequence:@[[SKAction scaleTo:1.1 duration:0.1], [SKAction scaleTo:1 duration:0.1]]];
		[self runAction:[SKAction group:@[colorAct, scaleAct]]];
	} else {
		self.color = color;
		self.colorBlendFactor = self.colorFactor;
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



- (void)setDirection:(int)direction vector:(CGVector)vec {
	
	
	if (vec.dx==0 && vec.dy==0) {
		self.arrow.hidden = YES;
	} else {
		CGFloat ang = WB_POLAR_ADJUST(WB_RadiansBetweenPoints(CGPointMake(vec.dx, vec.dy), CGPointMake(0, 0)));
		self.arrow.hidden = NO;
		self.arrow.zRotation = ang;
	}
	self.gLab.text = [NSString stringWithFormat:@"%d", (int)vec.dx];
	self.gLab.hidden = !_showWeightValue;
	self.hLab.text = [NSString stringWithFormat:@"%d", (int)vec.dy];
	self.hLab.hidden = !_showWeightValue;
	
	
//	_direction = direction;
//	if (direction==0) {
//		self.arrow.hidden = YES;
//	} else if (direction==2) {
//		self.arrow.hidden = NO;
//		self.arrow.zRotation = M_PI;
//	} else if (direction==4) {
//		self.arrow.hidden = NO;
//		self.arrow.zRotation = M_PI/2;
//	} else if (direction==6) {
//		self.arrow.hidden = NO;
//		self.arrow.zRotation = 0;
//	} else if (direction==8) {
//		self.arrow.hidden = NO;
//		self.arrow.zRotation = -M_PI/2;
//	}
	
	
	
}
























@end
