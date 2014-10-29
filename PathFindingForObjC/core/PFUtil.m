//
//  PFUtil.m
//
//  Created by JasioWoo on 14/10/27.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import "PFUtil.h"
#import "PFGrid.h"

@implementation PFUtil

+ (NSArray *)backtrace:(PFNode *)node {
	NSMutableArray *path = [NSMutableArray array];
	[path addObject:CGPointToNSValue(CGPointMake(node.x, node.y))];
	while (node.parent) {
		node = node.parent;
		[path addObject:CGPointToNSValue(CGPointMake(node.x, node.y))];
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
	CGPoint a, b;
	for (i=1; i<path.count; ++i) {
		a = NSValueToCGPoint(((NSValue*)path[i - 1]));
		b = NSValueToCGPoint(((NSValue*)path[i]));
		dx = a.x - b.x;
		dy = a.y - b.y;
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
	
	while (true) {
		[line addObject:CGPointToNSValue(CGPointMake( x0, y0))];
		
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
	
	int i;
	NSArray *interpolated;
	NSUInteger interpolatedLen = 0;
	CGPoint coord0, coord1;
	for (i = 0; i < len - 1; ++i) {
		coord0 = NSValueToCGPoint(((NSValue*)path[i]));
		coord1 = NSValueToCGPoint(((NSValue*)path[i + 1]));
		
		interpolated = [PFUtil interpolate:coord0.x :coord0.y :coord1.x :coord1.y];
		interpolatedLen = [interpolated count];
		if (interpolatedLen>0) {
			[expanded addObjectsFromArray:interpolated];
		}
	}
	[expanded addObject:path[len - 1]];
	return expanded;
}

+ (NSArray *)smoothenPathWithGrid:(PFGrid*)grid andPath:(NSArray*)path {
	
	NSUInteger len = [path count];
	CGPoint coord = NSValueToCGPoint(((NSValue*)path[0]));
	int x0 = coord.x;	// path start x
	int y0 = coord.y;	// path start x
	coord = NSValueToCGPoint(((NSValue*)path[len - 1]));
	int x1 = coord.x;	// path end x
	int y1 = coord.y;	// path end y
	int sx, sy;			// current start coordinate
	int ex, ey;			// current end coordinate
	int lx, ly;			// last valid end coordinate
	sx = x0;
	sy = y0;
	coord = NSValueToCGPoint(((NSValue*)path[1]));
	lx = coord.x;
	ly = coord.y;
	
	NSArray *line = nil;
	NSMutableArray *newPath = [NSMutableArray array];
	[newPath addObject:CGPointToNSValue(CGPointMake(sx, sy))];
	
	for (int i = 2; i < len; ++i) {
		coord = NSValueToCGPoint(((NSValue*)path[i]));
		ex = coord.x;
		ey = coord.y;
		line = [PFUtil interpolate:sx :sy :ex :ey];
		
		BOOL blocked = NO;
		for (int j = 1; j < [line count]; ++j) {
			CGPoint testCoord = NSValueToCGPoint(((NSValue*)line[j]));
			
			if (![grid isWalkableAtX:testCoord.x andY:testCoord.y]) {
				blocked = YES;
				[newPath addObject:CGPointToNSValue(CGPointMake(lx, ly))];
				sx = lx;
				sy = ly;
				break;
			}
		}
		if (!blocked) {
			lx = ex;
			ly = ey;
		}
	}
	[newPath addObject:CGPointToNSValue(CGPointMake(x1, y1))];
	
	return newPath;
	
}

+ (NSArray *)compressPath:(NSArray*)path {

	if([path count] < 3) {
		return path;
	}
	NSMutableArray *compressed = [NSMutableArray array];
	
	CGPoint coord = NSValueToCGPoint(((NSValue*)path[0]));
	int sx = coord.x;	// start x
	int sy = coord.y;	// start x
	coord = NSValueToCGPoint(((NSValue*)path[1]));
	int px = coord.x;	// second point x
	int py = coord.y;	// second point y
	int dx = px - sx;	// direction between the two points
	int dy = py - sy;	// direction between the two points
	int lx, ly, ldx, ldy;
	// normalize the direction
	int sq = sqrt(dx*dx + dy*dy);
	dx /= sq;
	dy /= sq;
	
	// start the new path
	
	[compressed addObject:CGPointToNSValue(CGPointMake(sx, sy))];
	
	for(int i = 2; i < [path count]; i++) {
		
		// store the last point
		lx = px;
		ly = py;
		
		// store the last direction
		ldx = dx;
		ldy = dy;
		
		// next point
		coord = NSValueToCGPoint(((NSValue*)path[i]));
		px = coord.x;
		py = coord.y;
		
		// next direction
		dx = px - lx;
		dy = py - ly;
		
		// normalize
		sq = sqrt(dx*dx + dy*dy);
		dx /= sq;
		dy /= sq;
		
		// if the direction has changed, store the point
		if ( dx != ldx || dy != ldy ) {
			[compressed addObject:CGPointToNSValue(CGPointMake(lx, ly))];
		}
	}
	
	// store the last point
	[compressed addObject:CGPointToNSValue(CGPointMake(px, py))];
	
	return compressed;

}


@end
