//
//  serviceNewDevice.h
//  shen1d
//
//  Created by Myth on 13-1-29.
//
//

#import "serviceInterface.h"

@protocol serviceNewDeviceCallBackDelegate;
@interface serviceNewDevice:serviceInterface{
    id m_delegate;
}

- (id)initWithDelegate:(id)aDelegate requestMode:(TRequestMode)mode;

@end
@protocol serviceNewDeviceCallBackDelegate<NSObject>;

- (void)serviceNewDeviceCallBack:(NSDictionary *)dicCallBack withErrorMessage:(Error *)error;
@end