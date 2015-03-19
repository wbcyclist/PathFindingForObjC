//
//  JPFMoveDiagonallyIfNoObstacles.m
//
//  Created by JasioWoo on 15/3/19.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "JPFMoveDiagonallyIfNoObstacles.h"

@implementation JPFMoveDiagonallyIfNoObstacles




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
	
	// check for forced neighbors
	// along the diagonal
	if (dx != 0 && dy != 0) {
		// when moving diagonally, must check for vertical/horizontal jump points
		PFNode *t1Node = [grid getNodeAtX:(x + dx) andY:(y)];
		PFNode *t2Node = [grid getNodeAtX:(x) andY:(y + dy)];
		if ([self jump:t1Node withNode:nodeA withEndNode:endNode withGrid:grid andTrackArr:trackArr]
			|| [self jump:t2Node withNode:nodeA withEndNode:endNode withGrid:grid andTrackArr:trackArr]) {
			return nodeA;
		}
	}
	// horizontally/vertically
	else {
		if( dx != 0 ) { // moving along x
			PFNode *t1Node = [grid getNodeAtX:(x) andY:(y - 1)];
			PFNode *t2Node = [grid getNodeAtX:(x - dx) andY:(y - 1)];
			PFNode *t3Node = [grid getNodeAtX:(x) andY:(y + 1)];
			PFNode *t4Node = [grid getNodeAtX:(x - dx) andY:(y + 1)];
			
			if((t1Node.walkable && !t2Node.walkable)
			   || (t3Node.walkable && !t4Node.walkable)) {
				return nodeA;
			}
		}
		else if(dy != 0) {
			PFNode *t1Node = [grid getNodeAtX:(x - 1) andY:(y)];
			PFNode *t2Node = [grid getNodeAtX:(x - 1) andY:(y - dy)];
			PFNode *t3Node = [grid getNodeAtX:(x + 1) andY:(y)];
			PFNode *t4Node = [grid getNodeAtX:(x + 1) andY:(y - dy)];
			
			if((t1Node.walkable && !t2Node.walkable)
			   || (t3Node.walkable && !t4Node.walkable)) {
				return nodeA;
			}
			
			// When moving vertically, must check for horizontal jump points
			// if (this._jump(x + 1, y, x, y) || this._jump(x - 1, y, x, y)) {
			//	return [x, y];
			// }
		}
	}
	
	// moving diagonally, must make sure one of the vertical/horizontal
	// neighbors is open to allow the path
	PFNode *t1Node = [grid getNodeAtX:(x + dx) andY:(y)];
	PFNode *t2Node = [grid getNodeAtX:(x) andY:(y + dy)];
	if (t1Node.walkable && t2Node.walkable) {
		PFNode *reNodeA = [grid getNodeAtX:(x + dx) andY:(y + dy)];
		return [self jump:reNodeA withNode:nodeA withEndNode:endNode withGrid:grid andTrackArr:trackArr];
	} else {
		return nil;
	}
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
		
		PFNode *cNode = nil;
		// search diagonally
		if (dx != 0 && dy != 0) {
			PFNode *c1Node = [grid getNodeAtX:x andY:(y + dy)];
			PFNode *c2Node = [grid getNodeAtX:(x + dx) andY:y];
			
			if (c1Node.walkable) {
				[neighbors addObject:c1Node];
			}
			if (c2Node.walkable) {
				[neighbors addObject:c2Node];
			}
			if (c1Node.walkable && c2Node.walkable) {
				cNode = [grid getNodeAtX:(x + dx) andY:(y + dy)];
				cNode?[neighbors addObject:cNode]:NO;
			}
		}
		// search horizontally/vertically
		else {
			BOOL isNextWalkable;
			if (dx != 0) {
				PFNode *c1Node = [grid getNodeAtX:(x + dx) andY:y];
				PFNode *c2Node = [grid getNodeAtX:x andY:(y + 1)];
				PFNode *c3Node = [grid getNodeAtX:x andY:(y - 1)];
				
				isNextWalkable = c1Node.walkable;
				BOOL isTopWalkable = c2Node.walkable;
				BOOL isBottomWalkable = c3Node.walkable;
				
				if (isNextWalkable) {
					[neighbors addObject:c1Node];
					if (isTopWalkable) {
						cNode = [grid getNodeAtX:(x + dx) andY:(y + 1)];
						cNode?[neighbors addObject:cNode]:NO;
					}
					if (isBottomWalkable) {
						cNode = [grid getNodeAtX:(x + dx) andY:(y - 1)];
						cNode?[neighbors addObject:cNode]:NO;
					}
				}
				if (isTopWalkable) {
					[neighbors addObject:c2Node];
				}
				if (isBottomWalkable) {
					[neighbors addObject:c3Node];
				}
			}
			else if (dy != 0) {
				PFNode *c1Node = [grid getNodeAtX:x andY:(y + dy)];
				PFNode *c2Node = [grid getNodeAtX:(x + 1) andY:y];
				PFNode *c3Node = [grid getNodeAtX:(x - 1) andY:y];
				
				isNextWalkable = c1Node.walkable;
				BOOL isRightWalkable = c2Node.walkable;
				BOOL isLeftWalkable = c3Node.walkable;
				
				if (isNextWalkable) {
					[neighbors addObject:c1Node];
					if (isRightWalkable) {
						cNode = [grid getNodeAtX:(x + 1) andY:(y + dy)];
						cNode?[neighbors addObject:cNode]:NO;
					}
					if (isLeftWalkable) {
						cNode = [grid getNodeAtX:(x - 1) andY:(y + dy)];
						cNode?[neighbors addObject:cNode]:NO;
					}
				}
				if (isRightWalkable) {
					[neighbors addObject:c2Node];
				}
				if (isLeftWalkable) {
					[neighbors addObject:c3Node];
				}
			}
		}
	}
	// return all neighbors
	else {
		
		NSArray *neighborNodes = [grid getNeighborsWith:node diagonalMovement:DiagonalMovement_OnlyWhenNoObstacles];
		PFNode *neighborNode=nil;
		for (int i=0; i<neighborNodes.count; i++) {
			neighborNode = neighborNodes[i];
			[neighbors addObject:neighborNode];
		}
	}
	
	return neighbors;
}


@end
