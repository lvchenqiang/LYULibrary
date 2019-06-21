//
//  LYUUploadFile.m
//  LYUKit
//
//  Created by 吕陈强 on 2019/6/21.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import "LYUUploadFile.h"
#import "LYUHTTPNetworkTool.h"


@interface LYUUploadFile ()

@property (nonatomic, copy) NSString *uploadKey;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *fileType;
@property (nonatomic, copy) NSString *md5String;
@property (nonatomic, strong) NSData *fileData;

@end

@implementation LYUUploadFile

- (instancetype)initWithFileData:(NSData *)data fileName:(NSString *)name fileType:(LYUFileType)type uploadKey:(NSString *)key {
    if (self = [super init]) {
        
        self.fileData = data;
        self.uploadKey = key;
        
        switch (type) {
            case LYUFileTypePng: {
                
                self.fileType = @"image/png";
                self.fileName = [name stringByAppendingString:@".png"];
            }   break;
                
            case LYUFileTypeJpg: {
                
                self.fileType = @"image/jpeg";
                self.fileName = [name stringByAppendingString:@".jpeg"];
            }   break;
                
            case LYUFileTypeMp3: {
                
                self.fileType = @"audio/mp3";
                self.fileName = [name stringByAppendingString:@".mp3"];
            }   break;
        }
        
    }
    return self;
}


+ (instancetype)pngImageWithFileData:(NSData *)data imageName:(NSString *)name {
    return [[LYUUploadFile alloc] initWithFileData:data fileName:name fileType:LYUFileTypePng uploadKey:nil];
}

+ (instancetype)jpgImageWithFileData:(NSData *)data imageName:(NSString *)name {
    return [[LYUUploadFile alloc] initWithFileData:data fileName:name fileType:LYUFileTypeJpg uploadKey:nil];
}

+ (instancetype)mp3AudioWithFileData:(NSData *)data audioName:(NSString *)name {
    return [[LYUUploadFile alloc] initWithFileData:data fileName:name fileType:LYUFileTypeMp3 uploadKey:nil];
}

+ (instancetype)pngImageWithFileData:(NSData *)data imageName:(NSString *)name uploadKey:(NSString *)key {
    return [[LYUUploadFile alloc] initWithFileData:data fileName:name fileType:LYUFileTypePng uploadKey:key];
}

+ (instancetype)jpgImageWithFileData:(NSData *)data imageName:(NSString *)name uploadKey:(NSString *)key {
    return [[LYUUploadFile alloc] initWithFileData:data fileName:name fileType:LYUFileTypeJpg uploadKey:key];
}

+ (instancetype)mp3AudioWithFileData:(NSData *)data audioName:(NSString *)name uploadKey:(NSString *)key {
    return [[LYUUploadFile alloc] initWithFileData:data fileName:name fileType:LYUFileTypeMp3 uploadKey:key];
}


#pragma mark - Getter

- (NSString *)uploadKey {
    if (!_uploadKey) {
        _uploadKey = self.md5String;
    }
    return _uploadKey;
}

- (NSString *)md5String {
    if (!_md5String) {
        _md5String = self.fileData.length > 0 ? [LYUHTTPNetworkTool lyu_md5WithData:self.fileData] : @"";
    }
    return _md5String;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\nfileName: %@\nfileType: %@\nuploadKey: %@\nfileLength: %ld",self.fileName,self.fileType,self.uploadKey,self.fileData.length];
}






@end
