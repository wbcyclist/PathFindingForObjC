//
//  StackViewController.m
//  PathFindingForObjC-Example
//
//  Created by JasioWoo on 15/3/22.
//  Copyright (c) 2015年 JasioWoo. All rights reserved.
//


#import "StackCellViewController.h"


#define DISCLOSED_HEIGHT 320



#pragma mark - OnlyIntegerValueFormatter
@interface OnlyIntegerValueFormatter : NSNumberFormatter
@end
@implementation OnlyIntegerValueFormatter
- (BOOL)isPartialStringValid:(NSString*)partialString newEditingString:(NSString**)newString errorDescription:(NSString**)error{
	if([partialString length] == 0) {
		return YES;
	}
	NSScanner* scanner = [NSScanner scannerWithString:partialString];
	if(!([scanner scanInt:0] && [scanner isAtEnd])) {
		NSBeep();
		return NO;
	}
	return YES;
}
@end




#pragma mark - StackCellViewController
@interface StackCellViewController () <NSTextFieldDelegate>
@property (nonatomic, copy)NSString *headerTitle;
@property (nonatomic, weak)IBOutlet NSTextField *titleView;

@property (nonatomic, weak)IBOutlet NSButton *disclosedBtn;
@property (nonatomic, strong)NSView *disclosedView;
@property (nonatomic, strong) NSLayoutConstraint *closingConstraint;


@end

@implementation StackCellViewController {
	
}

- (void)viewDidLoad {
    [super viewDidLoad];
	_headerTitle = @"";
	_disclosureIsClosed = YES;
	_weight = 1;
    // Do view setup here.
}


#pragma mark - 
- (void)setHeaderTitle:(NSString *)headerTitle {
	if (_headerTitle != headerTitle) {
		_headerTitle = headerTitle;
		_titleView.stringValue = headerTitle;
	}
}


- (void)setTitleView:(NSTextField *)titleView {
	if (_titleView != titleView) {
		_titleView = titleView;
		_titleView.stringValue = _headerTitle;
	}
}

- (void)setDisclosedBtn:(NSButton *)disclosedBtn {
	if (_disclosedBtn != disclosedBtn) {
		_disclosedBtn = disclosedBtn;
		[_disclosedBtn setState:_disclosureIsClosed];
	}
}

- (void)setDisclosureIsClosed:(BOOL)disclosureIsClosed {
	_disclosureIsClosed = disclosureIsClosed;
	[_disclosedBtn setState:!_disclosureIsClosed];
}



- (NSView *)disclosedView {
	if (!_disclosedView) {
		_disclosedView = [[NSView alloc] initWithFrame:CGRectMake(0, 0, 150, 250)];
		_disclosedView.wantsLayer = YES;
		_disclosedView.layer.backgroundColor = [NSColor whiteColor].CGColor;
		[_disclosedView setTranslatesAutoresizingMaskIntoConstraints:NO];
		
		[self.view addSubview:_disclosedView];
		[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_disclosedView]|"
																		  options:0
																		  metrics:nil
																			views:NSDictionaryOfVariableBindings(_disclosedView)]];
		[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_headerView][_disclosedView]"
																		  options:0
																		  metrics:nil
																			views:NSDictionaryOfVariableBindings(_headerView, _disclosedView)]];
		[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_disclosedView]|"
																		  options:0 metrics:nil
																			views:NSDictionaryOfVariableBindings(_disclosedView)]];
		
		
		self.closingConstraint = [NSLayoutConstraint constraintWithItem:_disclosedView
															  attribute:NSLayoutAttributeHeight
															  relatedBy:NSLayoutRelationEqual
																 toItem:nil attribute:0 multiplier:1 constant:0];
		[_disclosedView addConstraint:self.closingConstraint];

		self.closingConstraint.constant = DISCLOSED_HEIGHT;
	}
	return _disclosedView;
}

