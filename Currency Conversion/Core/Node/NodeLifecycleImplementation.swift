
import Foundation

protocol NodeLifecycleImplementation: AnyObject {
    func nodeSetup()
    func nodeUninstall()
}


protocol AnyMakable: AnyObject {
    static func make() -> Any?
}
