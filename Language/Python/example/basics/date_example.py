from datetime import datetime, timedelta

# 1. 현재 날짜 및 시간 가져오기
# 시스템의 현재 로컬 날짜와 시간을 반환
def get_current_datetime():
    now = datetime.now()
    # 결과: 2026-02-23 13:17:40.123456 (실행 시점에 따라 다름)
    return now

# 2. 특정 날짜 및 시간 생성하기
# 연, 월, 일, 시, 분, 초를 지정하여 datetime 객체 생성
def create_specific_datetime(year, month, day, hour=0, minute=0):
    specific_dt = datetime(year, month, day, hour, minute)
    # 결과: 2025-12-25 10:30:00 (year=2025, month=12, day=25, hour=10, minute=30 일 때)
    return specific_dt

# 3. 날짜 더하기 (timedelta)
# 특정 날짜에 일(days), 시간(hours), 분(minutes) 등을 더함
def add_timedelta(base_date, days_to_add):
    future_date = base_date + timedelta(days=days_to_add)
    # 결과: base_date로부터 days_to_add일 후의 날짜
    return future_date

# 4. 두 날짜의 차이 계산하기
# 두 datetime 객체를 빼서 시간 차이(timedelta)를 구함
def get_date_difference(date1, date2):
    diff = date1 - date2
    # 결과: 두 날짜 사이의 일(days) 수
    return diff.days

from datetime import datetime

def get_all_datetime_elements(dt):
    return {
        "year": dt.year,
        "month": dt.month,
        "day": dt.day,
        "hour": dt.hour,
        "minute": dt.minute,
        "second": dt.second,
        "microsecond": dt.microsecond,
        "weekday_index": dt.weekday(),
        "isoweekday_index": dt.isoweekday(),
        "weekday_name": dt.strftime("%A")
    }

now = datetime.now()
elements = get_all_datetime_elements(now)

for key, value in elements.items():
    print(f"{key}: {value}")

# --- 출력 확인용 ---
current = get_current_datetime()
specific = create_specific_datetime(2025, 12, 25, 10, 30)
added_date = add_timedelta(current, 100)
diff_days = get_date_difference(current, specific)

print(f"현재 날짜 및 시간: {current}")
print(f"특정 날짜 및 시간: {specific}")
print(f"100일 후 날짜: {added_date}")
print(f"두 날짜의 차이(일): {diff_days}")