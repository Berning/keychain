//
//  shareKey.m
//  keychain1
//
//  Created by aBerning on 2021/3/7.
//

#import "shareKey.h"

@implementation shareKey

+ (BOOL)saveData:(id)aData withAccount:(NSString *)account service:(NSString *)service
{
    return [[self new] saveData:aData withAccount:account service:service];
}

+ (id)getDataWithAccount:(NSString *)account service:(NSString *)service
{
    return [[self new] getDataWithAccount:account service:service];
}

+ (BOOL)updateData:(id)data withAccount:(NSString *)account service:(NSString *)service
{
    return [[self new] updateData:data withAccount:account service:service];
}

+ (void)deleteWithAccount:(NSString *)account service:(NSString *)service
{
    [[self new] deleteWithAccount:account service:service];
}


#pragma mark class methods
- (BOOL)saveData:(id)aData withAccount:(NSString *)account service:(NSString *)service{
    // 获取存储的数据的条件
    NSMutableDictionary * saveQueryDic = [self keychainDicWithAccountId:account andServiceId:service];
    // 删除旧的数据
    SecItemDelete((CFDictionaryRef)saveQueryDic);
    // 设置新的数据
    
    if (@available(iOS 11.0, *)) {
        [saveQueryDic setObject:[NSKeyedArchiver archivedDataWithRootObject:aData requiringSecureCoding:YES error:nil] forKey:(id)kSecValueData];
    } else {
//        [saveQueryDic setObject:[NSKeyedArchiver archivedDataWithRootObject:aData] forKey:(id)kSecValueData];
    }
    // 添加数据
    OSStatus saveState = SecItemAdd((CFDictionaryRef)saveQueryDic, nil);
    // 释放对象
    saveQueryDic = nil ;
    // 判断是否存储成功
    if (saveState == errSecSuccess) {
        return YES;
    }
    return NO;
}

- (id)getDataWithAccount:(NSString *)account service:(NSString *)service{
    id idObject = nil ;
    // 通过标记获取数据查询条件
    NSMutableDictionary * readQueryDic = [self keychainDicWithAccountId:account andServiceId:service];
    // 查询结果返回到 kSecValueData (此项必选)
    [readQueryDic setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    // 只返回搜索到的第一条数据 (此项必选)
    [readQueryDic setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    // 创建一个对象接受结果
    CFDataRef keyChainData = nil ;
    // 通过条件查询数据
    if (SecItemCopyMatching((CFDictionaryRef)readQueryDic , (CFTypeRef *)&keyChainData) == noErr){
        @try {
            //转换类型
            if(@available(iOS 11.0,*)){
                idObject = [NSKeyedUnarchiver unarchivedObjectOfClass:NSString.class fromData:(__bridge NSData*)keyChainData error:nil];
            }
            else{
                idObject = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)(keyChainData)];
            }
        } @catch (NSException * exception){
            NSLog(@"Unarchive of search data where %@ failed of %@ ",service,exception);
        }
    }
    if (keyChainData) {
        CFRelease(keyChainData);
    }
    readQueryDic = nil;
    // 返回数据
    return idObject ;
}

- (BOOL)updateData:(id)data withAccount:(NSString *)account service:(NSString *)service{
    // 通过标记获取数据更新的条件
    NSMutableDictionary * updataQueryDic = [self keychainDicWithAccountId:account andServiceId:service];
    // 创建更新数据字典
    NSMutableDictionary * newDic = @{}.mutableCopy;
    // 存储数据
    
    if (@available(iOS 11.0, *)) {
        [newDic setObject:[NSKeyedArchiver archivedDataWithRootObject:data requiringSecureCoding:YES error:nil] forKey:(id)kSecValueData];
    } else {
        [newDic setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    }
    // 获取存储的状态
    OSStatus  updataStatus = SecItemUpdate((CFDictionaryRef)updataQueryDic, (CFDictionaryRef)newDic);
    updataQueryDic = nil;
    newDic = nil;
    // 判断是否更新成功
    if (updataStatus == errSecSuccess) {
        return YES ;
    }
    return NO;
}


- (void)deleteWithAccount:(NSString *)account service:(NSString *)service{
    // 获取删除数据的查询条件
    NSMutableDictionary * deleteQueryDic = [self keychainDicWithAccountId:account andServiceId:service];
    // 删除指定条件的数据
    SecItemDelete((CFDictionaryRef)deleteQueryDic);
    deleteQueryDic = nil ;
}


- (NSMutableDictionary *)keychainDicWithAccountId:(NSString *)accountId andServiceId:(NSString *)serviceId{
//构建一个存取条件,实质是一个字典
    NSString *classKey = (__bridge NSString *)kSecClass;
    //指定服务类型是普通密码
    NSString *classValue = (__bridge NSString *)kSecClassGenericPassword;
    NSString *accessibleKey = (__bridge NSString *)kSecAttrAccessible;
    //指定安全类型是任何时候都可以访问
    NSString *accessibleValue = (__bridge NSString *)kSecAttrAccessibleAlways;
    NSString *accountKey = (__bridge NSString *)kSecAttrAccount;
    //指定服务的账户名 可以与服务名相同 账户名可以对应多个服务名
    NSString *accountValue = accountId;
    NSString *serviceKey = (__bridge NSString *)kSecAttrService;
    //指定服务的名字 可以与服务账户名相同
    NSString *serviceValue = serviceId;
    NSDictionary *keychainItems = @{classKey      : classValue,
                                    accessibleKey : accessibleValue,
                                    accountKey    : accountValue,
                                    serviceKey    : serviceValue};
    return keychainItems.mutableCopy;
}



@end