- (void)loadingData:(NSDictionary *)data {
	if (!data) {
		return;
	}
	self.cellData = data;
	self.headerTitle = self.cellData[@"Algorithm"];
	self.algType = [self.cellData[@"algType"] intValue];
	
	[self.disclosedView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
	// Heuristic
	NSArray *heuristicArr = self.cellData[@"Heuristic"];
	if (heuristicArr) {
		NSTextField *lab1 = [[NSTextField alloc] initWithFrame:CGRectMake(10, 0, 100, 17)];
		lab1.stringValue = @"Heuristic";
		lab1.bezeled = NO;
		lab1.drawsBackground = NO;
		lab1.editable = NO;
		lab1.selectable = NO;
		lab1.alignment = NSLeftTextAlignment;
		[lab1 setTranslatesAutoresizingMaskIntoConstraints:NO];
		[self.disclosedView addSubview:lab1];
		[self.disclosedView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[lab1(100)]"
																				   options:0
																				   metrics:nil
																					 views:NSDictionaryOfVariableBindings(lab1)]];
		[self.disclosedView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[lab1(17)]"
																				   options:0
																				   metrics:nil
																					 views:NSDictionaryOfVariableBindings(lab1)]];
		
		
		NSButtonCell *prototype = [[NSButtonCell alloc] init];
		[prototype setButtonType:NSRadioButton];
		
		NSMatrix *radioMatrix = [[NSMatrix alloc] initWithFrame:NSMakeRect(40, 0, 250, 21*heuristicArr.count)
														   mode:NSRadioModeMatrix
													  prototype:(NSCell *)prototype
												   numberOfRows:heuristicArr.count
												numberOfColumns:1];
		radioMatrix.cellSize = CGSizeMake(200, 20);
		radioMatrix.tag = 0;
		[radioMatrix setTarget:self];
		[radioMatrix setAction:@selector(btnSelected:)];
		for (int i=0; i < heuristicArr.count; i++) {
			NSString *cellTitle = heuristicArr[i];
			[radioMatrix.cells[i] setTag:i];
			[radioMatrix.cells[i] setTitle:cellTitle];
		}
		
		[radioMatrix setTranslatesAutoresizingMaskIntoConstraints:NO];
		[self.disclosedView addSubview:radioMatrix];
		
		[self.disclosedView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[radioMatrix(250)]"
																				   options:0
																				   metrics:nil
																					 views:NSDictionaryOfVariableBindings(radioMatrix)]];
		[self.disclosedView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[lab1]-5-[radioMatrix(%d)]", (int)heuristicArr.count*21]
																				   options:0
																				   metrics:nil
																					 views:NSDictionaryOfVariableBindings(lab1, radioMatrix)]];
		
		
	}
	
	// DiagonalMovement
	NSArray *movementArr = self.cellData[@"DiagonalMovement"];
	if (movementArr) {
		NSView *lastView = self.disclosedView.subviews.lastObject;
		
		NSTextField *lab1 = [[NSTextField alloc] initWithFrame:CGRectMake(10, 0, 100, 17)];
		lab1.stringValue = @"DiagonalMovement";
		lab1.bezeled = NO;
		lab1.drawsBackground = NO;
		lab1.editable = NO;
		lab1.selectable = NO;
		lab1.alignment = NSLeftTextAlignment;
		[lab1 setTranslatesAutoresizingMaskIntoConstraints:NO];
		[self.disclosedView addSubview:lab1];
		[self.disclosedView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[lab1(100)]"
																				   options:0
																				   metrics:nil
																					 views:NSDictionaryOfVariableBindings(lab1)]];
		if (lastView) {
			[self.disclosedView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lastView]-10-[lab1(17)]"
																					   options:0
																					   metrics:nil
																						 views:NSDictionaryOfVariableBindings(lastView, lab1)]];
		} else {
			[self.disclosedView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[lab1(17)]"
																					   options:0
																					   metrics:nil
																						 views:NSDictionaryOfVariableBindings(lab1)]];
		}
		
		NSButtonCell *prototype = [[NSButtonCell alloc] init];
		[prototype setButtonType:NSRadioButton];
		
		NSMatrix *radioMatrix = [[NSMatrix alloc] initWithFrame:NSMakeRect(40, 0, 250, 21*movementArr.count)
														   mode:NSRadioModeMatrix
													  prototype:(NSCell *)prototype
												   numberOfRows:movementArr.count
												numberOfColumns:1];
		radioMatrix.cellSize = CGSizeMake(200, 20);
		radioMatrix.tag = 1;
		[radioMatrix setTarget:self];
		[radioMatrix setAction:@selector(btnSelected:)];
		
		for (int i=0; i < movementArr.count; i++) {
			NSString *cellTitle = movementArr[i];
			[radioMatrix.cells[i] setTag:i];
			[radioMatrix.cells[i] setTitle:cellTitle];
		}
		
		[radioMatrix setTranslatesAutoresizingMaskIntoConstraints:NO];
		[self.disclosedView addSubview:radioMatrix];
		
		[self.disclosedView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[radioMatrix(250)]"
																				   options:0
																				   metrics:nil
																					 views:NSDictionaryOfVariableBindings(radioMatrix)]];
		[self.disclosedView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[lab1]-5-[radioMatrix(%d)]", (int)movementArr.count*21]
																				   options:0
																				   metrics:nil
																					 views:NSDictionaryOfVariableBindings(lab1, radioMatrix)]];
	}
	
	NSDictionary *options = self.cellData[@"Options"];
	BOOL hasBI = [options[@"Bi-directional"] boolValue];
	BOOL hasWeight = [options[@"Weight"] boolValue];
	
	if (hasBI || hasWeight) {
		NSView *lastView = self.disclosedView.subviews.lastObject;
		
		NSTextField *lab1 = [[NSTextField alloc] initWithFrame:CGRectMake(10, 0, 100, 17)];
		lab1.stringValue = @"Options";
		lab1.bezeled = NO;
		lab1.drawsBackground = NO;
		lab1.editable = NO;
		lab1.selectable = NO;
		lab1.alignment = NSLeftTextAlignment;
		[lab1 setTranslatesAutoresizingMaskIntoConstraints:NO];
		[self.disclosedView addSubview:lab1];
		[self.disclosedView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[lab1(100)]"
																				   options:0
																				   metrics:nil
																					 views:NSDictionaryOfVariableBindings(lab1)]];
		if (lastView) {
			[self.disclosedView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lastView]-10-[lab1(17)]"
																					   options:0
																					   metrics:nil
																						 views:NSDictionaryOfVariableBindings(lastView, lab1)]];
		} else {
			[self.disclosedView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[lab1(17)]"
																					   options:0
																					   metrics:nil
																						 views:NSDictionaryOfVariableBindings(lab1)]];
		}
		
		
		if (hasBI) {
			NSButton *checkBtn = [[NSButton alloc] init];
			checkBtn.tag = 2;
			[checkBtn setButtonType:NSSwitchButton];
			[checkBtn setState:NO];
			checkBtn.title = @"Bi-directional";
			checkBtn.target = self;
			checkBtn.action = @selector(btnSelected:);
			
			[checkBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
			[self.disclosedView addSubview:checkBtn];
			
			[self.disclosedView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-44-[checkBtn(250)]"
																					   options:0
																					   metrics:nil
																						 views:NSDictionaryOfVariableBindings(checkBtn)]];
			[self.disclosedView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lab1]-5-[checkBtn(21)]"
																					   options:0
																					   metrics:nil
																						 views:NSDictionaryOfVariableBindings(lab1, checkBtn)]];
		}
		
		if (hasWeight) {
			lastView = self.disclosedView.subviews.lastObject;
			
			NSTextField *weightField = [[NSTextField alloc] init];
			OnlyIntegerValueFormatter *formatter = [[OnlyIntegerValueFormatter alloc] init];
//			[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
			[weightField setFormatter:formatter];
			[weightField setTranslatesAutoresizingMaskIntoConstraints:NO];
			weightField.stringValue = @"1";
			weightField.tag = 3;
			weightField.delegate = self;
			
			NSTextField *lab1 = [[NSTextField alloc] init];
			lab1.stringValue = @"Weight";
			lab1.bezeled = NO;
			lab1.drawsBackground = NO;
			lab1.editable = NO;
			lab1.selectable = NO;
			lab1.alignment = NSLeftTextAlignment;
			[lab1 setTranslatesAutoresizingMaskIntoConstraints:NO];
			
			[self.disclosedView addSubview:weightField];
			[self.disclosedView addSubview:lab1];
			
			[self.disclosedView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-44-[weightField(50)]-5-[lab1(100)]"
																					   options:0
																					   metrics:nil
																						 views:NSDictionaryOfVariableBindings(weightField, lab1)]];
			[self.disclosedView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lastView]-5-[weightField(20)]"
																					   options:0
																					   metrics:nil
																						 views:NSDictionaryOfVariableBindings(lastView, weightField)]];
			
			[self.disclosedView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lastView]-5-[lab1(20)]"
																					   options:0
																					   metrics:nil
																						 views:NSDictionaryOfVariableBindings(lastView, lab1)]];
		}
	}
	
	if (self.disclosureIsClosed) {
		self.closingConstraint.constant = 0;
	} else {
		self.closingConstraint.constant = DISCLOSED_HEIGHT;
	}
}




