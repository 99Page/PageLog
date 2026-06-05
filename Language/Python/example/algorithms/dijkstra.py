import heapq
import math
import sys

# 입력 형식:
# 첫 줄: 노드 수(V) 간선 수(E)
# 둘째 줄: 시작 노드
# 이후 E줄: 출발 도착 가중치

def solution():
    graph_meta = sys.stdin.readline().split()
    node_count = int(graph_meta[0])
    edge_count = int(graph_meta[1])

    start_node = int(sys.stdin.readline())
    graph = [[] for _ in range(node_count + 1)]

    for _ in range(edge_count):
        edge_input = sys.stdin.readline().split()
        start = int(edge_input[0])
        dest = int(edge_input[1])
        weight = int(edge_input[2])
        graph[start].append((weight, dest))

    def dijkstra():
        min_distance = {x: math.inf for x in range(1, node_count + 1)}
        min_distance[start_node] = 0
        heap = []
        heapq.heappush(heap, (0, start_node))  # (거리, 노드)

        while heap:
            weight, cur = heapq.heappop(heap)

            if weight > min_distance[cur]:  # 이미 더 짧은 경로로 처리된 노드 스킵
                continue

            for (w, n) in graph[cur]:
                new_dist = weight + w
                if new_dist < min_distance[n]:
                    min_distance[n] = new_dist
                    heapq.heappush(heap, (new_dist, n))

        return min_distance

    min_dist = dijkstra()

    for i in range(1, node_count + 1):
        x = min_dist[i]
        print("INF" if x == math.inf else x)

solution()
