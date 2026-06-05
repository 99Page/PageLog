import sys

def union_find():
    parent = [] 
    rank = [] 

    def union(a, b):
        a_parent = parent[a]
        b_parent = parent[b] 

        if a_parent != b_parent: 
            if rank[a] < rank[b]: 
                rank[a] += 1 
                parent[b] = a_parent 
            

    def 

solution()
