//
//  PathFinding.m
//
//  Created by JasioWoo on 14/10/26.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import "PathFinding.h"

#import "AStarFinder.h"
#import "BestFirstFinder.h"
#import "DijkstraFinder.h"
#import "BreadthFirstFinder.h"
#import "JumpPointFinderBase.h"

#import "BiAStarFinder.h"
#import "BiBestFirstFinder.h"
#import "BiDijkstraFinder.h"
#import "BiBreadthFirstFinder.h"



@interface PathFinding ()
@property (nonatomic, strong) NSMutableArray *blockTiles;
@property (nonatomic, strong) NSMutableArray *dynamicBlockTiles;
@end

@implementation PathFinding {
	
}

#pragma mark - 

- (instancetype)initWithMapSize:(CGSize)mapSize tileSize:(CGSize)tileSize coordsOrgin:(CGPoint)orginPoint {
	self = [super init];
	if (self) {
		self.movementType = DiagonalMovement_Always;
		self.heuristicType = HeuristicTypeManhattan;
		
		self.weight = 1;
		self.mapSize = mapSize;
		self.tileSize = tileSize;
		self.orginPoint = orginPoint;
		
	}
	return self;
}

- (void)dealloc {
//	debugMethod();
}


#pragma mark -
- (NSMutableArray *)blockTiles {
	if (!_blockTiles) {
		_blockTiles = [NSMutableArray array];
	}
	return _blockTiles;
}
- (NSMutableArray *)dynamicBlockTiles {
	if (!_dynamicBlockTiles) {
		_dynamicBlockTiles = [NSMutableArray array];
	}
	return _dynamicBlockTiles;
}

- (void)addBlockTilePosition:(CGPoint)point {
	[self.blockTiles addObject:PF_CGPointToNSValue(point)];
}
- (void)addDynamicBlockTilePosition:(CGPoint)point {
	[self.dynamicBlockTiles addObject:PF_CGPointToNSValue(point)];
}

- (void)addBlockTilePositions:(NSArray *)points {
	[self.blockTiles addObjectsFromArray:points];
}

- (void)clearBlockTiles {
	if (_blockTiles) {
		[_blockTiles removeAllObjects];
	}
	if (_dynamicBlockTiles) {
		[_dynamicBlockTiles removeAllObjects];
	}
}


- (NSArray *)findPathing:(PathfindingAlgorithm)alg IsConvertToOriginCoords:(BOOL)isConvert {
	return [self findPathing:alg IsConvertToOriginCoords:isConvert trackFinding:nil];
}

