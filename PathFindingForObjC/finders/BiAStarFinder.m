//
//  BiAStarFinder.m
//  PathFindingForObjC-Example
//
//  Created by JasioWoo on 14/10/31.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import "BiAStarFinder.h"
#import "PFUtil.h"
#import "PFGrid.h"

#define BY_START	1
#define BY_END		2

@implementation BiAStarFinder

- (NSArray *)findPathInStartNode:(PFNode *)startNode toEndNode:(PFNode *)endNode withGrid:(PFGrid *)grid traceFinding:(NSMutableArray *__autoreleasing *)traceArrForTest {
	
	NSMutableArray *startOpenList = [NSMutableArray array];
	NSMutableArray *endOpenList = [NSMutableArray array];
	PFNode *node = nil, *neighbor = nil;
	NSArray *neighbors = nil;
	NSUInteger l=0;
	int i=0, x=0, y=0, endX=endNode.x, endY=endNode.y;
	float ng = 0;
	
	// set the `g` and `f` value of the start node to be 0
	// and push it into the start open list
	startNode.g = 0;
	startNode.f = 0;
	[startOpenList addObject:startNode];
	startNode.opened = BY_START;
	
	// set the `g` and `f` value of the end node to be 0
	// and push it into the open open list
	endNode.g = 0;
	endNode.f = 0;
	[endOpenList addObject:endNode];
	endNode.opened = BY_END;
	
	// trace
	if (traceArrForTest) {
		NSMutableArray *traceArr = [NSMutableArray array];
		[traceArr addObject:[startNode copy]];
		[traceArr addObject:[endNode copy]];
		[(*traceArrForTest) addObject:traceArr];
	}
	
	// while both the open lists are not empty
	while (startOpenList.count>0 && endOpenList.count>0) {
		
// startOpenList
		// pop the position of start node which has the minimum `f` value.
		[startOpenList sortUsingSelector:@selector(descFWeightSort:)];
		node = [startOpenList lastObject];
		[startOpenList removeLastObject];
		node.closed = YES;
		
		// trace
		NSMutableArray *traceArr = nil;
		if (traceArrForTest) {
			[(*traceArrForTest) addObject:[node copy]];
			traceArr = [NSMutableArray array];
		}
		
		// get neigbours of the current node
		neighbors = [grid getNeighborsWith:node isAllowDiagonal:self.allowDiagonal isCrossCorners:self.dontCrossCorners];
		for (i = 0, l = neighbors.count; i < l; ++i) {
			neighbor = neighbors[i];
			
			if (neighbor.closed) {
				continue;
			}
			if (neighbor.opened == BY_END) {
				return [PFUtil biBacktraceWithNodeA:node andNodeB:neighbor];
			}
			
			x = neighbor.x;
			y = neighbor.y;
			
			// get the distance between current node and the neighbor
			// and calculate the next g score
//			ng = node.g + ((x-node.x == 0 || y-node.y == 0) ? 1 : M_SQRT2);
			ng = node.g + ((x-node.x == 0 || y-node.y == 0) ? 1 : 1.4);
			
			// check if the neighbor has not been inspected yet, or
			// can be reached with smaller cost from the current node
			if (neighbor.opened==0 || ng < neighbor.g) {
				neighbor.g = ng;
				neighbor.h = neighbor.h==0 ? self.weight * [self calculateHeuristicValueWithX:abs(x - endX) andY:abs(y - endY)] : neighbor.h;
				neighbor.f = neighbor.g + neighbor.h;
				neighbor.parent = node;
				
				if (neighbor.opened==0) {
					[startOpenList addObject:neighbor];
					neighbor.opened = BY_START;
				}
				
				// trace
				if (traceArrForTest) { [traceArr addObject:[neighbor copy]]; }
			}
		} // end for each neighbor
		
		// trace
		if (traceArrForTest && traceArr.count>0) { [(*traceArrForTest) addObject:traceArr]; }
		
// endOpenList
		// pop the position of end node which has the minimum `f` value.
		[endOpenList sortUsingSelector:@selector(descFWeightSort:)];
		node = [endOpenList lastObject];
		[endOpenList removeLastObject];
		node.closed = YES;
		
		// trace
		if (traceArrForTest) {
			[(*traceArrForTest) addObject:[node copy]];
			traceArr = [NSMutableArray array];
		}
		
		// get neigbours of the current node
		neighbors = [grid getNeighborsWith:node isAllowDiagonal:self.allowDiagonal isCrossCorners:self.dontCrossCorners];
		for (i = 0, l = neighbors.count; i < l; ++i) {
			neighbor = neighbors[i];
			
			if (neighbor.closed) {
				continue;
			}
			if (neighbor.opened == BY_START) {
				return [PFUtil biBacktraceWithNodeA:neighbor andNodeB:node];
			}
			
			x = neighbor.x;
			y = neighbor.y;
			
			// get the distance between current node and the neighbor
			// and calculate the next g score
			ng = node.g + ((x-node.x == 0 || y-node.y == 0) ? 1 : 1.4);
			
			// check if the neighbor has not been inspected yet, or
			// can be reached with smaller cost from the current node
			if (neighbor.opened==0 || ng < neighbor.g) {
				neighbor.g = ng;
				neighbor.h = neighbor.h==0 ? self.weight * [self calculateHeuristicValueWithX:abs(x - endX) andY:abs(y - endY)] : neighbor.h;
				neighbor.f = neighbor.g + neighbor.h;
				neighbor.parent = node;
				
				if (neighbor.opened==0) {
					[endOpenList addObject:neighbor];
					neighbor.opened = BY_END;
				}
				
				// trace
				if (traceArrForTest) { [traceArr addObject:[neighbor copy]]; }
			}
		} // end for each neighbor
		
		// trace
		if (traceArrForTest && traceArr.count>0) { [(*traceArrForTest) addObject:traceArr]; }
		
	} // end while not open list empty
	
	// fail to find the path
	return nil;
}






@end
