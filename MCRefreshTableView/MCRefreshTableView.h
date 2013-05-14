//
//  MCRefreshTableView.h
//  MCRefreshTableView
//
//  Created by Vic Zhou on 5/6/13.
//  Copyright (c) 2013 Vic. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "MCRefreshTableFooterView.h"
@class MCRefreshTableView;

//tableview Mode
typedef enum {
    MCRefreshTableViewModeNormal = 0,//load latest, load last
    MCRefreshTableViewModeJustLatest,//just load latest
    MCRefreshTableViewModeJustLast,//just load last
    MCRefreshTableViewModeRefreshDisabled,
}MCRefreshTableViewMode;

//table State
typedef enum {
    MCRefreshTableViewStateNormal = 0,//get origin data success
    MCRefreshTableViewStateError,//get origin data fail
}MCRefreshTableViewState;

//load state
typedef enum {
    MCRefreshTableViewLoadedStateLatest = 0,
    MCRefreshTableViewLoadedStateLastEnable,
    MCRefreshTableViewLoadedStateLastDisable,
}MCRefreshTableViewLoadedState;

@protocol MCRefreshTableViewDelegate <NSObject>

@required
- (void)MCRefreshTableViewWillBeginLoadingOrigin;

@required
- (void)MCRefreshTableViewWillBeginLoadingLatest;

@required
- (void)MCRefreshTableViewWillBeginLoadingLast;

@optional
- (UIView*)MCRefreshTableViewErrorView;

@end

@interface MCRefreshTableView : UITableView <EGORefreshTableHeaderDelegate,
MCRefreshTableFooterViewDelegate, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id <MCRefreshTableViewDelegate> delegateRefresh;
@property (nonatomic, assign) MCRefreshTableViewState tableState;
@property (nonatomic, assign) MCRefreshTableViewMode tableMode;
@property (nonatomic, assign) MCRefreshTableViewLoadedState loadOverState;

- (void)MCScrollViewDidScroll:(UIScrollView *)scrollView;

- (void)MCScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

- (void)showLoadingLatest;

- (void)showLoadingLast;

- (void)showLoadingOrigin;

@end
