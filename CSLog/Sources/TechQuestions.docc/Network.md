# Network

네트워크 관련 내용을 정리한 문서

## TCP, UDP

||TCP|UDP|
|---|---|---|
|연결 방식|연결 지향|비연결|
|순서 보장|O|X|
|속도|느림|빠름|
|용도|이메일, 웹 등|실시간 스트리밍, VoIP|

## 3-way handshake

1. [SYN] 클라이언트 -> 서버: 통신 시작 알림
2. [SYN+ACK] 서버 -> 클라이언트: 통신 가능함을 알림
3. [ACK] 클라이언트 -> 서버: 확인

## Restful API

HTTP 프로토콜을 기반으로 자원을 URI로 표현하고, HTTP 메서드로 행위(요청)를 표현함
즉, 리소스 지향적이고, 표준적인 HTTP 메서드(GET, POST 등)를 사용하는 API를 말함


## TCP/IP 5계층 

1.    물리 계층 (Physical Layer)
•    전기 신호, 광 신호, 무선 신호 등 비트 전송 담당
•    하드웨어 장치: 케이블, 리피터, 허브
2.    데이터 링크 계층 (Data Link Layer)
•    같은 네트워크 내에서 프레임 단위 전송
•    오류 검출, 흐름 제어, MAC 주소 기반 통신
•    장치: 스위치, 브리지
•    프로토콜: Ethernet, ARP
3.    네트워크 계층 (Network Layer)
•    다른 네트워크 간 패킷 전달 & 라우팅
•    논리 주소(IP) 사용
•    장치: 라우터
•    프로토콜: IP, ICMP
4.    전송 계층 (Transport Layer)
•    프로세스 간 종단 간(end-to-end) 통신 보장
•    신뢰성, 흐름 제어, 오류 제어
•    프로토콜: TCP, UDP
5.    응용 계층 (Application Layer)
•    사용자가 직접 접하는 서비스
•    프로토콜: HTTP, FTP, SMTP, DNS
