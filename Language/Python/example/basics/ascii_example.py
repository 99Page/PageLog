def example_ord_basic():
    """문자를 아스키/유니코드 정수로 변환"""
    char = 'A'
    code = ord(char)
    print(f"ord('{char}'): {code}")  # 65

def example_chr_basic():
    """정수를 다시 문자로 변환"""
    code = 97
    char = chr(code)
    print(f"chr({code}): {char}")  # 'a'

def example_char_distance():
    """두 문자 사이의 거리 계산"""
    dist = ord('z') - ord('a')
    print(f"Distance between 'a' and 'z': {dist}")  # 25

def example_alphabet_index():
    """문자를 0~25 사이의 인덱스로 변환 (코테 단골 활용)"""
    char = 'c'
    # 'a'를 0으로 기준 잡기
    index = ord(char) - ord('a')
    print(f"Index of '{char}': {index}")  # 2

def example_caesar_cipher_shift():
    """알파벳 순환 처리 (모듈러 연산 활용)"""
    char = 'z'
    shift = 1
    # 'z'에서 1을 더하면 'a'가 나오도록 처리
    next_char = chr((ord(char) - ord('a') + shift) % 26 + ord('a'))
    print(f"Shift '{char}' by {shift}: {next_char}")  # 'a'

def example_check_digit():
    """문자가 숫자인지 아스키 범위로 확인"""
    char = '5'
    is_digit = ord('0') <= ord(char) <= ord('9')
    print(f"Is '{char}' a digit?: {is_digit}")  # True

# 실행 확인
if __name__ == "__main__":
    example_ord_basic()
    example_chr_basic()
    example_char_distance()
    example_alphabet_index()
    example_caesar_cipher_shift()
    example_check_digit()