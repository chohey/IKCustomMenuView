//
//  IKViewController.h
//  IKCustomMenuView
//
//  Created by 閑野 伊織 on 13/10/27.
//  Copyright (c) 2013年 Chohey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IKViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *backImageView;
@property (strong, nonatomic) IBOutlet UIButton *btn1;
@property (strong, nonatomic) IBOutlet UIButton *btn2;
@property (strong, nonatomic) IBOutlet UIView *coverView;


- (IBAction)pushCustomBtn:(id)sender;
@end
