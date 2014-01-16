//
//  FacebookServer.h
//  TWSTest
//
//  Created by Manjula Jonnalagadda on 8/22/13.
//  Copyright (c) 2013 Manjula Jonnalagadda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>


@interface FacebookServer : NSObject<FBLoginViewDelegate>{
    
    NSArray *_readPermissions;
    void (^_loggedBlock)();

    

}

@property(nonatomic,strong)FBSession *session;
@property(nonatomic,strong)id<FBGraphUser> me;

+(FacebookServer *)facebookServer;
-(void)loginWithSuccessBlock:(void (^)(void))successBlock andFailureBlock:(void (^)(NSError *error)) failureBlock;
-(void)pullFriendsWithSuccessBlock:(void (^)(NSArray *friends))successBlock andFailureBlock:(void (^)(NSError *error)) failureBlock;
-(void)postOnMyWall:(NSString *)status withSuccessBlock:(void(^)(void))successBlock andFailureBlock:(void (^)(NSError *error)) failureBlock;
-(void)searchForPlace:(CLLocationCoordinate2D)coordinate withinRadius:(NSInteger)radius limit:(NSInteger)limit keyword:(NSString *)keyword withSuccessBlock:(void (^)(NSArray *places))successBlock andFailureBlock:(void (^)(NSError *error)) failureBlock;

-(void)postOnMyWall:(NSString *)status atPlace:(NSDictionary<FBGraphPlace> *)place tags:(NSArray *)tags withSuccessBlock:(void (^)(void))successBlock andFailureBlock:(void (^)(NSError *))failureBlock;
-(void)postPhotoOnWall:(UIImage *)image withSuccessBlock:(void(^)(void))successBlock andFailureBlock:(void (^)(NSError *error)) failureBlock;
-(NSString *)accessToken;


-(BOOL)loggedIn;

-(void)loggedIn:(void (^)(BOOL))loggedInBlock andFailureBlock:(void (^)(NSError *error)) failureBlock;

-(FBLoginView *)fbLoginViewWithLoggedBlock:(void (^)(void))loggedBlock;



@end
