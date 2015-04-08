//
//  FGrid.m
//
//  Created by JasioWoo on 14/10/27.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import "PFGrid.h"

#import "PFNode.h"
//#import <objc/message.h>

@interface PFGrid ()


@end

@implementation PFGrid {
	NSMutableArray *_nodes;
	
}

- (instancetype)initWithColumn:(unsigned int)col andRow:(unsigned int)row andBlockPoints:(NSArray*)blockPoints{
	self = [super init];
	if (self) {
		if (col==0 || row==0) {
//			NSLog(@"Grid Size Must Be > 0. (col=%d, row=%d)", col, row);
			return nil;
		}
		_column = col;
		_row = row;
		_matrix = (int**)malloc(_row * sizeof(int*));
		NSMutableArray *nodeArr = [NSMutableArray arrayWithCapacity:_row];
		
		PFNode *node = nil;;
		for (int i=0; i<_row; i++) {
			_matrix[i] = (int*)malloc(_column * sizeof(int));
			memset(_matrix[i], 0, _column * sizeof(int));
			
			nodeArr[i] = [NSMutableArray arrayWithCapacity:_column];
			
			for (int j=0; j<_column; j++) {
				node = [[PFNode alloc] init];
				node.x = j;
				node.y = i;
				node.f = 0;
				node.g = 0;
				node.h = 0;
				node.walkable = YES;
				node.parent = nil;
				nodeArr[i][j] = node;
			}
		}
		_nodes = nodeArr;
		
		// setup block zone
		CGPoint blockPoint;
		for (NSValue *value in blockPoints) {
			blockPoint = PF_NSValueToCGPoint(value);
			node = [self getNodeAtX:blockPoint.x andY:blockPoint.y];
			if (node) {
				node.walkable = NO;
				_matrix[node.y][node.x] = 1;
			}
		}
		
//		NSLog(@"PFNode size(memory): %zd", class_getInstanceSize([PFNode class]));
//		NSLog(@"PFGrid size(memory): %zd", class_getInstanceSize([PFGrid class]));
//		[self printMatrix];
	}
	return self;
}

- (void)printMatrix {
	for (int i=_row-1; i>=0; i--) {
		for(int j=0; j<_column; j++) {
			printf("	%d", _matrix[i][j]);
		}
		printf("\n");
	}
}

- (void)printFoundPath:(NSArray *)path {
	NSUInteger l = path.count;
	for (int i=0; i<l; i++) {
		PFNode *obj = path[i];
		int x=obj.x, y=obj.y;
		if (i==0) {
			// start
			_matrix[y][x] = 2;
		} else if (i==l-1) {
			// end
			_matrix[y][x] = 4;
		} else {
			// path
			_matrix[y][x] = 3;
		}
	}
	
	for (int i=_row-1; i>=0; i--) {
		for(int j=0; j<_column; j++) {
			if (_matrix[i][j]==1) {
				// block
				printf("	\U0001F51E");
			} else if (_matrix[i][j]==2) {
				// start
				printf("	\U0001F64F");
			} else if (_matrix[i][j]==3) {
				// path
				printf("	\U0001F497");
			} else if (_matrix[i][j]==4) {
				// end
				printf("	\U0001F645");
			} else {
				printf("	\U0001F50E");
			}
//			printf("	%d", _matrix[i][j]);
		}
		printf("\n");
	}
}


- (void)dealloc {
//	debugMethod();
	[_nodes removeAllObjects];
	_nodes = nil;
	
	// release matrix
	for(int i=0; i<_row; i++) {
		memset(_matrix[i], 0, sizeof(int));
		free(_matrix[i]);
	}
	free(_matrix);
	_matrix = NULL;
}


- (PFNode *)getNodeAtX:(int)x andY:(int)y {
	if (x<0 || x>self.column-1
		|| y<0 || y>self.row-1) {
		return nil;
	}
	return self.nodes[y][x];
}

- (BOOL)isWalkableAtX:(int)x andY:(int)y {
	return [self getNodeAtX:x andY:y].walkable;
}

- (void)setWalkableAtX:(int)x andY:(int)y andWalkable:(BOOL)walkable {
	[self getNodeAtX:x andY:y].walkable = walkable;
}

- (NSArray *)getNeighborsWith:(PFNode*)node diagonalMovement:(DiagonalMovement)movementType {
	NSMutableArray *neighbors = [NSMutableArray arrayWithCapacity:4];
	int x = node.x;
	int y = node.y;
	BOOL s0 = NO;
	BOOL s1 = NO;
	BOOL s2 = NO;
	BOOL s3 = NO;
	BOOL d0 = NO;
	BOOL d1 = NO;
	BOOL d2 = NO;
	BOOL d3 = NO;
	
	// ↑
	if ([self isWalkableAtX:x andY:y-1]) {
		[neighbors addObject:self.nodes[y-1][x]];
		s0 = YES;
	}
	// →
	if ([self isWalkableAtX:x+1 andY:y]) {
		[neighbors addObject:self.nodes[y][x+1]];
		s1 = YES;
	}
	// ↓
	if ([self isWalkableAtX:x andY:y+1]) {
		[neighbors addObject:self.nodes[y+1][x]];
		s2 = YES;
	}
	// ←
	if ([self isWalkableAtX:x-1 andY:y]) {
		[neighbors addObject:self.nodes[y][x-1]];
		s3 = YES;
	}
	
	switch (movementType) {
		case DiagonalMovement_Always:
			d0 = d1 = d2 = d3 = YES;
			break;
			
		case DiagonalMovement_Never:
			return neighbors;
			
		case DiagonalMovement_OnlyWhenNoObstacles:
			d0 = s3 && s0;
			d1 = s0 && s1;
			d2 = s1 && s2;
			d3 = s2 && s3;
			break;
			
		case DiagonalMovement_IfAtMostOneObstacle:
			d0 = s3 || s0;
			d1 = s0 || s1;
			d2 = s1 || s2;
			d3 = s2 || s3;
			break;
			
		default:
			NSAssert(NO, @"Incorrect value of diagonalMovement");
			break;
	}
	
	// ↖
	if (d0 && [self isWalkableAtX:x-1 andY:y-1]) {
		[neighbors addObject:self.nodes[y-1][x-1]];
	}
	// ↗
	if (d1 && [self isWalkableAtX:x+1 andY:y-1]) {
		[neighbors addObject:self.nodes[y-1][x+1]];
	}
	// ↘
	if (d2 && [self isWalkableAtX:x+1 andY:y+1]) {
		[neighbors addObject:self.nodes[y+1][x+1]];
	}
	// ↙
	if (d3 && [self isWalkableAtX:x-1 andY:y+1]) {
		[neighbors addObject:self.nodes[y+1][x-1]];
	}
	
	return neighbors;
}





@end
