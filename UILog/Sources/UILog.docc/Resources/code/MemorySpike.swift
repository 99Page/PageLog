Button("make spike") {
    for _ in 0..<100_000{
        print("Now is \(Date.now)") // 가장 간단하게 확인할 수 있는 메모리 유지
    }
}
