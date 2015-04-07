//
//  StackTableViewCell.h
//  PathFindingForObjC-Example
//
//  Created by JasioWoo on 15/4/5.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StackTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *openView;

@property (nonatomic, assign)BOOL isOpened;
@property (nonatomic, assign)CGFloat cellHeight;
@property (nonatomic, strong)NSDictionary *cellData;

@property (nonatomic, assign)int algType;
@property (nonatomic, assign)int heuristicType;
@property (nonatomic, assign)int movementType;
@property (nonatomic, assign)BOOL isBidirectional;
@property (nonatomic, assign)int weight;




- (void)loadingData:(NSDictionary*)data;

@end
