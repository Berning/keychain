//
//  shareKey.h
//  keychain1
//
//  Created by aBerning on 2021/3/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface shareKey : NSObject

+ (BOOL)saveData:(id)aData withAccount:(NSString *)account service:(NSString *)service;
+ (id)getDataWithAccount:(NSString *)account service:(NSString *)service;
+ (BOOL)updateData:(id)data withAccount:(NSString *)account service:(NSString *)service;
+ (void)deleteWithAccount:(NSString *)account service:(NSString *)service;


- (BOOL)saveData:(id)aData withAccount:(NSString *)account service:(NSString *)service;
- (id)getDataWithAccount:(NSString *)account service:(NSString *)service;
- (BOOL)updateData:(id)data withAccount:(NSString *)account service:(NSString *)service;
- (void)deleteWithAccount:(NSString *)account service:(NSString *)service;

@end

NS_ASSUME_NONNULL_END
