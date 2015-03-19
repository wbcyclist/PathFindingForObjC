//
//  JPFNeverMoveDiagonally.m
//
//  Created by JasioWoo on 15/3/17.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "JPFNeverMoveDiagonally.h"

@implementation JPFNeverMoveDiagonally


/**
 * Search recursively in the direction (parent -> child), stopping only when a
 * jump point is found.
 * @protected
 * @return {Array.<[number, number]>} The x, y coordinate of the jump point
 *     found, or null if not found
 */
- (PFNode *)jump:(PFNode*)nodeA withNode:(PFNode*)nodeB withEndNode:(PFNode*)endNode withGrid:(PFGrid *)grid andTrackArr:(NSMutableArray*)trackArr {
	
	int x=nodeA.x, y=nodeA.y;
	int dx = nodeA.x - nodeB.x;
	int dy = nodeA.y - nodeB.y;
	if (!nodeA.walkable) {
		return nil;
	}
	
	if(trackArr) {
		nodeA.tested = YES;
		[trackArr addObject:[nodeA copy]];
	}
	
	if (nodeA == endNode) {
		return nodeA;
	}
	
	
	if (dx != 0) {
		PFNode *t1Node = [grid getNodeAtX:(x) andY:(y - 1)];
		PFNode *t2Node = [grid getNodeAtX:(x - dx) andY:(y - 1)];
		PFNode *t3Node = [grid getNodeAtX:(x) andY:(y + 1)];
		PFNode *t4Node = [grid getNodeAtX:(x - dx) andY:(y + 1)];
		
		if ((t1Node.walkable && !t2Node.walkable)
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
//		PFNode *reNodeA1 = [grid getNodeAtX:(x + 1) andY:(y)];
//		PFNode *reNodeA2 = [grid getNodeAtX:(x - 1) andY:(y)];
		if ([self jump:t3Node withNode:nodeA withEndNode:endNode withGrid:grid andTrackArr:trackArr]
			|| [self jump:t1Node withNode:nodeA withEndNode:endNode withGrid:grid andTrackArr:trackArr]) {
			return nodeA;
		}
	} else {
		// throw new Error("Only horizontal and vertical movements are allowed");
		NSAssert(NO, @"Only horizontal and vertical movements are allowed");
	}
	
	PFNode *reNode = [grid getNodeAtX:(x + dx) andY:(y + dy)];
	return [self jump:reNode withNode:nodeA withEndNode:endNode withGrid:grid andTrackArr:trackArr];
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
		
		PFNode *c1Node, *c2Node, *c3Node;
		
		if (dx != 0) {
			c1Node = [grid getNodeAtX:x andY:(y - 1)];
			c2Node = [grid getNodeAtX:x andY:(y + 1)];
			c3Node = [grid getNodeAtX:(x + dx) andY:y];
			
		} else if (dy != 0) {
			c1Node = [grid getNodeAtX:(x - 1) andY:y];
			c2Node = [grid getNodeAtX:(x + 1) andY:y];
			c3Node = [grid getNodeAtX:x andY:(y + dy)];
		}
		
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
	// return all neighbors
	else {
		
		NSArray *neighborNodes = [grid getNeighborsWith:node diagonalMovement:DiagonalMovement_Never];
		PFNode *neighborNode=nil;
		for (int i=0; i<neighborNodes.count; i++) {
			neighborNode = neighborNodes[i];
			[neighbors addObject:neighborNode];
		}
	}
	
	return neighbors;
}




@end
