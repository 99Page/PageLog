# PageLog

개발 도중 마주친 문제, 알고리즘 공부 및 각종 R&D 했던 것들을 기록하기 위한 저장소입니다. 

## Tuist 설치

개인 프로젝트지만 학습을 위해 `tuist`를 사용했습니다. `tuist` 가 설치되어있지 있다면, 터미널에 아래 커맨드를 순차적으로 입력 후 프로젝트를 확인할 수 있습니다. 

``` bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

brew install mise 

mise install tuist    
mise use tuist@latest 

echo 'eval "$(mise activate zsh)"' >> ~/.zshrc
source ~/.zshrc

tuist generate 
```

`tuist`를 이미 사용 중이신 경우는 `tuist generate`만 입력하시면 됩니다. 


## References

학습에 참고했던 자료들입니다. 자료가 방대하거나 영상인 경우만 기록했습니다.

### Documentation provided by Apple


[The Swift Programming Language(6.1) - Language Guide](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/#Language-Guide)

### WWDC 23

[Create rich documentation with Swift-DocC](https://developer.apple.com/videos/play/wwdc2023/10244/)

### WWDC24
[Enhance your UI animations and transitions](https://developer.apple.com/kr/videos/play/wwdc2024/10145/)

[Creating a chart using Swift charts](https://developer.apple.com/documentation/charts/creating-a-chart-using-swift-charts)

[What’s new in SF Symbols 6](https://developer.apple.com/kr/videos/play/wwdc2024/10188/)

[Meet the Translation API](https://developer.apple.com/kr/videos/play/wwdc2024/10117/)

[Demystify SwiftUI containers](https://developer.apple.com/videos/play/wwdc2024/10146/)

[Go further with Swift Testing](https://developer.apple.com/videos/play/wwdc2024/10195/)

## WWDC25 

[What’s new in UIKit](https://developer.apple.com/videos/play/wwdc2025/243/)

### Point-free

[EP#110 Designing Dependencies: The Problem](https://www.pointfree.co/collections/dependencies/designing-dependencies/ep110-designing-dependencies-the-problem)

[EP#111 Designing Dependencies: Modularization](https://www.pointfree.co/collections/dependencies/designing-dependencies/ep111-designing-dependencies-modularization)

[EP#112 Designing Dependencies: Reachability](https://www.pointfree.co/collections/dependencies/designing-dependencies/ep112-designing-dependencies-reachability)

[EP#113 Designing Dependencies: Core Location](https://www.pointfree.co/episodes/ep113-designing-dependencies-core-location)

[EP#114 Designing Dependencies: The Point](https://www.pointfree.co/collections/dependencies/designing-dependencies/ep114-designing-dependencies-the-point)

[EP#243 Tour of the Composable Architecture: The Basics](https://www.pointfree.co/episodes/ep243-tour-of-the-composable-architecture-1-0-the-basics)

[EP#244 Tour of the Composable Architecture: Introducing Standups](https://www.pointfree.co/episodes/ep244-tour-of-the-composable-architecture-1-0-standups-part-1)

[EP#245 Tour of the Composable Architecture: Navigation](https://www.pointfree.co/episodes/ep245-tour-of-the-composable-architecture-1-0-navigation)

[EP#246 Tour of the Composable Architecture: Stacks](https://www.pointfree.co/episodes/ep246-tour-of-the-composable-architecture-1-0-stacks)

[EP#247 Tour of the Composable Architecture: Domain Modeling](https://www.pointfree.co/episodes/ep247-tour-of-the-composable-architecture-1-0-correctness)

[EP#248 Tour of the Composable Architecture: Dependencies](https://www.pointfree.co/episodes/ep248-tour-of-the-composable-architecture-1-0-dependencies)

[EP#249 Tour of the Composable Architecture: Persistence](https://www.pointfree.co/episodes/ep249-tour-of-the-composable-architecture-1-0-persistence)

[EP#309 Sharing with SQLite: The Problems](https://www.pointfree.co/episodes/ep309-sharing-with-sqlite-the-problems#downloads)

[EP#310 Sharing with SQLite: The Solution](https://www.pointfree.co/episodes/ep310-sharing-with-sqlite-the-solution)

 [EP#316 SQL Builders: Selects](https://www.pointfree.co/episodes/ep316-sql-builders-selects)