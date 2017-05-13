//
//  AboutUsVC.m
//  LiveProject
//
//  Created by coolyouimac02 on 15/10/20.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "AboutUsVC.h"
#import "PrivacyPolicyVC.h"
#import "AttentionVC.h"
#import "AnchorProVC.h"
@interface AboutUsVC ()
@property (weak, nonatomic) IBOutlet UILabel *lineLabel1;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel2;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel3;

@end

@implementation AboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUsualNavigationBarWithBackAndTitleWithString:@"关于我们"];
    _lineLabel1.height = 0.3;
    _lineLabel2.height = 0.3;
    _lineLabel3.height = 0.3;
    _lineLabel1.backgroundColor = UIColorFromRGB(240, 240, 240);
    _lineLabel2.backgroundColor = UIColorFromRGB(240, 240, 240);
    _lineLabel3.backgroundColor = UIColorFromRGB(240, 240, 240);
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)userProtocolButtonAction:(id)sender {
    PrivacyPolicyVC *ppVC = [[PrivacyPolicyVC alloc]init];
    ppVC.policyType = kUserPolicyType;
    [self presentAsPushAndPopAnimationWithViewController:ppVC animation:YES];
}
- (IBAction)anchorProtocolButtonAction:(id)sender {
    PrivacyPolicyVC *ppVC = [[PrivacyPolicyVC alloc]init];
    ppVC.policyType = kAnchorPolicyType;
    [self presentAsPushAndPopAnimationWithViewController:ppVC animation:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
