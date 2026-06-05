# SudoLog

개발 도중 마주친 문제, 알고리즘 풀이, 언어 문법, UI 실험, CS 지식을 기록하는 개인 학습 저장소입니다.

## Structure

| Path | Description |
| --- | --- |
| `Algorithm` | 백준, 프로그래머스 문제 풀이와 알고리즘 기록 |
| `iOS` | UIKit, SwiftUI, TCA, Swift Macro, Tuist, iOS 실험 프로젝트 |
| `Language` | Swift, Python 문법과 언어별 학습 노트 |
| `PageKit` | 공통 유틸, 자료구조, 알고리즘 구현 |
| `Resource` | 공통 리소스 |

## Writing Guide

- 문제 풀이: 접근법, 시간복잡도, 실수 포인트를 함께 기록합니다.
- 문법 정리: 짧은 설명보다 실행 가능한 예제 코드를 우선합니다.
- R&D 기록: 문제 상황, 시도한 방법, 결론을 분리해서 작성합니다.
- 참고 자료: 문서 하단에는 직접 참고한 핵심 자료만 남깁니다.

## Open Project

이 저장소는 학습 목적으로 `Tuist`를 사용합니다.

이미 `Tuist`를 사용 중이라면 아래 명령만 실행하면 됩니다.

```bash
tuist generate
```

처음 설정하는 경우:

```bash
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

## References

학습 중 자주 참고한 큰 자료는 [References.md](Docs/References.md)에 따로 정리합니다.
