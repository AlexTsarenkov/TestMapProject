//
//  Animation.h
//  TestMapProject
//
//  Created by Alexey Tsarenkov on 15.05.15.
//  Copyright (c) 2015 alextsarenkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface Animation : NSObject
+ (void) movePlaceholder:(UIView *) view Points:(int)points isMoveLeft:(BOOL) isMoveLeft;
@end
