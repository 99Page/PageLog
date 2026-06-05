# List_Comprehension
# 리스트를 사용해서 리스트를 생성할 때 생성합니다. 


def get_basic_comprehension(numbers):
    # 1. 기본 형태 (Basic)
    return [n * 2 for n in numbers]

def get_condition_comprehension(numbers):
    # 2. 조건문 포함 (Conditionals)
    return [n for n in numbers if n % 2 == 0]

def get_if_else_comprehension(numbers):
    # 3. 다중 조건 (If-Else)
    return ["Even" if n % 2 == 0 else "Odd" for n in numbers]

def get_nested_loop_comprehension(matrix):
    # 4. 이중 for문 (Nested Loops) - 2차원을 1차원으로
    return [num for row in matrix for num in row]

def get_2d_array_comprehension(rows, cols):
    # 5. 2차원 배열 생성 (2D Array)
    return [[0 for _ in range(cols)] for _ in range(rows)]

def get_zip_comprehension(list1, list2):
    # 6. zip 사용 (Zip Combination)
    return [a + b for a, b in zip(list1, list2)]

numbers = [1, 2, 3, 4, 5]
matrix = [[1, 2], [3, 4]]
list1 = [10, 20, 30]
list2 = [1, 2, 3]

basic = get_basic_comprehension(numbers)
# 결과: [2, 4, 6, 8, 10]

condition = get_condition_comprehension(numbers)
# 결과: [2, 4]

if_else = get_if_else_comprehension(numbers)
# 결과: ['Odd', 'Even', 'Odd', 'Even', 'Odd']

nested = get_nested_loop_comprehension(matrix)
# 결과: [1, 2, 3, 4]

two_d_array = get_2d_array_comprehension(3, 3)
# 결과: [[0, 0, 0], [0, 0, 0], [0, 0, 0]]

zip_comp = get_zip_comprehension(list1, list2)
# 결과: [11, 22, 33]

# --- 출력 확인용 ---
print(f"기본 형태: {basic}")
print(f"조건문 포함: {condition}")
print(f"다중 조건: {if_else}")
print(f"이중 for문: {nested}")
print(f"2차원 배열 생성: {two_d_array}")
print(f"zip 사용: {zip_comp}"