import Foundation

func runOnMainThread(_ block: @escaping (() -> Void)) {
    if Thread.current.isMainThread {
        block()
    } else {
        DispatchQueue.main.async(execute: block)
    }
}
