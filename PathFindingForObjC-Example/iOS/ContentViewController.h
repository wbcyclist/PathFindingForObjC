//
//  ContentViewController.h
//  PathFindingForObjC-Example
//
//  Created by JasioWoo on 15/4/4.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameScene.h"

@interface ContentViewController : UIViewController

@property (nonatomic, weak)IBOutlet SKView *skView;

@property (nonatomic, weak)id<PathFindingActionDelegate> pf_delegate;


- (void)adjustTrackSpeed:(UISlider *)sender;

@end
