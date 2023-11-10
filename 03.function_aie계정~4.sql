/*
<함수>
전달된 컬럼값을 읽어들여 함수를 실행한 결과 반환

-단일행 함수 :n개의 값을 읽어서 n개의 결과값을 반환(매 행마다 함수 실행)
-그룹 함수:n개의 값을 읽어들여 1개의 결과값을 반환(그룹별로 함수 실행)

>>select절에 단일행 함수과 그룹함수를 함께 사용할수 없음
>>함수식을 기술할 수 있는 위치 : SELECT절,WHERE절,ORDER BY절,HAVING절
*/
------------------------------단일 행 함수-------------------------------
--=====================================================================
--                            <문자 처리 함수>
--=====================================================================
/*
LENGTH/LENGTHB => NUMBER로 반환

LENGTH(컬럼|'문자열') : 해당 문자열의 글자수 반환
LNEGTHB(컬럼|'문자열') : 해당 문자열의 BYTE수 반환
  -한글:XE버전일 때=>1글자당 3byte(김,ㄱㄷㅏ 등도 1글자에 해당)
       EE버전일 때 =>1글자당 2byte 
  -그외 : 1글자당 1byte
  
*/

SELECT LENGTH('오라클'),LENGTHB('오라클')
FROM DUAL;  --오라클에서 제공하는 가상테이블

SELECT LENGTH('oracle'),LENGTHB('oracle')
FROM DUAL;

SELECT LENGTH('ㅇㅗㄹㅏ')||'글자',LENGTHB('ㅇㅗㄹㅏ')||'byte'
FROM DUAL;

SELECT EMP_NAME,LENGTH(EMP_NAME)||'글자',LENGTHB(EMP_NAME)||'BYTE',EMAIL,LENGTH(EMAIL)||'글자',LENGTHB(EMAIL)||'BYTE'
FROM EMPLOYEE;

------------------------------------------------------------------------------------
/*
INSTR : 문자열로부터 특정 문자의 시작위치(INDEX를 찾아서 반환(반환형:NUMBER)
-ORACLE에서 INDEX번호는 1부터시작.찾는 문자가 없으면 0반환
INSTR(컬럼|'문자열','찾을 문자열',[찾을위치의 시작값,[순번])

찾을위치의 시작값
1:앞에서부터 찾기(기본값)
-1:뒤에서부터 찾기

*/
SELECT INSTR('JAVASCRIPTJAVAORACLE','A') --  결과 2
FROM DUAL;
SELECT INSTR('JAVASCRIPTJAVAORACLE','A',1) --  결과 2
FROM DUAL;
SELECT INSTR('JAVASCRIPTJAVAORACLE','A',-1) FROM DUAL; --결과 17
SELECT INSTR('JAVASCRIPTJAVAORACLE','A',1,3) FROM DUAL;--결과 12
SELECT INSTR('JAVASCRIPTJAVAORACLE','A',-1,2) FROM DUAL;--결과14

SELECT EMAIL,INSTR(EMAIL,'_')"_위치",INSTR(EMAIL,'@')"@위치"
FROM EMPLOYEE;

--------------------------------------------------------------------
/*
SUBSTR : 문자열에서 특정 문자열을 추출하여 반환(CHARACTER)

SUBSTR('문자열',POSITION, [LENGTH])
-POSITION : 문자열 추출할 시작위치 INDEX
-LENGTH : 추출할 문자 개수 (생략시 맨마지막까지 추출)

*/
SELECT SUBSTR('ORACLEHTMLCSS',7)FROM DUAL;  --결과 : HTMLCSS
SELECT SUBSTR('ORACLEHTMLCSS',7,4)FROM DUAL; -- 결과 : HTML
SELECT SUBSTR('ORACLEHTMLCSS',1,6)FROM DUAL; -- 결과 : ORACLE
SELECT SUBSTR('ORACLEHTMLCSS',-7,4)FROM DUAL; -- 결과 : HTML(INDE가 음수이면 뒤부터 센다)

-- 주민번호에서 성별만 추출하여 주민번호,사원명,성별을 조회
SELECT EMP_NO,EMP_NAME,SUBSTR(EMP_NO,8,1)성별
FROM EMPLOYEE;

--여자사원들만 사번,사원명,성별을 조회
SELECT EMP_ID,EMP_NAME,SUBSTR(EMP_NO,8,1) 성별
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8,1) ='2' OR SUBSTR(EMP_NO,8,1)='4';

