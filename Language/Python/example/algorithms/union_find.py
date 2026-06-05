class UnionFind:
    def __init__(self, n):
        self.parent = list(range(n)) # [0, 1, 2, 3 ... n]
        self.rank = [0] * n

    def find(self, x):
        if self.parent[x] != x:
            # 경로 압축 (Path Compression)
            self.parent[x] = self.find(self.parent[x])
        return self.parent[x]

    def union(self, x, y):
        rootX = self.find(x)
        rootY = self.find(y)

        if rootX != rootY:
            # 랭크 기반 합치기 (Union by Rank / Load Balancing)
            if self.rank[rootX] > self.rank[rootY]:
                self.parent[rootY] = rootX
            elif self.rank[rootX] < self.rank[rootY]:
                self.parent[rootX] = rootY
            else:
                self.parent[rootY] = rootX
                self.rank[rootX] += 1
            return True
        return False

# 사용 예시
n = 5
uf = UnionFind(n)

uf.union(0, 2)
uf.union(4, 2)
uf.union(3, 1)

print(f"0과 4는 연결되어 있나요? {uf.find(0) == uf.find(4)}") # True
print(f"0과 1은 연결되어 있나요? {uf.find(0) == uf.find(1)}") # False