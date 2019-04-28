//
//  LYUViewController.m
//  LYULibrary
//
//  Created by lvchenqiang on 03/21/2019.
//  Copyright (c) 2019 lvchenqiang. All rights reserved.
//

#import "LYUViewController.h"
//#import "LYUClassInfo.h"
#import "LYUTaskManager.h"
#import "LYUView.h"
#import "LYURSASignAndVerify.h"
#import "NSString+AES256.h"
#import "NSObject+Reflection.h"
#import <objc/runtime.h>
//设置随机的颜色
#define LRRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]



@interface LYUViewController ()

@end

@implementation LYUViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@----%@",[LYURSASignAndVerify instanceMethodList], [LYURSASignAndVerify classMethodList]);
    
    
//    [self testEncrpt];
    
}

- (void)testRSASign{
    NSString *private_key = @"MIICXAIBAAKBgQDDexXjLoCmBU3TqiiAmHqkX0AMxLaPIz9U2nExHMQLDjQTZmpK\nsJTClwec/m+NMapG1lujQnoinp/jKtXCUPWWYGJItxqXAM0sT91QtyotCYynwHHt\nwhsYQedW9/KaN6eCMnrZoDd8oTKJQszjpFpHxV4GOKqkFRL2UBN6a4n+WwIDAQAB\nAoGAB0HNiTaTvhYaUo5RnJyMiQekOBUhdeToF/1YEGux93sagdHehlFR5Ht44+Iq\nQAKlAKY6lrAEGr7qzqMrdmBNDaxiPfhKU/NqLwNDP5sbZaA40+MD2nyuCsfPAD4m\npRrd9Ut4KXUeubQn5B5y4i74bXTKkQvpueoLenE5HKn3DyECQQD75vjg3p1Lbu9E\nBngPIS8bysmafdY8kgYxyjA088HqEEh4k/oyGg1Cz8kDE/77+kf23ksasVf8cuWL\naLN1Z8dRAkEAxqkmiN3HOuDFeDAxG+HF4vomIp0gnqCXZGsCPAKbHdBytdr9mTxj\nYtj9PZ4ZzyMIM4H1JeOj36j1O2bsGJHX6wJAGgOQUCitNc0PCIdifq1+n/AhQcMd\nDMRHv3yR3eYOcI2d7lXZ0LLAC9ZJe/fkrUD7jZMHToph+8Ah1HPLlKRTAQJACWvU\nLAF4hU5LjxuZ+JyIae87B8Ez3tH23AhHHtlwycUs63rrM+0tOW7Y86cfyjb7GJY9\nLgLRrrWwi5Sh9bhU6QJBAJbWhJknnygWs8jQTINCgOhpCFmIKMJCsuMd6Zuh0PCX\n8Fu8LIXQEbNGck4lGheyuz7ppjCwCQ8408jhNNMZ5eM=";
    
    
    NSString *public_key = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDDexXjLoCmBU3TqiiAmHqkX0AM\nxLaPIz9U2nExHMQLDjQTZmpKsJTClwec/m+NMapG1lujQnoinp/jKtXCUPWWYGJI\ntxqXAM0sT91QtyotCYynwHHtwhsYQedW9/KaN6eCMnrZoDd8oTKJQszjpFpHxV4G\nOKqkFRL2UBN6a4n+WwIDAQAB";
    

    NSString *aeskey = @"zxczxczxczxc";
    
    // 明文
    NSString *plainText = @"你好,world!";
    // AES加密后的密文
    NSString *cipherTextByAES = [plainText aes256_encryptWithKey:aeskey];
    // 签名
    NSString *signature = [LYURSASignAndVerify sign:cipherTextByAES withPriKey:private_key];
    // 验签
    BOOL success = [LYURSASignAndVerify verify:cipherTextByAES signature:signature withPublivKey:public_key];
    
    NSLog(@"【明文】：%@",plainText);
    NSLog(@"【密文】：%@",cipherTextByAES);
    NSLog(@"【签名】：%@",signature);
    
    
    if (success) {
        NSLog(@"【验签成功】");
        NSString *decryptString = [cipherTextByAES aes256_decryptWithKey:aeskey];
        NSLog(@"【解密密文得到的明文】：%@",decryptString);
    }
    
    
    
    
}



