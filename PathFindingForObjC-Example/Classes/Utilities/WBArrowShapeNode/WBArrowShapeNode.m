//
//  WBArrowShapeNode.m
//  BalloonFight
//
//  Created by JasioWoo on 14/9/19.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import "WBArrowShapeNode.h"

@implementation WBArrowShapeNode

#pragma mark - init
+ (id)arrowNodeWithStartPoint:(CGPoint)startPoint
					 endPoint:(CGPoint)endPoint
					headWidth:(CGFloat)headWidth
				   headLength:(CGFloat)headLength
					tailWidth:(CGFloat)tailWidth
						color:(SKColor *)color
{
	return [[WBArrowShapeNode alloc] initWithStartPoint:startPoint endPoint:endPoint headWidth:headWidth headLength:headLength tailWidth:tailWidth color:color];
}


- (id)initWithStartPoint:(CGPoint)startPoint
				endPoint:(CGPoint)endPoint
			   headWidth:(CGFloat)headWidth
			  headLength:(CGFloat)headLength
			   tailWidth:(CGFloat)tailWidth
				   color:(SKColor *)color
{
	self = [super init];
	if (self) {
//		NSLog(@"startPoint=%@", NSStringFromCGPoint(startPoint));
//		NSLog(@"endPoint=%@", NSStringFromCGPoint(endPoint));
		
		CGPathRef pathRef = WBCreateArrowShapePath(startPoint, endPoint,
												   headWidth, headLength,
												   tailWidth);
		self.fillColor = color;
		self.path = pathRef;
		CGPathRelease(pathRef);
	}
	return self;
}



#pragma mark - C Method
void WBAxisAlignedArrowPoints(CGPoint *points,
							  CGFloat length,
							  CGFloat headWidth,
							  CGFloat headLength,
							  CGFloat tailWidth) {
	headWidth *= 0.5;
	tailWidth *= 0.5;
	points[0] = CGPointMake(0.0, -tailWidth);
	points[1] = CGPointMake(length - headLength, -tailWidth);
	points[2] = CGPointMake(length - headLength, -headWidth);
	points[3] = CGPointMake(length, 0.0);
	points[4] = CGPointMake(length - headLength, headWidth);
	points[5] = CGPointMake(length - headLength, tailWidth);
	points[6] = CGPointMake(0.0, tailWidth);
}

CGPathRef WBCreateArrowShapePath(CGPoint startPoint,
								 CGPoint endPoint,
								 CGFloat headWidth,
								 CGFloat headLength,
								 CGFloat tailWidth) {
	CGFloat length = hypot(endPoint.x - startPoint.x, endPoint.y - startPoint.y);
	CGPoint points[7];
	WBAxisAlignedArrowPoints(points, length, headWidth, headLength, tailWidth);
	
	CGFloat angle = atan2(endPoint.y - startPoint.y, endPoint.x - startPoint.x);
	CGAffineTransform transform = CGAffineTransformMakeRotation(angle);
	
//	CGFloat cosine = (endPoint.x - startPoint.x) / length;
//	CGFloat sine = (endPoint.y - startPoint.y) / length;
//	CGAffineTransform transform = (CGAffineTransform){ cosine, sine, -sine, cosine, startPoint.x, startPoint.y };
//	CGAffineTransform transform = (CGAffineTransform){ cosine, sine, -sine, cosine, 0, 0 };
	
	CGMutablePathRef pathRef = CGPathCreateMutable();
	CGPathAddLines(pathRef, &transform, points, sizeof(points)/sizeof(*points));
	CGPathCloseSubpath(pathRef);
	return pathRef;
	
}








@end
