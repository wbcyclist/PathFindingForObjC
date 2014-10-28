//
//  WBSpriteButton.m
//  BalloonFight
//
//  Created by JasioWoo on 14/10/9.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import "WBSpriteButton.h"

#define SuppressPerformSelectorLeakWarning(Stuff) \
	do { \
		_Pragma("clang diagnostic push") \
		_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
		Stuff; \
		_Pragma("clang diagnostic pop") \
	} while (0)


@interface WBSpriteButton ()

//	NSValue(SEL) - Target
@property (nonatomic, retain) NSMapTable *eventTouchDownMap;
@property (nonatomic, retain) NSMapTable *eventTouchUpMap;
@property (nonatomic, retain) NSMapTable *eventTouchMovedMap;
@property (nonatomic, retain) NSMapTable *eventTouchUpInsideMap;
@property (nonatomic, retain) NSMapTable *eventTouchUpOutsideMap;
@property (nonatomic, retain) NSMapTable *eventTouchCancelMap;
@property (nonatomic, retain) NSMapTable *eventTouchAllMap;


@end


@implementation WBSpriteButton

#pragma mark - setter&getter
-(NSMapTable *)eventTouchDownMap {
	if (!_eventTouchDownMap) {
		_eventTouchDownMap = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory
												   valueOptions:NSMapTableWeakMemory];
	}
	return _eventTouchDownMap;
}
-(NSMapTable *)eventTouchUpMap {
	if (!_eventTouchUpMap) {
		_eventTouchUpMap = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory
												 valueOptions:NSMapTableWeakMemory];
	}
	return _eventTouchUpMap;
}
-(NSMapTable *)eventTouchMovedMap {
	if (!_eventTouchMovedMap) {
		_eventTouchMovedMap = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory
												 valueOptions:NSMapTableWeakMemory];
	}
	return _eventTouchMovedMap;
}
-(NSMapTable *)eventTouchUpInsideMap {
	if (!_eventTouchUpInsideMap) {
		_eventTouchUpInsideMap = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory
													   valueOptions:NSMapTableWeakMemory];
	}
	return _eventTouchUpInsideMap;
}
-(NSMapTable *)eventTouchUpOutsideMap {
	if (!_eventTouchUpOutsideMap) {
		_eventTouchUpOutsideMap = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory
													   valueOptions:NSMapTableWeakMemory];
	}
	return _eventTouchUpOutsideMap;
}
-(NSMapTable *)eventTouchCancelMap {
	if (!_eventTouchCancelMap) {
		_eventTouchCancelMap = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory
													   valueOptions:NSMapTableWeakMemory];
	}
	return _eventTouchCancelMap;
}
-(NSMapTable *)eventTouchAllMap {
	if (!_eventTouchAllMap) {
		_eventTouchAllMap = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory
												  valueOptions:NSMapTableWeakMemory];
	}
	return _eventTouchAllMap;
}

- (void)setIsEnabled:(BOOL)isEnabled {
	_isEnabled = isEnabled;
	if (self.disabledButtonTexture) {
		if (!_isEnabled) {
			[self setTexture:_disabledButtonTexture];
		} else {
			[self setTexture:_normalButtonTexture];
		}
	}
}

- (void)setIsSelected:(BOOL)isSelected {
	_isSelected = isSelected;
	if (self.selectedButtonTexture && self.isEnabled) {
		if (_isSelected) {
			[self setTexture:_selectedButtonTexture];
		} else {
			[self setTexture:_normalButtonTexture];
		}
	}
}

#pragma mark - Texture Init
- (id)initWithTextureNormal:(SKTexture *)normal selected:(SKTexture *)selected {
	return [self initWithTextureNormal:normal selected:selected disabled:nil];
}

- (id)initWithTextureNormal:(SKTexture *)normal selected:(SKTexture *)selected disabled:(SKTexture *)disabled {
	self = [super initWithTexture:normal];
	if (self) {
		self.controlEvent = WBButtonControlEventNone;
		[self setNormalButtonTexture:normal];
		[self setSelectedButtonTexture:selected];
		[self setDisabledButtonTexture:disabled];
		[self setIsEnabled:YES];
		[self setIsSelected:NO];
		
		_title = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
		_title.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
		_title.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
		[self addChild:_title];
		
		self.userInteractionEnabled = YES;
	}
	return self;
}

#pragma mark - Image Init
- (id)initWithImageNamedNormal:(NSString *)normal selected:(NSString *)selected {
	return [self initWithImageNamedNormal:normal selected:selected disabled:nil];
}

- (id)initWithImageNamedNormal:(NSString *)normal selected:(NSString *)selected disabled:(NSString *)disabled {
	SKTexture *textureNormal = nil;
	if (normal) {
		textureNormal = [SKTexture textureWithImageNamed:normal];
	}
	
	SKTexture *textureSelected = nil;
	if (selected) {
		textureSelected = [SKTexture textureWithImageNamed:selected];
	}
	
	SKTexture *textureDisabled = nil;
	if (disabled) {
		textureDisabled = [SKTexture textureWithImageNamed:disabled];
	}
	
	return [self initWithTextureNormal:textureNormal selected:textureSelected disabled:textureDisabled];
}


