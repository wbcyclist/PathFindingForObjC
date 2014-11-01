//
//  FNode.m
//
//  Created by JasioWoo on 14/10/27.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import "PFNode.h"

@implementation PFNode

- (instancetype)init {
	self = [super init];
	if (self) {
		self.f = 0;
		self.g = 0;
		self.h = 0;
		self.walkable = YES;
		self.opened = 0;
		self.closed = NO;
		self.tested = NO;
	}
	return self;
}

- (instancetype)initWithX:(int)x andY:(int)y {
	self = [self init];
	if (self) {
		self.x = x;
		self.y = y;
	}
	return self;
}

- (id)copyWithZone:(NSZone *)zone {
	PFNode *copy = [[PFNode alloc] init];
	copy.f = self.f;
	copy.g = self.g;
	copy.h = self.h;
	copy.x = self.x;
	copy.y = self.y;
	copy.weight = self.weight;
	copy.walkable = self.walkable;
	copy.opened = self.opened;
	copy.closed = self.closed;
	copy.tested = self.tested;
	return copy;
}

- (NSComparisonResult)descFWeightSort:(PFNode *)anObject {
	if (self.f > anObject.f) {
		return NSOrderedAscending;
	} else if (self.f < anObject.f) {
		return NSOrderedDescending;
	} else {
		return NSOrderedSame;
	}
}


//- (void)dealloc {
//	debugMethod();
//}

- (NSString *)description {
	NSString *score = [NSString stringWithFormat:@"F:%.1f G:%.1f H:%.1f Opened:%d Closed:%@", self.f, self.g, self.h, self.opened, self.closed?@"YES":@"NO"];
	return [NSString stringWithFormat:@"{%d, %d} %@", self.x, self.y, score];
}

@end
