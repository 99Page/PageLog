class Parent {
    var child: Child?
}

class Child {
//    let parent: Parent
    weak parent: Parent?
    
    init(parent: Parent) {
        self.parent = parent
    }
}
