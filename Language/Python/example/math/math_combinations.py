from itertools import combinations, permutations, combinations_with_replacement, product

items = ['A', 'B', 'C']
r = 2

# 1. 조합 (Combinations)
# 순서 상관 없음, 중복 허용 안 함
comb = list(combinations(items, r))
# 결과: [('A', 'B'), ('A', 'C'), ('B', 'C')]

# 2. 순열 (Permutations)
# 순서 상관 있음 (A, B와 B, A는 다름), 중복 허용 안 함
perm = list(permutations(items, r))
# 결과: [('A', 'B'), ('A', 'C'), ('B', 'A'), ('B', 'C'), ('C', 'A'), ('C', 'B')]

# 3. 중복 조합 (Combinations with replacement)
# 순서 상관 없음, 같은 요소 중복 선택 가능
comb_res = list(combinations_with_replacement(items, r))
# 결과: [('A', 'A'), ('A', 'B'), ('A', 'C'), ('B', 'B'), ('B', 'C'), ('C', 'C')]

# 4. 중복 순열 (Product)
# 순서 상관 있음, 같은 요소 중복 선택 가능
# product는 repeat 인자로 뽑을 개수를 정함
prod = list(product(items, repeat=r))
# 결과: [('A', 'A'), ('A', 'B'), ('A', 'C'), ('B', 'A'), ('B', 'B'), ('B', 'C'), ('C', 'A'), ('C', 'B'), ('C', 'C')]

# --- 출력 확인용 ---
print(f"조합: {comb}")
print(f"순열: {perm}")
print(f"중복 조합: {comb_res}")
print(f"중복 순열: {prod}")