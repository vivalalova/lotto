//
//  PhoneFansListView.m
//  LiveProject
//
//  Created by coolyouimac01 on 16/5/24.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PhoneFansListView.h"
#import "PhoneFansCell.h"
//#import "RankingModel.h"
@interface PhoneFansListView ()<UITableViewDelegate,UITableViewDataSource>
{
    int segmentTag;
}
@property (weak, nonatomic) IBOutlet UIVisualEffectView *visualView;//模糊视图
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (strong, nonatomic) NSMutableArray *dataArray;
@end
@implementation PhoneFansListView
- (NSMutableArray *)dataArray{
    if (_dataArray==nil) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor=[UIColor clearColor];
    _visualView.effect=[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _segmentControl.layer.masksToBounds=YES;
    _segmentControl.layer.cornerRadius=_segmentControl.height/2;
    _segmentControl.layer.borderWidth=1.0f;
    [_segmentControl setTintColor:[UIColor colorWithHexString:@"0xaaa7a2"]];
    _segmentControl.layer.borderColor=_segmentControl.tintColor.CGColor;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.delegate=self;
    _tableView.dataSource=self;
}
- (void)showInView:(UIView *)view{
    if(SCREEN_WIDTH>SCREEN_HEIGHT){
        [_segmentControl setTop:_closeBtn.top];
        [_segmentControl setWidth:SCREEN_HEIGHT*0.8];
        [_segmentControl setCenterX:SCREEN_WIDTH/2];
        [_tableView setWidth:_segmentControl.width*1.25];
        [_tableView setCenterX:_segmentControl.centerX];
        [_tableView setTop:_segmentControl.bottom+15];
    }else{
        [_segmentControl setTop:62.5];
        [_segmentControl setWidth:SCREEN_WIDTH-57*2];
        [_segmentControl setCenterX:SCREEN_WIDTH/2];
        [_tableView setWidth:SCREEN_WIDTH];
        [_tableView setCenterX:_segmentControl.centerX];
        [_tableView setTop:_segmentControl.bottom+15];
    }
    [_tableView setHeight:self.height-_tableView.top ];
    [self setFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [view addSubview:self];
    [view bringSubviewToFront:self];
    [UIView animateWithDuration:0.5f animations:^{
        [self setFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }completion:^(BOOL finished) {
        [self addDataToDataArray:_weekArray];
    }];
}
- (void)hideFromView{
    [UIView animateWithDuration:0.5f animations:^{
        [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self setFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }completion:^(BOOL finished) {
       [self removeFromSuperview];
    }];
}
- (IBAction)segmentControlClick:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex==0) {
        segmentTag = 0;
        [self addDataToDataArray:_weekArray];
    }
    if (sender.selectedSegmentIndex==1) {
        segmentTag = 1;
        [self addDataToDataArray:_currentArray];
    }
    if (sender.selectedSegmentIndex==2) {
        segmentTag = 2;
        [self addDataToDataArray:_totalArray];
    }
}
- (IBAction)closeBtnClick:(UIButton *)sender {
    [self hideFromView];
}
- (void)addDataToDataArray:(NSArray *)array{
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:array];
    [_tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"PhoneFansCell";
    PhoneFansCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"PhoneFansCell" owner:nil options:nil]lastObject];
    }
    if (segmentTag != 1) {
//        cell.rankingModel=self.dataArray[indexPath.row];
    }else{
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[indexPath.row]];
        [dict setObject:[NSString stringWithFormat:@"%ld",indexPath.row+1] forKey:@"rank"];
        cell.dict = dict;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}

@end
