
import Foundation

extension Node {
    
    func firstAncestor(where condition: (Node) -> Bool) -> Node? {
        if let parent = parent,
           condition(parent) == true {
            return parent
        } else {
            return parent?.firstAncestor(where: condition)
        }
    }
    
    func firstBloodline(where condition: (Node) -> Bool) -> Node? {
        if condition(self) == true {
            return self
        } else {
            return parent?.firstBloodline(where: condition)
        }
    }
    
    func firstBloodline(whoseParentMatches condition: (Node) -> Bool) -> Node? {
        if let parent = parent,
           condition(parent) == true {
            return self
        } else {
            return parent?.firstBloodline(whoseParentMatches: condition)
        }
    }
}
