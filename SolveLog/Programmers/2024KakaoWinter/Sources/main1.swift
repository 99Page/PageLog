////
////  main.swift
////  2023KakaoManifests
////
////  Created by 노우영 on 9/10/24.
////
//
//import Foundation
//
////solution(["muzi", "ryan", "frodo", "neo"], ["muzi frodo", "muzi frodo", "ryan muzi", "ryan muzi", "ryan muzi", "frodo muzi", "frodo ryan", "neo muzi"])
////
////solution(["joy", "brad", "alessandro", "conan", "david"], ["alessandro brad", "alessandro joy", "alessandro conan", "david alessandro", "alessandro david"])
//
////solution(["a", "b", "c"], ["a b", "b a", "c a", "a c", "a c", "c a"])
//
///// 선물 지수: 준 선물 - 받은 선물
/////
///// 선물 주는 기준
///// - 두 사람 중 선물 더 많이 보낸 쪽
/////
///// 같은 경우면
///// - 선물 지수 큰 쪽이 선물 받는다.
///// - 선물 지수가 같다면 없다.
/////
//
//// key: 이름
//// value: 선물 지수
//var giftFigure: [String: Int] = [:]
//
//// key: 선물을 받은 사람
//// value
////  - key: 선물을 준 사람
////  - value: 선물을 준 횟수
//var giftRecord: [String: [String: Int]] = [:]
//
//// key: 이름
//// value: 다음 달에 받을 선물
//var expectedGiftCount: [String: Int] = [:]
//
//var maxGiftCount: Int = 0
//
//
//func solution(_ friends:[String], _ gifts:[String]) -> Int {
//    setGiftInformation(friends, gifts)
//    
//    let twoFriends = friends.combinations(of: 2)
//    
//    for twoFriend in twoFriends {
//        giveGift(friends: twoFriend)
//    }
//    
//    return maxGiftCount
//}
//
//func giveGift(friends: [String]) {
//    let friend1 = friends[0]
//    let friend2 = friends[1]
//    
//    let giftRecord1 = giftRecord[friend1]?[friend2] ?? 0
//    let giftRecord2 = giftRecord[friend2]?[friend1] ?? 0
//    
//    let expectedGift1 = expectedGiftCount[friend1] ?? 0
//    let expectedGift2 = expectedGiftCount[friend2] ?? 0
//    
//    if giftRecord1 > giftRecord2 { // friend1이 선물을 더 많이 받은 경우
//        updateExpectedGift(for: friend2, currentCount: expectedGift2)
//    } else if giftRecord1 < giftRecord2 { // friend2가 선물을 더 많이 받은 경우
//        updateExpectedGift(for: friend1, currentCount: expectedGift1)
//    } else { // 서로 주고 받은 회수가 같은 경우
//        giveGiftByGiftFigure(friend1: friend1, friend2: friend2)
//    }
//}
//
//func updateExpectedGift(for friend: String, currentCount: Int) {
//    expectedGiftCount[friend] = currentCount + 1
//    maxGiftCount = max(maxGiftCount, currentCount + 1)
//}
//
//func giveGiftByGiftFigure(friend1: String, friend2: String) {
//    let giftFigure1 = giftFigure[friend1] ?? 0
//    let giftFigure2 = giftFigure[friend2] ?? 0
//    
//    let expectedGift1 = expectedGiftCount[friend1] ?? 0
//    let expectedGift2 = expectedGiftCount[friend2] ?? 0
//    
//    if giftFigure1 > giftFigure2 {
//        updateExpectedGift(for: friend1, currentCount: expectedGift1)
//    } else if giftFigure1 < giftFigure2 {
//        updateExpectedGift(for: friend2, currentCount: expectedGift2)
//    }
//}
//
//func setGiftInformation(_ friends: [String], _ gifts: [String]) {
//    for friend in friends {
//        giftFigure[friend] = 0
//        giftRecord[friend] = [:]
//    }
//    
//    for gift in gifts {
//        let split = gift.split(separator: " ")
//        let giver = String(split[0])
//        let receiver = String(split[1])
//        
//        let giverFigure = giftFigure[giver] ?? 0
//        giftFigure[giver] = giverFigure + 1
//        
//        let receiverFigure = giftFigure[receiver] ?? 0
//        giftFigure[receiver]  = receiverFigure - 1
//        
//        let giveCount = giftRecord[receiver]?[giver] ?? 0
//        giftRecord[receiver]?[giver] = giveCount + 1
//    }
//}
//
//extension Array {
//    func combinations(of k: Int) -> [[Element]] {
//        guard k > 0 else { return [[]] }
//        guard let first = self.first else { return [] }
//        
//        let subarray = Array(self.dropFirst())
//        
//        /// 배열의 첫번째 원소에서 하나를 고르고 나머지 원소를 이용해 조합합니다.
//        let withFirst = subarray.combinations(of: k - 1).map { [first] + $0 }
//        
//        /// 배열의 첫번째 원소를 제외한 나머지를 이용해 조합합니다.
//        let withoutFirst = subarray.combinations(of: k)
//        
//        return withFirst + withoutFirst
//    }
//}
