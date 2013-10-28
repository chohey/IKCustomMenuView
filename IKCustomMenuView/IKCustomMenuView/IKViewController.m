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
@property int currentBtn1X, currentBtn1Y, currentBtn2X, currentBtn2Y, reverse;
@property (nonatomic, strong) UILabel *naviTitleLabel;
@property (strong, nonatomic) NSTimer *shakeTimer;
@property BOOL moveBtn;
@end

@implementation IKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self longPressSetup];
    [self uiSetup];
}
- (void)longPressSetup{
    // ボタンの長押し検出設定
    UILongPressGestureRecognizer *gestureRecognizerData = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressedHandler:)];
    [self.btn2 addGestureRecognizer:gestureRecognizerData];
    UILongPressGestureRecognizer *gestureRecognizerCamera = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressedHandler:)];
    [self.btn1 addGestureRecognizer:gestureRecognizerCamera];
}
- (void)uiSetup{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if ([ud objectForKey:@"backImage"]) {
        [self.backImageView setImage:[[UIImage alloc] initWithData:[ud objectForKey:@"backImage"]]];
    }else{
        [self.backImageView setImage:[UIImage imageNamed:@"backImage.png"]];
    }
    if ([ud objectForKey:@"buttonImage"]) {
        [self.btn1 setBackgroundImage:[[UIImage alloc] initWithData:[ud objectForKey:@"buttonImage"]] forState:UIControlStateNormal];
        [self.btn2 setBackgroundImage:[[UIImage alloc] initWithData:[ud objectForKey:@"buttonImage"]] forState:UIControlStateNormal];
    }else{
        [self.btn1 setBackgroundImage:[UIImage imageNamed:@"baseball.png"] forState:UIControlStateNormal];
        [self.btn2 setBackgroundImage:[UIImage imageNamed:@"baseball.png"] forState:UIControlStateNormal];
    }
    if ([ud objectForKey:@"btnPoint"]) {
        NSDictionary *dict = [ud objectForKey:@"btnPoint"];
        self.btn1.center = CGPointMake([[dict objectForKey:@"btn1X"] integerValue], [[dict objectForKey:@"btn1Y"] integerValue]);
        self.btn2.center = CGPointMake([[dict objectForKey:@"btn2X"] integerValue], [[dict objectForKey:@"btn2Y"] integerValue]);
    }else{
        self.btn1.center = CGPointMake(160,124);
        self.btn2.center = CGPointMake(160,240);
    }
    UIColor *color = [UIColor blackColor];
    UIColor *alphaColor = [color colorWithAlphaComponent:0.0];
    self.coverView.backgroundColor = alphaColor;
    self.currentBtn1X = self.btn1.frame.origin.x+self.btn1.frame.size.width/2;
    self.currentBtn1Y = self.btn1.frame.origin.y+self.btn1.frame.size.height/2;
    self.currentBtn2X = self.btn2.frame.origin.x+self.btn2.frame.size.width/2;
    self.currentBtn2Y = self.btn2.frame.origin.y+self.btn2.frame.size.height/2;
    self.moveBtn = NO;
}
- (void)viewWillAppear:(BOOL)animated
{
    self.naviTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.naviTitleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    self.naviTitleLabel.textColor = [UIColor colorWithRed:0.8f green:0.2f blue:0.2f alpha:1.0];
    self.naviTitleLabel.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = self.naviTitleLabel;
    self.naviTitleLabel.text = @"　　　　　　　　";
    [self.naviTitleLabel sizeToFit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushCustomBtn:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"レイアウトの変更" message:nil delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"背景画像変更",@"ボタン画像変更",@"ボタン位置変更",@"初期化",nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:{
            // cancelButtonが押されたときのアクション
            break;
        }
        case 1:{
            // 背景画像変更
            self.caseString = [NSMutableString stringWithString:@"backImage"];
            [self imagePickerSetup];
            break;
        }
        case 2:{
            // ボタン画像変更
            self.caseString = [NSMutableString stringWithString:@"buttonImage"];
            [self imagePickerSetup];
            break;
        }
        case 3:{
            // ボタン位置変更
            [self setMoveButton];
            break;
        }
        case 4:{
            // 初期化
            [self.backImageView setImage:[UIImage imageNamed:@"backImage.png"]];
            [self.btn1 setBackgroundImage:[UIImage imageNamed:@"baseball.png"] forState:UIControlStateNormal];
            [self.btn2 setBackgroundImage:[UIImage imageNamed:@"baseball.png"] forState:UIControlStateNormal];
            self.btn1.center = CGPointMake(160,124);
            self.btn2.center = CGPointMake(160,240);
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud removeObjectForKey:@"backImage"];
            [ud removeObjectForKey:@"buttonImage"];
            [ud removeObjectForKey:@"btnPoint"];
            [ud synchronize]; // 一応すぐに反映させる
            break;
        }
        default:
            break;
    }
}
- (void)imagePickerSetup{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];  // 生成
    ipc.delegate = self;  // デリゲートを自分自身に設定
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;  // 画像の取得先をカメラに設定
    ipc.allowsEditing = YES;  // 画像取得後編集する
    [self presentViewController:ipc animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    // UIImagePNGRepresentation関数によりUIImageが保持する画像データをPNG形式で抽出
    NSData* pngData = [[NSData alloc] initWithData:UIImagePNGRepresentation( image )];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if ([self.caseString isEqualToString:@"backImage"]) {
        [self.backImageView setImage:image];
        [ud setObject:pngData forKey:@"backImage"];
    }else{
        [self.btn1 setBackgroundImage:image forState:UIControlStateNormal];
        [self.btn2 setBackgroundImage:image forState:UIControlStateNormal];
        [ud setObject:pngData forKey:@"buttonImage"];
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)longPressedHandler:(UILongPressGestureRecognizer *)gestureRecognizer{
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan://長押しを検知開始
        {
            NSLog(@"UIGestureRecognizerStateBegan");
            [self setMoveButton];
        }
            break;
        default:
            break;
    }
}
-(void)setMoveButton
{
    [self.view bringSubviewToFront:self.coverView];
    self.naviTitleLabel.text = @"ボタン移動モード";
    self.shakeTimer = [NSTimer scheduledTimerWithTimeInterval:0.14f target:self selector:@selector(shake) userInfo:nil repeats:YES];
    self.reverse = 1;
    [self.shakeTimer fire];
    self.moveBtn = YES;
}

