//
//  IKViewController.m
//  IKCustomMenuView
//
//  Created by 閑野 伊織 on 13/10/27.
//  Copyright (c) 2013年 Chohey. All rights reserved.
//

#import "IKViewController.h"

@interface IKViewController ()
@property (nonatomic,strong) NSMutableString *caseString;
@property int currentCameraX, currentCameraY, currentDataX, currentDataY, reverse;
@property (nonatomic, strong) UILabel *naviTitleLabel;
@property (strong, nonatomic) NSTimer *shakeTimer;
@end

@implementation IKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushCustomBtn:(id)sender {
}
@end
