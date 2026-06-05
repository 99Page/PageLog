def example_basic():
    """기본 삼항연산자: 조건에 따라 값 선택"""
    x = 10
    result = "양수" if x > 0 else "음수 또는 0"
    print(f"Basic: {result}")

def example_assignment():
    """변수 할당에 활용"""
    score = 75
    grade = "합격" if score >= 60 else "불합격"
    print(f"Grade: {grade}")

def example_in_expression():
    """표현식 내부에서 활용 (출력, 리턴 등)"""
    nums = [1, -2, 3, -4, 5]
    abs_nums = [n if n >= 0 else -n for n in nums]
    print(f"Absolute: {abs_nums}")

def example_nested():
    """중첩 삼항연산자: 3가지 분기"""
    score = 85
    grade = "A" if score >= 90 else "B" if score >= 80 else "C"
    print(f"Nested: {grade}")

def example_with_function():
    """함수 반환값에 활용"""
    def get_max(a, b):
        return a if a > b else b

    print(f"Max: {get_max(3, 7)}")

if __name__ == "__main__":
    example_basic()
    example_assignment()
    example_in_expression()
    example_nested()
    example_with_function()
