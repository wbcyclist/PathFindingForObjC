//
//  SplitWindow.h
//  PathFindingForObjC-Example
//
//  Created by JasioWoo on 15/3/20.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GameScene.h"



@interface SplitWindow : NSWindow <NSSplitViewDelegate>

@property (assign)IBOutlet NSSplitView *splitView;
@property (nonatomic, weak)IBOutlet NSView *leftView;
@property (nonatomic, weak)IBOutlet NSView *rightView;

@property (nonatomic, weak)IBOutlet NSSlider *speedSlider;
@property (nonatomic, weak)IBOutlet NSButton *weightCheckBtn;
@property (nonatomic, strong)NSMutableArray *stackCells;

@property (nonatomic, weak)IBOutlet NSTextField *timeLab;
@property (nonatomic, weak)IBOutlet NSTextField *lengthLab;
@property (nonatomic, weak)IBOutlet NSButton *startBtn;
@property (nonatomic, weak)IBOutlet NSButton *pauseBtn;
@property (nonatomic, weak)IBOutlet NSButton *clearBtn;

@property (nonatomic, weak)id<PathFindingActionDelegate> pf_delegate;


- (IBAction)startBtnAction:(NSButton *)sender;
- (IBAction)pauseBtnAction:(NSButton *)sender;
- (IBAction)clearBtnAction:(NSButton *)sender;




@end
