import bisect

def manual_binary_search(arr, target):
    left, right = 0, len(arr)  # 반열린 구간 [left, right)

    while left < right:
        mid = (left + right) // 2
        if arr[mid] == target:
            return mid
        elif arr[mid] < target:
            left = mid + 1
        else:
            right = mid  # exclusive이므로 mid - 1 아님

    return -1  # 없으면 -1


def lower_bound(arr, target):
    # target 이상인 첫 번째 인덱스 (bisect_left 직접 구현)
    left, right = 0, len(arr)
    while left < right:
        mid = (left + right) // 2
        if arr[mid] < target:
            left = mid + 1
        else:
            right = mid
    return left  # arr[left] >= target 인 첫 위치, 없으면 len(arr)

def upper_bound(arr, target):
    # target 초과인 첫 번째 인덱스 (bisect_right 직접 구현)
    left, right = 0, len(arr)
    while left < right:
        mid = (left + right) // 2
        if arr[mid] <= target:
            left = mid + 1
        else:
            right = mid
    return left  # arr[left] > target 인 첫 위치, 없으면 len(arr)


def bisect_examples():
    arr = [1, 3, 5, 7, 9, 11]

    # 1. bisect_left: target 삽입 시 왼쪽 인덱스 (target 이상인 첫 위치)
    idx_left = bisect.bisect_left(arr, 7)   # 3

    # 2. bisect_right: target 삽입 시 오른쪽 인덱스 (target 초과인 첫 위치)
    idx_right = bisect.bisect_right(arr, 7)  # 4

    # 3. 값 존재 여부 확인
    def contains(arr, target):
        i = bisect.bisect_left(arr, target)
        return i < len(arr) and arr[i] == target

    # 4. 범위 내 원소 개수: lo <= x <= hi
    def count_range(arr, lo, hi):
        return bisect.bisect_right(arr, hi) - bisect.bisect_left(arr, lo)

    return {
        "bisect_left(7)": idx_left,
        "bisect_right(7)": idx_right,
        "contains(7)": contains(arr, 7),
        "count_range(3~9)": count_range(arr, 3, 9),  # 4
    }


def parametric_search_example():
    # 파라메트릭 서치: "조건 만족하는 최솟값" 찾기
    # 예) 길이 M개 이상 자를 수 있는 최대 절단 높이
    logs = [4, 8, 6, 9]
    M = 7

    left, right = 0, max(logs)
    result = 0

    while left <= right:
        mid = (left + right) // 2
        total = sum(max(0, l - mid) for l in logs)
        if total >= M:
            result = mid
            left = mid + 1
        else:
            right = mid - 1

    return result  # 4
