Button("avoid spike") {
    for _ in 0..<100_000{
        autoreleasepool {
            print("Now is \(Date.now)")
        }
    }
}

