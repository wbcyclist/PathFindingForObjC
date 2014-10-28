//
//  Heuristic.m
//
//  Created by JasioWoo on 14/10/27.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import "Heuristic.h"

static float F = 1.4-1;//M_SQRT2 - 1;

@implementation Heuristic
- (float)performAlgorithmWithX:(float)dx andY:(float)dy {
	// Override
	return 0;
}
@end

@implementation Manhattan
- (float)performAlgorithmWithX:(float)dx andY:(float)dy {
	return dx + dy;
}
@end

@implementation Euclidean
- (float)performAlgorithmWithX:(float)dx andY:(float)dy {
	return sqrtf(dx * dx + dy * dy);
}
@end

@implementation Octile
- (float)performAlgorithmWithX:(float)dx andY:(float)dy {
	return (dx < dy) ? F * dx + dy : F * dy + dx;
}
@end

@implementation Chebyshev
- (float)performAlgorithmWithX:(float)dx andY:(float)dy {
	return MAX(dx, dy);
}
@end



