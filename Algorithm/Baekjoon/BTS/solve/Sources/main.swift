import Foundation

let input: [Int] = readArray()

var dateComponent = DateComponents()
dateComponent.year = 2000
dateComponent.hour = input[0]
dateComponent.minute = input[1]

let date = Calendar.current.date(from: dateComponent)!

print(date)

let targetDate = Calendar.current.date(byAdding: .minute, value: -45, to: date)


let formatter = DateFormatter()
formatter.locale = .current
formatter.dateFormat = "H mm"

if targetDate != nil {
    print(formatter.string(from: targetDate!))
}

func readArray<T: LosslessStringConvertible>() -> [T] {
    let line = readLine()!
    let splitedLine = line.split(separator: " ")
    let array = splitedLine.map { T(String($0))! }
    return array
}
