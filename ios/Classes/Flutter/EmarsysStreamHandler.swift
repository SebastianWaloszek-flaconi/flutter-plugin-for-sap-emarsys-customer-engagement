//
//  Created by Emarsys on 2021.
//

import Foundation
import EmarsysSDK

class EmarsysStreamHandler: NSObject, FlutterStreamHandler {

    var sink: FlutterEventSink?
    var eventHandler: EMSEventHandlerBlock?
    var voidHandler: (() -> ())!
    var completionHandler: ((Error?) -> ())!
    var cache: [(String, [String: Any])] = []

    override init() {
        super.init()
        self.eventHandler = { [unowned self] eventName, payload in
            if (sink == nil) {
                cache.append((eventName, payload ?? [:]))
            } else {
                var event = [String: Any]()
                event["name"] = eventName
                event["payload"] = payload
                self.sink?(event)
            }
        }
        self.voidHandler = {
            self.sink?(nil)
        }
        self.completionHandler = { error in
            self.sink?(error)
        }
    }

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        sink = events
        cache.forEach { cachedEvent in
            var event: [String: Any] = [:]
            event["name"] = cachedEvent.0
            event["payload"] = cachedEvent.1
            self.sink?(event)
        }
        cache.removeAll()
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
}
