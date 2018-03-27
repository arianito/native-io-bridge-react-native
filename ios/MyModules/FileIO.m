//
//  FileIO.m
//  ioBridgeModule
//
//  Created by Aryan on 3/27/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "FileIO.h"

@implementation FileIO

RCT_EXPORT_MODULE();

- (NSString*) resolvePath:(NSString*)name {
  NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *fileName = [NSString stringWithFormat:@"%@/%@", documentsDirectory, name];
  return fileName;
}

RCT_REMAP_METHOD(save, to:(NSString*)to base64:(NSString *)base64 resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject )
{
  @try {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileName = [self resolvePath:to];
    
    
    NSURL * _Nullable url = [NSURL fileURLWithPath:fileName];
    if(url){
      [fileManager createDirectoryAtURL:[url URLByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    [base64 writeToFile:fileName atomically:YES encoding:NSASCIIStringEncoding error:nil];
    resolve(@(TRUE));
  } @catch(NSException *exception) {
    reject([exception name], [exception reason], NULL);
  }
}





RCT_EXPORT_METHOD(saveSync:(NSString *)to base64:(NSString *)base64)
{
  @try {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *fileName = [self resolvePath:to];
    
    
    NSURL * _Nullable url = [NSURL fileURLWithPath:fileName];
    if(url){
      [fileManager createDirectoryAtURL:[url URLByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    [base64 writeToFile:fileName atomically:YES encoding:NSASCIIStringEncoding error:nil];
    
    
  }@catch(NSException *exception) {
  }
}


RCT_REMAP_METHOD(read, from:(NSString*)from resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject )
{
  @try {
    NSString *fileName = [self resolvePath:from];
    NSString* content = [[NSString alloc] initWithContentsOfFile:fileName encoding:NSASCIIStringEncoding error:nil];
    resolve(content);
  } @catch(NSException *exception) {
    reject([exception name], [exception reason], NULL);
  }
}



RCT_EXPORT_METHOD(delete:(NSString *)from)
{
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSString *fileName = [self resolvePath:from];
  [fileManager removeItemAtPath:fileName error:nil];
}


RCT_REMAP_METHOD(exists, name:(NSString*)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject )
{
  @try {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileName = [self resolvePath:name];
    BOOL data = [fileManager fileExistsAtPath:fileName];
    if(data == TRUE){
      resolve(@(TRUE));
    }else{
      resolve(@(FALSE));
    }
  } @catch(NSException *exception) {
    reject([exception name], [exception reason], NULL);
  }
}

RCT_REMAP_METHOD(path, to:(NSString*)to resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject )
{
  @try {
    NSString *fileName = [self resolvePath:to];
    resolve(fileName);
  } @catch(NSException *exception) {
    reject([exception name], [exception reason], NULL);
  }
}



RCT_EXPORT_METHOD(saveToGallery: (NSString *)base64)
{
  @try {
    NSURL *url = [NSURL URLWithString:base64];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:imageData];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
  } @catch(NSException *exception) {
  }
}


RCT_EXPORT_METHOD(saveFileToGallery: (NSString *)path)
{
  @try {
    NSString *fileName = [self resolvePath:path];
    NSString* base64 = [[NSString alloc] initWithContentsOfFile:fileName encoding:NSASCIIStringEncoding error:nil];
    NSURL *url = [NSURL URLWithString:base64];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:imageData];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
  } @catch(NSException *exception) {
  }
}



@end

