//
//  AStarFinder.m
//
//  Created by JasioWoo on 14/10/28.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import "AStarFinder.h"

#import "PFUtil.h"


@implementation AStarFinder


- (NSArray *)findPathInStartNode:(PFNode *)startNode toEndNode:(PFNode *)endNode withGrid:(PFGrid *)grid trackFinding:(NSMutableArray *__autoreleasing *)trackArrForTest {
	
	NSMutableArray *openList = [NSMutableArray array];
	PFNode *node = nil, *neighbor = nil;
	NSArray *neighbors = nil;
	NSUInteger l=0;
	int i=0, x=0, y=0, endX=endNode.x, endY=endNode.y;
	float ng = 0;
	
	// set the `g` and `f` value of the start node to be 0
	startNode.g = 0;
	startNode.f = 0;
	
	// push the start node into the open list
	[openList addObject:startNode];
	startNode.opened = 1;
	
	// track
	if (trackArrForTest) {[(*trackArrForTest) addObject:[startNode copy]];}
	
	// while the open list is not empty
	while (openList.count>0) {
		// pop the position of node which has the minimum `f` value.
		[openList sortUsingSelector:@selector(descFWeightSort:)];
		node = [openList lastObject];
		[openList removeLastObject];
		node.closed = YES;
		
		// track
		NSMutableArray *trackArr = nil;
		if (trackArrForTest) {
			[(*trackArrForTest) addObject:[node copy]];
			trackArr = [NSMutableArray array];
		}
		
		// if reached the end position, construct the path and return it
		if (node == endNode) {
			return [PFUtil backtrace:endNode];
		}
		
		// get neigbours of the current node
		neighbors = [grid getNeighborsWith:node diagonalMovement:self.movementType];
		for (i = 0, l = neighbors.count; i < l; ++i) {
			neighbor = neighbors[i];
			
			if (neighbor.closed) {
				continue;
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
					[openList addObject:neighbor];
					neighbor.opened = 1;
				}
				
				// track
				if (trackArrForTest) { [trackArr addObject:[neighbor copy]]; }
			}
		} // end for each neighbor
		
		// track
		if (trackArrForTest && trackArr.count>0) { [(*trackArrForTest) addObject:trackArr]; }
	} // end while not open list empty
	
	// fail to find the path
	return nil;
}





@end
