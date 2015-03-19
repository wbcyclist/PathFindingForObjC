//
//  PFUtil.m
//
//  Created by JasioWoo on 14/10/27.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import "PFUtil.h"
#import "PFNode.h"
#import "PFGrid.h"

@implementation PFUtil

+ (NSArray *)backtrace:(PFNode *)node {
	NSMutableArray *path = [NSMutableArray array];
	[path addObject:node];
	while (node.parent) {
		node = node.parent;
		[path addObject:node];
	}
	
	return [[path reverseObjectEnumerator] allObjects];
}

+ (NSArray *)biBacktraceWithNodeA:(PFNode *)nodeA andNodeB:(PFNode *)nodeB {
	NSArray *pathA = [PFUtil backtrace:nodeA];
	NSArray *pathB = [PFUtil backtrace:nodeB];
	
	NSMutableArray *mergePath = [NSMutableArray arrayWithArray:pathA];
	[mergePath addObjectsFromArray:[pathB reverseObjectEnumerator].allObjects];
	return mergePath;
}

+ (float)pathLength:(NSArray*)path {
	float sum = 0;
	int i, dx, dy;
	PFNode *aNode, *bNode;
	for (i=1; i<path.count; ++i) {
		aNode = path[i-1];
		bNode = path[i];
		dx = aNode.x - bNode.x;
		dy = aNode.y - bNode.y;
		sum = sqrtf(dx * dx + dy * dy);
	}
	return sum;
}

+ (NSArray *)interpolate:(int)x0 :(int)y0 :(int)x1 :(int)y1 {
	NSMutableArray *line = [NSMutableArray array];
	int sx, sy, dx, dy, err, e2;
	
	dx = abs(x1 - x0);
	dy = abs(y1 - y0);
	
	sx = (x0 < x1) ? 1 : -1;
	sy = (y0 < y1) ? 1 : -1;
	
	err = dx - dy;
	
	while (YES) {
		[line addObject:[[PFNode alloc] initWithX:x0 andY:y0]];
		
		if (x0 == x1 && y0 == y1) {
			break;
		}
		
		e2 = 2 * err;
		if (e2 > -dy) {
			err = err - dy;
			x0 = x0 + sx;
		}
		if (e2 < dx) {
			err = err + dx;
			y0 = y0 + sy;
		}
	}
	
	return line;
}

+ (NSArray *)expandPath:(NSArray*)path {
	NSMutableArray *expanded = [NSMutableArray array];
	NSUInteger len = [path count];
	if (len < 2) {
		return expanded;
	}
	
	PFNode *aNode, *bNode;
	for (int i = 0; i < len - 1; ++i) {
		aNode = path[i];
		bNode = path[i+1];
		
		NSArray *interpolated = [PFUtil interpolate:aNode.x :aNode.y :bNode.x :bNode.y];
		if (interpolated.count >0) {
			[expanded addObjectsFromArray:interpolated];
		}
	}
	[expanded addObject:path[len - 1]];
	return expanded;
}

+ (NSArray *)smoothenPathWithGrid:(PFGrid*)grid andPath:(NSArray*)path {
	
	NSUInteger len = [path count];
	if (len<2) {
		return path;
	}
	
	PFNode *currentNode	= path[0];
	PFNode *nextNode	= nil;
	PFNode *lastNode	= nil;
	
	NSArray *line = nil;
	NSMutableArray *newPath = [NSMutableArray array];
	[newPath addObject:currentNode];
	
	for (int i = 2; i < len; ++i) {
		nextNode = path[i];
		line = [PFUtil interpolate:currentNode.x :currentNode.y :nextNode.x :nextNode.y];
		
		BOOL blocked = NO;
		for (int j = 1; j < [line count]; ++j) {
			PFNode *testNode = line[j];
			
			if (![grid isWalkableAtX:testNode.x andY:testNode.y]) {
				blocked = YES;
				break;
			}
		}
		
		if (blocked) {
			lastNode = path[i - 1];
			[newPath addObject:lastNode];
			
			currentNode = lastNode;
		}
	}
	[newPath addObject:[path lastObject]];
	
	return newPath;
	
}

+ (NSArray *)compressPath:(NSArray*)path {
	
	// nothing to compress
	if([path count] < 3) {
		return path;
	}
	NSMutableArray *compressed = [NSMutableArray array];
	
	PFNode *lastNode = path[0];
	PFNode *nextNode = path[1];
	
	int dx = nextNode.x - lastNode.x;	// direction between the two points
	int dy = nextNode.y - lastNode.y;	// direction between the two points
	int ldx, ldy;
	// normalize the direction
	int sq = sqrt(dx*dx + dy*dy);
	dx /= sq;
	dy /= sq;
	
	// start the new path
	[compressed addObject:lastNode];
	
	for(int i = 2; i < [path count]; i++) {
		// store the last point
		lastNode = nextNode;
		
		// store the last direction
		ldx = dx;
		ldy = dy;
		
		// next point
		nextNode = path[i];
		
		// next direction
		dx = nextNode.x - lastNode.x;
		dy = nextNode.y - lastNode.y;
		
		// normalize
		sq = sqrt(dx*dx + dy*dy);
		dx /= sq;
		dy /= sq;
		
		// if the direction has changed, store the point
		if ( dx != ldx || dy != ldy ) {
			[compressed addObject:lastNode];
		}
	}
	
	// store the last point
	[compressed addObject:nextNode];
	
	return compressed;
}


@end
