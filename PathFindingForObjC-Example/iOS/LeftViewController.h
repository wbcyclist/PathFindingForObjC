//
//  LeftViewController.h
//  PathFindingForObjC-Example
//
//  Created by JasioWoo on 15/4/4.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak)IBOutlet UITableView *stackTableView;


- (NSDictionary *)fetchPFInfo;

@end
