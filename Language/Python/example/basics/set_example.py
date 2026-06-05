def remove_elements_examples():
    s = {1, 2, 3, 4, 5}
    
    # 요소가 확실히 있을 때 삭제
    s.remove(3)
    
    # 요소 존재 여부가 불확실할 때 안전하게 삭제
    s.discard(10)
    
    # 임의의 요소 하나를 꺼내기
    item = s.pop()
    
    # 전체 비우기
    s.clear()

def set_methods_examples():
    a = {1, 2, 3}
    b = {3, 4, 5}
    c = [5, 6, 7] # 리스트 형태
    
    # 1. 합집합 (Union)
    # 연산자 a | b | set(c)와 동일
    union_res = a.union(b, c)
    
    # 2. 교집합 (Intersection)
    # 연산자 a & b와 동일
    inter_res = a.intersection(b)
    
    # 3. 차집합 (Difference)
    # 연산자 a - b와 동일
    diff_res = a.difference(b)
    
    # 4. 대칭 차집합 (Symmetric Difference)
    # 연산자 a ^ b와 동일
    sym_diff_res = a.symmetric_difference(b)

def set_update_methods_examples():
    a = {1, 2}
    b = {2, 3}
    
    # 결과를 반환하는 게 아니라 a 자체를 수정 (In-place)
    
    # a에 b를 합침
    a.update(b)
    
    # a에서 b와 겹치는 것만 남김
    a.intersection_update({3, 4})
    
    # a에서 b에 포함된 요소를 제거
    a.difference_update({3})

def set_membership_examples():
    s = {"apple", "banana", "cherry"}
    
    # 존재 확인
    is_exists = "apple" in s
    
    # 존재하지 않음 확인
    is_not_exists = "orange" not in s

def set_comparison_examples():
    set_small = {1, 2}
    set_big = {1, 2, 3, 4}
    
    # 부분 집합 여부
    is_subset = set_small.issubset(set_big)
    
    # 상위 집합 여부
    is_superset = set_big.issuperset(set_small)
    
    # 서로소 여부 (겹치는 게 없는지)
    is_disjoint = set_small.isdisjoint({5, 6})