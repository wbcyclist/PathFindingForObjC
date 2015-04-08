//
//  VectorFieldGrid.m
//
//  Created by JasioWoo on 14/11/4.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import "VectorFieldGrid.h"

typedef enum {
	Algorithm_Dijkstra,
	Algorithm_BreadthFirstSearch
} AlgorithmType;


@implementation VectorFieldGrid {
	NSMutableArray *_nodes;
}

- (instancetype)initWithMapSize:(CGSize)mapSize tileSize:(CGSize)tileSize coordsOrgin:(CGPoint)orginPoint {
	self = [super init];
	if (self) {
		_mapSize = mapSize;
		_tileSize = tileSize;
		_orginPoint = orginPoint;
		
		unsigned int column = mapSize.width/tileSize.width;
		unsigned int row = mapSize.height/tileSize.height;
		
		_column = column;
		_row = row;
		_nodes = [NSMutableArray arrayWithCapacity:_row];
		
		PFNode *node = nil;;
		for (int i=0; i<_row; i++) {
			_nodes[i] = [NSMutableArray arrayWithCapacity:_column];
			
			for (int j=0; j<_column; j++) {
				node = [[PFNode alloc] init];
				node.x = j;
				node.y = i;
				node.f = 0;
				node.walkable = YES;
				node.parent = nil;
				_nodes[i][j] = node;
			}
		}
	}
	return self;
}

- (void)setMapSize:(CGSize)mapSize {
	if ((int)_mapSize.width != (int)mapSize.width || (int)_mapSize.height != (int)mapSize.height) {
		_mapSize = mapSize;
		self.column = _mapSize.width/_tileSize.width;
		self.row = _mapSize.height/_tileSize.height;
	}
}

- (void)setTileSize:(CGSize)tileSize {
	if ((int)_tileSize.width != (int)tileSize.width || (int)_tileSize.height != (int)tileSize.height) {
		_tileSize = tileSize;
		self.column = _mapSize.width/_tileSize.width;
		self.row = _mapSize.height/_tileSize.height;
	}
}


- (void)setColumn:(unsigned int)column {
	if (_column != column) {
		if (_column > column) {
			NSMutableArray *rowArr;
			for (int i=0; i<_row; i++) {
				rowArr = _nodes[i];
				for (int j=column; j<_column; j++) {
					[rowArr removeObjectAtIndex:j];
				}
			}
			
		} else {
			PFNode *node;
			NSMutableArray *rowArr;
			for (int i=0; i<_row; i++) {
				rowArr = _nodes[i];
				for (int j=_column; j<column; j++) {
					node = [[PFNode alloc] init];
					node.x = j;
					node.y = i;
					node.f = 0;
					node.walkable = YES;
					node.parent = nil;
					[rowArr addObject:node];
				}
			}
		}
		_column = column;
	}
}

- (void)setRow:(unsigned int)row {
	if (_row != row) {
		if (_row > row) {
			for (int i=row; i<_row; i++) {
				[_nodes removeObjectAtIndex:i];
			}
		} else {
			PFNode *node;
			for (int i=_row; i<row; i++) {
				_nodes[i] = [NSMutableArray arrayWithCapacity:_column];
				for (int j=0; j<_column; j++) {
					node = [[PFNode alloc] init];
					node.x = j;
					node.y = i;
					node.f = 0;
					node.walkable = YES;
					node.parent = nil;
					_nodes[i][j] = node;
				}
			}
		}
		_row = row;
	}
}

