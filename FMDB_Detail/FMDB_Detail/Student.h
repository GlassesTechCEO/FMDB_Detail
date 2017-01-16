//
//  Student.h
//  FMDB_Detail
//
//  Created by 高强的Macbook Air on 2017/1/16.
//  Copyright © 2017年 GlassesTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject

@property (nonatomic, assign) int id;//学号
@property (nonatomic, strong) NSString *name;//姓名
@property (nonatomic, strong) NSString *sex;//性别
@property (nonatomic, assign) int age;//年龄

@end
