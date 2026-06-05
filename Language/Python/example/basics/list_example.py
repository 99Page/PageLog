def example_slicing_basic():
    """기본 슬라이싱: 시작과 끝 지정"""
    text = "Hello World"
    # [시작:끝] -> '끝' 인덱스는 미포함. (5-0=5이므로 앞의 5글자 추출)
    result = text[0:5]
    print(f"Basic: {result}")

def example_negative_slicing():
    """음수 인덱스: 뒤에서부터 추출"""
    text = "Hello World"
    # [-5:] -> 뒤에서 5번째부터 끝까지. (빈칸은 '끝까지'를 의미)
    result = text[-5:]
    print(f"Negative: {result}")

def example_step_slicing():
    """단계 설정: 간격 조절 및 뒤집기"""
    text = "ABCDEFG"
    # [::2] -> 처음부터 끝까지 2칸 간격으로 (A, C, E, G)
    step = text[::2]
    # [::-1] -> step이 음수면 역방향. 빈칸은 '끝에서 끝까지'를 의미하므로 뒤집기
    reverse = text[::-1]
    # [::-2] -> 역순으로 2칸씩 건너뛰기 (G, E, C, A)
    reverse_step = text[::-2]
    print(f"Step: {step}, Reverse: {reverse}, RevStep: {reverse_step}")

def example_list_remove_back():
    """리스트 뒷부분 다루기"""
    arr = [1, 2, 3, 4, 5, 6, 7, 8]
    
    # 1. 뒤에서 4개를 제외한 나머지 추출 (복사본 생성, O(n))
    remained = arr[:-4]
    
    # 2. 뒤에서 4개만 따로 추출
    last_four = arr[-4:]
    
    # 3. 원본 리스트에서 뒤에서 4개 삭제
    # 리스트 슬라이싱(arr[-4:])은 O(N) 사용 
    # del은 O(1)
    del arr[-4:]
    
    print(f"Remained: {remained}, Last 4: {last_four}, After Del: {arr}")

def example_list_comprehension():
    numbers = [1, 2, 3, 4, 5, 6, 7, 8]
    squared = [x**2 for x in numbers]
    even_squared = [x**2 for x in numbers if x % 2 == 0]
    print(f"Squared: {squared}, Even Squared: {even_squared}")

if __name__ == "__main__":
    example_slicing_basic()
    example_negative_slicing()
    example_step_slicing()
    example_list_remove_back()
    example_list_comprehension()