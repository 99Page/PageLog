from collections import defaultdict

def basic_operations():
    user = {"name": "Alice", "level": 10}
    
    # 추가 및 수정
    user["gold"] = 500
    user["level"] = 11
    
    if "gold" in user:
        user.pop("gold")
        
    print(f"Basic: {user}")

def safe_access():
    inventory = {"apple": 3, "banana": 5}
    
    # 키가 없을 때를 대비한 기본값 설정
    grape_count = inventory.get("grape", 0)
    apple_count = inventory.get("apple", 0)
    
    print(f"Safe Access: Apple({apple_count}), Grape({grape_count})")

# 반복문을 이용한 탐색
def dictionary_loops():
    scores = {"Math": 90, "English": 85}
    
    print("Loops:")
    for subject, score in scores.items():
        print(f" - {subject}: {score}")

# 딕셔너리 컴프리헨션
def dict_comprehension():
    # 리스트를 딕셔너리로 변환 (숫자: 제곱값)
    squares = {x: x**2 for x in range(1, 4)}
    print(f"Comprehension: {squares}")

# 코딩 테스트 필수 스킬 (defaultdict)
def counting_with_defaultdict():
    words = ["apple", "banana", "apple", "cherry"]
    word_count = defaultdict(int) # 기본값을 0으로 설정
    
    for word in words:
        word_count[word] += 1
        
    print(f"Counting: {dict(word_count)}")

if __name__ == "__main__":
    basic_operations()
    safe_access()
    dictionary_loops()
    dict_comprehension()
    counting_with_defaultdict()