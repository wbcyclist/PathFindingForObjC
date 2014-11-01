//
//  OrthogonalJumpPointFinder.m
//
//  Created by JasioWoo on 14/11/1.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import "OrthogonalJumpPointFinder.h"
#import "PFUtil.h"
#import "PFGrid.h"


@implementation OrthogonalJumpPointFinder



/**
 * Search recursively in the direction (parent -> child), stopping only when a
 * jump point is found.
 * @protected
 * @return {Array.<[number, number]>} The x, y coordinate of the jump point
 *     found, or null if not found
 */
- (PFNode *)jump:(PFNode*)nodeA withNode:(PFNode*)nodeB withEndNode:(PFNode*)endNode withGrid:(PFGrid *)grid {
	
	int x=nodeA.x, y=nodeA.y;
	int dx = nodeA.x - nodeB.x;
	int dy = nodeA.y - nodeB.y;
	if (!nodeA.walkable) {
		return nil;
	}
	
	//	if(this.trackJumpRecursion === true) {
	//		grid.getNodeAt(x, y).tested = true;
	//	}
	
	if (nodeA == endNode) {
		return nodeA;
	}
	
	if( dx != 0 ) {
		PFNode *t1Node = [grid getNodeAtX:(x) andY:(y - 1)];
		PFNode *t2Node = [grid getNodeAtX:(x - dx) andY:(y - 1)];
		PFNode *t3Node = [grid getNodeAtX:(x) andY:(y + 1)];
		PFNode *t4Node = [grid getNodeAtX:(x - dx) andY:(y + 1)];
		
		if((t1Node.walkable && !t2Node.walkable)
		   || (t3Node.walkable && !t4Node.walkable)) {
			return nodeA;
		}
		
	} else if (dy != 0) {
		PFNode *t1Node = [grid getNodeAtX:(x - 1) andY:(y)];
		PFNode *t2Node = [grid getNodeAtX:(x - 1) andY:(y - dy)];
		PFNode *t3Node = [grid getNodeAtX:(x + 1) andY:(y)];
		PFNode *t4Node = [grid getNodeAtX:(x + 1) andY:(y - dy)];
		
		if((t1Node.walkable && !t2Node.walkable)
		   || (t3Node.walkable && !t4Node.walkable)) {
			return nodeA;
		}
		//When moving vertically, must check for horizontal jump points
		if ([self jump:t3Node withNode:nodeA withEndNode:endNode withGrid:grid]
			|| [self jump:t1Node withNode:nodeA withEndNode:endNode withGrid:grid]) {
			return nodeA;
		}
		
	} else {
		NSException *ex = [NSException exceptionWithName:@"JumpSearchError"
												  reason:@"Only horizontal and vertical movements are allowed In OrthogonalJumpPointFinder"
												userInfo:@{@"nodeA":[nodeA copy], @"nodeB":[nodeB copy]}];
		[ex raise];
	}
	
	PFNode *cNode = [grid getNodeAtX:(x + dx) andY:(y + dy)];
	return [self jump:cNode withNode:nodeA withEndNode:endNode withGrid:grid];
}

/**
 * Find the neighbors for the given node. If the node has a parent,
 * prune the neighbors based on the jump point search algorithm, otherwise
 * return all available neighbors.
 * @return {Array.<[number, number]>} The neighbors found.
 */
- (NSArray *)findNeighbors:(PFNode *)node withGrid:(PFGrid *)grid {
	
	PFNode *parent = node.parent;
	NSMutableArray *neighbors = [NSMutableArray array];
	int x=node.x, y=node.y, dx, dy;
	
	// directed pruning: can ignore most neighbors, unless forced.
	if (parent) {
		// get the normalized direction of travel
		dx = (x - parent.x) / MAX(abs(x - parent.x), 1);
		dy = (y - parent.y) / MAX(abs(y - parent.y), 1);
		
		if (dx != 0) {
			PFNode *c1Node = [grid getNodeAtX:x andY:(y - 1)];
			PFNode *c2Node = [grid getNodeAtX:(x) andY:(y + 1)];
			PFNode *c3Node = [grid getNodeAtX:(x + dx) andY:y];
			
			if (c1Node.walkable) {
				[neighbors addObject:c1Node];
			}
			if (c2Node.walkable) {
				[neighbors addObject:c2Node];
			}
			if (c3Node.walkable) {
				[neighbors addObject:c3Node];
			}
			
		} else if (dy != 0) {
			PFNode *c1Node = [grid getNodeAtX:(x - 1) andY:(y)];
			PFNode *c2Node = [grid getNodeAtX:(x + 1) andY:(y)];
			PFNode *c3Node = [grid getNodeAtX:(x) andY:(y + dy)];
			
			if (c1Node.walkable) {
				[neighbors addObject:c1Node];
			}
			if (c2Node.walkable) {
				[neighbors addObject:c2Node];
			}
			if (c3Node.walkable) {
				[neighbors addObject:c3Node];
			}
		}
	}
	// return all neighbors
	else {
		NSArray *neighborNodes = [grid getNeighborsWith:node isAllowDiagonal:NO isCrossCorners:NO];
		PFNode *neighborNode=nil;
		for (int i=0; i<neighborNodes.count; i++) {
			neighborNode = neighborNodes[i];
			[neighbors addObject:neighborNode];
		}
	}
	
	return neighbors;
}





@end
