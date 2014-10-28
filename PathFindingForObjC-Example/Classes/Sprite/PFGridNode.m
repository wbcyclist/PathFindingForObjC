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
	SKColor *lastColor;
}

- (instancetype)initWithTexture:(SKTexture *)texture {
	self = [super initWithTexture:texture];
	if (self) {
		lastColor = [SKColor colorWithRed:1 green:1 blue:1 alpha:0];
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
		lab.position = CGPointMake(OFFSET, self.size.height-CGRectGetHeight(lab.frame)-OFFSET);
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
		lab.position = CGPointMake(OFFSET, CGRectGetHeight(lab.frame)+OFFSET);
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
		lab.position = CGPointMake(OFFSET, OFFSET);
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
		self.fLab.hidden = !showWeightValue;
		self.gLab.hidden = !showWeightValue;
		self.hLab.hidden = !showWeightValue;
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
































@end