--남자사원들만 사원,사원명,성별을 조회
SELECT EMP_ID,EMP_NAME,SUBSTR(EMP_NO,8,1) 성별
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8,1)IN(1,3);

--사원명, 이메일, 아이디(@표시 앞까지만)조회
SELECT EMP_NAME,EMAIL,SUBSTR(EMAIL,1,INSTR(EMAIL,'@')-1) 아이디
FROM EMPLOYEE;

----------------------------------------------
/*
LPAD/RPAD : 문자열을 조회할 때 통일감있게 조회하고자 할 때(CHARACTER:반환형)

LPAD/RPAD : ('문자열',최종적으로 반환할 문자의 길이,[덧붙이고자하는 문자])
문자열에 덧붙이고자하는 문자를 왼쪽 혹은 오른쪽에 덧붙여서 최종 길이만큼의 문자열 반환

*/
--EMAIL을 20길이로 오른쪽정렬로 출력(왼쪽으로 공백으로 채워서 출력)
SELECT EMP_NAME,LPAD(EMAIL,20,'#')
FROM EMPLOYEE;

SELECT EMP_NAME,RPAD(EMAIL,20,'#')
FROM EMPLOYEE;

--사번,사원명,주민번호출력 (12345-1****** 의 형식으로) 
SELECT EMP_ID,EMP_NAME,RPAD(SUBSTR(EMP_NO,1,8),14,'*')
FROM EMPLOYEE;
--------------------------------------------------------------
/*
LTRIM/RTRIM : 문자열에서 특정 문자를 제거한 나머지 문자 반환(CHARACTER : 반환형)
TRIM : 문자열의 앞/뒤 양쪽에 있는 지정한 문자를 제거한 나머지 문자 반환

[표현법]
LTRIM/RTRIM('문자열',[제거하고자하는 문자열])
TRIM([LEADING|TRAILING|BOTH]제거하고자하는 문자열 FROM '문자열'

*/
SELECT LTRIM('     AI  E     ')||'애드인애듀'FROM DUAL; --제거하고자하는 문자열 생략시 기본값 공백
SELECT LTRIM('JAVASCRIPTSPRING','JAVA')FROM DUAL;
SELECT LTRIM('BCABACBDEFGABC','ABC')FROM DUAL;
SELECT RTRIM('9875468786KKON654984','123456789')FROM DUAL;
SELECT RTRIM('7895465KLI8498498','123456789')FROM DUAL;

SELECT TRIM('     AI  E     ')||'애드인애듀'FROM DUAL; -- TRIM은 양쪽모두 제거
SELECT TRIM('A' FROM'AAAAABDKD342AAAA')FROM DUAL;

--LEDING : 앞의 문자 제거
SELECT TRIM(LEADING'A'FROM'AAAAKDJDIAAAA')FROM DUAL;
--TRAILING : 뒤의 문자 제거
SELECT TRIM(TRAILING'A'FROM'AAAAKDJDIAAAA')FROM DUAL;
--BOTH : 뒤의 문자 제거
SELECT TRIM(BOTH'A'FROM'AAAAKDJDIAAAA')FROM DUAL;

--------------------------------------------------------------
/*
LOWER/UPPER/INITCAP : 문자열을 대문자 혹은 소문자 혹은 단어의 앞글자만 대문자로 변환

[표현법]
LOWER/UPPER/INITCAP("영문자열")

SELECT LOWER('java Javascript Oracale')FROM DUAL;
SELECT UPPER('java Javascript Oracale')FROM DUAL;
SELECT INITCAP('java Javascript Oracale')FROM DUAL;
*/
------------------------------------------------------------------
/*
--CONCAT : 문자열 두개를 하나로 합친 결과 반환
--표현법]
--CONCAT('문자열','문자열')
*/


SELECT CONCAT('oracle','(오라클)') from dual;
SELECT 'oracle' ||'(오라클)' FROM DUAL;

