//
//  StackTableViewCell.m
//  PathFindingForObjC-Example
//
//  Created by JasioWoo on 15/4/5.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//

#import "StackTableViewCell.h"
#import "RadioButton.h"

@interface StackTableViewCell ()

@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation StackTableViewCell


//- (void)setCellBG:(UIImageView *)cellBG {
//	if (_cellBG != cellBG) {
//		_cellBG = cellBG;
//		UIImage *image = [[UIImage imageNamed:@"cell_menu_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(4,0,4,0)];
//		[cellBG setImage:image];
//	}
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.weight = 1;
		self.cellHeight = 44;
		self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 180, 44)];
		self.titleLab.font = [UIFont boldSystemFontOfSize:14];
		[self.contentView addSubview:self.titleLab];
		
		self.openView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLab.frame), 400, 0)];
		self.openView.backgroundColor = [UIColor lightGrayColor];
		self.openView.clipsToBounds = YES;
		self.openView.hidden = YES;
		[self.contentView addSubview:self.openView];
		
	}
	return self;
}

//- (void)layoutSubviews {
//	debugMethod();
//	[super layoutSubviews];
//	
////	self.bounds = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 60);
//	NSLog(@"cell tag=%d frame = %@", self.tag, NSStringFromCGRect(self.frame));
//	NSLog(@"cell content frame = %@", NSStringFromCGRect(self.contentView.frame));
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:NO];
}


- (void)setIsOpened:(BOOL)isOpened {
	if (_isOpened != isOpened) {
		_isOpened = isOpened;
		self.openView.hidden = !isOpened;
		if (isOpened) {
			self.cellHeight = CGRectGetMaxY(self.openView.frame);
		} else {
			self.cellHeight = CGRectGetMinY(self.openView.frame);
		}
	}
}

- (void)loadingData:(NSDictionary*)data {
	if (data==self.cellData) {
		return;
	}
	self.openView.frame = CGRectMake(0, CGRectGetMaxY(self.titleLab.frame), 400, 0);
	self.cellHeight = CGRectGetMinY(self.openView.frame);
	[self.openView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
	if (!data) {
		return;
	}
	CGFloat height = 0;
	
	self.cellData = data;
	self.titleLab.text = self.cellData[@"Algorithm"];
	self.algType = [self.cellData[@"algType"] intValue];
	
	int index = 0;
	for (NSString *key in @[@"Heuristic", @"DiagonalMovement"]) {
		NSArray *value = self.cellData[key];
		if (value) {
			UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, height, 250, 17)];
			lab.font = [UIFont boldSystemFontOfSize:14];
			lab.textColor = [UIColor whiteColor];
			lab.text = key;
			[self.openView addSubview:lab];
			height = CGRectGetMaxY(lab.frame);
			
			NSMutableArray* buttons = [NSMutableArray arrayWithCapacity:4];
			CGRect btnRect = CGRectMake(10, height, 250, 30);
			for (int i=0; i < value.count; i++) {
				NSString *optionTitle = value[i];
				RadioButton* btn = [[RadioButton alloc] initWithFrame:btnRect];
				[btn addTarget:self action:@selector(onRadioButtonValueChanged:) forControlEvents:UIControlEventValueChanged];
				btnRect.origin.y += 25;
				btn.tag = i + index;
				[btn setTitle:optionTitle forState:UIControlStateNormal];
				[btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
				btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
				[btn setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
				[btn setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
				btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
				btn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
				[buttons addObject:btn];
				
				[self.openView addSubview:btn];
				height = CGRectGetMaxY(btn.frame);
			}
			[buttons[0] setGroupButtons:buttons]; // Setting buttons into the group
			[buttons[0] setSelected:YES];
		}
		index += 10;
	}
	
	NSDictionary *options = self.cellData[@"Options"];
	BOOL hasBI = [options[@"Bi-directional"] boolValue];
	BOOL hasWeight = [options[@"Weight"] boolValue];
	
	if (hasBI || hasWeight) {
		UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, height, 200, 17)];
		lab.font = [UIFont boldSystemFontOfSize:14];
		lab.textColor = [UIColor whiteColor];
		lab.text = @"Options";
		[self.openView addSubview:lab];
		height = CGRectGetMaxY(lab.frame);
		
		if (hasBI) {
			UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(10, height+5, 100, 17)];
			lab2.font = [UIFont boldSystemFontOfSize:14];
			lab2.textColor = [UIColor whiteColor];
			lab2.text = @"Bi-directional:";
			[self.openView addSubview:lab2];
			
			UISwitch *biSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lab2.frame), height-3, 0, 0)];
			biSwitch.on = NO;
			biSwitch.tag = 0;
			[biSwitch addTarget:self action:@selector(onSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
			[self.openView addSubview:biSwitch];
			height = CGRectGetMaxY(biSwitch.frame);
		}
		
//		if (hasWeight) {
//			UILabel *lab3 = [[UILabel alloc] initWithFrame:CGRectMake(10, height+10, 55, 17)];
//			lab3.font = [UIFont boldSystemFontOfSize:14];
//			lab3.textColor = [UIColor whiteColor];
//			lab3.text = @"Weight:";
//			[self.openView addSubview:lab3];
//			
//			UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lab3.frame), height, 98, 27)];
//			field.text = @"1";
//			field.returnKeyType = UIReturnKeyDone;
//			field.enablesReturnKeyAutomatically = YES;
//			field.keyboardType = UIKeyboardTypeNumberPad;
//			field.textAlignment = NSTextAlignmentRight;
//			field.borderStyle = UITextBorderStyleRoundedRect;
//			
//			[self.openView addSubview:field];
//			height = CGRectGetMaxY(field.frame);
//		}
	}
	height +=5;
	self.openView.frame = (CGRect){
		.origin = self.openView.frame.origin,
		.size.width =  CGRectGetWidth(self.openView.frame),
		.size.height = height
	};
	if (self.isOpened) {
		self.cellHeight = CGRectGetMaxY(self.openView.frame);
	} else {
		self.cellHeight = CGRectGetMinY(self.openView.frame);
	}
}


-(void)onRadioButtonValueChanged:(RadioButton*)sender {
	if(sender.selected) {
		NSLog(@"Selected: %@, tag=%d", sender.titleLabel.text, (int)sender.tag);
		if (sender.tag<10) {
			self.heuristicType = (int)sender.tag;
		} else {
			self.movementType = (int)sender.tag-10;
		}
	}
}

-(void)onSwitchValueChanged:(UISwitch*)sender {
	NSLog(@"UISwitch tag:%d, state:%@", (int)sender.tag, sender.on?@"YES":@"NO");
	if (sender.tag==0) {
		self.isBidirectional = sender.isOn;
	}
}






@end
