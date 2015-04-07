//
//  LeftViewController.m
//  PathFindingForObjC-Example
//
//  Created by JasioWoo on 15/4/4.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "LeftViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "StackTableViewCell.h"
#import "ContentViewController.h"

static NSString *CellIdentifier = @"StackTableCell";

@interface LeftViewController ()

@property (nonatomic, weak)IBOutlet UISlider *speedSlider;
@property (nonatomic, weak)IBOutlet UISwitch *weightSwitch;

@end

@implementation LeftViewController {
	int currentRow;
	NSMutableArray *cells;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	cells = [NSMutableArray array];
	
	// load data
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"PathFindingData" ofType:@"json"];
	NSData *data = [NSData dataWithContentsOfFile:filePath];
	NSArray *pfDics = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
	
	currentRow = 0;
	for (int i=0; i<pfDics.count; i++) {
		NSDictionary *data = pfDics[i];
		StackTableViewCell *cell = [[StackTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
		cell.tag = i;
		[cell loadingData:data];
		if (i==currentRow) {
			cell.isOpened = YES;
		}
		[cells addObject:cell];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
//	NSLog(@"leftView Frame = %@", NSStringFromCGRect(self.view.frame));
}

- (void)setSpeedSlider:(UISlider *)speedSlider {
	if (_speedSlider != speedSlider) {
		_speedSlider = speedSlider;
		[speedSlider addTarget:self.slidingViewController.topViewController action:@selector(adjustTrackSpeed:) forControlEvents:UIControlEventValueChanged];
	}
}


- (NSDictionary *)fetchPFInfo {
	NSMutableDictionary *pfInfo = [NSMutableDictionary dictionary];
	
	pfInfo[@"isShowWeight"] = @(self.weightSwitch.isOn);
	pfInfo[@"trackSpeed"] = @(fabsf(self.speedSlider.value-self.speedSlider.maximumValue-1));
	
	for (StackTableViewCell *cell in cells) {
		if (cell.isOpened) {
			pfInfo[@"algType"] = @(cell.algType);
			pfInfo[@"heuristicType"] = @(cell.heuristicType);
			pfInfo[@"movementType"] = @(cell.movementType);
			pfInfo[@"isBidirectional"] = @(cell.isBidirectional);
			pfInfo[@"weight"] = @(cell.weight);
			break;
		}
	}
	return pfInfo;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return cells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	StackTableViewCell *cell = cells[indexPath.row];
	return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return [cells[indexPath.row] cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	if (currentRow == indexPath.row) {
		return;
	}
	currentRow = (int)indexPath.row;
	
	for (int i=0; i<cells.count; i++) {
		StackTableViewCell *cell = cells[i];
		cell.isOpened = i == currentRow;
	}
//	[tableView beginUpdates];
	[tableView reloadData];
	[tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
//	[tableView endUpdates];
	
}




@end
