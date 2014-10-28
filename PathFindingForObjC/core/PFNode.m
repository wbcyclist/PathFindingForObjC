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
	}
	return self;
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
	NSString *score = [NSString stringWithFormat:@"F:%.1f\tG:%.1f\tH:%.1f", self.f, self.g, self.h];
	return [NSString stringWithFormat:@"{%d, %d}\t%@", self.x, self.y, score];
}

@end
