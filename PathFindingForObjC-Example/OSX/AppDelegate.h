//
//  AppDelegate.h
//  PathFinding-Mac
//

//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SpriteKit/SpriteKit.h>
#import "SplitWindow.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet SplitWindow *window;

@property (nonatomic, weak)IBOutlet NSStackView *stackView;
@property (nonatomic, weak)IBOutlet SKView *skView;



- (IBAction)showHelp:(id)sender;



@end
