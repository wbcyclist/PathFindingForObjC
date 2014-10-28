//
//  WBGameUtilities.h
//  BalloonFight
//
//  Created by JasioWoo on 14/9/23.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//


#import "SKNode+WBKit.h"

#if TARGET_OS_IPHONE

#else
//iOS SDK NSStringFromCG To OSX SDK
	#define NSStringFromCGPoint(x) NSStringFromPoint(NSPointFromCGPoint(x))
	#define NSStringFromCGSize(x) NSStringFromSize(NSSizeFromCGSize(x))
	#define NSStringFromCGRect(x) NSStringFromRect(NSRectFromCGRect(x))
#endif




/* The assets are all facing Y down, so offset by pi half to get into X right facing. */
#define WB_POLAR_ADJUST(x) x+(M_PI*0.5f)

/// 两点间的距离
CGFloat WB_DistanceBetweenPoints(CGPoint first, CGPoint second);
/// 两点直线相对的弧度
CGFloat WB_RadiansBetweenPoints(CGPoint first, CGPoint second);
/// 两点相加
CGPoint WB_PointByAddingCGPoints(CGPoint first, CGPoint second);

/// YES: x和y有相同的符号 NO: x，y有相反的符号
BOOL WB_ISSameSign(NSInteger x, NSInteger y);

/* Load the named frames in a texture atlas into an array of frames. */
NSArray *WB_LoadFramesFromAtlas(NSString *atlasName, NSString *baseFileName, int numberOfFrames);


/* Category on SKEmitterNode to make it easy to load an emitter from a node file created by Xcode. */
@interface SKEmitterNode (WBBalloonFightAdditions)
+ (instancetype)wbbf_emitterNodeWithEmitterNamed:(NSString *)emitterFileName;
@end










