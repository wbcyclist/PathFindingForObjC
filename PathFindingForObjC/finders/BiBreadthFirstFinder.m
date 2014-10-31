//
//  BiBreadthFirstFinder.m
//  PathFindingForObjC-Example
//
//  Created by JasioWoo on 14/10/31.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import "BiBreadthFirstFinder.h"
#import "PFUtil.h"
#import "PFGrid.h"

#define BY_START	1
#define BY_END		2

@implementation BiBreadthFirstFinder


- (NSArray *)findPathInStartNode:(PFNode *)startNode toEndNode:(PFNode *)endNode withGrid:(PFGrid *)grid traceFinding:(NSMutableArray *__autoreleasing *)traceArrForTest {
	
	NSMutableArray *startOpenList = [NSMutableArray array];
	NSMutableArray *endOpenList = [NSMutableArray array];
	PFNode *node = nil, *neighbor = nil;
	NSArray *neighbors = nil;
	NSUInteger l=0;
	int i=0;
	
	// push the start and end nodes into the queues
	[startOpenList addObject:startNode];
	startNode.opened = BY_START;
	
	[endOpenList addObject:endNode];
	endNode.opened = BY_END;
	
	// trace
	if (traceArrForTest) {
		NSMutableArray *traceArr = [NSMutableArray array];
		[traceArr addObject:[startNode copy]];
		[traceArr addObject:[endNode copy]];
		[(*traceArrForTest) addObject:traceArr];
	}
	
	// while both the queues are not empty
	while (startOpenList.count>0 && endOpenList.count>0) {
		
	// expand start open list
		node = startOpenList.firstObject;
		[startOpenList removeObject:node];
		node.closed = true;
		
		// trace
		NSMutableArray *traceArr = nil;
		if (traceArrForTest) {
			[(*traceArrForTest) addObject:[node copy]];
			traceArr = [NSMutableArray array];
		}
		
		neighbors = [grid getNeighborsWith:node isAllowDiagonal:self.allowDiagonal isCrossCorners:self.dontCrossCorners];
		for (i = 0, l = neighbors.count; i < l; ++i) {
			neighbor = neighbors[i];
			
			if (neighbor.closed) {
				continue;
			}
			if (neighbor.opened>0) {
				// if this node has been inspected by the reversed search,
				// then a path is found.
				if (neighbor.opened == BY_END) {
					return [PFUtil biBacktraceWithNodeA:node andNodeB:neighbor];
				}
				continue;
			}
			[startOpenList addObject:neighbor];
			neighbor.parent = node;
			neighbor.opened = BY_START;
			
			// trace
			if (traceArrForTest) { [traceArr addObject:[neighbor copy]]; }
		}
		// trace
		if (traceArrForTest && traceArr.count>0) { [(*traceArrForTest) addObject:traceArr]; }
		
	// expand end open list
		node = endOpenList.firstObject;
		[endOpenList removeObject:node];
		node.closed = true;
		
		// trace
		if (traceArrForTest) {
			[(*traceArrForTest) addObject:[node copy]];
			traceArr = [NSMutableArray array];
		}
		
		neighbors = [grid getNeighborsWith:node isAllowDiagonal:self.allowDiagonal isCrossCorners:self.dontCrossCorners];
		for (i = 0, l = neighbors.count; i < l; ++i) {
			neighbor = neighbors[i];
			
			if (neighbor.closed) {
				continue;
			}
			if (neighbor.opened>0) {
				if (neighbor.opened == BY_START) {
					return [PFUtil biBacktraceWithNodeA:neighbor andNodeB:node];
				}
				continue;
			}
			[endOpenList addObject:neighbor];
			neighbor.parent = node;
			neighbor.opened = BY_END;
			
			// trace
			if (traceArrForTest) { [traceArr addObject:[neighbor copy]]; }
		}
		// trace
		if (traceArrForTest && traceArr.count>0) { [(*traceArrForTest) addObject:traceArr]; }
		
	} // end while not open list empty
	
	return nil;
}


@end
