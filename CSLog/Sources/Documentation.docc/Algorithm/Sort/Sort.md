# Sort

## Selection Sort

![SelectionSort](SelectionSort)

* 맨 앞부터 차례대로 작은 값을 채워갑니다. 
* 각 순회마다, 가장 작은 값을 선택(selection) 합니다. 

## Insertion Sort

![InsertionSort](InsertionSort)

* 앞에서부터 순차적으로 값을 하나 고릅니다. 

* 그 값보다 큰 값들을 오른쪽으로 밀어내고, 현재 선택한 값을 올바른 곳에 삽입(insertion)합니다.

## Bubble sort

![BubbleSort](BubbleSort)

* 값을 인접한 값들과 계속 비교합니다.
* 위치가 맞지 않으면 두 자리의 값을 바꿉니다. 
* 더 큰 값은 계속 배열의 맨 뒷자리로 떠오르게(Bubble) 됩니다. 

## Merge sort

![MergeSort](MergeSort)

* Divide and Conquer 방식으로 동작합니다. 

* 배열을 쪼갭니다. 

* 쪼개진 두 배열을 합칠 때, 가장 작은 값들이 먼저 오게 병합합니다. 

* 별도의 배열이 필요해서, in-place 방식이 아닙니다. 

## Quick sort

![QuickSort](QuickSort)

* 피벗을 하나 선정합니다. 

* 피벗을 기준으로 좌측에는 작은 값, 우측에는 큰 값을 배치합니다. 

* 피벗을 기준으로 좌우로 쪼개서 계속 반복합니다. 

* in-place 방식입니다. 
