-- 한줄 주석 (ctrl+/)
/*
여러줄 주석
alt + shift + c

*/
-- 커서가 깜빡거릴 때 ctrl + enter : 그 줄 실행
-- 나의 계정 보기
show user;

-- 사용자 계정 조회
select*from DBA_USERS;

-- 계정 만들기
--create user 사용자명 identified by 비밀번호;
-- 오라클 12버전 부터 일반사용자는 c##을 붙여 이름을 작명한다
--  오류 : CREATE user user1 identified by 1234;
create user c##user1 identified by user1234;
create user c##user2 identified by user2;

-- 사용자 이름에 c##을 붙이는 것을 회피하는 방법
ALTER SESSION set"_oracle_script" = true;
create user user3 identified by user3;

-- 사용자 이름은 대소문자를 가리지 안는다
-- 실제 사용할 계정 생성
create user aie identified by aie;

--권한 생성
--[표현법]grant 권한1,권한2,...to 계정명;
grant RESOURSE,CONNET to aie;

--테이블스페이스에 얼마만큼의 영역을 할당할 것인지를 부여
alter user aie default TABLESPACE users quota UNLIMITED on users;

--테이블스페이스에 영역을 특정 용량만큼 할당하려면
alter user user3 quota 30M on users;

--user 삭제
--[표현법] drop user 사용자명; => 태아불아 없는 상태
--[표현법] drop user 사용자명 cascade; => 테이블이 있을 때
drop user user c##user1;





