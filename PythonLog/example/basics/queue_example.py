from collections import deque

def example_append():
    """오른쪽 끝에 요소 추가"""
    dq = deque([1, 2])
    dq.append(3)
    print(f"append: {dq}")  # deque([1, 2, 3])

def example_appendleft():
    """왼쪽 앞 부분에 요소 추가"""
    dq = deque([1, 2])
    dq.appendleft(0)
    print(f"appendleft: {dq}")  # deque([0, 1, 2])

def example_pop():
    """오른쪽 끝 요소 제거 및 반환"""
    dq = deque([1, 2, 3])
    item = dq.pop()
    print(f"pop: {item}, 남은 결과: {dq}")  # 3, deque([1, 2])

def example_popleft():
    """왼쪽 앞 요소 제거 및 반환"""
    dq = deque([1, 2, 3])
    item = dq.popleft()
    print(f"popleft: {item}, 남은 결과: {dq}")  # 1, deque([2, 3])

def example_extend():
    """오른쪽 끝에 반복 가능한 객체(리스트 등)를 연장"""
    dq = deque([1, 2])
    dq.extend([3, 4])
    print(f"extend: {dq}")  # deque([1, 2, 3, 4])

def example_extendleft():
    """왼쪽 앞에 반복 가능한 객체를 연장 (순서 주의)"""
    dq = deque([1, 2])
    dq.extendleft([-1, 0])
    print(f"extendleft: {dq}")  # deque([0, -1, 1, 2])

def example_rotate():
    """요소들을 지정한 수만큼 회전 (양수: 오른쪽, 음수: 왼쪽)"""
    dq = deque([1, 2, 3, 4, 5])
    dq.rotate(2)
    print(f"rotate(2): {dq}")  # deque([4, 5, 1, 2, 3])
    dq.rotate(-1)
    print(f"rotate(-1): {dq}")  # deque([5, 1, 2, 3, 4])

def example_peek():
    """제거 없이 앞/뒤 요소 확인"""
    dq = deque([1, 2, 3])
    front = dq[0]   # 제일 앞
    back = dq[-1]   # 제일 뒤
    print(f"front: {front}, back: {back}")  # 1, 3

def example_maxlen():
    """최대 길이를 제한 (초과 시 오래된 요소 자동 삭제)"""
    dq = deque(maxlen=3)
    dq.extend([1, 2, 3])
    dq.append(4)  # 1이 삭제됨
    print(f"maxlen(3) after append(4): {dq}")  # deque([2, 3, 4], maxlen=3)

# 실행 확인
if __name__ == "__main__":
    example_append()
    example_appendleft()
    example_pop()
    example_popleft()
    example_extend()
    example_extendleft()
    example_rotate()
    example_peek()
    example_maxlen()