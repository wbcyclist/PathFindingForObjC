//
//  AppDelegate.m
//  PathFinding-Mac
//
//  Created by JasioWoo on 14/10/28.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import "AppDelegate.h"
#import "GameScene.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	CGSize size = CGSizeMake(560*2, 320*2);
	GameScene *scene = [[GameScene alloc] initWithSize:size];
    /* Set the scale mode to scale to fit the window */
    scene.scaleMode = SKSceneScaleModeAspectFit;

    [self.skView presentScene:scene];

    /* Sprite Kit applies additional optimizations to improve rendering performance */
    self.skView.ignoresSiblingOrder = YES;
	
    self.skView.showsFPS = YES;
	self.skView.showsDrawCount = YES;
    self.skView.showsNodeCount = YES;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}


- (IBAction)showHelp:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://github.com/wbcyclist/PathFindingForObjC"]];
}



@end
