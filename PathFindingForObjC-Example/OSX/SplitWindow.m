//
//  SplitWindow.m
//  PathFindingForObjC-Example
//
//  Created by JasioWoo on 15/3/20.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "SplitWindow.h"
#import "StackCellViewController.h"


@interface SplitWindow()
@property (nonatomic, weak)GameScene *gameScene;
@end

@implementation SplitWindow

- (void)setRightView:(NSView *)rightView {
	if (_rightView != rightView) {
		_rightView = rightView;
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(startFindingPath:)
													 name:PathFinding_NC_Start object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(finishFindingPath:)
													 name:PathFinding_NC_Finish object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(resultFindingPath:)
													 name:PathFinding_NC_Result object:nil];
	}
}

#define LEFT_VIEW_MIN_WIDTH 250.0
#define LEFT_VIEW_MAX_WIDTH 350.0

- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview {
	return self.leftView == subview;
}

- (BOOL)splitView:(NSSplitView *)splitView shouldCollapseSubview:(NSView *)subview forDoubleClickOnDividerAtIndex:(NSInteger)dividerIndex {
	return self.leftView == subview;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)dividerIndex {
	return LEFT_VIEW_MIN_WIDTH;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMaximumPosition ofSubviewAt:(NSInteger)dividerIndex {
	return LEFT_VIEW_MAX_WIDTH;
}

//- (CGFloat)splitView:(NSSplitView *)splitView constrainSplitPosition:(CGFloat)proposedPosition ofSubviewAt:(NSInteger)dividerIndex {
//	NSLog(@"proposedPosition=%f, dividerIndex=%ld", proposedPosition, (long)dividerIndex);
//	return proposedPosition;
//}

//- (void)splitView:(NSSplitView *)splitView resizeSubviewsWithOldSize:(NSSize)oldSize {
//	if (NSEqualSizes(splitView.frame.size, oldSize)) {
//		return;
//	}
//	NSSize newSize = splitView.frame.size;
//	NSPoint rightOrigin = NSMakePoint(splitView.dividerThickness, 0);
//	
//	if (![splitView isSubviewCollapsed:self.leftView]) {
//		rightOrigin = NSMakePoint(self.leftView.frame.size.width + splitView.dividerThickness, 0);
//		
//		if (newSize.height != oldSize.height) {
//			[self.leftView setFrameSize:NSMakeSize(self.leftView.frame.size.width, newSize.height)];
//		}
//	}
//	
//	NSRect rightFrame = {
//		rightOrigin,
//		newSize.width - rightOrigin.x,
//		newSize.height
//	};
//	[self.rightView setFrame:rightFrame];
//}

//- (BOOL)splitView:(NSSplitView *)splitView shouldAdjustSizeOfSubview:(NSView *)view {
//	return YES;
//}
//
//- (BOOL)splitView:(NSSplitView *)splitView shouldHideDividerAtIndex:(NSInteger)dividerIndex {
//	
//}
//
//- (NSRect)splitView:(NSSplitView *)splitView effectiveRect:(NSRect)proposedEffectiveRect forDrawnRect:(NSRect)drawnRect ofDividerAtIndex:(NSInteger)dividerIndex {
//	
//}
//
//- (NSRect)splitView:(NSSplitView *)splitView additionalEffectiveRectOfDividerAtIndex:(NSInteger)dividerIndex {
//	
//}

//- (void)splitViewWillResizeSubviews:(NSNotification *)notification {
////	debugMethod();
//	
//}
//- (void)splitViewDidResizeSubviews:(NSNotification *)notification {
////	debugMethod();
//}

- (void)setPf_delegate:(id<PathFindingActionDelegate>)pf_delegate {
	if (_pf_delegate != pf_delegate) {
		_pf_delegate = pf_delegate;
		if ([_pf_delegate isKindOfClass:[GameScene class]]) {
			self.gameScene = (GameScene *)_pf_delegate;
		} else {
			self.gameScene = nil;
		}
	}
}

static NSString *TIME_LAB_PREFIX = @"Time: ";
static NSString *LENGTH_LAB_PREFIX = @"Length: ";

//- (void)setStartBtn:(NSButton *)startBtn {
//	if (_startBtn != startBtn) {
//		_startBtn = startBtn;
//		_startBtn.alphaValue = 0.8f;
////		_startBtn.title = @"sda\nsdsd";
//	}
//}



- (IBAction)startBtnAction:(NSButton *)sender {
	NSMutableDictionary *pfInfo;
	if (self.gameScene.pfState!=PFState_pause) {
		pfInfo = [NSMutableDictionary dictionary];
		pfInfo[@"isShowWeight"] = @(self.weightCheckBtn.state);
		self.gameScene.trackSpeed = abs(self.speedSlider.intValue-(int)self.speedSlider.maxValue-1);
		for (StackCellViewController *cellVC in self.stackCells) {
			if (!cellVC.disclosureIsClosed) {
				pfInfo[@"algType"] = @(cellVC.algType);
				pfInfo[@"heuristicType"] = @(cellVC.heuristicType);
				pfInfo[@"movementType"] = @(cellVC.movementType);
				pfInfo[@"isBidirectional"] = @(cellVC.isBidirectional);
				pfInfo[@"weight"] = @(cellVC.weight);
				break;
			}
		}
	}
	[self.gameScene startAction:self withPFInfo:pfInfo];
	
	self.startBtn.title = @"Restart\nSearch";
	self.pauseBtn.title = @"Pause\nSearch";
}
- (IBAction)pauseBtnAction:(NSButton *)sender {
	if (self.gameScene.pfState==PFState_Ide) {
		self.pauseBtn.title = @"Pause\nSearch";
		return;
	} else if (self.gameScene.pfState==PFState_finding) {
		self.startBtn.title = @"Resume\nSearch";
		self.pauseBtn.title = @"Cancel\nSearch";
	} else if (self.gameScene.pfState==PFState_pause || self.gameScene.pfState==PFState_finish) {
		self.startBtn.title = @"Start\nSearch";
		self.pauseBtn.title = @"Pause\nSearch";
	}
	[self.gameScene pauseAction:self];
}
- (IBAction)clearBtnAction:(NSButton *)sender {
	[self.gameScene clearAction:self];
	self.startBtn.title = @"Start\nSearch";
	self.pauseBtn.title = @"Pause\nSearch";
}


-(IBAction)adjustTrackSpeed:(NSSlider *)sender {
	self.gameScene.trackSpeed = abs(sender.intValue-(int)sender.maxValue-1);
}

#pragma mark - GameScene Notification
- (void)startFindingPath:(NSNotification *)notification {
	
}
- (void)finishFindingPath:(NSNotification *)notification {
	self.startBtn.title = @"Restart\nSearch";
	self.pauseBtn.title = @"Clear\nPath";
}
- (void)resultFindingPath:(NSNotification *)notification {
	NSNumber *costTime = notification.userInfo[@"costTime"];
	NSNumber *length = notification.userInfo[@"length"];
	
	self.timeLab.stringValue = [NSString stringWithFormat:@"%@%fms", TIME_LAB_PREFIX, costTime.floatValue];
	self.lengthLab.stringValue = [NSString stringWithFormat:@"%@%d", LENGTH_LAB_PREFIX, length.intValue];
}















@end
