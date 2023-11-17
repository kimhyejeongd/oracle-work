
--1.3의 권한 부여전에는 실행하면 오류, 권한붕여 후에는 생성 가능
CREATE TABLE TEST (
  ID VARCHAR(30),
  NAME VARCHAR2(20)
  );

--1.4의 권한 부여 전과 후 비교
INSERT INTO TEST VALUES('user01','홍길동');

--------------------------------------------------------------------------------
--2.1의 권한 부여 전과 후 비교
SELECT *AIE.EMPLOYEE;

--2.2의 권한 부여 후
SELECT*FROM AIE.DEPARTMENT;
INSERT INTO AIE.DEPARTMENT VALUES('D0','관리부','L2');

SELECT*FROM AIE.DEPARTMENT;
COMMIT