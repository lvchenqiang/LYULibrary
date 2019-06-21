//
//  LYUUploadFile.h
//  LYUKit
//
//  Created by 吕陈强 on 2019/6/21.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, LYUFileType) {
    LYUFileTypePng,
    LYUFileTypeJpg,
    LYUFileTypeMp3,
};


@interface LYUUploadFile : NSObject
/**< 默认以data的md5值做uploadKey */
+ (instancetype)pngImageWithFileData:(NSData *)data imageName:(NSString *)name;
+ (instancetype)jpgImageWithFileData:(NSData *)data imageName:(NSString *)name;
+ (instancetype)mp3AudioWithFileData:(NSData *)data audioName:(NSString *)name;
+ (instancetype)pngImageWithFileData:(NSData *)data imageName:(NSString *)name uploadKey:(NSString *)key;
+ (instancetype)jpgImageWithFileData:(NSData *)data imageName:(NSString *)name uploadKey:(NSString *)key;
+ (instancetype)mp3AudioWithFileData:(NSData *)data audioName:(NSString *)name uploadKey:(NSString *)key;

- (instancetype)initWithFileData:(NSData *)data fileName:(NSString *)name fileType:(LYUFileType)type uploadKey:(NSString *)key;

- (NSData *)fileData;
- (NSString *)fileName;
- (NSString *)fileType;
- (NSString *)uploadKey;
- (NSString *)md5String;
@end

