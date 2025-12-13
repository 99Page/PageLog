# Regex

정규식에 대해 정리합니다. 

## Contents of Regex 

정규식을 표현하기 위한 요소는 Anchor, Quantifiers, Character Classes, Grouping and Capturing, Escaping이 존재합니다.

### Anchor

문자열 내의 특정 위치를 지정하며, 문자를 소비하지 않습니다.
|키워드|이름|설명|
|---|---|---|
|\^|시작 앵커|문자열의 시작 위치에 일치합니다. (다중 라인 모드에서는 줄의 시작)|
|$|끝 앵커|문자열의 끝 위치에 일치합니다. (다중 라인 모드에서는 줄의 끝)|
|\\b|단어 경계|단어 문자와 비단어 문자 사이의 위치에 일치합니다. 단어의 시작이나 끝을 나타냅니다.|
|\\B|비단어 경계|단어 경계가 아닌 모든 위치(단어의 내부)에 일치합니다.|

```swift
let string = "hello world"

// 'hello'로 시작하는지 검사
/^hello/.wholeMatch(in: string) // true 

// 'world'로 끝나는지 검사
/world$/.wholeMatch(in: string) // true
/hello$/.wholeMatch(in: string) // false

// 단어 'world'에만 일치
/\bworld\b/.wholeMatch(in: string) // true 

let internalWord = "uncatalogued"
let standaloneWord = "cat"

// \Bcat\B: 'cat'이 단어의 시작도 끝도 아닌, '단어 내부'에 있을 때 일치
// 'uncatalogued'에서 'cat' 앞뒤 ('n', 'a')는 모두 단어 문자(\w)이므로 \B 경계에 일치
/\Bcat\B/.firstMatch(in: internalWord) // true 

// 'cat'은 독립된 단어이므로 \b 경계에 둘러싸여 \B 경계에는 불일치
/\Bcat\B/.firstMatch(in: standaloneWord) // false
```

### Quantifiers

바로 앞에 오는 요소가 몇 번 반복되어야 하는지를 지정합니다.

|키워드|이름|설명|동작|
|---|---|---|---|
|\*|0회 이상|0번 이상 반복|Greedy|
|\+|1회 이상|1번 이상 반복|Greedy|
|\?|0 또는 1회|0번 또는 1번 반복|Greedy|
|{n}|정확히 n회|정확히 n번 반복|-|
|{n,}|n회 이상|최소 n번 이상 반복|-|
|{n, m}|n회에서 m회|최소 n번, 최대 m번 반복|-|
|\*\?, \+\?, \?\?|최소 일치|수량자 뒤에 붙어 가능한 한 짧게 매치|Lazy|
