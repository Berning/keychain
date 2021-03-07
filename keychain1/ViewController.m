//
//  ViewController.m
//  keychain1
//
//  Created by aBerning on 2021/3/6.
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

//    [self test];

}

- (void)test {

//    kSecClass;
//    kSecClassInternetPassword;
//    kSecClassGenericPassword;
//    kSecClassIdentity;
//    kSecClassKey;
//    kSecClassCertificate;
    
    BOOL is_save_password = [shareKey saveData:@"123456789" withAccount:@"trigger" service:@"password"];
    BOOL is_save_accout = [shareKey saveData:@"987654321" withAccount:@"trigger" service:@"account"];
    
    NSLog(@"is save password = %d",is_save_password);
    NSLog(@"is save account = %d",is_save_accout);
    
    NSLog(@"get accout = %@",(NSString *)[shareKey getDataWithAccount:@"trigger" service:@"account"]);
    NSLog(@"get password = %@",(NSString *)[shareKey getDataWithAccount:@"trigger" service:@"password"]);
    
    
    [shareKey updateData:@"100000001" withAccount:@"trigger" service:@"password"];
    NSLog(@"updated  data = %@",(NSString *)[shareKey getDataWithAccount:@"trigger" service:@"password"]);
    
    
    [shareKey deleteWithAccount:@"trigger" service:@"account"];
     NSLog(@"%@",(NSString *)[shareKey getDataWithAccount:@"trigger" service:@"account"]);
}





@end
