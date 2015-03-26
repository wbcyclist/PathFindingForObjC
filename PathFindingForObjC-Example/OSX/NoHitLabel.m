//
//  NoHitLabel.m
//  PathFindingForObjC-Example
//
//  Created by JasioWoo on 15/3/27.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "NoHitLabel.h"

@implementation NoHitLabel

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (NSView *)hitTest:(NSPoint)aPoint {
	return nil;
}

@end
