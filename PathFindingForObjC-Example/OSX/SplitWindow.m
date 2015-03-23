//
//  SplitWindow.m
//  PathFindingForObjC-Example
//
//  Created by JasioWoo on 15/3/20.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "SplitWindow.h"

@implementation SplitWindow


//- (void)setLeftView:(NSView *)leftView {
//	if (_leftView != leftView) {
//		_leftView = leftView;
//		_leftView.wantsLayer = YES;
//		_leftView.layer.backgroundColor = [NSColor redColor].CGColor;
//	}
//}
//
//- (void)setRightView:(NSView *)rightView {
//	if (_rightView != rightView) {
//		_rightView = rightView;
//		_rightView.wantsLayer = YES;
//		_rightView.layer.backgroundColor = [NSColor blueColor].CGColor;
//	}
//}



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

- (void)splitView:(NSSplitView *)splitView resizeSubviewsWithOldSize:(NSSize)oldSize {
	if (NSEqualSizes(splitView.frame.size, oldSize)) {
		return;
	}
	NSSize newSize = splitView.frame.size;
	NSPoint rightOrigin = NSMakePoint(splitView.dividerThickness, 0);
	
	if (![splitView isSubviewCollapsed:self.leftView]) {
		rightOrigin = NSMakePoint(self.leftView.frame.size.width + splitView.dividerThickness, 0);
		
		if (newSize.height != oldSize.height) {
			[self.leftView setFrameSize:NSMakeSize(self.leftView.frame.size.width, newSize.height)];
		}
	}
	
	NSRect rightFrame = {
		rightOrigin,
		newSize.width - rightOrigin.x,
		newSize.height
	};
	[self.rightView setFrame:rightFrame];
}

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

@end
