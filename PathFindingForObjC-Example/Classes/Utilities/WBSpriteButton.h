//
//  WBSpriteButton.h
//  BalloonFight
//
//  Created by JasioWoo on 14/10/9.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_OPTIONS(NSUInteger, WBButtonControlEvent) {
	WBButtonControlEventNone			= 0,
	WBButtonControlEventTouchDown		= 1 << 0,
	WBButtonControlEventTouchUp			= 1 << 1,
	WBButtonControlEventTouchMoved		= 1 << 2,
	WBButtonControlEventTouchUpInside	= 1 << 3,
	WBButtonControlEventTouchUpOutside	= 1 << 4,
	WBButtonControlEventTouchCancel		= 1 << 5,
	WBButtonControlEventAllEvents		= 0xFFFFFFFF
};


@interface WBSpriteButton : SKSpriteNode

@property (nonatomic) BOOL isEnabled;
@property (nonatomic) BOOL isSelected;
@property (nonatomic) CGPoint touchPoint;
@property (nonatomic) WBButtonControlEvent controlEvent;
@property (nonatomic, readonly, strong) SKLabelNode *title;
@property (nonatomic, strong) SKTexture *normalButtonTexture;
@property (nonatomic, strong) SKTexture *selectedButtonTexture;
@property (nonatomic, strong) SKTexture *disabledButtonTexture;

- (id)initWithTextureNormal:(SKTexture *)normal selected:(SKTexture *)selected;
- (id)initWithTextureNormal:(SKTexture *)normal selected:(SKTexture *)selected disabled:(SKTexture *)disabled;

- (id)initWithImageNamedNormal:(NSString *)normal selected:(NSString *)selected;
- (id)initWithImageNamedNormal:(NSString *)normal selected:(NSString *)selected disabled:(NSString *)disabled;


- (void)addTarget:(id)target action:(SEL)action forControlEvents:(WBButtonControlEvent)controlEvents;


@end
