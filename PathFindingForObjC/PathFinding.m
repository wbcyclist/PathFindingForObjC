//
//  PathFinding.m
//
//  Created by JasioWoo on 14/10/26.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import "PathFinding.h"
#import "PFGrid.h"
#import "AStarFinder.h"
#import "PFUtil.h"


#define ConvertToGridPoint(p, t, o) do{ p.x = (int)((p.x+self.o.x)/self.t.width); p.y = (int)((p.y+self.o.y)/self.t.height);}while(0)

@interface PathFinding ()
@property (nonatomic, retain) NSMutableArray *blockTiles;
@end

@implementation PathFinding {
	
}

- (instancetype)initWithMapSize:(CGSize)mapSize tileSize:(CGSize)tileSize coordsOrgin:(CGPoint)orginPoint {
	self = [super init];
	if (self) {
		self.heuristicType = HeuristicTypeManhattan;
		self.allowDiagonal = YES;
		self.dontCrossCorners = NO;
		self.weight = 1;
		self.mapSize = mapSize;
		self.tileSize = tileSize;
		self.orginPoint = orginPoint;
		
	}
	return self;
}

- (NSMutableArray *)blockTiles {
	if (!_blockTiles) {
		_blockTiles = [NSMutableArray array];
	}
	return _blockTiles;
}

- (void)addBlockTilePosition:(CGPoint)point {
	[self.blockTiles addObject:CGPointToNSValue(point)];
}

- (void)addBlockTilePositions:(NSArray *)points {
	[self.blockTiles addObjectsFromArray:points];
}

- (void)clearBlockTiles {
	[self.blockTiles removeAllObjects];
}


- (NSArray *)findPathing:(PathfindingAlgorithm)alg {
	
	unsigned int column = self.mapSize.width/self.tileSize.width;
	unsigned int row = self.mapSize.height/self.tileSize.height;
	
	NSMutableArray *blockPoints = [NSMutableArray arrayWithCapacity:self.blockTiles.count];
	for (NSValue *value in self.blockTiles) {
		CGPoint point = NSValueToCGPoint(value);
		ConvertToGridPoint(point, self.tileSize, self.orginPoint);
		[blockPoints addObject:CGPointToNSValue(point)];
	}
	
	CGPoint sPoint = self.startPoint;
//	sPoint.x = (int)((sPoint.x+self.orginPoint.x)/self.tileSize.width);
//	sPoint.y = (int)((sPoint.y+self.orginPoint.y)/self.tileSize.height);
	ConvertToGridPoint(sPoint, self.tileSize, self.orginPoint);
	
	CGPoint ePoint = self.endPoint;
	ConvertToGridPoint(ePoint, self.tileSize, self.orginPoint);
	
	PFGrid *grid = [[PFGrid alloc] initWithColumn:column andRow:row andBlockPoints:blockPoints];
	PFNode *startNode = [grid getNodeAtX:sPoint.x andY:sPoint.y];
	PFNode *endNode = [grid getNodeAtX:ePoint.x andY:ePoint.y];
	if (!startNode || !endNode) {
		NSLog(@"not found startPoint(%@) or endPoint(%@)", NSStringFromCGPoint(self.startPoint), NSStringFromCGPoint(self.endPoint));
		NSLog(@"mapSize=%@, tileSize=%@, orginPoint=%@", NSStringFromCGSize(self.mapSize), NSStringFromCGSize(self.tileSize), NSStringFromCGPoint(self.orginPoint));
		return nil;
	} else if (startNode.x==endNode.x && startNode.y==endNode.y) {
		return @[CGPointToNSValue(self.startPoint), CGPointToNSValue(self.endPoint)];
	}
	
	BaseFinder *finder = [self getFinder:alg];
	finder.heuristicType = self.heuristicType;
	finder.allowDiagonal = self.allowDiagonal;
	finder.dontCrossCorners = self.dontCrossCorners;
	finder.weight = self.weight;
	NSArray *result = [finder findPathInStartNode:startNode toEndNode:endNode withGrid:grid];
//	NSLog(@"result=%@", result);
	[grid printFoundPath:result];
	
	return result;
}



- (BaseFinder*)getFinder:(PathfindingAlgorithm)alg{
	BaseFinder *result = nil;
	
	switch (alg) {
		case PathfindingAlgorithm_AStar:
			result = [[AStarFinder alloc] init];
			break;
		case PathfindingAlgorithm_IDAStar:
			result = [[AStarFinder alloc] init];
			break;
		case PathfindingAlgorithm_BreadthFirstSearch:
			result = [[AStarFinder alloc] init];
			break;
		case PathfindingAlgorithm_DepthFirstSearch:
			result = [[AStarFinder alloc] init];
			break;
		case PathfindingAlgorithm_BestFirstSearch:
			result = [[AStarFinder alloc] init];
			break;
		case PathfindingAlgorithm_Dijkstra:
			result = [[AStarFinder alloc] init];
			break;
		case PathfindingAlgorithm_JumpPointSearch:
			result = [[AStarFinder alloc] init];
			break;
		case PathfindingAlgorithm_OrthogonalJumpPointSearch:
			result = [[AStarFinder alloc] init];
			break;
		case PathfindingAlgorithm_Trace:
			result = [[AStarFinder alloc] init];
			break;
		default:
			result = [[AStarFinder alloc] init];
			break;
	}
	return result;
}

@end
