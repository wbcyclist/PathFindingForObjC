//
//  NoHitLabel.m
//  PathFindingForObjC-Example
//
//  Created by JasioWoo on 15/3/27.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "NoHitLabel.h"

@implementation NoHitLabel


- (NSView *)hitTest:(NSPoint)aPoint {
	return nil;
}

@end
