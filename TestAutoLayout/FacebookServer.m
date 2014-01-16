//
//  FacebookServer.m
//  TWSTest
//
//  Created by Manjula Jonnalagadda on 8/22/13.
//  Copyright (c) 2013 Manjula Jonnalagadda. All rights reserved.
//

#import "FacebookServer.h"

static FacebookServer *facebookServer=nil;

@implementation FacebookServer

-(id)init{
    self=[super init];
    if (self) {
 //       [self loginWithSuccessBlock:NULL andFailureBlock:NULL];
        _readPermissions=@[@"basic_info", @"email", @"user_likes"];
    }
    return self;
}

+(FacebookServer *)facebookServer{
    
    static FacebookServer *_facebookServer=nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _facebookServer = [[self alloc] init];
        
    });
    
    return _facebookServer;
    
}

-(void)loginWithSuccessBlock:(void (^)(void))successBlock andFailureBlock:(void (^)(NSError *))failureBlock{
    if (self.session.state==FBSessionStateOpen) {
        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (error) {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                failureBlock(error);
            }else{
                self.me=result;
                successBlock();
            }
        }];
        return;
    }
    [FBSession openActiveSessionWithReadPermissions:_readPermissions allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        if (error) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error Logging in" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            failureBlock(error);
        }else{
            self.session=session;
            [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    self.me=result;
                }else{
                    failureBlock(error);

                }
            }];
        }
    }];

}

-(void)pullFriendsWithSuccessBlock:(void (^)(NSArray *))successBlock andFailureBlock:(void (^)(NSError *error)) failureBlock{
    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (error) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            failureBlock(error);
        }else{
            NSArray *array=result[@"data"];
            successBlock(array);
         }
    }];
}

-(void)postOnMyWall:(NSString *)status withSuccessBlock:(void (^)(void))successBlock andFailureBlock:(void (^)(NSError *error))failureBlock{
    
    [FBRequestConnection startForPostStatusUpdate:status completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (error) {
            failureBlock(error);
        }else{
            successBlock();
        }
    }];
    
}

-(void)searchForPlace:(CLLocationCoordinate2D)coordinate withinRadius:(NSInteger)radius limit:(NSInteger)limit keyword:(NSString *)keyword withSuccessBlock:(void (^)(NSArray *))successBlock andFailureBlock:(void (^)(NSError *))failureBlock{
    
    [FBRequestConnection startForPlacesSearchAtCoordinate:coordinate radiusInMeters:radius resultsLimit:limit searchText:keyword completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (error) {
            failureBlock(error);
        }else{
            NSArray *array=result[@"data"];
            successBlock(array);
        }
    }];
}

-(void)postOnMyWall:(NSString *)status atPlace:(NSDictionary<FBGraphPlace> *)place tags:(NSArray *)tags withSuccessBlock:(void (^)(void))successBlock andFailureBlock:(void (^)(NSError *))failureBlock{
    
    [FBRequestConnection startForPostStatusUpdate:status place:place tags:tags completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (error) {
            failureBlock(error);
        }else{
            successBlock();
        }
    }];
    
}

-(void)postPhotoOnWall:(UIImage *)image withSuccessBlock:(void (^)(void))successBlock andFailureBlock:(void (^)(NSError *))failureBlock{
    [FBRequestConnection startForUploadPhoto:image completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
       
        if (error) {
            failureBlock(error);
        }else{
            successBlock();
        }
        
    }];
}



-(NSString *)accessToken{
    
    return self.session.accessTokenData.accessToken;
    
}

-(NSString *)identifier{
    
    return self.me.id;
    
}

-(FBLoginView *)fbLoginViewWithLoggedBlock:(void (^)(void))loggedBlock{
    
    _loggedBlock=[loggedBlock copy];
    
    FBLoginView *loginView= [[FBLoginView alloc] initWithReadPermissions:_readPermissions];
    loginView.delegate=self;
    
    return loginView;

}

-(void)loggedIn:(void (^)(BOOL loggedIn))loggedInBlock andFailureBlock:(void (^)(NSError *))failureBlock{
    
    [FBSession openActiveSessionWithReadPermissions:_readPermissions allowLoginUI:NO completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        
        if (!error) {
            if (status==FBSessionStateOpen) {
                loggedInBlock(YES);
            }else{
                loggedInBlock(NO);
            }
        }else{
            failureBlock(error);
        }
        
    }];
    
}

-(BOOL)loggedIn{
    
    return [[FBSession activeSession] isOpen];
    
}



#pragma mark - FBLoginViewDelegate

-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user{
    
    self.me=user;
    _loggedBlock();
    
    
    
}



-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
 
}


@end
