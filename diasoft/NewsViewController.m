//
//  NewsViewController.m
//  diasoft
//
//  Created by Artem Zabludovsky on 25.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import "NewsViewController.h"

#import "NewsTableViewCell.h"

#import "VKAutharisation.h"
#import "PostsManager.h"
#import "Post.h"
#import "NetworkService.h"

#import <CCBottomRefreshControl/UIScrollView+BottomRefreshControl.h>

#import "SinglePostViewController.h"


static NSString *const NameForAuthButton = @"Auth";
static NSString *const NameForLogoutButton = @"Logout";

static CGFloat const EstimatedRowHeight = 200.f;


@interface NewsViewController ()<VKAutharisationDelegate,UITableViewDelegate,UITableViewDataSource,PostsManagerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *vkAutharisationButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) VKAutharisation *vkAutharisation;
@property (nonatomic, strong) PostsManager *postManager;
@property (nonatomic, strong) NetworkService *networkService;

@property (nonatomic, copy) NSArray *postsArray;

@property (nonatomic, assign) BOOL isLogin;


@end


@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = EstimatedRowHeight;
    
    self.postsArray = @[];
    
    [self setupRefreshControlOnTop];
    [self setupRefreshControlOnBottom];
    
    if (self.isLogin)
    {
        [self changeAutharisationButtonName];
        [self getPosts];
    }
}


#pragma mark - Custom Accessors

- (VKAutharisation *)vkAutharisation
{
    if (!_vkAutharisation)
    {
        _vkAutharisation = [VKAutharisation new];
        _vkAutharisation.delegate = self;
    }
    return _vkAutharisation;
}

- (PostsManager *)postManager
{
    if (!_postManager)
    {
        _postManager = [PostsManager new];
        _postManager.delegate = self;
    }
    return _postManager;
}

- (NetworkService *)networkService
{
    if (!_networkService)
    {
        _networkService = [NetworkService new];
    }
    return _networkService;
}

- (BOOL)isLogin
{
    if (![VKAutharisation token])
    {
        return NO;
    }
    return YES;
}


#pragma mark - Buttons

- (IBAction)vkAutharisationButtonClicked:(id)sender {
    NSLog(@"Clicked");
    if ([self.vkAutharisationButton.title isEqualToString:NameForAuthButton])
    {
        [self.vkAutharisation autharisation];
        [self.tableView reloadData];
    }
    else
    {
        [self logout];
    }
}

- (void)logout
{
    [self.vkAutharisation logout];
    [self changeAutharisationButtonName];
    self.postsArray = @[];
    [self.tableView reloadData];
}

- (void)changeAutharisationButtonName
{
    if ([self.vkAutharisationButton.title isEqualToString:NameForAuthButton])
    {
        [self.vkAutharisationButton setTitle:NameForLogoutButton];
        [self.postManager getPosts];
    }
    else
    {
        [self.vkAutharisationButton setTitle:NameForAuthButton];
    }
}


#pragma mark - Private Methods

- (void)setupRefreshControlOnTop
{
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(getNewPosts) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = refresh;
}

- (void)setupRefreshControlOnBottom
{
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    refreshControl.triggerVerticalOffset = 100.;
    [refreshControl addTarget:self action:@selector(getPosts) forControlEvents:UIControlEventValueChanged];
    self.tableView.bottomRefreshControl = refreshControl;
}

- (void)getNewPosts
{
    if (self.isLogin)
    {
        [self.postManager getNewerPosts];
    }
    else
    {
        [self.tableView.refreshControl endRefreshing];
    }
}

- (void)getPosts
{
    if (self.isLogin)
    {
        [self.postManager getPosts];
    }
    else
    {
        [self.tableView.bottomRefreshControl endRefreshing];
    }
    
}

- (NSArray *)makeUniqueAndSortedArray:(NSArray *)array
{
    NSSet *set = [NSSet setWithArray:array];
    NSArray *uniqueArray = [set allObjects];
    
    NSArray *uniqueAndSortedArray = [uniqueArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Post *post1 = obj1;
        Post *post2 = obj2;
        if (post1.unixDate.integerValue > post2.unixDate.integerValue)
        {
            return NSOrderedAscending;
        }
        else
        {
            return NSOrderedDescending;
        }
    }];
    return uniqueAndSortedArray;
}


#pragma mark - VKAutharisationDelegate

- (void)autharisationDidDone:(nonnull VKAutharisation *)vkAutharisation withToken:(nonnull NSString *)token withUserId:(nonnull NSString *)userId
{
    [self changeAutharisationButtonName];
}

- (void)autharisationDidCancel:(VKAutharisation *)vkAutharisation
{
    NSLog(@"Cancel auth");
}

#pragma mark - TableviewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isLogin)
    {
        if ([self.postsArray count])
        {
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        }
        else
        {
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
        tableView.backgroundView = nil;
        return 1;
    }
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 300, CGRectGetWidth(self.view.frame), 50)];
    messageLabel.text = @"Пожалуйста, залогинтесь, чтобы смотреть новости!";
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    tableView.backgroundView = messageLabel;

    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.postsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return EstimatedRowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"testCell"];

    Post *post = self.postsArray[indexPath.row];

    [cell setupCellForPost:post withNetworkService:self.networkService];
    [cell showOnlyPreviewOfText];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                @"Main" bundle:[NSBundle mainBundle]];
    SinglePostViewController *nextViewController = [storyboard instantiateViewControllerWithIdentifier:@"SinglePostViewController"];
    
    nextViewController.post = self.postsArray[indexPath.row];
    [self.navigationController pushViewController:nextViewController animated:YES];
}

#pragma mark - PostsManagerDelegate

-(void)postsDidLoad:(PostsManager *)postManager withPostsArray:(NSArray *)postsArray
{
    NSLog(@"postsDidLoad");
    self.postsArray = [self.postsArray arrayByAddingObjectsFromArray:postsArray];
    self.postsArray = [self makeUniqueAndSortedArray:self.postsArray];
    
    [self.tableView reloadData];
    [self.tableView.bottomRefreshControl endRefreshing];
    [self.tableView.refreshControl endRefreshing];
}




@end
