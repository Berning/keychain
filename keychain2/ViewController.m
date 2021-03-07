//
//  ViewController.m
//  keychain2
//
//  Created by aBerning on 2021/3/7.
//

#import "ViewController.h"
#import "shareKey.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *bien = [shareKey getDataWithAccount:@"bien" service:@"udid"];
    
    NSString *trigger = [shareKey getDataWithAccount:@"trigger" service:@"password"];
    
    NSLog(@"bien = %@",bien);
    NSLog(@"trigger = %@",trigger);


}


@end