- (NSArray *)findPathing:(PathfindingAlgorithm)alg IsConvertToOriginCoords:(BOOL)isConvert trackFinding:(NSMutableArray *__autoreleasing *)trackArrForTest {
	unsigned int column = self.mapSize.width/self.tileSize.width;
	unsigned int row = self.mapSize.height/self.tileSize.height;
	
	NSMutableArray *blockPoints = [NSMutableArray arrayWithCapacity:self.blockTiles.count];
	for (NSValue *value in self.blockTiles) {
		CGPoint point = PF_NSValueToCGPoint(value);
		PF_ConvertToMatrixPoint(point, self.tileSize, self.orginPoint);
		[blockPoints addObject:PF_CGPointToNSValue(point)];
	}
	NSArray *dyArr = self.dynamicBlockTiles;
	self.dynamicBlockTiles = nil;
	for (NSValue *value in dyArr) {
		CGPoint point = PF_NSValueToCGPoint(value);
		PF_ConvertToMatrixPoint(point, self.tileSize, self.orginPoint);
		[blockPoints addObject:PF_CGPointToNSValue(point)];
	}
	
	
	CGPoint sPoint = self.startPoint;
	//	sPoint.x = (int)((sPoint.x+self.orginPoint.x)/self.tileSize.width);
	//	sPoint.y = (int)((sPoint.y+self.orginPoint.y)/self.tileSize.height);
	PF_ConvertToMatrixPoint(sPoint, self.tileSize, self.orginPoint);
	
	CGPoint ePoint = self.endPoint;
	PF_ConvertToMatrixPoint(ePoint, self.tileSize, self.orginPoint);
	
	PFGrid *grid = [[PFGrid alloc] initWithColumn:column andRow:row andBlockPoints:blockPoints];
	PFNode *startNode = [grid getNodeAtX:sPoint.x andY:sPoint.y];
	PFNode *endNode = [grid getNodeAtX:ePoint.x andY:ePoint.y];
	if (!startNode || !endNode) {
//		NSLog(@"not found startPoint(%@) or endPoint(%@)", NSStringFromCGPoint(self.startPoint), NSStringFromCGPoint(self.endPoint));
//		NSLog(@"mapSize=%@, tileSize=%@, orginPoint=%@", NSStringFromCGSize(self.mapSize), NSStringFromCGSize(self.tileSize), NSStringFromCGPoint(self.orginPoint));
		return nil;
	} else if (startNode.x==endNode.x && startNode.y==endNode.y) {
		return @[PF_CGPointToNSValue(self.startPoint), PF_CGPointToNSValue(self.endPoint)];
	}
	
	BaseFinder *finder = [self getFinder:alg];
	finder.heuristicType = self.heuristicType;
	finder.movementType = self.movementType;
	
	finder.weight = self.weight;
	NSMutableArray *trackArr = trackArrForTest?*trackArrForTest:nil;
	NSArray *result = [finder findPathInStartNode:startNode toEndNode:endNode withGrid:grid trackFinding:&trackArr];
	
	// convert to origin coords
	if (isConvert) {
		// convert track operation
		for (NSObject *obj in trackArr) {
			if ([obj isKindOfClass:[PFNode class]]) {
				PFNode *node = (PFNode *)obj;
				CGPoint originPoint = CGPointMake(node.x, node.y);
				PF_ConvertToOriginPoint(originPoint, self.tileSize, self.orginPoint);
				node.originPoint = originPoint;
			} else if ([obj isKindOfClass:[NSMutableArray class]]) {
				NSArray *arr = (NSArray*)obj;
				for (PFNode *node in arr) {
					CGPoint originPoint = CGPointMake(node.x, node.y);
					PF_ConvertToOriginPoint(originPoint, self.tileSize, self.orginPoint);
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
				PF_ConvertToOriginPoint(originPoint, self.tileSize, self.orginPoint);
				node.originPoint = originPoint;
			}
		}
	}
	
	if (PF_DEBUG) {
		[grid printFoundPath:result];
	}
//	NSLog(@"result=%@", trackArr);
	return result;
}



- (BaseFinder*)getFinder:(PathfindingAlgorithm)alg{
	BaseFinder *result = nil;
	
	switch (alg) {
		case PathfindingAlgorithm_AStar:
			result = [[AStarFinder alloc] init];
			break;
		case PathfindingAlgorithm_BestFirstSearch:
			result = [[BestFirstFinder alloc] init];
			break;
		case PathfindingAlgorithm_Dijkstra:
			result = [[DijkstraFinder alloc] init];
			break;
		case PathfindingAlgorithm_BreadthFirstSearch:
			result = [[BreadthFirstFinder alloc] init];
			break;
		case PathfindingAlgorithm_JumpPointSearch:
			result = [[JumpPointFinderBase alloc] initWithMovementType:self.movementType];
			break;
			
		case PathfindingAlgorithm_BiAStar:
			result = [[BiAStarFinder alloc] init];
			break;
		case PathfindingAlgorithm_BiBestFirst:
			result = [[BiBestFirstFinder alloc] init];
			break;
		case PathfindingAlgorithm_BiDijkstra:
			result = [[BiDijkstraFinder alloc] init];
			break;
		case PathfindingAlgorithm_BiBreadthFirst:
			result = [[BiBreadthFirstFinder alloc] init];
			break;
			
		case PathfindingAlgorithm_IDAStar:
			result = [[AStarFinder alloc] init];
			break;
		
		default:
			result = [[AStarFinder alloc] init];
			break;
	}
	return result;
}

@end
