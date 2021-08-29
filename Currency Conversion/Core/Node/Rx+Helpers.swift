import Foundation
import RxSwift
import RxCocoa

extension BehaviorRelay {
    public convenience init(_ value: Element) {
        self.init(value: value)
    }
}

typealias RxVar = BehaviorRelay

extension ObservableType {
    func onNext(_ onNext: @escaping ((Element) -> Void)) -> Disposable {
        return subscribe(onNext: onNext)
    }
}