-- 문자열 두개만 가능
-- SELECT CONACT('oracle'',(오라클)','02-313-0470'from dual;


-----------------------------------------------------
/*
REPLACE : 기존문자열을 새로운 문자열로 바꿈

[표현법]
REPLACE('문자열','기존문자열','바꿀문자열')
*/

SELECT EMP_NAME,EMAIL,REPLACE(EMAIL,'kh.or.kr','aie.or.kr')
FROM EMPLOYEE;

--=======================================================================
--숫자함수

/* 
ABS : 절대값을 구하는 함수

[표현법]
ABS(NUMBER)
*/
SELECT ABS(-10)FROM DUAL;
SELECT ABS(-3.1415)FROM DUAL;

----------------------------------------------
/*
MOD : 두 수를 나눈 나머지값반환

[표현법]
MOD(NUMBER,NUMBER)
*/

SELECT MOD(10,3)FROM DUAL;
SELECT MOD(10.9,2)FROM DUAL;  --잘사용하지않음

-----------------------------------------------
/*
ROUND : 반올림한 결과 반환
[표현법]
ROUND(NUMBER,[위치]))
*/

SELECT ROUND(1234.56)FROM DUAL;  -- 위치 생략시 0
SELECT ROUND(12.34)FROM DUAL;
SELECT ROUND(1234.5678,2)FROM DUAL;
SELECT ROUND(1234.56,4)FROM DUAL;
SELECT ROUND(1234.56,-2)FROM DUAL; -- 1200

-----------------------------------------------
/*
CEIL : 올림한 결과 반환

[표현법]
CEIL(NUMBER)
*/
SELECT CEIL(123.456)FROM DUAL;
SELECT CEIL(-123.456)FROM DUAL;
----------------------------------------------------------
/*
FLOOR : 내림한 결과 반환
[표현법]
FLOOR(NUMBER)
*/
SELECT FLOOR(123.456)FROM DUAL;
SELECT FLOOR(-123.456)FROM DUAL;
---------------------------------------------------------
/*
TRUNC : 위치 지정 가능한 버림처리 함수

[표현법]
TRUNC(NUMBER,[위치])
*/
SELECT TRUNC(123.78)FROM DUAL;
SELECT TRUNC(123.7867,2)FROM DUAL;
SELECT TRUNC(123.7867,-1)FROM DUAL;

SELECT TRUNC(-123.78)FROM DUAL;
SELECT TRUNC(-123.78,-2)FROM DUAL;
---------------------------------------------------------
--                            <날짜 처리 함수>
--========================================================
/*
SYSDATE : 시스템의 날짜와 시간 반환

*/
SELECT SYSDATE FROM DUAL;

----------------------------------------------------------
/*
MONTH_BETWEEN(DATE1,DATE2):두 날짜 사이의 개월 수 반환
*/
SELECT EMP_NAME,HIRE_DATE,SYSDATE-HIRE_DATE 근무일수
FROM EMPLOYEE;

SELECT EMP_NAME,HIRE_DATE,CEIL(MONTHS_BETWEEN(SYSDATE,HIRE_DATE)) 근무개월수
FROM EMPLOYEE;

/*
ADD_MONTHS(DATE,NUMBER): 특정날짜에 해당 숫자만큼의 개월수를 더해 그 날짜 반환
*/

-- 사원명, 입사일, 입사후 정직원 된 날짜(6개윌 뒤) 조회
SELECT EMP_NAME,HIRE_DATE,ADD_MONTHS(HIRE_DATE,6)"정직원된 날짜"
FROM EMPLOYEE;

-----------------------------------------
/*
NEXT_DAT(DATE,요일(문자|숫자)) : 특정 날짜 이후에 가까운 해당요일의 날짜 반환
*/
SELECT SYSDATE,NEXT_DAY(SYSDATE,'월요일')FROM DUAL;
SELECT SYSDATE,NEXT_DAY(SYSDATE,'월')FROM DUAL;

--1 :일요일
SELECT SYSDATE,NEXT_DAY(SYSDATE,2)FROM DUAL;
--SELECT SYSDATE,NEXT_DAY(SYSDATE,'MONDAY')FROMM DUAL; --에러 현재언어가 KOREA이기 때문

--언어변경
ALTER SESSION SET NLS_LANGUAGE=AMERICAN;
SELECT SYSDATE,NEXT_DAY(SYSDATE,'MONDAY')FROM DUAL;
ALTER SESSION SET NLS_LANGUAGE=KOREAN;
---------------------------------------------------------------
/*
LAST_DAY(DATE) : 해당 월의 마지막 일자의 날짜 반환
*/
SELECT LAST_DAY(SYSDATE)FROM DUAL;

--사원명,입사일,입사한 달의 마지막날짜 조회
SELECT EMP_NAME,HIRE_DATE,LAST_DAY(HIRE_DATE)
FROM EMPLOYEE;

----사원명,입사일,입사한 달의 마지막날짜,입사한 달의 근무 일수 조회
SELECT EMP_NAME,HIRE_DATE,LAST_DAY(HIRE_DATE)-HIRE_DATE + 1
FROM EMPLOYEE;

 --------------------------------------------------------------
/*
EXTRACT : 특정 날짜로부터 년|월|일 값을 추출하여 반환하는 함수(NUMBER:반환형)

[표현법]
EXPRACT(YEAR FROM DATE) : 년도만 추출
EXPRACT(MONTH FROM DATE) : 월만 추출
EXPRACT(DATE FROM DATE) : 일만 추출
*/
--사원명, 입사년도,입사월,입사일 조회
SELECT EMP_NAME,EXTRACT(YEAR FROM HIRE_DATE)입사년도,
EXTRACT(MONTH FROM HIRE_DATE)입사월,
EXTRACT(DAY FROM HIRE_DATE)입사일
FROM EMPLOYEE
ORDER BY 입사년도,입사월,입사일;

--===============================================================================
--                    <형변환 함수>
--==============================================================================
/*
TO_CHAR : 숫자 또는 날짜의 값을 문자타입으로 변환

[표현법]
TO_CHAR(숫자|날짜,[포맷])
포맷:반환 결과를 특정 형식에 맞게 출력하도록 함
*/

---------------------------------숫자=>문자 --------------------------------------
/*
9: 해당자리의 숫자를 의미
-값이 없을 경우 소수점 이상은 공백,소수점 이하는 0으로 표시

0 : 해당자리의 숫자를 의미
-값이 없을 경우 0표시,숫자의 길이를 고정적으로 표시할 때 주로사용
FM : 좌우 9로 치환된 소수점 이상의 공백 및 소수점 이하의 0으르 제거
해당자리에 값이 없을 경우 자리차지하지 않음
*/

SELECT TO_CHAR(1234)FROM DUAL;
SELECT TO_CHAR(1234,'999999') 자리 FROM DUAL; -- 6자리공간 차지,왼쪽정렬,빈칸공백
SELECT TO_CHAR(1234,'000000') 자리 FROM DUAL; -- 6자리공간 차지,왼쪽정렬,빈칸0으로
SELECT TO_CHAR(1234,'L999999') 자리 FROM DUAL; -- L(LOCAL)현재 설정된 나라의화폐단위(빈칸공백)
SELECT TO_CHAR(1234,'L999,999') 자리 FROM DUAL; -- $는 문자의 의미
SELECT TO_CHAR(123412,'L999,999,999') 자리 FROM DUAL;
--사번,이름,급여(/1,111,111),연봉(/123,234,234)조회
SELECT EMP_ID,EMP_NAME,TO_CHAR(SALARY,'L99,999,999')급여, TO_CHAR(SALARY*12,'L999,999,999') 연봉
FROM EMPLOYEE;

--FM
SELECT TO_CHAR(123.456,'FM99990.999'),
TO_CHAR(1234.56,'FM9990.99'),
TO_CHAR(0.1000,'FM9990.999'),
TO_CHAR(0.1000,'FM9999.999')
FROM DUAL;

SELECT TO_CHAR(123.456,'99990.999'),
TO_CHAR(1234.56,'9990.99'),
TO_CHAR(0.1000,'9990.999'),
TO_CHAR(0.1000,'9999.999')
FROM DUAL;
--------------------------------------------------------------------------
--===============================날짜 => 문자-----------------------------------
--시간

SELECT TO_CHAR(SYSDATE,'AM HH:MI:SS')FROM DUAL; - 12시간 형식
SELECT TO_CHAR(SYSDATE,'HH24:MI:SS')FROM DUAL; - 24시간 형식

--날짜
SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD DAY') FROM DUAL;
SELECT TO_CHAR(SYSDATE,'MON,YYYY') FROM DUAL;
SELECT TO_CHAR(SYSDATE,'YYYY"년"MM"월"DD"일"DAY')FROM DUAL;

SELECT TO_CHAR(SYSDATE,'YY-MM-DD')FROM DUAL;

--사원명,입사일(23-02-02),입사일(2023년 2월 2일 금요일)
SELECT EMP_NAME,TO_CHAR(HIRE_DATE,'YY-MM-DD')입사일,
               TO_CHAR(HIRE_DATE'DL')입사년월일
               FROM EMPLOYEE;
               
-----------------------------년도
/*
YY:무조건 앞에 '20'이 붙는다
RR:50년을 기준으로 작으면 앞에 '20'붙이고, 크면 앞에 '19'
*/
SELECT TO_CHAR(SYSDATE,'YYYY'),
TO_CHAR(SYSDATE,'YY'),
TO_CHAR(SYSDATE,'RRRR'),
TO_CHAR(SYSDATE,'YEAR')
FROM DUAL;

SELECT TO_CHAR(HIRE_DATE,'YYYY'),TO_CHAR(HIRE_DATE,'RRRR')
FROM EMPLOYEE;
--월
SELECT TO_CHAR(SYSDATE,'MM'),
TO_CHAR(SYSDATE,'MON'),
TO_CHAR(SYSDATE,'MONTH'),
TO_CHAR(SYSDATE,'RM') -- 로마기호
FROM DUAL;

--일
SELECT TO_CHAR(SYSDATE,'DD'),
TO_CHAR(SYSDATE,'DDD'), -- 년 기준으로 몇일째
TO_CHAR(SYSDATE,'D') -- 주 기준으로 몇일 째
FROM DUAL; -- 주 기준(일요일)으로 몇일 째

--요일에 대한 포맷
SELECT TO_CHAR(SYSDATE,'DAY'),
TO_CHAR(SYSDATE,'DY')
FROM DUAL;
---------------------------------------------------------------
/*
TO_DATE:숫자 또는 문자 타입을 날짜타입으로 전환
[표현법]
TO_DATE(숫자|문자,[포맷])
*/
SELECT TO_DATE(20231110)FROM DUAL;
SELECT TO_DATE(231110)FROM DUAL;

--SELECT TO_DATE(011110)FROM DUAL; -- 숫자 형태로 넣을때 앞이0일떄 오류
SELECT TO_DATE('011110')FROM DUAL; 

SELECT TO_DATE('070407 020830','YYMMDD HHMISS')FROM DUAL;

---------------------------------------------------------
/*
TO_NOMBER : 문자타입을 숫자 타입으로 변경

TO_NUMBER(문자,[포맷])
*/
SELECT TO_NUMBER('0212341234')FROM DUAL;
SELECT '1000' + '5500' FROM DUAL; -- 연산이 들어가면 가동으로 숫자로 형변환
SELECT TO_NUMBER('1,000','9,999,999')FROM DUAL;
SELECT TO_NUMBER('1,000,000','9,999,999') + TO_NUMBER('1,000,000','9,999,999'}
FROM DUAL;

--NVL(컬럼,해당컬럼이 NULL일 경우 반환될 값)
SELECT EMP_NAME,NVL(BONUS,0)
FROM EMPLOYEE;

--사원명,보너스를 포함한 연봉조회
SELECT EMP_NAME,SALARY*(1+NVL(BONUS,0))*12
FROM EMPLOYEE;

SELECT EMP_NAME,NVL(DEPT_CODE,'부서 없음')
FROM EMPLOYEE;

-------------------------------
/*
NVL2(컬럼,반환값1,반환값2)
-컬럼값이 존재할경우 반환값1
-컬럼값이 NULL일때 반환값2
*/

SELECT EMP_NAME,SALARY*NVL2(BONUS,0.5,0.1)
FROM EMPLOYEE;

/*
NULLIF(비교대상1,비교대상2)
-두개의값이 일치하지 않으면 비교대상1을 반환
두개의 값이 일치하면 NULL 반환

*/
SELECT NULLIF('1234','5678')FROM DUAL;
SELECT NULLIF('1234','1234')FROM DUAL;

--=====================================================================
--                                 <선택함수>
--=====================================================================
/*
DECODE(비교하고자하는 대상(컬럼|산술연산|함수식),비교값1,결과값1,비교값2,결과값2,...

SWITCH(비교대상) 
*/
--사원명,성별
SELECT EMP_NAME,DECODE(SUBSTR(EMP_NO,8,1),'1','남자','2','여자')성별
FROM EMPLOYEE;

--직원의 급여를 직급별로 인상해서 조회
--J7이면 급여의 10%인상
-- J6이면 급여의 15%인상
-- J5이면 급여의 20%인상
--그외이면 급여의 5%인상

--사원명,직급코드,기존급여,인상된 급여
SELECT EMP_NAME,JOB_CODE,SALARY 기존급여,DECODE(JOB_CODE,'J7',SALARY*1.1,
                                                        'J6',SALARY*1.15,
                                                        'J5',SALARY*1.2,
                                                        SALARY*1.05)"인상된급여"
FROM EMPLOYEE;








              





































