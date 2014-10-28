//
//  BaseFinder.m
//
//  Created by JasioWoo on 14/10/28.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import "BaseFinder.h"
#import "PFUtil.h"
#import "PFGrid.h"

@implementation BaseFinder

- (instancetype)init {
	self = [super init];
	if (self) {
		self.heuristicType = HeuristicTypeManhattan;
		self.heuristic = [self createHeuristicWithType:self.heuristicType];
		self.allowDiagonal = YES;
		self.dontCrossCorners = NO;
		self.weight = 1;
	}
	return self;
}

- (void)setHeuristicType:(HeuristicType)heuristicType {
	if (heuristicType != _heuristicType) {
		_heuristicType = heuristicType;
		self.heuristic = [self createHeuristicWithType:heuristicType];
	}
}

- (NSArray *)findPathInStartNode:(PFNode*)startNode toEndNode:(PFNode*)endNode withGrid:(PFGrid *)grid {
	return nil;
}



- (Heuristic *)createHeuristicWithType:(HeuristicType)type {
	Heuristic *result = nil;
	switch (type) {
		case HeuristicTypeManhattan:
			result = [[Manhattan alloc] init];
			break;
		case HeuristicTypeEuclidean:
			result = [[Euclidean alloc] init];
			break;
		case HeuristicTypeOctile:
			result = [[Octile alloc] init];
			break;
		case HeuristicTypeChebyshev:
			result = [[Chebyshev alloc] init];
			break;
		default:
			result = [[Manhattan alloc] init];
			break;
	}
	return result;
}

- (float)calculateHeuristicValueWithX:(float)dx andY:(float)dy {
	return [self.heuristic performAlgorithmWithX:dx andY:dy];
}



@end
