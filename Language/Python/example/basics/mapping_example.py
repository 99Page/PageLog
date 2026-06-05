# Mapping
# 값을 다른 값으로 변환할 때 사용.


def get_map_to_int(values):
    return list(map(int, values))


def get_map_with_lambda(numbers):
    return list(map(lambda n: n * 2, numbers))


def get_map_with_function(words):
    return list(map(len, words))


def get_dict_mapping(grades):
    grade_score = {
        "A": 4,
        "B": 3,
        "C": 2,
        "D": 1,
        "F": 0,
    }

    return [grade_score[grade] for grade in grades]


def get_safe_dict_mapping(grades):
    grade_score = {
        "A": 4,
        "B": 3,
        "C": 2,
    }

    return [grade_score.get(grade, 0) for grade in grades]


values = ["1", "2", "3"]
numbers = [1, 2, 3]
words = ["apple", "banana", "kiwi"]
grades = ["A", "C", "F"]
unknown_grades = ["A", "B", "Z"]

int_values = get_map_to_int(values)
# 결과: [1, 2, 3]

doubled = get_map_with_lambda(numbers)
# 결과: [2, 4, 6]

word_lengths = get_map_with_function(words)
# 결과: [5, 6, 4]

scores = get_dict_mapping(grades)
# 결과: [4, 2, 0]

safe_scores = get_safe_dict_mapping(unknown_grades)
# 결과: [4, 3, 0]

print(f"문자열 -> 숫자: {int_values}")
print(f"lambda 변환: {doubled}")
print(f"함수 변환: {word_lengths}")
print(f"딕셔너리 매핑: {scores}")
print(f"안전한 딕셔너리 매핑: {safe_scores}")
