# TIL-Test

## 테스트에 대한 생각

유닛 테스트, UI 테스트 중요한건 맞으나 최종적으로는 프로젝트에서 잘 되는지 확인해야한다.
코드로 하는 테스트는 그 상황이 정말 의미가 있고 이후 개발을 단축 시킬 수 있을 때 하는 것이 맞다. 

## POSTMAN 

실제 프로젝트에서 확인할 때는 내가 원하는 데이터를 직접 만들어 보기가 어렵다. 이럴 때 POSTMAN Scripts 잘 사용하자.


![postman-script](postman-script)

``` javascript
let counter = pm.environment.get("botCount");

if (!counter) {
    counter = 1;
} else {
    counter = parseInt(counter) + 1;
}

pm.environment.set("botCount", counter.toString());
```

이렇게 사용하면 된다!

## Topics

### <!--@START_MENU_TOKEN@-->Group<!--@END_MENU_TOKEN@-->

- <!--@START_MENU_TOKEN@-->``Symbol``<!--@END_MENU_TOKEN@-->
