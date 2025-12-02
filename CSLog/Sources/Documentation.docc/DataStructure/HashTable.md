# Hash Table

## Hashing

> keyword: Chaing, Open addressing

* 해시 테이블의 원리 

키를 해시 함수에 넣어 인덱스를 얻고 배열 버킷에 저장. 해시 함수로 나온 값을 O(1)로 접근할 수 있다. 

* 해시 충돌이 발생하는 이유 

서로 다른 키가 같은 해시 값을 갖는다. 

키는 무한한 반면, 해시값은 유한하다. 

* 해시 충돌 해결 방법 

1. 체이닝: 각 버킷을 연결. 최악의 경우 O(n)

2. Open addressing: 충돌 발생 시 빈 버킷으로 이동. 메모리 사용이 효율적이지만 마찬가지로 한쪽 영역에 데이터가 몰리면 O(n). 빈 영역을 찾기 위한 probing 이 필요하다. 

## Probing 

충돌 발생 시 문제를 해결하기 위해 빈 공간을 찾는 방법이다. 세가지 방법이 있다. 

* Linear Probing 

* Quadratic Probing 

* Double Hashing

### Linear Probing

충돌하면 한 칸씩 이동하면서 빈 공간을 찾는다.

`h + 1, h + 2, h + 3` 

### Quadratic Probing 

충돌 시 탐사 횟수의 제곱만큼 이동한다. 

`h + 1^2, h + 2^2, h + 3^3`

### Double hashing

2개의 해시 함수를 사용해서 다음 위치를 정한다. 

`h1(key) + i x h2(key)` 
