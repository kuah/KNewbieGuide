//
//  KNewbieGuide.h
//  KNewbieGuide
//
//  Created by 陈世翰 on 2018/1/9.
//  Copyright © 2018年 Kuah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface KNewbieGuide : NSObject
+(instancetype)shared;
/**
 *  @brief 显示新手引导页
 *  @param key 新手引导页的标致
 *  @param imagesName 图片名
 */
+(void)show:(NSString *)key withImageName:(NSString *)imagesName,...;
/**
 *  @brief 显示新手引导页
 *  @param key 新手引导页的标致
 *  @param imagesNames 图片名集合
 */
+(void)show:(NSString *)key withImageNames:(NSArray *)imagesNames;
/**
 *  @brief 判断是否需要显示新手引导
 *  @param key 新手引导页的key
 *  @return 是否 YES/NO
 */
+(BOOL)isNewbie:(NSString *)key;
/**
 *  @brief 针对key消除新手引导(某些用户的新手引导是保存到服务器的,登录后，可以将状态通过这个方法导入)
 *  @param keys 键值数组
 */
+(void)removeNewbieForKeys:(NSArray *)keys;
@end
