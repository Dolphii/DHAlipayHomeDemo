//
//  ViewController.m
//  AlipayHomeDemo
//
//  Created by 陈凯军 on 2018/1/9.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import "ViewController.h"
#import "MJRefresh.h"

#define kScreenHeight   [UIScreen mainScreen].bounds.size.height
#define kScreenWidth    [UIScreen mainScreen].bounds.size.width

static const float TableHeaderViewHeight = 144.0;//

@interface FakeTableHeaderView:UIView

@end

@implementation FakeTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor grayColor];
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 100, 30)];
    label.text = @"你好";
    [self addSubview:label];
}

@end



@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) FakeTableHeaderView *fakeTableHeaderView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_tableView addSubview:self.fakeTableHeaderView];
    _tableView.rowHeight = 50;
    /* 修改scrollIndicatorInsets。仿造出tableView从下方开始的效果 */
    _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(TableHeaderViewHeight, 0, 0, 0);
    __weak __typeof(self)weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
    }];
    self.tableView.mj_header.mj_h = 50;
    self.tableView.mj_header.ignoredScrollViewContentInsetTop = -TableHeaderViewHeight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (FakeTableHeaderView *)fakeTableHeaderView{
    if(!_fakeTableHeaderView){
        _fakeTableHeaderView = [[FakeTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 144)];
    }
    return _fakeTableHeaderView;
}

#pragma mark- tableView datasource/delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIden"];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIden"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"这是第%d行",(int)indexPath.row];
    return cell;
}

#pragma mark- scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat tableViewoffsetY = scrollView.contentOffset.y;
    if( tableViewoffsetY <= 0){
        self.fakeTableHeaderView.frame = CGRectMake(0, 0 + tableViewoffsetY, kScreenWidth, TableHeaderViewHeight);
    }
}


@end