-(void)shake{
    [UIView animateWithDuration:0.07f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         // 揺らす
                         self.btn1.transform = CGAffineTransformMakeRotation(self.reverse * M_PI * 3 / 180.0);
                         self.btn2.transform = CGAffineTransformMakeRotation(self.reverse * M_PI * 3 / 180.0);
                         self.reverse *= -1;
                     } completion:^(BOOL finished) {
                         // アニメーションが終わった後実行する処理
                     }];
}

// 画面に指を一本以上タッチしたときに実行されるメソッド
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // タッチ点がボタン上でなければ移動モード解除 ポイントを記録する
    CGPoint p = [[touches anyObject] locationInView:self.view];
    if (![self checkInBtn:self.btn1 point:p] && ![self checkInBtn:self.btn2 point:p]) {
        [self.view sendSubviewToBack:self.coverView];
        self.naviTitleLabel.text = @"　　　　　　　　";
        NSDictionary *pointDict = [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:self.currentBtn1X], [NSNumber numberWithInt:self.currentBtn1Y], [NSNumber numberWithInt:self.currentBtn2X], [NSNumber numberWithInt:self.currentBtn2Y]] forKeys:@[@"btn1X",@"btn1Y",@"btn2X",@"btn2Y"]];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:pointDict forKey:@"btnPoint"];
        NSLog(@"ポイント保存！！:%@",pointDict);
        [self.shakeTimer invalidate];
        self.btn1.transform = CGAffineTransformMakeRotation(0.0 / 180.0);
        self.btn2.transform = CGAffineTransformMakeRotation(0.0 / 180.0);
        self.moveBtn = NO;
    }
}
// 画面に触れている指が一本以上移動したときに実行されるメソッド
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.moveBtn) {
        // ボタン上であればボタンを移動させる
        CGPoint p = [[touches anyObject] locationInView:self.view];
        if ([self checkInBtn:self.btn1 point:p]) {
            self.currentBtn1X = p.x;
            self.currentBtn1Y = p.y;
            self.btn1.center = CGPointMake(self.currentBtn1X, self.currentBtn1Y);
        }
        if ([self checkInBtn:self.btn2 point:p]) {
            self.currentBtn2X = p.x;
            self.currentBtn2Y = p.y;
            self.btn2.center = CGPointMake(self.currentBtn2X, self.currentBtn2Y);
        }
    }
}
- (BOOL)checkInBtn:(UIButton *)btn point:(CGPoint)point
{
    CGPoint b = btn.frame.origin;
    return (((b.x < point.x) && ((b.x+btn.frame.size.width) > point.x)) && ((b.y < point.y) && ((b.y+btn.frame.size.height) > point.y)));
}
@end
