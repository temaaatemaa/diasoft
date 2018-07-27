//
//  SinglePostViewController.m
//  diasoft
//
//  Created by Artem Zabludovsky on 26.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import "SinglePostViewController.h"
#import "NewsTableViewCell.h"
#import "ImageTableViewCell.h"
#import "NetworkService.h"
#import "Post.h"
#import "UIImage+Size.h"


static CGFloat const EstimatedRowHeight = 200.f;


@interface SinglePostViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NetworkService *networkService;

@end

@implementation SinglePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = EstimatedRowHeight;
    
}

- (NetworkService *)networkService
{
    if (!_networkService)
    {
        _networkService = [NetworkService new];
    }
    return _networkService;
}

- (void)setPost:(Post *)post
{
    _post = post;
    [self.tableView reloadData];
}


#pragma mark TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 + [self.post.photoURLArray count];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return EstimatedRowHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellForText"];
        [cell setupCellForPost:self.post withNetworkService:self.networkService];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    ImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellForImage"];
    
    NSDictionary *fotoInfo = self.post.photoURLArray[indexPath.row-1];
    [cell setupCellWithFotoInfo:fotoInfo forPost:self.post withNetworkService:self.networkService];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}
@end
