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
		self.opened = NO;
		self.closed = NO;
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
	NSString *score = [NSString stringWithFormat:@"F:%.1f G:%.1f H:%.1f Opened:%@ Closed:%@", self.f, self.g, self.h, self.opened?@"YES":@"NO", self.closed?@"YES":@"NO"];
	return [NSString stringWithFormat:@"{%d, %d} %@", self.x, self.y, score];
}

@end