#pragma mark -
- (void)dealloc {
	if (_eventTouchDownMap) {
		[_eventTouchDownMap removeAllObjects];
	}
	if (_eventTouchUpMap) {
		[_eventTouchUpMap removeAllObjects];
	}
	if (_eventTouchMovedMap) {
		[_eventTouchMovedMap removeAllObjects];
	}
	if (_eventTouchUpInsideMap) {
		[_eventTouchUpInsideMap removeAllObjects];
	}
	if (_eventTouchUpOutsideMap) {
		[_eventTouchUpOutsideMap removeAllObjects];
	}
	if (_eventTouchCancelMap) {
		[_eventTouchCancelMap removeAllObjects];
	}
	if (_eventTouchAllMap) {
		[_eventTouchAllMap removeAllObjects];
	}
}

#pragma mark - Setting Target-Action
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(WBButtonControlEvent)controlEvents {
	switch (controlEvents) {
		case WBButtonControlEventTouchDown:
			[self.eventTouchDownMap setObject:target forKey:[NSValue valueWithPointer:action]];
			break;
		case WBButtonControlEventTouchUp:
			[self.eventTouchUpMap setObject:target forKey:[NSValue valueWithPointer:action]];
			break;
		case WBButtonControlEventTouchMoved:
			[self.eventTouchMovedMap setObject:target forKey:[NSValue valueWithPointer:action]];
			break;
		case WBButtonControlEventTouchUpInside:
			[self.eventTouchUpInsideMap setObject:target forKey:[NSValue valueWithPointer:action]];
			break;
		case WBButtonControlEventTouchUpOutside:
			[self.eventTouchUpOutsideMap setObject:target forKey:[NSValue valueWithPointer:action]];
			break;
		case WBButtonControlEventTouchCancel:
			[self.eventTouchCancelMap setObject:target forKey:[NSValue valueWithPointer:action]];
			break;
		case WBButtonControlEventAllEvents:
			[self.eventTouchAllMap setObject:target forKey:[NSValue valueWithPointer:action]];
			break;
			
		default:
			return;
	}
}

-(void)controlEventOccured:(WBButtonControlEvent)controlEvent {
	NSMapTable *mapTable = nil;
	switch (controlEvent) {
		case WBButtonControlEventTouchDown:
			mapTable = _eventTouchDownMap;
			break;
		case WBButtonControlEventTouchUp:
			mapTable = _eventTouchUpMap;
			break;
		case WBButtonControlEventTouchMoved:
			mapTable = _eventTouchMovedMap;
			break;
		case WBButtonControlEventTouchUpInside:
			mapTable = _eventTouchUpInsideMap;
			break;
		case WBButtonControlEventTouchUpOutside:
			mapTable = _eventTouchUpOutsideMap;
			break;
		case WBButtonControlEventTouchCancel:
			mapTable = _eventTouchCancelMap;
			break;
		case WBButtonControlEventAllEvents:
			mapTable = _eventTouchAllMap;
			break;
			
		default:
			return;
	}
	if (mapTable) {
		NSEnumerator *enumerator = mapTable.keyEnumerator;
		NSValue *keyValue = nil;;
		while (keyValue = [enumerator nextObject]) {
			id target = [mapTable objectForKey:keyValue];
			if (target) {
				SuppressPerformSelectorLeakWarning([target performSelector:[keyValue pointerValue] withObject:self]);
			}
		}
	}
	
}


#if TARGET_OS_IPHONE
#pragma mark - Event Handling - iOS
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if ([self isEnabled]) {
		UITouch *touch = [touches anyObject];
		CGPoint touchPoint = [touch locationInNode:self.parent];
		self.touchPoint = touchPoint;
		self.controlEvent = WBButtonControlEventTouchDown;
		[self setIsSelected:YES];
		[self controlEventOccured:WBButtonControlEventTouchDown];
		[self controlEventOccured:WBButtonControlEventAllEvents];
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if ([self isEnabled]) {
		self.controlEvent = WBButtonControlEventTouchMoved;
		UITouch *touch = [touches anyObject];
		CGPoint touchPoint = [touch locationInNode:self.parent];
		self.touchPoint = touchPoint;
		if (CGRectContainsPoint(self.frame, touchPoint)) {
			[self setIsSelected:YES];
		} else {
			[self setIsSelected:NO];
		}
		[self controlEventOccured:WBButtonControlEventTouchMoved];
		[self controlEventOccured:WBButtonControlEventAllEvents];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if ([self isEnabled]) {
		UITouch *touch = [touches anyObject];
		CGPoint touchPoint = [touch locationInNode:self.parent];
		[self setIsSelected:NO];
		if (CGRectContainsPoint(self.frame, touchPoint)) {
			self.controlEvent = WBButtonControlEventTouchUp | WBButtonControlEventTouchUpInside;
			[self controlEventOccured:WBButtonControlEventTouchUpInside];
		} else {
			self.controlEvent = WBButtonControlEventTouchUp | WBButtonControlEventTouchUpOutside;
			[self controlEventOccured:WBButtonControlEventTouchUpOutside];
		}
		[self controlEventOccured:WBButtonControlEventTouchUp];
		[self controlEventOccured:WBButtonControlEventAllEvents];
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	if ([self isEnabled]) {
		[self setIsSelected:NO];
		self.controlEvent = WBButtonControlEventTouchCancel;
		[self controlEventOccured:WBButtonControlEventTouchCancel];
		[self controlEventOccured:WBButtonControlEventAllEvents];
	}
}
#else

#pragma mark - Event Handling - OS X










#endif





@end
