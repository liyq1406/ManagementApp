//
//  ClientDetailVC.m
//  ManagementApp
//
//  Created by 邱成西 on 15/10/27.
//  Copyright © 2015年 suda_505. All rights reserved.
//

#import "ClientDetailVC.h"

#import "AddClientVC.h"
#import "ClientDetailHeader.h"

@interface ClientDetailVC ()

@end

@implementation ClientDetailVC

#pragma mark - lifeStyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.index = 0;
    [self setNavBarView];
    
    //集成刷新控件
    [self addHeader];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    if (!self.view.window){
        SafeRelease(_tableView);
        self.view=nil;
    }
}

#pragma mark - UI

-(void)setNavBarView {
    
    //左侧名称显示的分类名称
    [self.navBarView setLeftWithImage:@"back_nav" title:nil];
    [self.navBarView setRightWithArray:@[SetTitle(@"product_edit")] type:1];
    [self.navBarView setTitle:SetTitle(@"detail") image:nil];
    [self.view addSubview:self.navBarView];
    
    [self setTableViewUI];
}

-(void)setTableViewUI {
    self.tableView = [[UITableView alloc]initWithFrame:(CGRect){0,self.navBarView.bottom,self.view.width,self.view.height-self.navBarView.bottom} style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [Utility setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[ClientDetailHeader class] forHeaderFooterViewReuseIdentifier:@"ClientDetailHeader"];
}

#pragma mark - private

- (void)addHeader {
    __weak __typeof(self)weakSelf = self;
    [self.tableView addHeaderWithCallback:^{
        [weakSelf getDataFromSever];
    } dateKey:@"ClientDetailVC"];
}

#pragma mark - 导航栏代理

-(void)leftBtnClickByNavBarView:(NavBarView *)navView {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBtnClickByNavBarView:(NavBarView *)navView tag:(NSUInteger)tag {
    AddClientVC *proVC = [[AddClientVC alloc]init];
    proVC.clientModel = self.clientModel;
    [self.navigationController pushViewController:proVC animated:YES];
    SafeRelease(proVC);
}

#pragma mark -

#pragma mark - table代理

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [ClientDetailHeader returnHeightWithIndex:self.index];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ClientDetailHeader *header = (ClientDetailHeader*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ClientDetailHeader"];
    header.clientModel = self.clientModel;
    header.selectedIndex = self.index;
    
    __weak __typeof(self)weakSelf = self;
    header.segmentChange = ^(NSInteger index){
        weakSelf.index = index;
        [weakSelf.tableView reloadData];
    };
    header.showPrivate = ^(ClientModel *clientModel){
        
    };
    
    
    return header;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"product_cell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%d",(int)indexPath.row];
    
    return cell;
}

//去掉UItableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        CGFloat sectionHeaderHeight = [ClientDetailHeader returnHeightWithIndex:self.index];
        if (self.index==0) {
            sectionHeaderHeight -= 80;
        }else {
            sectionHeaderHeight -= 52;
        }
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

#pragma mark -
#pragma mark - 请求数据

-(void)getDataFromSever {
    ///接口请求
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak __typeof(self)weakSelf = self;
    [[APIClient sharedClient] POST:loginInterface parameters:@{} success:^(NSURLSessionDataTask *task, id responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
        
        NSDictionary *jsonData=(NSDictionary *)responseObject;
        
        if ([[jsonData objectForKey:@"status"]integerValue]==1) {
            
            
        }else {
            [Utility interfaceWithStatus:[jsonData[@"status"] integerValue] msg:jsonData[@"msg"]];
        }
        
        [strongSelf.tableView headerEndRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        [strongSelf.tableView headerEndRefreshing];
        
        [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
        
        [PopView showWithImageName:@"error" message:SetTitle(@"connect_error")];
    }];
}

@end
