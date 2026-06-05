# Sort
# lambda로 정렬 기준 지정.


def get_sorted_by_second(items):
    return sorted(items, key=lambda x: x[1])


def get_sorted_by_second_desc(items):
    return sorted(items, key=lambda x: x[1], reverse=True)


def get_sorted_by_two_keys(items):
    return sorted(items, key=lambda x: (x[1], x[0]))


def get_sorted_by_length(words):
    return sorted(words, key=lambda word: len(word))


def sort_in_place(items):
    items.sort(key=lambda x: x[1])
    return items


scores = [
    ("kim", 80),
    ("lee", 90),
    ("park", 80),
]

words = ["banana", "kiwi", "apple"]

by_score = get_sorted_by_second(scores)
# 결과: [('kim', 80), ('park', 80), ('lee', 90)]

by_score_desc = get_sorted_by_second_desc(scores)
# 결과: [('lee', 90), ('kim', 80), ('park', 80)]

by_score_name = get_sorted_by_two_keys(scores)
# 결과: [('kim', 80), ('park', 80), ('lee', 90)]

by_length = get_sorted_by_length(words)
# 결과: ['kiwi', 'apple', 'banana']

in_place = sort_in_place(scores[:])
# 결과: [('kim', 80), ('park', 80), ('lee', 90)]

print(f"두 번째 값 정렬: {by_score}")
print(f"두 번째 값 내림차순: {by_score_desc}")
print(f"점수, 이름 정렬: {by_score_name}")
print(f"길이 정렬: {by_length}")
print(f"원본 변경 정렬: {in_place}")
