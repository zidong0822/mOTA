//
//  NavigationView.swift
//  Elara
//
//  Created by HeHongwe on 15/12/3.
//  Copyright © 2015年 harvey. All rights reserved.
//


#import <UIKit/UIKit.h>


@protocol ExtensibleTableViewDelegate <NSObject>

@required
//返回展开之后的cell
- (UITableViewCell *)tableView:(UITableView *)tableView extendedCellForRowAtIndexPath:(NSIndexPath *)indexPath;
//返回展开之后的cell的高度
- (CGFloat)tableView:(UITableView *)tableView extendedHeightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ExtensibleTableView : UITableView
{
    //当前被展开的索引
    NSIndexPath *currentIndexPath;
    
    id<ExtensibleTableViewDelegate> delegate_extend;
}
@property(nonatomic,retain)id delegate_extend;
@property(nonatomic,retain)NSIndexPath *currentIndexPath;
//将indexPath对应的row展开
- (void)extendCellAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated goToTop:(BOOL)goToTop;

//将展开的cell收起
- (void)shrinkCellWithAnimated:(BOOL)animated;

//查看传来的索引和当前被选中索引是否相同
- (BOOL)isEqualToSelectedIndexPath:(NSIndexPath *)indexPath;

@end


