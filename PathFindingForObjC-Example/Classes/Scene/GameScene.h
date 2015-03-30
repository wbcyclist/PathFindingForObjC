//
//  GameScene.h
//  PathFindingForObjC-Example
//

//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>


@protocol PathFindingActionDelegate <NSObject>
-(void)startAction:(id)sender withPFInfo:(NSDictionary *)info;
-(void)pauseAction:(id)sender;
-(void)clearAction:(id)sender;
@end

typedef enum {
	PFState_Ide = 0,
	PFState_finding,
	PFState_pause,
	PFState_finish
} PFState;



extern NSString *const PathFinding_NC_Start;
extern NSString *const PathFinding_NC_Finish;
extern NSString *const PathFinding_NC_Result;

@interface GameScene : SKScene <PathFindingActionDelegate>

@property (nonatomic, assign) CGSize gridSize;
@property (nonatomic, assign) PFState pfState;
@property (nonatomic, assign) NSUInteger trackSpeed;


- (void)startFindingPath:(NSDictionary *)pfInfo;

@end
