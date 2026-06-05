import heapq

def manage_min_heap():
    min_heap = []
    
    # 1. 원소 추가 (push)
    heapq.heappush(min_heap, 10)
    heapq.heappush(min_heap, 2)
    heapq.heappush(min_heap, 5)
    
    # 2. 최솟값 확인 (삭제 없이 조회만)
    smallest = min_heap[0] 
    
    # 3. 최솟값 삭제 및 반환 (pop)
    popped_value = heapq.heappop(min_heap) # 2 반환
    
    # 4. 기존 리스트를 힙으로 변환 (heapify)
    data = [4, 1, 7, 3, 8, 5]
    heapq.heapify(data) # 별도 반환값 없이 data 리스트 자체를 힙 구조로 재배치
    
    return min_heap, data