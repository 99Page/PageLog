import MyMacro

let a = 17
let b = 25

let (result, code) = #stringify(a + b)

print("The value \(result) was produced by the code \"\(code)\"")

enum Slope {
    case beginnersParadise
    case practiceRun
    case livingRoom
    case olympicRun
    case blackBeauty
}

@EnumSubset<Slope>
enum EasySlope {
    case beginnersParadise
    case practiceRun
}
