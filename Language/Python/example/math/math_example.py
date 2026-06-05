import math

# 1. 최대공약수 (Greatest Common Divisor)
# 두 수의 공통된 약수 중 가장 큰 값
def get_gcd(a, b):
    gcd_val = math.gcd(a, b)
    # 결과: 6 (a=12, b=18 일 때)
    return gcd_val

# 2. 최소공배수 (Least Common Multiple)
# 두 수의 공통된 배수 중 가장 작은 값
def get_lcm(a, b):
    lcm_val = math.lcm(a, b)
    # 결과: 36 (a=12, b=18 일 때)
    return lcm_val

# 3. 팩토리얼 (Factorial)
# 1부터 n까지의 정수를 모두 곱한 값 (n!)
def get_factorial(n):
    fact_val = math.factorial(n)
    # 결과: 120 (n=5 일 때)
    return fact_val

# 4. 정수 제곱근 (Integer Square Root)
# 주어진 수의 제곱근을 내림한 정수 반환
def get_isqrt(m):
    isqrt_val = math.isqrt(m)
    # 결과: 3 (m=10 일 때)
    return isqrt_val

# --- 출력 확인용 ---
print(f"최대공약수: {get_gcd(12, 18)}")
print(f"최소공배수: {get_lcm(12, 18)}")
print(f"팩토리얼: {get_factorial(5)}")
print(f"정수 제곱근: {get_isqrt(10)}")