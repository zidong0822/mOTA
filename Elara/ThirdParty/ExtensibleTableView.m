//
//  NavigationView.swift
//  Elara
//
//  Created by HeHongwe on 15/12/3.
//  Copyright © 2015年 harvey. All rights reserved.
//

#import "ExtensibleTableView.h"

@implementation ExtensibleTableView

@synthesize delegate_extend;
@synthesize currentIndexPath;

- (id)init
{
    currentIndexPath = nil;
    return [super init];
}

//重写设置代理的方法，使为UITableView设置代理时，将子类的delegate_extend同样设置
- (void)setDelegate:(id<UITableViewDelegate>)delegate
{
    self.delegate_extend = delegate;
    [super setDelegate:delegate];
}

/*
 
 将indexPath对应的row展开
 params:
 
 animated:是否要动画效果
 goToTop:展开后是否让到被展开的cell滚动到顶部
 
 */
- (void)extendCellAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated goToTop:(BOOL)goToTop
{      
    //被取消选中的行的索引
    NSIndexPath *unselectedIndex = [NSIndexPath indexPathForRow:[currentIndexPath row] inSection:[currentIndexPath section]];
    //要刷新的index的集合
    NSMutableArray *array1 = [[NSMutableArray alloc]init];
    //若当前index不为空
    if(currentIndexPath)
    {
        //被取消选中的行的索引
        [array1 addObject:unselectedIndex];
    }
    
    //若当前选中的行和入参的选中行不相同，说明用户点击的不是已经展开的cell
    if(![self isEqualToSelectedIndexPath:indexPath])
    {
        //被选中的行的索引
        [array1 addObject:indexPath];
    }
    
    //将当前被选中的索引重新赋值
    currentIndexPath = indexPath;

    if(animated)
    {
        [self reloadRowsAtIndexPaths:array1 withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        [self reloadRowsAtIndexPaths:array1 withRowAnimation:UITableViewRowAnimationNone];
    }
    if(goToTop)
    {
        //tableview滚动到新选中的行的高度
        [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

//将展开的cell收起
- (void)shrinkCellWithAnimated:(BOOL)animated
{
    //要刷新的index的集合
    NSMutableArray *array1 = [[NSMutableArray alloc]init];
    
    if(currentIndexPath)
    {
        //当前展开的cell的索引
        [array1 addObject:currentIndexPath];
        //将当前展开的cell的索引设为空
        currentIndexPath = nil;
        [self reloadRowsAtIndexPaths:array1 withRowAnimation:UITableViewRowAnimationFade];    
    }
    
}

//查看传来的索引和当前被选中索引是否相同
- (BOOL)isEqualToSelectedIndexPath:(NSIndexPath *)indexPath
{
    if(currentIndexPath)
    {
        return ([currentIndexPath row] == [indexPath row]) && ([currentIndexPath section] == [indexPath section]);
    }
    return NO;
}

/*
 
 重写了这个方法，却无效，因为这个方法总在didSelect之前调用，很奇怪。因为无法重写该方法，所以ExtensibleTableView不算完善，因为还有额外的代码需要在heightForRowAtIndexPath和cellForRowAtIndexPath中。哪个找到完善的方法后希望可以与qq82934162联系或者在http://borissun.iteye.com来留言
 
*/

//- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if([currentIndexPath row] == [indexPath row])
//    {
//        return [self.delegate_extend tableView:self extendedCellForRowAtIndexPath:indexPath];
//    }
//    return [super cellForRowAtIndexPath:indexPath];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([currentIndexPath row] == [indexPath row])
    {
        return [self.delegate_extend tableView:self extendedHeightForRowAtIndexPath:indexPath];
    }
    return [super rowHeight];
}

@end
