//
//  singletonManager.h
//  QuranUniversalApp
//
//  Created by Faizan on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface singletonManager : NSObject 

@property (nonatomic, assign) NSUInteger pageNumToJump;
@property(nonatomic, retain)NSMutableArray *surahMapping;
@property(nonatomic, retain)NSMutableArray *chapterMapping;

+(singletonManager*)sharedSingletonManager;


@end
