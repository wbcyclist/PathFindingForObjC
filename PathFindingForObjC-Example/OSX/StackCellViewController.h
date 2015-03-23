//  Created by JasioWoo on 15/3/22.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface StackCellViewController : NSViewController

@property (weak)IBOutlet NSView *headerView;


- (IBAction)toggleDisclosure:(id)sender;


- (void)loadingData:(NSDictionary *)data;

@end
