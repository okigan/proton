//
//  bridge.swift
//  
//
//  Created by Igor Okulist on 5/19/21.
//

public typealias DispatcherType = @convention(c) (
    _ callback: UnsafeRawPointer, 
    _ param: UnsafePointer<CChar>
) -> UnsafePointer<CChar>


struct DispatcherAndCallback {
    var dispatcher: DispatcherType
    var callback: UnsafeRawPointer
}

var functionCallbackWithDispatcherMap = [String : DispatcherAndCallback]()

@_cdecl("prtn_register_function_callback_with_dispatcher")
public func prtn_register_function_callback_with_dispatcher(
    namePtr: UnsafePointer<CChar>,
    dispatcher: @escaping DispatcherType,
    callback: UnsafeRawPointer
) -> Int
{
    functionCallbackWithDispatcherMap[String(cString: namePtr)] = DispatcherAndCallback (
        dispatcher:dispatcher,
        callback: callback
    )
    
    return functionCallbackWithDispatcherMap.capacity
}

public func prtn_invoke_function_through_dispatcher(name: String, param: String ) -> String {
    print("[swift] in prtn_invoke_function_through_dispatcher\n" )

    // print(functionCallbackWithDispatcherMap.capacity)
    // for (k, _) in functionCallbackWithDispatcherMap {
    //     print(k)
    // }
    
    let entry = functionCallbackWithDispatcherMap[name]

    if entry == nil {
        print("[swift] in no callback for \(name)\n" )
        return "no callback for \(name)"
    }

    let dispatcherAndCallback = functionCallbackWithDispatcherMap[name]!
    let dispatcher = dispatcherAndCallback.dispatcher
    let callback = dispatcherAndCallback.callback
    
    let result = dispatcher(callback, param);
    let swift_result = String(cString:result)
    
    //TODO: add free of the result
    
    return swift_result;
}