- (void)btnSelected:(id)sender {
//	NSLog(@"sender.tag=%d", (int)[sender tag]);
	if ([sender tag]==0) {
		NSButtonCell *selCell = [sender selectedCell];
		self.heuristicType = (int)selCell.tag;
	} else if ([sender tag]==1) {
		NSButtonCell *selCell = [sender selectedCell];
		self.movementType = (int)selCell.tag;
	} else if ([sender tag]==2) {
		//self.isBidirectional = [sender state];
        self.isBidirectional = [((NSButton *)sender) state];
	}
}


- (void)toggleDisclosure:(id)sender {
//	debugMethod();
	self.disclosureIsClosed = NO;
	if (self.closingConstraint.constant==0) {
		[NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
			context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
			self.closingConstraint.animator.constant = DISCLOSED_HEIGHT;
		} completionHandler:^{
		}];
		
		//
		if (self.delegate) {
			[self.delegate stackCellVC:self disclosureDidChange:self.disclosureIsClosed];
		}
	} else {
		
//		self.disclosureIsClosed = YES;
//		[NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
//			context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//			self.closingConstraint.animator.constant = 0;
//		} completionHandler:^{
//		}];
	}
}

- (void)changeDisclosureViewState:(BOOL)disclosureIsClosed {
	if (self.disclosureIsClosed == disclosureIsClosed) {
		return;
	}
	self.disclosureIsClosed = disclosureIsClosed;
	
	if (self.disclosureIsClosed) {
		[NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
			context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
			self.closingConstraint.animator.constant = 0;
		} completionHandler:^{
		}];
	} else {
		[NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
			context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
			self.closingConstraint.animator.constant = DISCLOSED_HEIGHT;
		} completionHandler:^{
		}];
	}
}


#pragma mark - NSTextFieldDelegate
- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor {
//	NSLog(@"text tag=%d %@", (int)control.tag, fieldEditor.string);
	self.weight = fieldEditor.string.intValue;
	return YES;
}


@end


