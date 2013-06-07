//
//  MCRefreshTableView.m
//  MCRefreshTableView
//
//  Created by Vic Zhou on 5/6/13.
//  Copyright (c) 2013 Vic. All rights reserved.
//

#import "MCRefreshTableView.h"

@interface MCRefreshTableView ()

@property (nonatomic, strong) EGORefreshTableHeaderView *pullRefreshView;
@property (nonatomic, strong) MCRefreshTableFooterView *loadMoreView;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) UIView *viewError;

@end


@implementation MCRefreshTableView

- (EGORefreshTableHeaderView*)pullRefreshView {
    if (!_pullRefreshView) {
        _pullRefreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.bounds.size.height, self.frame.size.width, self.bounds.size.height)];
        _pullRefreshView.delegate = self;
    }
    return _pullRefreshView;
}

- (MCRefreshTableFooterView*)loadMoreView {
    if (!_loadMoreView) {
        _loadMoreView = [[MCRefreshTableFooterView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.bounds.size.width, 44.f)];
        _loadMoreView.delegate = self;
    }
    return _loadMoreView;
}

- (void)setTableMode:(MCRefreshTableViewMode)tableMode {
    switch (tableMode) {
        case MCRefreshTableViewModeNormal: {
            [self addSubview:self.pullRefreshView];
            [self.pullRefreshView refreshLastUpdatedDate];
            self.tableFooterView = self.loadMoreView;
        }
            break;
            
        case MCRefreshTableViewModeJustLatest: {
            [self addSubview:self.pullRefreshView];
            [self.pullRefreshView refreshLastUpdatedDate];
            self.tableFooterView = nil;
        }
            break;
            
        case MCRefreshTableViewModeJustLast: {
            [self.pullRefreshView removeFromSuperview];
            self.tableFooterView = self.loadMoreView;
        }
            break;
            
        case MCRefreshTableViewModeRefreshDisabled: {
            [self.pullRefreshView removeFromSuperview];
            self.tableFooterView = nil;
        }
            break;
            
        default:
            break;
    }
}

- (void)setTableState:(MCRefreshTableViewState)tableState {
    switch (tableState) {
        case MCRefreshTableViewStateNormal: {
            [self.viewError removeFromSuperview];
            self.scrollEnabled = YES;
        }
            break;
            
        case MCRefreshTableViewStateError: {
            [self addSubview:self.viewError];
            self.scrollEnabled = NO;
        }
            break;
            
        default:
            break;
    }
}

- (void)setLoadOverState:(MCRefreshTableViewLoadedState)loadOverState {
    switch (loadOverState) {
        case MCRefreshTableViewLoadedStateLatest: {
            [self doneLoadingTableViewData];
        }
            break;
            
        case MCRefreshTableViewLoadedStateLastEnable: {
            [self loadMoreOver];
            self.loadMoreView.state = MCRefreshTableViewStateNormal;
        }
            break;
            
        case MCRefreshTableViewLoadedStateLastDisable: {
            [self loadMoreOver];
            self.loadMoreView.state = MCRefreshTableFooterViewStateEnd;
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - NSObject

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tableMode = MCRefreshTableViewModeNormal;
    }
    return self;
}

#pragma mark - UIView
- (void)drawRect:(CGRect)rect {
    if ([self.delegateRefresh respondsToSelector:@selector(MCRefreshTableViewErrorView)]) {
        self.viewError = [self.delegateRefresh MCRefreshTableViewErrorView];
    }
}

#pragma mark - Actions Public

- (void)MCScrollViewDidScroll:(UIScrollView *)scrollView {
	[self.pullRefreshView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)MCScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	[self.pullRefreshView egoRefreshScrollViewDidEndDragging:scrollView];
    if(scrollView.contentOffset.y-65.f > ((scrollView.contentSize.height - scrollView.frame.size.height)))
    {
        if (self.loadMoreView.state != MCRefreshTableFooterViewStateEnd) {
            [self loadMore];
        }
    }
}

- (void)showLoadingLatest {
    [self setContentOffset:CGPointMake(0.f, -65.f) animated:NO];
    [self.pullRefreshView egoRefreshScrollViewDidEndDragging:self];
}

- (void)showLoadingLast {
    [self loadMore];
}

- (void)showLoadingOrigin {
    if (!self.isLoading) {
        if ([self.delegateRefresh respondsToSelector:@selector(MCRefreshTableViewWillBeginLoadingOrigin)]) {
            [self.delegateRefresh MCRefreshTableViewWillBeginLoadingOrigin];
        }
        self.isLoading = YES;
        self.loadMoreView.state = MCRefreshTableFooterViewStateLoading;
    }
}

#pragma mark - Actions Private

- (void)loadMore {
    if (!self.isLoading) {
        if ([self.delegateRefresh respondsToSelector:@selector(MCRefreshTableViewWillBeginLoadingLast)]) {
            [self.delegateRefresh MCRefreshTableViewWillBeginLoadingLast];
        }
        self.isLoading = YES;
        self.loadMoreView.state = MCRefreshTableFooterViewStateLoading;
    }
}

- (void)loadMoreOver {
    self.isLoading = NO;
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
    if (!self.isLoading) {
        self.isLoading = YES;
        if ([self.delegateRefresh respondsToSelector:@selector(MCRefreshTableViewWillBeginLoadingLatest)]) {
            [self.delegateRefresh MCRefreshTableViewWillBeginLoadingLatest];
        }
    }
}

- (void)doneLoadingTableViewData{
	self.isLoading = NO;
	[self.pullRefreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
}

#pragma mark - EGORefreshTableHeaderDelegate Methods

// 开始刷新时回调
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    [self reloadTableViewDataSource];
}

// 下拉时回调
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return self.isLoading;
}

// 请求上次更新时间时调用
- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}

#pragma mark - MCRefreshTableFooterViewDelegate

- (void)footerViewButtonAction {
    [self loadMore];
}

@end
