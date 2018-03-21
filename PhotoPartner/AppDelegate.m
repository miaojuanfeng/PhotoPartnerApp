//
//  AppDelegate.m
//  PhotoPartner
//
//  Created by USER on 6/3/2018.
//  Copyright © 2018 MJF. All rights reserved.
//

#import "MacroDefine.h"
#import "AppDelegate.h"
#import "HomeController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    [UINavigationBar appearance].barTintColor = RGBA_COLOR(27, 163, 232, 1);
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    // Init Global Varables
    self.deviceId = [[NSMutableArray alloc] init];
    self.fileDesc = [[NSMutableArray alloc] init];
    self.photos = [[NSMutableArray alloc] init];
    self.focusImageIndex = -1;
    self.isSending = false;
    
    self.videos = [[NSMutableArray alloc] init];
    self.completedUnitPercent = [[NSMutableArray alloc] init];
    
//    self.deviceList = [[NSMutableDictionary alloc] init];
    [self loadDeviceList];
    if( self.deviceList == nil ){
        self.deviceList = [[NSMutableArray alloc] init];
    }
    NSLog(@"%@", self.deviceList);
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    HomeController *homeController = [[HomeController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeController];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)clearProperty {
    [self.deviceId removeAllObjects];
    [self.fileDesc removeAllObjects];
    [self.photos removeAllObjects];
    self.focusImageIndex = -1;
    self.isSending = false;
}

- (void)saveDeviceList:(NSMutableDictionary *) device {
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [path objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"deviceList.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *newDic = nil;
    if ([fileManager fileExistsAtPath:plistPath] == NO) {
        newDic = [[NSMutableArray alloc] init];
    }else{
        newDic = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    }
    [newDic addObject:device];
    [newDic writeToFile:plistPath atomically:YES];
}

- (void)loadDeviceList {
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
    NSString *plistPath = [path stringByAppendingPathComponent:@"deviceList.plist"];
    self.deviceList = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
}


@end
