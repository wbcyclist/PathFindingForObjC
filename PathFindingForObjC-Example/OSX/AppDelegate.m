//
//  AppDelegate.m
//  PathFinding-Mac
//
//  Created by JasioWoo on 14/10/28.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import "AppDelegate.h"
#import "GameScene.h"
#import "StackCellViewController.h"

@interface AppDelegate ()

@property (weak)IBOutlet NSView *headerView;

@property (nonatomic, strong)NSMutableArray *stackCells;

@end


@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	
	CGSize size = self.skView.frame.size;
	NSLog(@"SKView size = %@", NSStringFromSize(size));
	GameScene *scene = [[GameScene alloc] initWithSize:size];
	scene.scaleMode = SKSceneScaleModeResizeFill;
	[self.skView presentScene:scene];
	self.skView.ignoresSiblingOrder = YES;
	//	self.skView.showsFields = YES;
	//	self.skView.showsPhysics = YES;
	self.skView.showsFPS = YES;
	self.skView.showsDrawCount = YES;
	self.skView.showsNodeCount = YES;
	
	
	NSString *aStar = @"[{\"Algorithm\": \"AStar\", "
						"\"Heuristic\": [\"Manhattan\", \"Euclidean\", \"Octile\", \"Chebyshev\"], "
						"\"DiagonalMovement\": [\"Always\", \"Never\", \"IfAtMostOneObstacle\", \"OnlyWhenNoObstacles\"], "
						"\"Options\": {\"Bi-directional\": \"true\", \"Weight\": \"true\"}},";
	
	NSString *bestFirstSearch = @"{\"Algorithm\": \"BestFirstSearch\", "
									"\"Heuristic\": [\"Manhattan\", \"Euclidean\", \"Octile\", \"Chebyshev\"], "
									"\"DiagonalMovement\": [\"Always\", \"Never\", \"IfAtMostOneObstacle\", \"OnlyWhenNoObstacles\"], "
									"\"Options\": {\"Bi-directional\": \"true\"}},";
	
	NSString *breadthFirstSearch = @"{\"Algorithm\": \"BreadthFirstSearch\", "
									"\"DiagonalMovement\": [\"Always\", \"Never\", \"IfAtMostOneObstacle\", \"OnlyWhenNoObstacles\"], "
									"\"Options\": {\"Bi-directional\": \"true\"}},";
	
	NSString *dijkstra = @"{\"Algorithm\": \"Dijkstra\", "
							"\"DiagonalMovement\": [\"Always\", \"Never\", \"IfAtMostOneObstacle\", \"OnlyWhenNoObstacles\"], "
							"\"Options\": {\"Bi-directional\": \"true\"}},";
	
	NSString *jumpPointSearch = @"{\"Algorithm\": \"JumpPointSearch\", "
								"\"Heuristic\": [\"Manhattan\", \"Euclidean\", \"Octile\", \"Chebyshev\"], "
								"\"DiagonalMovement\": [\"Always\", \"Never\", \"IfAtMostOneObstacle\", \"OnlyWhenNoObstacles\"]}]";
	
	NSString *json = [NSString stringWithFormat:@"%@%@%@%@%@", aStar, bestFirstSearch, breadthFirstSearch, dijkstra, jumpPointSearch];
	
	
	NSArray *pfDic = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
	
//	NSLog(@"%@", pfDic);
	[self.stackView addView:self.headerView inGravity:NSStackViewGravityLeading];
	self.stackCells = [NSMutableArray array];
	for (NSDictionary *data in pfDic) {
		StackCellViewController *cellVC = [[StackCellViewController alloc] initWithNibName:@"StackCellViewController" bundle:nil];
		[cellVC loadingData:data];
		[self.stackView addView:cellVC.view inGravity:NSStackViewGravityLeading];
		[self.stackCells addObject:cellVC];
	}
	
}




- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}


- (IBAction)showHelp:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://github.com/wbcyclist/PathFindingForObjC"]];
}


















@end
