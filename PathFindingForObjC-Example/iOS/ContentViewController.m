//
//  ContentViewController.m
//  PathFindingForObjC-Example
//
//  Created by JasioWoo on 15/4/4.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "ContentViewController.h"
#import "LeftViewController.h"
#import "UIViewController+ECSlidingViewController.h"

@interface ContentViewController ()
@property (nonatomic, weak)GameScene *gameScene;

@property (nonatomic, weak)IBOutlet UIButton *startBtn;
@property (nonatomic, weak)IBOutlet UIButton *pauseBtn;
@property (nonatomic, weak)IBOutlet UIButton *clearBtn;
@property (nonatomic, weak)IBOutlet UILabel *timeLab;
@property (nonatomic, weak)IBOutlet UILabel *lengthLab;



@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Configure the view.
	self.skView.showsFPS = YES;
//	self.skView.showsDrawCount = YES;
//	self.skView.showsNodeCount = YES;
	self.skView.ignoresSiblingOrder = YES;
	
	// Create and configure the scene.
	CGSize viewSize = self.view.bounds.size;
	viewSize.width *= 2;
	viewSize.height *= 2;
	GameScene *scene = [[GameScene alloc] initWithSize:viewSize];
	scene.scaleMode = SKSceneScaleModeFill;
	// Present the scene.
	[self.skView presentScene:scene];
	self.pf_delegate = scene;
	
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

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
//	self.slidingViewController.anchorRightPeekAmount = 50;
//	[self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

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


#pragma mark - fun
- (IBAction)menuButtonTapped:(UIButton *)sender {
	if (self.slidingViewController.currentTopViewPosition == ECSlidingViewControllerTopViewPositionCentered) {
		[self.slidingViewController anchorTopViewToRightAnimated:YES];
		[sender setTitle:@"Close" forState:UIControlStateNormal];
	} else {
		[self.slidingViewController resetTopViewAnimated:YES];
		[sender setTitle:@"Menu" forState:UIControlStateNormal];
	}
}

- (void)adjustTrackSpeed:(UISlider *)sender {
//	NSLog(@"track speed = %d", (int)fabsf(sender.value-sender.maximumValue-1));
	self.gameScene.trackSpeed = fabsf(sender.value-sender.maximumValue-1);
}


static NSString *TIME_LAB_PREFIX = @"Time: ";
static NSString *LENGTH_LAB_PREFIX = @"Length: ";

- (IBAction)startBtnAction:(UIButton *)sender {
	NSDictionary *pfInfo = nil;
	if (self.gameScene.pfState!=PFState_pause) {
		LeftViewController *leftVC = (LeftViewController*)self.slidingViewController.underLeftViewController;
		pfInfo = [leftVC fetchPFInfo];
		if (!pfInfo) {
			return;
		}
	}
	[self.gameScene startAction:self withPFInfo:pfInfo];
	
	[self.startBtn setTitle:@"Restart\nSearch" forState:UIControlStateNormal];
	[self.pauseBtn setTitle:@"Pause\nSearch" forState:UIControlStateNormal];
}
- (IBAction)pauseBtnAction:(UIButton *)sender {
	if (self.gameScene.pfState==PFState_Ide) {
		[self.pauseBtn setTitle:@"Pause\nSearch" forState:UIControlStateNormal];
		return;
	} else if (self.gameScene.pfState==PFState_finding) {
		[self.startBtn setTitle:@"Resume\nSearch" forState:UIControlStateNormal];
		[self.pauseBtn setTitle:@"Cancel\nSearch" forState:UIControlStateNormal];
	} else if (self.gameScene.pfState==PFState_pause || self.gameScene.pfState==PFState_finish) {
		[self.startBtn setTitle:@"Start\nSearch" forState:UIControlStateNormal];
		[self.pauseBtn setTitle:@"Pause\nSearch" forState:UIControlStateNormal];
	}
	[self.gameScene pauseAction:self];
}
- (IBAction)clearBtnAction:(UIButton *)sender {
	[self.gameScene clearAction:self];
	[self.startBtn setTitle:@"Start\nSearch" forState:UIControlStateNormal];
	[self.pauseBtn setTitle:@"Pause\nSearch" forState:UIControlStateNormal];
}


#pragma mark - GameScene Notification
- (void)startFindingPath:(NSNotification *)notification {
	
}
- (void)finishFindingPath:(NSNotification *)notification {
	[self.startBtn setTitle:@"Restart\nSearch" forState:UIControlStateNormal];
	[self.pauseBtn setTitle:@"Clear\nPath" forState:UIControlStateNormal];
}
- (void)resultFindingPath:(NSNotification *)notification {
	NSNumber *costTime = notification.userInfo[@"costTime"];
	NSNumber *length = notification.userInfo[@"length"];
	
	self.timeLab.text = [NSString stringWithFormat:@"%@%fms", TIME_LAB_PREFIX, costTime.floatValue];
	self.lengthLab.text = [NSString stringWithFormat:@"%@%d", LENGTH_LAB_PREFIX, length.intValue];
}




@end
