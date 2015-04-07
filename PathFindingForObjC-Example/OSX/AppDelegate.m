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

@interface AppDelegate () <StackCellViewDelegate>

@property (weak)IBOutlet NSView *headerView;

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
//	self.skView.showsDrawCount = YES;
//	self.skView.showsNodeCount = YES;
	
	[self.window.rightView setWantsLayer:YES];
	self.window.pf_delegate = scene;
	
	// load data
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"PathFindingData" ofType:@"json"];
	NSData *data = [NSData dataWithContentsOfFile:filePath];
	NSArray *pfDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
	
	[self.stackView addView:self.headerView inGravity:NSStackViewGravityLeading];
	self.window.stackCells = [NSMutableArray array];
	int i = 0;
	for (NSDictionary *data in pfDic) {
		StackCellViewController *cellVC = [[StackCellViewController alloc] initWithNibName:@"StackCellViewController" bundle:nil];
		cellVC.delegate = self;
		[cellVC loadingData:data];
		[self.stackView addView:cellVC.view inGravity:NSStackViewGravityLeading];
		[self.window.stackCells addObject:cellVC];
		if (i==0) {
			[cellVC changeDisclosureViewState:NO];
		}
		i++;
	}
	
}




- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}


- (IBAction)showHelp:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://github.com/wbcyclist/PathFindingForObjC"]];
}



#pragma mark - StackCellViewDelegate
- (void)stackCellVC:(StackCellViewController *)stackCellVC disclosureDidChange:(BOOL)disclosureIsClosed {
	for (StackCellViewController *cellVC in self.window.stackCells) {
		if (stackCellVC != cellVC) {
			[cellVC changeDisclosureViewState:YES];
		}
	}
}




@end
