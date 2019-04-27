//
//  LYURSASignAndVerify.h
//  LYUTTT
//
//  Created by 吕陈强 on 2019/4/27.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import <Foundation/Foundation.h>


/*
 1）生成RSA私钥：
 
 genrsa -out rsa_private_key.pem 1024
 
 该命令会生成1024位的私钥，生成成功的界面如下：
 
 
 
 如何使用openssl生成RSA公钥和私钥对
 此时我们就可以在当前路径下看到rsa_private_key.pem文件了。
 
 
 
 2）把RSA私钥转换成PKCS8格式
 输入命令pkcs8 -topk8 -inform PEM -in rsa_private_key.pem -outform PEM –nocrypt，并回车
 得到生成功的结果，这个结果就是PKCS8格式的私钥，如下图：
 
 如何使用openssl生成RSA公钥和私钥对
 
 
 
 
 3) 生成RSA公钥
 
 输入命令rsa -in rsa_private_key.pem -pubout -out rsa_public_key.pem，并回车，
 得到生成成功的结果，如下图：
 
 如何使用openssl生成RSA公钥和私钥对
 
 
 此时，我们可以看到一个文件名为rsa_public_key.pem的文件，打开它，可以看到-----BEGIN PUBLIC KEY-----开头，
 -----END PUBLIC KEY-----结尾的没有换行的字符串，这个就是公钥。
 */


NS_ASSUME_NONNULL_BEGIN

@interface LYURSASignAndVerify : NSObject




+ (NSString *)sign:(NSString *)content withPriKey:(NSString *)priKey;
+ (BOOL)verify:(NSString *)content signature:(NSString *)signature withPublivKey:(NSString *)publicKey;






+(NSString *)encryptContent:(NSString *)content withPubKey:(NSString *)publicKey;

+(NSString *)decryptContent:(NSString *)content withPriKey:(NSString *)privateKey;


@end

NS_ASSUME_NONNULL_END
