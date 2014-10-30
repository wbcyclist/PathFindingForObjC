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


#define ConvertToMatrixPoint(p, t, o) do{ p.x = (int)((p.x+o.x)/t.width); p.y = (int)((p.y+o.y)/t.height);}while(0)
#define ConvertToOriginPoint(p, t, o) do{ p.x = p.x*t.width - o.x + t.width/2.0; p.y = p.y*t.height - o.y + t.height/2.0;}while(0)

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


- (NSArray *)findPathing:(PathfindingAlgorithm)alg IsConvertToOriginCoords:(BOOL)isConvert {
	return [self findPathing:alg IsConvertToOriginCoords:isConvert traceFinding:nil];
}

- (NSArray *)findPathing:(PathfindingAlgorithm)alg IsConvertToOriginCoords:(BOOL)isConvert traceFinding:(NSMutableArray *__autoreleasing *)traceArrForTest {
	unsigned int column = self.mapSize.width/self.tileSize.width;
	unsigned int row = self.mapSize.height/self.tileSize.height;
	
	NSMutableArray *blockPoints = [NSMutableArray arrayWithCapacity:self.blockTiles.count];
	for (NSValue *value in self.blockTiles) {
		CGPoint point = NSValueToCGPoint(value);
		ConvertToMatrixPoint(point, self.tileSize, self.orginPoint);
		[blockPoints addObject:CGPointToNSValue(point)];
	}
	
	CGPoint sPoint = self.startPoint;
	//	sPoint.x = (int)((sPoint.x+self.orginPoint.x)/self.tileSize.width);
	//	sPoint.y = (int)((sPoint.y+self.orginPoint.y)/self.tileSize.height);
	ConvertToMatrixPoint(sPoint, self.tileSize, self.orginPoint);
	
	CGPoint ePoint = self.endPoint;
	ConvertToMatrixPoint(ePoint, self.tileSize, self.orginPoint);
	
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
	NSMutableArray *traceArr = traceArrForTest?*traceArrForTest:nil;
	NSArray *result = [finder findPathInStartNode:startNode toEndNode:endNode withGrid:grid traceFinding:&traceArr];
	
	// convert to origin coords
	if (isConvert) {
		// convert trace operation
		for (NSObject *obj in traceArr) {
			if ([obj isKindOfClass:[PFNode class]]) {
				PFNode *node = (PFNode *)obj;
				CGPoint originPoint = CGPointMake(node.x, node.y);
				ConvertToOriginPoint(originPoint, self.tileSize, self.orginPoint);
				node.originPoint = originPoint;
			} else if ([obj isKindOfClass:[NSMutableArray class]]) {
				NSArray *arr = (NSArray*)obj;
				for (PFNode *node in arr) {
					CGPoint originPoint = CGPointMake(node.x, node.y);
					ConvertToOriginPoint(originPoint, self.tileSize, self.orginPoint);
					node.originPoint = originPoint;
				}
			}
		}
		// convert found path
		if (result) {
			PFNode *firstNode = [result firstObject];
			PFNode *lastNode = [result lastObject];
			firstNode.originPoint = self.startPoint;
			lastNode.originPoint = self.endPoint;
			for (int i=1; i<result.count-1; i++) {
				PFNode *node = result[i];
				CGPoint originPoint = CGPointMake(node.x, node.y);
				ConvertToOriginPoint(originPoint, self.tileSize, self.orginPoint);
				node.originPoint = originPoint;
			}
		}
	}
	
//	[grid printFoundPath:result];
//	NSLog(@"result=%@", traceArr);
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
