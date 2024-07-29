import LocalizedPreview
import SwiftUI

let a = 17
let b = 25

let (result, code) = #stringify(a + b)

print("The value \(result) was produced by the code \"\(code)\"")


#localizedPreview(view: {
    Color.red
        .frame(width: 10)
})

//#Preview {
//    Color.red
//}

