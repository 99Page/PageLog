def example_slicing_basic():
    """기본 슬라이싱: 시작과 끝 지정"""
    text = "Hello World"
    # 'Hello'만 추출 (0~4번 인덱스)
    result = text[0:5]
    print(f"Basic: {result}")

def example_negative_slicing():
    """음수 인덱스: 뒤에서부터 추출"""
    text = "Hello World"
    # 뒤에서 5글자 'World' 추출
    result = text[-5:]
    print(f"Negative: {result}")

def example_step_slicing():
    """단계 설정: 간격 조절 및 뒤집기"""
    text = "ABCDEFG"
    # 한 칸씩 건너뛰기
    step = text[::2]
    # 문자열 뒤집기
    reverse = text[::-1]
    print(f"Step: {step}, Reverse: {reverse}")

def example_omit_indices():
    text = "Hello World"
    prefix = text[:5]
    suffix = text[6:]
    print(f"Prefix: {prefix}, Suffix: {suffix}")

def example_negative_step():
    text = "ABCDEFG"
    partial_reverse = text[5:1:-1]
    print(f"Partial Reverse: {partial_reverse}")

def example_list_slicing_and_modification():
    arr = [1, 2, 3, 4, 5]
    sub_arr = arr[1:4]
    arr[1:3] = [8, 9]
    print(f"Sub Array: {sub_arr}, Modified: {arr}")

def example_string_lower_upper():
    text = "Hello World"
    lower_s = text.lower()
    upper_s = text.upper()
    print(f"Lower: {lower_s}, Upper: {upper_s}")

def example_string_capitalize_title():
    text = "hello world"
    capitalize_s = text.capitalize()
    title_s = text.title()
    print(f"Capitalize: {capitalize_s}, Title: {title_s}")

if __name__ == "__main__":
    example_slicing_basic()
    example_negative_slicing()
    example_step_slicing()
    example_omit_indices()
    example_negative_step()
    example_list_slicing_and_modification()
    example_string_lower_upper()
    example_string_capitalize_title()