- (void)dealloc {
//	debugMethod();
	[_nodes removeAllObjects];
	_nodes = nil;
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

- (void)clearBlockTiles {
	for (int i=0; i<self.row; i++) {
		for (int j=0; j<self.column; j++) {
			((PFNode *)self.nodes[i][j]).walkable = YES;
		}
	}
}

- (void)addBlockTilePosition:(CGPoint)point {
	PF_ConvertToMatrixPoint(point, self.tileSize, self.orginPoint);
	PFNode *node = [self getNodeAtX:point.x andY:point.y];
	if (node) {
		node.walkable = NO;
	}
}

- (void)setTargetPoint:(CGPoint)targetPoint {
	PF_ConvertToMatrixPoint(targetPoint, self.tileSize, self.orginPoint);
	if (targetPoint.x==_targetPoint.x && targetPoint.y==_targetPoint.y) {
		return;
	}
	_targetPoint = targetPoint;
	// add DynamicBlock
	[self addDynamicBlockTile]; // custom
	[self fieldGridGeneration];
	[self clearDynamicBlockTile]; // custom
}

// custom method
- (void)addDynamicBlockTile {
	PFNode *node = nil;
	for (int i=1; i<4; i++) {
		for (int j=0; j<5; j++) {
			node = [self getNodeAtX:_targetPoint.x-i andY:_targetPoint.y-j];
			if (node && node.walkable) {
				node.walkable = NO;
				node.tested = YES;
				node.direction = 8;
				if (j==0) {
					node.vector = CGVectorMake(-1, 0);
				} else {
					node.vector = CGVectorMake(-1, 1);
				}
			}
			
			node = [self getNodeAtX:_targetPoint.x+i andY:_targetPoint.y-j];
			if (node && node.walkable) {
				node.walkable = NO;
				node.tested = YES;
				node.direction = 4;
				if (j==0) {
					node.vector = CGVectorMake(1, 0);
				} else {
					node.vector = CGVectorMake(1, 1);
				}
			}
		}
	}
	
	for (int i=1; i<5; i++) {
		node = [self getNodeAtX:_targetPoint.x andY:_targetPoint.y-i];
		if (node && node.walkable) {
			node.walkable = NO;
			node.tested = YES;
			node.direction = 6;
			node.vector = CGVectorMake(0, -1);
		}
	}
}

- (void)clearDynamicBlockTile {
	PFNode *node = nil;
	for (int i=1; i<4; i++) {
		for (int j=0; j<5; j++) {
			node = [self getNodeAtX:_targetPoint.x-i andY:_targetPoint.y-j];
			if (node && node.tested) {
				node.walkable = YES;
				node.tested = NO;
			}
			
			node = [self getNodeAtX:_targetPoint.x+i andY:_targetPoint.y-j];
			if (node && node.tested) {
				node.walkable = YES;
				node.tested = NO;
			}
		}
	}
	
	for (int i=1; i<5; i++) {
		node = [self getNodeAtX:_targetPoint.x andY:_targetPoint.y-i];
		if (node && node.tested) {
			node.walkable = YES;
			node.tested = NO;
		}
	}
}


- (void)clearFieldNode {
	for (NSArray *rowArr in self.nodes) {
		for (PFNode *node in rowArr) {
			node.cost = 0;
			node.f = 0;
			node.g = 0;
			node.h = 0;
			node.opened = 0;
			node.closed = NO;
			node.direction = 0;
		}
	}
}

- (void)fieldGridGeneration {
//	NSLog(@"fieldGridGeneration");
	[self clearFieldNode];
	
	NSMutableArray *openList = [NSMutableArray array];
	PFNode *node = nil, *neighbor = nil;
	int x, y;
	
	PFNode *startNode = [self getNodeAtX:_targetPoint.x andY:_targetPoint.y];
	if (!startNode) {
		return;
	}
	// push the start node into the open list
	[openList addObject:startNode];
	startNode.opened = 1;
	
	AlgorithmType type = Algorithm_BreadthFirstSearch;
//	AlgorithmType type = Algorithm_Dijkstra;
	
	// while the open list is not empty
	while (openList.count>0) {
		if (type==Algorithm_BreadthFirstSearch) {
			node = [openList firstObject];
			[openList removeObject:node];
		} else {
			[openList sortUsingSelector:@selector(descFWeightSort:)];
			node = [openList lastObject];
			[openList removeLastObject];
		}
		
		node.closed = YES;
		
		int leftCost, rightCost, upCost, downCost;
		
		// get neigbours of the current node
		// ↑
		x = node.x;
		y = node.y + 1;
		neighbor = [self getNodeAtX:x andY:y];
		if (neighbor.walkable) {
			if ([self updateNeighborNode:neighbor withCenterNode:node andOpenList:openList option:type]) {
				neighbor.direction = 2;
			}
		}
		upCost = neighbor.walkable ? neighbor.cost : node.cost;
		
		// ←
		x = node.x - 1;
		y = node.y;
		neighbor = [self getNodeAtX:x andY:y];
		if (neighbor.walkable) {
			if ([self updateNeighborNode:neighbor withCenterNode:node andOpenList:openList option:type]) {
				neighbor.direction = 8;
			}
		}
		leftCost = neighbor.walkable ? neighbor.cost : node.cost;
		
		// ↓
		x = node.x;
		y = node.y - 1;
		neighbor = [self getNodeAtX:x andY:y];
		if (neighbor.walkable) {
			if ([self updateNeighborNode:neighbor withCenterNode:node andOpenList:openList option:type]) {
				neighbor.direction = 6;
			}
		}
		downCost = neighbor.walkable ? neighbor.cost : node.cost;
		
		// →
		x = node.x + 1;
		y = node.y;
		neighbor = [self getNodeAtX:x andY:y];
		if (neighbor.walkable) {
			if ([self updateNeighborNode:neighbor withCenterNode:node andOpenList:openList option:type]) {
				neighbor.direction = 4;
			}
		}
		rightCost = neighbor.walkable ? neighbor.cost : node.cost;
		
		
		// recalculate the vector field
		node.vector = CGVectorMake(leftCost-rightCost, (downCost-upCost));
		if (node.vector.dx==0) {
			if (node.direction==8) {
				node.vector = CGVectorMake(-1, node.vector.dy);
			} else if (node.direction==4) {
				node.vector = CGVectorMake(1, node.vector.dy);
			}
		}
		if (node.vector.dy==0) {
			if (node.direction==2) {
				node.vector = CGVectorMake(node.vector.dx, 1);
			}else if (node.direction==6) {
				node.vector = CGVectorMake(node.vector.dx, -1);
			}
		}
	}
	
}



- (BOOL)updateNeighborNode:(PFNode*)neighbor withCenterNode:(PFNode*)cNode andOpenList:(NSMutableArray*)openList option:(AlgorithmType)type {
	if (neighbor.closed) {
		return NO;
	}
	
	if (type==Algorithm_BreadthFirstSearch) {
		if (neighbor.opened==0) {
			neighbor.cost = cNode.cost + 1;
			neighbor.opened = 1;
			[openList addObject:neighbor];
			return YES;
		}
		
	} else if (type==Algorithm_Dijkstra) {
		float ng = cNode.g + ((neighbor.x-cNode.x == 0 || neighbor.y-cNode.y == 0) ? 1 : 1.4);
		if (neighbor.opened==0 || ng < neighbor.g) {
			neighbor.cost = cNode.cost + 1;
			neighbor.g = ng;
			neighbor.f = neighbor.g;
			
			if (neighbor.opened==0) {
				neighbor.opened = 1;
				[openList addObject:neighbor];
			}
			return YES;
		}
	}
	
	return NO;
}









@end
