//
//  FileIO.h
//  ioBridgeModule
//
//  Created by Aryan on 3/27/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "React/RCTBridgeModule.h"

#import <UIKit/UIKit.h>

@interface FileIO : NSObject<RCTBridgeModule>
- (NSString*) resolvePath:(NSString*)name;
@end