- (void)testEncrpt{
    
    NSString *private_key = @"MIICXAIBAAKBgQDDexXjLoCmBU3TqiiAmHqkX0AMxLaPIz9U2nExHMQLDjQTZmpK\nsJTClwec/m+NMapG1lujQnoinp/jKtXCUPWWYGJItxqXAM0sT91QtyotCYynwHHt\nwhsYQedW9/KaN6eCMnrZoDd8oTKJQszjpFpHxV4GOKqkFRL2UBN6a4n+WwIDAQAB\nAoGAB0HNiTaTvhYaUo5RnJyMiQekOBUhdeToF/1YEGux93sagdHehlFR5Ht44+Iq\nQAKlAKY6lrAEGr7qzqMrdmBNDaxiPfhKU/NqLwNDP5sbZaA40+MD2nyuCsfPAD4m\npRrd9Ut4KXUeubQn5B5y4i74bXTKkQvpueoLenE5HKn3DyECQQD75vjg3p1Lbu9E\nBngPIS8bysmafdY8kgYxyjA088HqEEh4k/oyGg1Cz8kDE/77+kf23ksasVf8cuWL\naLN1Z8dRAkEAxqkmiN3HOuDFeDAxG+HF4vomIp0gnqCXZGsCPAKbHdBytdr9mTxj\nYtj9PZ4ZzyMIM4H1JeOj36j1O2bsGJHX6wJAGgOQUCitNc0PCIdifq1+n/AhQcMd\nDMRHv3yR3eYOcI2d7lXZ0LLAC9ZJe/fkrUD7jZMHToph+8Ah1HPLlKRTAQJACWvU\nLAF4hU5LjxuZ+JyIae87B8Ez3tH23AhHHtlwycUs63rrM+0tOW7Y86cfyjb7GJY9\nLgLRrrWwi5Sh9bhU6QJBAJbWhJknnygWs8jQTINCgOhpCFmIKMJCsuMd6Zuh0PCX\n8Fu8LIXQEbNGck4lGheyuz7ppjCwCQ8408jhNNMZ5eM=";
    
    
    NSString *public_key = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDDexXjLoCmBU3TqiiAmHqkX0AM\nxLaPIz9U2nExHMQLDjQTZmpKsJTClwec/m+NMapG1lujQnoinp/jKtXCUPWWYGJI\ntxqXAM0sT91QtyotCYynwHHtwhsYQedW9/KaN6eCMnrZoDd8oTKJQszjpFpHxV4G\nOKqkFRL2UBN6a4n+WwIDAQAB";
    
    
    NSString *aeskey = @"zxczxczxczxc";
    
    // 明文
    NSString *plainText = @"你好,world!";
    

    
    

    // AES加密后的密文
    NSString *cipherTextByAES = [plainText aes256_encryptWithKey:aeskey];
    // 签名
    NSString *signature = [LYURSASignAndVerify  encryptContent:cipherTextByAES withPubKey:public_key];
    // 验签
    NSString * plainText2 = [LYURSASignAndVerify decryptContent:signature withPriKey:private_key];
     NSString *decryptString = [plainText2 aes256_decryptWithKey:aeskey];
    
    NSLog(@"【明文】：%@",plainText);
    NSLog(@"【密文】：%@",cipherTextByAES);
    NSLog(@"【签名】：%@",signature);
    NSLog(@"【解密密文得到的明文】：%@",decryptString);
    
    
}
- (void)testTask{
    
    /// 添加任务
    for (int i = 0; i < 6; i++){
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [[LYUTaskManager sharedManager] addTask:^{
                
                LYUView * vvv = [[LYUView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                
                vvv.tag = LYUTaskManager.LYUTaskGlobalIdentifier;
                vvv.backgroundColor = LRRandomColor;
                vvv.alpha = 0.5;
                [self.view addSubview:vvv];
            } async:true];
            
        });
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
