//
//  BreadthFirstFinder.m
//  PathFindingForObjC-Example
//
//  Created by JasioWoo on 14/10/31.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import "BreadthFirstFinder.h"
#import "PFUtil.h"
#import "PFGrid.h"


@implementation BreadthFirstFinder


- (NSArray *)findPathInStartNode:(PFNode *)startNode toEndNode:(PFNode *)endNode withGrid:(PFGrid *)grid traceFinding:(NSMutableArray *__autoreleasing *)traceArrForTest {
	
	NSMutableArray *openList = [NSMutableArray array];
	PFNode *node = nil, *neighbor = nil;
	NSArray *neighbors = nil;
	NSUInteger l=0;
	int i=0;
	
	// push the start pos into the queue
	[openList addObject:startNode];
	startNode.opened = 1;
	
	// trace
	if (traceArrForTest) {[(*traceArrForTest) addObject:[startNode copy]];}
	
	// while the queue is not empty
	while (openList.count>0) {
		// take the front node from the queue
		node = openList.firstObject;
		[openList removeObject:node];
		node.closed = true;
		
		// trace
		NSMutableArray *traceArr = nil;
		if (traceArrForTest) {
			[(*traceArrForTest) addObject:[node copy]];
			traceArr = [NSMutableArray array];
		}
		
		// reached the end position
		if (node == endNode) {
			return [PFUtil backtrace:endNode];
		}
		
		neighbors = [grid getNeighborsWith:node isAllowDiagonal:self.allowDiagonal isCrossCorners:self.dontCrossCorners];
		for (i = 0, l = neighbors.count; i < l; ++i) {
			neighbor = neighbors[i];
			
			// skip this neighbor if it has been inspected before
			if (neighbor.closed || neighbor.opened==1) {
				continue;
			}
			
			[openList addObject:neighbor];
			neighbor.opened = 1;
			neighbor.parent = node;
			
			// trace
			if (traceArrForTest) { [traceArr addObject:[neighbor copy]]; }
		}
		// trace
		if (traceArrForTest && traceArr.count>0) { [(*traceArrForTest) addObject:traceArr]; }
		
	} // end while not open list empty
	
	return nil;
}


@end
