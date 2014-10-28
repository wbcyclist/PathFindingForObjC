//
//  WBArrowShapeNode.h
//  BalloonFight
//
//  Created by JasioWoo on 14/9/19.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>


@interface WBArrowShapeNode : SKShapeNode

+ (id)arrowNodeWithStartPoint:(CGPoint)startPoint
					 endPoint:(CGPoint)endPoint
					headWidth:(CGFloat)headWidth
				   headLength:(CGFloat)headLength
					tailWidth:(CGFloat)tailWidth
						color:(SKColor *)color;

- (id)initWithStartPoint:(CGPoint)startPoint
				endPoint:(CGPoint)endPoint
			   headWidth:(CGFloat)headWidth
			  headLength:(CGFloat)headLength
			   tailWidth:(CGFloat)tailWidth
				   color:(SKColor *)color;

@end
