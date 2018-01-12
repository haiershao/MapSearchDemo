//
//  ViewController.m
//  MapDemo
//
//  Created by 蔡强 on 2018/1/12.
//  Copyright © 2018年 kuaijiankang. All rights reserved.
//

#import "ViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface ViewController ()<AMapSearchDelegate, UITableViewDataSource>

@property (nonatomic, strong) AMapSearchAPI *search;

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ViewController

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 90, self.view.frame.size.width, 40)];
    [self.view addSubview:self.textField];
    self.textField.backgroundColor = [UIColor grayColor];
    [self.textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    self.textField.placeholder = @"输入查询关键词";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 130, self.view.frame.size.width, self.view.frame.size.height - 130)];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
}

- (void)textChanged:(UITextField *)sender {
    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
    tips.keywords = sender.text;
    tips.city     = @"成都";
    [self.search AMapInputTipsSearch:tips];
}

/* 输入提示回调. */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    self.dataArray = response.tips;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellid"];
    }
    AMapTip *tip = self.dataArray[indexPath.row];
    cell.textLabel.text = tip.name;
    return cell;
}

@end
