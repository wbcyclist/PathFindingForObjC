//
//  BreadthFirstFinder.m
//
//  Created by JasioWoo on 14/10/31.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import "BreadthFirstFinder.h"
#import "PFUtil.h"


@implementation BreadthFirstFinder


- (NSArray *)findPathInStartNode:(PFNode *)startNode toEndNode:(PFNode *)endNode withGrid:(PFGrid *)grid trackFinding:(NSMutableArray *__autoreleasing *)trackArrForTest {
	
	NSMutableArray *openList = [NSMutableArray array];
	PFNode *node = nil, *neighbor = nil;
	NSArray *neighbors = nil;
	NSUInteger l=0;
	int i=0;
	
	// push the start pos into the queue
	[openList addObject:startNode];
	startNode.opened = 1;
	
	// track
	if (trackArrForTest) {[(*trackArrForTest) addObject:[startNode copy]];}
	
	// while the queue is not empty
	while (openList.count>0) {
		// take the front node from the queue
		node = openList.firstObject;
		[openList removeObject:node];
		node.closed = YES;
		
		// track
		NSMutableArray *trackArr = nil;
		if (trackArrForTest) {
			[(*trackArrForTest) addObject:[node copy]];
			trackArr = [NSMutableArray array];
		}
		
		// reached the end position
		if (node == endNode) {
			return [PFUtil backtrace:endNode];
		}
		
		neighbors = [grid getNeighborsWith:node diagonalMovement:self.movementType];
		for (i = 0, l = neighbors.count; i < l; ++i) {
			neighbor = neighbors[i];
			
			// skip this neighbor if it has been inspected before
			if (neighbor.closed || neighbor.opened==1) {
				continue;
			}
			
			[openList addObject:neighbor];
			neighbor.opened = 1;
			neighbor.parent = node;
			
			// track
			if (trackArrForTest) { [trackArr addObject:[neighbor copy]]; }
		}
		// track
		if (trackArrForTest && trackArr.count>0) { [(*trackArrForTest) addObject:trackArr]; }
		
	} // end while not open list empty
	
	return nil;
}


@end
