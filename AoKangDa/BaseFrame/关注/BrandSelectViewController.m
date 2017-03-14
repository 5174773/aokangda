//
//  BrandSelectViewController.m
//  AoKangDa
//
//  Created by xshhanjuan on 15/12/10.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "BrandSelectViewController.h"

#import "Public.h"

#import "UIImageView+WebCache.h"

@interface BrandSelectViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *brandArray;
@property (nonatomic,strong ) UITableView *brandListTableView;

@end

@implementation BrandSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addStatusBlackBackground];
    self.title = @"品牌选择";
    
    _brandArray = [NSMutableArray new];
    
    [self createUI];
    [self httpRequest];
}

- (void)createUI
{
    float navHeight = 0;
    if (!self.navigationController.navigationBarHidden) {
        navHeight = 64;
    }
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ViewScreen_Width, ViewScreen_Height - navHeight)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _brandListTableView = tableView;
    [self.view addSubview:tableView];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _brandArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = _brandArray[section][@"array"];
    
    return array.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    
    NSArray *array = _brandArray[indexPath.section][@"array"];
    NSDictionary *dict = array[indexPath.row];
    
    [cell.imageView sd_setImageWithURL:VALUEFORKEY(dict, @"Image") placeholderImage:[Header getTheImageNoCache:@"temp_logo"]];
    cell.textLabel.text = VALUEFORKEY(dict, @"Name");
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = _brandArray[indexPath.section][@"array"];
    NSDictionary *dict = array[indexPath.row];
    
    MMLog(@"%@ \n %@",VALUEFORKEY(dict, @"Name"),dict);
    
    if (dict) {
        if (_delegate && [_delegate respondsToSelector:@selector(BrandSelectViewSelect:)]) {
            [_delegate BrandSelectViewSelect:dict];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return VALUEFORKEY(_brandArray[section], @"Letter");

}


- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [_brandArray valueForKey:@"Letter"];
}



#pragma mark -- httpRequest
- (void)httpRequest
{
    
    [self showActityHoldView];
    
    [RequestManager getBrandListSucceed:^(NSData *data) {
        
        [self hiddenActityHoldView];
        NSDictionary *returnDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        MMLog(@"-- %@",returnDict);
        

        NSArray *returnArray = returnDict[@"Data"];
        
        [self resetDataArrayWith:returnArray];
        

        
    } failed:^(NSError *error) {
        
         [self hiddenActityHoldView];
        
    }];
}

- (void)resetDataArrayWith:(NSArray*)dataArray
{

    for (int i = 65; i<65 + 26; i++) {
        char mychar = i;
        NSString *charStr = [NSString stringWithFormat:@"%c",mychar];
     
        NSMutableArray *tempArray = [NSMutableArray new];
        for (int j = 0; j<dataArray.count; j++) {
            
            NSDictionary *dict = dataArray[j];
            if ([VALUEFORKEY(dict, @"Letter") isEqualToString:charStr]) {
                
                [tempArray addObject:dict];
            }
        }
        
        if (tempArray.count > 0) {
             [_brandArray addObject:@{@"array":tempArray,@"Letter":charStr}];
        }
       
    }
    
        [_brandListTableView reloadData];
}



@end
