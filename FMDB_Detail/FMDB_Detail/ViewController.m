//
//  ViewController.m
//  FMDB_Detail
//
//  Created by 高强的Macbook Air on 2017/1/16.
//  Copyright © 2017年 GlassesTech. All rights reserved.
//

#import "ViewController.h"
#import "FMDatabase.h"
#import "Student.h"

@interface ViewController ()
{
    FMDatabase *_db;//FMDB对象
    int mark_student;//学生标记
    NSString *_docPath;//沙盒地址（数据库地址）
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.获取数据库文件的路径
    _docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@",_docPath);
    
    mark_student = 1;
    
    //设置数据库名称
    NSString *fileName = [_docPath stringByAppendingPathComponent:@"student.sqlite"];
    //2.获取数据库
    _db = [FMDatabase databaseWithPath:fileName];
    if ([_db open]) {
        NSLog(@"打开数据库成功");
    } else {
        NSLog(@"打开数据库失败");
    }
}

//新建数据库
- (IBAction)createSQLiteMethod:(id)sender {
    NSLog(@"新建数据库");
    [self fmdb_Function:sender withButtonTitle:@"新建数据库"];
    
    //设置数据库名称
    NSString *fileName = [_docPath stringByAppendingPathComponent:@"student.sqlite"];
    //2.获取数据库
    _db = [FMDatabase databaseWithPath:fileName];
    if ([_db open]) {
        NSLog(@"打开数据库成功");
    } else {
        NSLog(@"打开数据库失败");
    }
}

//新建表
- (IBAction)createTableMethod:(id)sender {
    NSLog(@"新建表");
    [self fmdb_Function:sender withButtonTitle:@"新建表"];
    
    //3.创建表
    BOOL result = [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_student (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, age integer NOT NULL, sex text NOT NULL);"];
    if (result) {
        NSLog(@"创建表成功");
    } else {
        NSLog(@"创建表失败");
    }
}

//添加数据
- (IBAction)addDataMethod:(id)sender {
    NSLog(@"添加数据");
    [self fmdb_Function:sender withButtonTitle:@"添加数据"];
    //插入数据
    NSString *name = [NSString stringWithFormat:@"王子涵%@",@(mark_student)];
    int age = mark_student;
    NSString *sex = @"男";

    mark_student ++;
    
    //1.executeUpdate:不确定的参数用？来占位（后面参数必须是oc对象，；代表语句结束）
        BOOL result = [_db executeUpdate:@"INSERT INTO t_student (name, age, sex) VALUES (?,?,?)",name,@(age),sex];
    //2.executeUpdateWithForamat：不确定的参数用%@，%d等来占位 （参数为原始数据类型，执行语句不区分大小写）
//    BOOL result = [_db executeUpdateWithFormat:@"insert into t_student (name,age, sex) values (%@,%i,%@)",name,age,sex];
    
    //3.参数是数组的使用方式
    //    BOOL result = [_db executeUpdate:@"INSERT INTO t_student(name,age,sex) VALUES  (?,?,?);" withArgumentsInArray:@[name,@(age),sex]];
    if (result) {
        NSLog(@"插入成功");
    } else {
        NSLog(@"插入失败");
    }
}

//删除数据
- (IBAction)deleteDataMethod:(id)sender {
    NSLog(@"删除数据");
    [self fmdb_Function:sender withButtonTitle:@"删除数据"];
    
    //1.不确定的参数用？来占位 （后面参数必须是oc对象,需要将int包装成OC对象）
        int idNum = 11;
        BOOL result = [_db executeUpdate:@"delete from t_student where id = ?",@(idNum)];
    //2.不确定的参数用%@，%d等来占位
//    BOOL result = [_db executeUpdateWithFormat:@"delete from t_student where name = %@",@"王子涵"];
    if (result) {
        NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败");
    }
}

//修改数据
- (IBAction)changeDataMethod:(id)sender {
    NSLog(@"修改数据");
    [self fmdb_Function:sender withButtonTitle:@"修改数据"];
    
    //修改学生的名字
    NSString *newName = @"李浩宇";
    NSString *oldName = @"王子涵2";
    BOOL result = [_db executeUpdate:@"update t_student set name = ? where name = ?",newName,oldName];
    if (result) {
        NSLog(@"修改成功");
    } else {
        NSLog(@"修改失败");
    }
}

//查询数据
- (IBAction)searchDataMethod:(id)sender {
    NSLog(@"查询数据");
    [self fmdb_Function:sender withButtonTitle:@"查询数据"];
    
    //查询整个表
        FMResultSet *resultSet = [_db executeQuery:@"select * from t_student"];
    
    //根据条件查询
//    FMResultSet *resultSet = [_db executeQuery:@"select * from t_student where id < ?", @(4)];
    
    //遍历结果集合
    while ([resultSet next]) {
        int idNum = [resultSet intForColumn:@"id"];
        NSString *name = [resultSet objectForColumnName:@"name"];
        int age = [resultSet intForColumn:@"age"];
        NSString *sex = [resultSet objectForColumnName:@"sex"];
        NSLog(@"学号：%@ 姓名：%@ 年龄：%@ 性别：%@",@(idNum),name,@(age),sex);
    }
}

//删除表
- (IBAction)deleteTableMethod:(id)sender {
    NSLog(@"删除表");
    [self fmdb_Function:sender withButtonTitle:@"删除表"];
    
    //如果表格存在 则销毁
    BOOL result = [_db executeUpdate:@"drop table if exists t_student"];
    if (result) {
        NSLog(@"删除表成功");
    } else {
        NSLog(@"删除表失败");
    }
}

/**
 点击按钮的动作

 @param button 点击的按钮
 @param title  按钮的标题
 */
- (void)fmdb_Function:(UIButton *)button withButtonTitle:(NSString *)title {
    __block int timeout = 5; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [button setTitle:title forState:UIControlStateNormal];
                button.userInteractionEnabled = YES;
            });
        } else {
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [button setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                button.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
