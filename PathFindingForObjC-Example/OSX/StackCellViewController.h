//  Created by JasioWoo on 15/3/22.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class StackCellViewController;

@protocol StackCellViewDelegate <NSObject>
@optional
- (void)stackCellVC:(StackCellViewController *)stackCellVC disclosureDidChange:(BOOL)disclosureIsClosed;
@end


@interface StackCellViewController : NSViewController

@property (nonatomic, weak) id<StackCellViewDelegate>delegate;

@property (weak)IBOutlet NSView *headerView;
@property (nonatomic, assign, readonly)BOOL disclosureIsClosed;
@property (nonatomic, strong)NSDictionary *cellData;

@property (nonatomic, assign)int heuristicType;
@property (nonatomic, assign)int movementType;
@property (nonatomic, assign)BOOL isBidirectional;
@property (nonatomic, assign)int weight;


- (IBAction)toggleDisclosure:(id)sender;


- (void)loadingData:(NSDictionary*)data;
- (void)changeDisclosureViewState:(BOOL)disclosureIsClosed;

@end
