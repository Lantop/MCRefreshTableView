//
//  MCRefreshTableFooterView.h
//  MCemo
//
//  Created by Vic Zhou on 5/2/13.
//  Copyright (c) 2013 Vic Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MCRefreshTableFooterView;

//load more view State
typedef enum {
    MCRefreshTableFooterViewStateNormal = 0,//load more normal
    MCRefreshTableFooterViewStateLoading,//loading
    MCRefreshTableFooterViewStateEnd,//load more all
}MCRefreshTableFooterViewState;

@protocol MCRefreshTableFooterViewDelegate <NSObject>

- (void)footerViewButtonAction;

@end


@interface MCRefreshTableFooterView : UIView

@property (nonatomic, weak) id <MCRefreshTableFooterViewDelegate> delegate;
@property (nonatomic, assign) MCRefreshTableFooterViewState state;
@property (nonatomic, strong) UIButton *buttonLoadMore;
@property (nonatomic, strong) UILabel *labelLoadEnd;

@end
