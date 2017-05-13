//
//  LeftVC.h
//  LDLiveProject
//
//  Created by MAC on 16/5/30.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "BasisVC.h"

@interface LeftVC : BasisVC<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,SRRefreshDelegate>

@property (nonatomic,strong)UITableView*hotTableView;
@property (nonatomic,strong)UITableView*focusTableView;
@property (nonatomic,strong)UITableView*moreTableView;
@end
