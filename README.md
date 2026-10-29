# 📘 Team Project Convention Guide
(Spring Boot + Maven + MyBatis + MySQL)

---

## 📌 1. Git 전략

### ✅ 브랜치 전략

* `main` : 배포용 (항상 안정 상태 유지)
* `develop` : 개발 통합 브랜치
* `feature/{기능명}` : 기능 개발
* `fix/{이슈명}` : 버그 수정

### ✅ 커밋 메시지 규칙

```
feat: 로그인 기능 추가
fix: 회원가입 validation 오류 수정
refactor: service 로직 분리
docs: README 수정
```

### ✅ PR 규칙

* PR 전 `develop` 최신화 필수
* 최소 1명 이상 리뷰 승인 후 merge
* PR 내용에 변경사항 상세 작성

---

## 📌 2. 프로젝트 구조

```
com.project
 ┣ domain
 ┃ ┣ user
 ┃ ┃ ┣ controller
 ┃ ┃ ┣ service
 ┃ ┃ ┣ mapper
 ┃ ┃ ┣ model
 ┣ global
 ┃ ┣ config
 ┃ ┣ exception
 ┃ ┗ common
```

---

## 📌 3. 네이밍 규칙

### ✅ 클래스

* Controller: `UserController`
* Service: `UserService`
* Mapper: `UserMapper`

### ✅ 메서드

'' Mapper, xml
* 조회: `selectUser`, 'selectUserList'
* 등록: `insertUser`
* 수정: `updateUser`
* 삭제: `deleteUser`

'' Service
* 조회: `getUser`, 'getUserList'
* 등록: `addUser`
* 수정: `editUser`
* 삭제: `removeUser`

### ✅ 변수

* camelCase 사용

```java
userName, userId
```

---

## 📌 4. API 설계 규칙

### ✅ URL

```
목록 : /users/list.do, /users/list.dox
조회 : /users/info.do, /users/info.dox
삽입 : /users/add.do, /users/add.dox
삭제 : /users/remove.do, /users/remove.dox
수정 : /users/edit.do, /users/edit.dox
```

### ✅ 응답 형식 통일

```json
{
  "success": true,
  "data": {},
  "message": "요청 성공"
}
```

---

## 📌 5. MyBatis 규칙

### ✅ Mapper 파일 위치

```
resources/mapper/{domain}/{Mapper명}.xml
```

### ✅ SQL 작성 규칙

* 키워드는 대문자
* alias 사용
* 들여쓰기 유지

```sql
SELECT U.ID, U.NAME
FROM TBL_USER U
WHERE U.ID = #{id}
```

### ✅ 파라미터

* `#{}` 사용 (SQL Injection 방지)
* `${}` 사용 금지 (특수한 경우 제외)

---

## 📌 6. MySQL 규칙

### ✅ 테이블 네이밍

* snake_case 사용

```
users
order_items
```

### ✅ 컬럼 네이밍

```
user_id
user_name
```

### ✅ PK 규칙

* `id` (BIGINT, AUTO_INCREMENT)

### ✅ 시간 컬럼

* `cdatetime`
* `udatetime`

---

## 📌 7. DTO / Entity 규칙

### ✅ Entity

* DB 테이블과 1:1 매핑

---

## 📌 9. 로그 규칙

* `System.out.println` 사용 금지
* `log.info()`, `log.error()` 사용

---

## 📌 10. 설정 파일 관리 (application.properties 기준)


### ✅ 민감 정보 관리

* DB 비밀번호, API 키 등은 Git에 절대 포함 금지
* 아래 방법 중 하나 사용

#### 1) 환경 변수 사용

```properties
spring.datasource.password=${DB_PASSWORD}
```

#### 2) 별도 파일 (gitignore 포함)

```properties
application-secret.properties
```

---

### ✅ MyBatis 설정

```properties
mybatis.mapper-locations=classpath:/mapper/**/*.xml
mybatis.type-aliases-package=com.project.domain
```

---

### ✅ 로그 설정

```properties
logging.level.root=info
logging.level.com.project=debug
```

---

### ✅ 파일 작성 규칙

* key는 소문자 + dot(.) 표기법 사용
* 값에 공백 포함 시 주의
* 주석은 `#` 사용

```properties
# 서버 포트 설정
server.port=8080
```

---

## 📌 11. 코드 스타일

### ✅ 공통

* 들여쓰기: 4칸
* 한 줄 최대 120자
* 의미 없는 주석 금지

### ✅ Lombok 사용 권장

---

## 📌 12. 테스트 규칙

* Service / Mapper 최소 단위 테스트 작성
* 테스트 코드도 PR 리뷰 대상

---

## 📌 13. 금지 사항 🚫

* main 브랜치 직접 커밋 금지
* SQL 하드코딩 금지
* 중복 코드 방치 금지
* 무의미한 로그 남기기 금지

---

## 📌 14. 협업 규칙

* 작업 시작 전 이슈 등록
* 하루 1회 이상 Pull
* 충돌 발생 시 반드시 팀원과 공유
* 모르면 혼자 오래 고민하지 말고 질문

---

## 📌 15. 추가 권장 사항

* 코드 리뷰 시 "왜 이렇게 했는지" 설명

---

## 📌 16. DB 변경 관리

* DB 변경은 반드시 문서화
* 변경 SQL 스크립트 공유
* 가능하면 migration 도구 사용 (Flyway 등)

---

## 📌 17. MyBatis 성능/안전 규칙 (중요)

* N+1 쿼리 주의
* 필요 없는 SELECT * 금지
* join 시 필요한 컬럼만 조회

---

## 📌 18. 코드 리뷰 체크리스트 ✅

* [ ] 네이밍 규칙 준수
* [ ] API 규칙 준수
* [ ] SQL 최적화 여부
* [ ] 예외 처리 여부
* [ ] 불필요한 코드 제거

---

💡 **Tip**

> "읽기 쉬운 코드가 좋은 코드다"
> 팀원이 이해 못하면 잘못 작성된 코드이다.
