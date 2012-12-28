//
//  singletonManager.m
//  QuranUniversalApp
//
//  Created by Faizan on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "singletonManager.h"

static singletonManager *singletonInstanceManager = nil;

@implementation singletonManager

@synthesize pageNumToJump;
@synthesize surahMapping;
@synthesize chapterMapping;

+(singletonManager*)sharedSingletonManager {
	@synchronized(self) {
		if (!singletonInstanceManager) {
			singletonInstanceManager = [[singletonManager alloc] init];
		}
	}
	return singletonInstanceManager;
}

@end

