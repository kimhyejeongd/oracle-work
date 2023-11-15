/*
-서브쿼리(SUBQUERY)
하나의 SQL문 안에 포함된 또다른 SELECT 문
메인 SQL문에 보조 역할을 하는 쿼리문
*/

--박정보 사원과 같은 부서에 속한 사원들 조회
-- 1.박정보 사원 부서코드 조회
SELECT DEPT_CODE
FROM EMPLOYEE 
WHERE EMP_NAME='박정보';

--2.부서코드가 'D9'인 사원의 정보 조호
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE='D9';

--> 위의 두 쿼리문을 하나로 하면
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE=(SELECT DEPT_CODE
                 FROM EMPLOYEE
                 WHERE EMP_NAME='박정보');
--전직원의 평균급여보다 급여를 더 많이 받는 사원의 사번, 사원명, 급여, 직급코드 조회
SELECT EMP_ID,EMP_NAME,SALARY,DEPT_CODE
FROM EMPLOYEE
WHERE SALARY>=(SELECT AVG(SALARY)
               FROM EMPLOYEE);
               
               --------------------------------------
/*
서브쿼리의 구분
서브쿼리를 수행한 결과값이 몇 행 몇 열이냐에 따라 분류

*단일행 서브쿼리 : 서버쿼리의 조회 결과값이 오로지 1개일 때 (1행1열)
*다중행 서브쿼리 : 서비쿼리의 조회 결과값이 여러행일때(여러행 1열)
*다중열 서브쿼리 : 서버쿼리의 조회 결과값이 여러열일때(1행 여러열)
*다중행 다중열 서브쿼리 : 서버쿼리의 조회 결과값이 여러행 여러열일때 (여러행 여러열)

>>서브쿼리의 종류가 무엇이냐에따라 서브쿼리 앞에 붙는 연산자가 달라짐
/*1. 단일행 서브쿼리
  일반 비교 연산자 사용
  =,!=,<,>, ...

*/
--1)전직원의 평균급여보다 급여를 적게 받는 사원의 사원명, 급여 조회
 SELECT EMP_NAME,SALARY
 FROM EMPLOYEE
 WHERE SALARY<(SELECT AVG(SALARY)
 FROM EMPLOYEE)
 ORDER BY SALARY;
 
 
 --2)최저 급여를 받는 사원의 사원명, 급여 조회
 SELECT EMP_NAME,SALARY
 FROM EMPLOYEE
 WHERE SALARY=(SELECT MIN(SALARY)
               FROM EMPLOYEE);
 
 --3)박정보 사원의 급여보다 더 많이 받는 사원의 사원명,급여 조회
 SELECT EMP_NAME,SALARY
 FROM EMPLOYEE
 WHERE SALARY>(SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '박정보');
                
--JOIN+SUBQUERY
--4)박정보 사원의 급여보다 더많이 받는 사원의 사번, 사원명,부서코드, 부서이름, 급여 조회
-- >> 오라클 전용 구문
SELECT EMP_ID,EMP_NAME,DEPT_CODE,DEPT_TITLE,SALARY
FROM EMPLOYEE,DEPARTMENT
WHERE SALARY>(SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '박정보')
  AND DEPT_CODE=DEPT_ID;
  
  --ANSI 구문
  SELECT EMP_ID,EMP_NAME,DEPT_CODE,DEPT_TITLE,SALARY
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID)
WHERE SALARY>(SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '박정보');
                
--5)왕정보 사원과 같은 부서원들의 사번, 사원명,전화번호, 부서명 조회 단, 왕정보는 제외
SELECT EMP_ID,EMP_NAME,PHONE,DEPT_TITLE
FROM EMPLOYEE,DEPARTMENT
WHERE DEPT_CODE = (SELECT DEPT_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME='왕정보')
AND DEPT_CODE=DEPT_ID
AND EMP_NAME != '왕정보';

-->>ANSI구문
SELECT EMP_ID,EMP_NAME,PHONE,DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID)
WHERE DEPT_CODE=(SELECT DEPT_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME='왕정보')
AND EMP_NAME!='왕정보';
  
  --GROUP+SUBQUERY
  --6)부서별 급여합이 가장 큰 부서의 부서코드, 급여합 조회
  --6.1.부서별 급여의 합중 가장 큰 합 조회
  /*SELECT MAX(SUM(SALARY))
  FROM EMPLOYEE
  GROUP BY DEPT_CODE
  ORDER BY SUM(SALARY) DESC;*/
  
  SELECT MAX(SUM(SALARY))
  FROM EMPLOYEE
  GROUP BY DEPT_CODE;
  
  --6.2부서별 급여합이 17,700,000안 부서 조회
  SELECT DEPT_CODE,SUM(SALARY) 급여합
  FROM EMPLOYEE
  GROUP BY DEPT_CODE
  HAVING SUM(SALARY) = 17700000;
  
  --> 위2개를 합치면 
  SELECT DEPT_CODE,SUM(SALARY) 급여합
  FROM EMPLOYEE
  GROUP BY DEPT_CODE
  HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))
  FROM EMPLOYEE
  GROUP BY DEPT_CODE);
  
  ------------------------------------------------------------------------------
  /* 2.다중행 서브쿼리(MULTI ROW SUBQUERY)
  서버쿼리의 조회 결과값이 여러행 일때 (여러행1열)
  -IN서브쿼리 : 여러개의 결과값 중 한개라도 일치하는 값이 있다면
  
  -> > ANY 서브쿼리:여러개의 결과값 중 "한개라도"클 경우
    (여러개의 결과값 중 가장 작은값보다 클경우)
     -> < ANY 서브쿼리:여러개의 결과값 중 "한개라도"작은 경우
    (여러개의 결과값 중 가장 큰값보다 작을 경우)
    
    비교대상>ANY(값1,값2,값3)
    비교대상 < 값1 OR 비교대상 < 값2 OR 비교대상<값3
  */
  
  --1) 조정연 또는 전지연과 같은 직급인 사원들의 사번,사원명,직급 코드, 급여
  SELECT JOB_CODE
  FROM EMPLOYEE
  --WHERE EMP_NAME='조정연'OR EMP_NAME='전지연';또는
  WHERE EMP_NAME IN('조정연','전지연');
  
  --1.2직급코드가 J3,J7인 사원의 사번,사원명,직급코드, 급여 조회
  SELECT EMP_ID,EMP_NAME,JOB_CODE,SALARY
  FROM EMPLOYEE
  WHERE JOB_CODE IN('J3','J7');
  
   SELECT EMP_ID,EMP_NAME,JOB_CODE,SALARY
  FROM EMPLOYEE
  WHERE JOB_CODE IN(SELECT JOB_CODE
  FROM EMPLOYEE
  WHERE EMP_NAME IN('조정연','전지연'));
  
  --대표=>부사장=>부장=>차장=>과장=>대리=>사원
  --2. 대리 직급임에도 불구하고 과장직급의 급여들 중 최소 급여보다 많이 받는 직원의 사번, 사원명,직급명,급여를 조회
  --2.1 과장 직급인 사원들의 급여를 조회
  SELECT SALARY
  FROM EMPLOYEE
  JOIN JOB USING(JOB_CODE)
  WHERE JOB_NAME='과장'; --2,200,2,500,3,760
  
  --2.2직급이 대리이면서 급여가 위의 목록값들 중에 하나라도 큰 사원
  SELECT EMP_ID,EMP_NAME,JOB_NAME,SALARY
  FROM EMPLOYEE
  JOIN JOB USING(JOB_CODE)
  WHERE JOB_NAME = '대리'
  AND SALARY >ANY(SELECT SALARY
  FROM EMPLOYEE
  JOIN JOB USING(JOB_CODE)
  WHERE JOB_NAME='과장');
  
  --단일행 서브쿼리로도 가능
  SELECT EMP_ID,EMP_NAME,JOB_NAME,SALARY
  FROM EMPLOYEE
  JOIN JOB USING(JOB_CODE)
  WHERE JOB_NAME = '대리'
  AND SALARY >(SELECT MIN(SALARY)
             FROM EMPLOYEE
             JOIN JOB USING(JOB_CODE)
  WHERE JOB_NAME='과장');
  
  --차장 직급임에도 과장직급의 급여보다 적게 받는 사원의 사번, 사원명,직급명, 급여 조회
  SELECT EMP_ID,EMP_NAME,JOB_NAME,SALARY
  FROM EMPLOYEE
  JOIN JOB USING(JOB_CODE)
  WHERE JOB_NAME='차장'
  AND SALARY<ANY(SELECT SALARY 
                 FROM EMPLOYEE
                 JOIN JOB USING(JOB_CODE)
                 WHERE JOB_NAME='과장');
  
  --4) 과장직급임에도 불구하고 차장직급인 사원들의 모든 급여보다 더 많이 받는 사원들의 사번,사원명,직급명,급여조회
  --ANY : 차장의 가장 적게 받는 급여보다 많이 받는 과장
       -- 비교대상>값1 OR 비교대상>값2 OR 비교대상>값3
       SELECT EMP_ID,EMP_NAME,JOB_NAME,SALARY
       FROM EMPLOYEE
       JOIN JOB USING(JOB_CODE)
       WHERE JOB_NAME='과장'
       AND SALARY > ANY(SELECT SALARY 
                          FROM EMPLOYEE
                          JOIN JOB USING(JOB_CODE)
                          WHERE JOB_NAME= '차장');
  --ALL : 서브쿼리의 값들중 가장 큰값보다 큰값을 얻어올 때
  --비교대상>값1 AND 비교대상>값2 AND 비교대상>값3
  --차장의 가장 많이 받는 급여보다 더 많이 받는 과장
  SELECT EMP_ID,EMP_NAME,JOB_NAME,SALARY
       FROM EMPLOYEE
       JOIN JOB USING(JOB_CODE)
       WHERE JOB_NAME='과장'
       AND SALARY > ALL(SELECT SALARY 
                          FROM EMPLOYEE
                          JOIN JOB USING(JOB_CODE)
                          WHERE JOB_NAME= '차장');
--------------------------------------------------------------------------------
/*
3.다중열 서브쿼리
결과값이 한행이면서 여러 컬럼일 때
*/
-- 1. 장정보 사원과 같은 부서코드, 같은 직급코드에 해당하는 사원들의 사번, 사원명,부서코드, 직급코드 조회
SELECT EMP_ID,EMP_NAME,DEPT_CODE,JOB_CODE
FROM EMPLOYEE
WHERE DEPT_CODE=(SELECT DEPT_CODE
                 FROM EMPLOYEE
                 WHERE EMP_NAME='장정보')
  AND JOB_CODE=(SELECT JOB_CODE
                 FROM EMPLOYEE
                 WHERE EMP_NAME='장정보');
-- 다중열 서브쿼리로
SELECT EMP_ID,EMP_NAME,DEPT_CODE,JOB_CODE
FROM EMPLOYEE
WHERE (DEPT_CODE,JOB_CODE)=(SELECT DEPT_CODE,JOB_CODE
                            FROM EMPLOYEE
                            WHERE EMP_NAME='장정보')
AND EMP_NAME!='장정보';

--지정보 사원과 같은 직급코드,같은 사수를 가지고 있는 사원들의 사번, 사원명, 직급코드,사수번호 조회
SELECT EMP_ID,EMP_NAME,JOB_CODE,MANAGER_ID
FROM EMPLOYEE
WHERE (JOB_CODE,MANAGER_ID)=(SELECT JOB_CODE,MANAGER_ID
                              FROM EMPLOYEE
                              WHERE EMP_NAME='지정보');
--------------------------------------------------------------------------------
/* 4. 다중행 다중열 서브쿼리
      서브쿼리 결과 여러행, 여러열일 경우
*/
-- 1) 각 직급별 최소급여를 받는 사원의 사번, 이름, 직급코드, 급여 조회
--1.1 각 직급별로 최소급여를 받는 사원의 직급코드, 최소급여 조회
SELECT JOB_CODE,MIN(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE;

SELECT EMP_ID,EMP_NAME,JOB_CODE,SALARY
FROM EMPLOYEE
WHERE JOB_CODE='J5'AND SALARY = 2200000
   OR JOB_CODE='J6'AND SALARY = 2000000;
   
/*SELECT EMP_ID,EMP_NAME,JOB_CODE,SALARY
FROM EMPLOYEE
WHERE(JOB_CODE,SALARY)=('J5',220000); ..7번수행*/

--다중행 다중열 서브쿼리
SELECT EMP_ID,EMP_NAME,JOB_CODE,SALARY
FROM EMPLOYEE
WHERE(JOB_CODE,SALARY)IN(SELECT JOB_CODE,MIN(SALARY)
                         FROM EMPLOYEE
                         GROUP BY JOB_CODE);
 --2)각 부서별 최고급여를 받는 사원들의 사번, 사원명, 부서코드, 급여조회
 SELECT EMP_ID,EMP_NAME,DEPT_CODE,SALARY
FROM EMPLOYEE
WHERE(DEPT_CODE,SALARY)IN(SELECT DEPT_CODE,MAX(SALARY)
                         FROM EMPLOYEE
                         GROUP BY DEPT_CODE);
--------------------------------------------------------------------------------
/*
5.인라인 뷰 (INLINE VIEW)
  FROM 절에 서브쿼리를 작성
  
  서브쿼리를 수행한 결과를 마치 테이블처럼 사용
  */
   --사원들의 사번, 사원명, 보너스포함연봉,부서코드 조회
   -- 조건1.보너스 포함 연봉이 NULL이 나오지 않도록
   -- 조건2.보너스 포함 연봉이  3000만원 이상인 사원들만 조회
   
 /*  SELECT 연봉
   FROM 내가 만든 테이블(보너스 포함 연봉)
   WHERE 조건2

순서 1. FROM
      2. WHERE
      3. SELECT
      */
  SELECT EMP_ID,EMP_NAME,SALARY*NVL((1+BONUS),1)*12 연봉,DEPT_CODE
  FROM EMPLOYEE
  WHERE SALARY*NVL((1+BONUS),1)*12 >= 30000000;
  
  SELECT *
  FROM(SELECT EMP_ID,EMP_NAME,SALARY*NVL((1+BONUS),1)*12 연봉,DEPT_CODE
  FROM EMPLOYEE)
  WHERE 연봉>=30000000;
   -- 인라인 뷰에 없는 컬럼은 가져올 수 없다
   
   --인라인 뷰를 주로 사용하는 곳 = > TOP-N분석(상위 몇위만 가져오기)
   
   --전 직원 중 급여가 가장 높은 상위 5명만 조회
   --*ROWNUM : 오라클에서 제공해주는 컬럼, 조회된 순서대로 1부터 부여해줌
        --     WHERE 절에 기술
        
 SELECT ROWNUM,EMP_NAME,SALARY
 FROM EMPLOYEE;
 
 SELECT ROWNUM,EMP_NAME,SALARY
 FROM EMPLOYEE
 ORDER BY SALARY;
  
 SELECT ROWNUM,EMP_NAME,SALARY
 FROM EMPLOYEE
 WHERE ROWNUM <= 5
 ORDER BY SALARY;
 
 --순서때문에 내가 원하는 결과가 나오지 않음
 --먼저 정렬(ORDER BY)한 테이블을 만들고 
 -- 그 테이블에서 ROWNUM을 부여
 
 SELECT ROWNUM,EMP_NAME,SALARY,DEPT_CODE
 FROM(SELECT EMP_NAME,SALARY,DEPT_CODE
      FROM EMPLOYEE
      ORDER BY SALARY DESC) 
      WHERE ROWNUM <=5;
   --인라인 뷰의 모든 컬럼과 다른 컬럼(오라클에 있는 컬럼)을 가져올 때 테이블에 별칭을 부여
  SELECT ROWNUM,T.*
 FROM(SELECT EMP_NAME,SALARY,DEPT_CODE
      FROM EMPLOYEE
      ORDER BY SALARY DESC) T
      WHERE ROWNUM <=5;
  
  
  --가장 최근에 입사한 사원5명의ROWNUM, 사번, 사원명, 입사일 조회
  SELECT ROWNUM,T.* 
  FROM (SELECT EMP_ID,EMP_NAME,HIRE_DATE
        FROM EMPLOYEE
        ORDER BY HIRE_DATE DESC) T
  WHERE ROWNUM <=5;
  --각 부서별 평균급여가 높은 3개의 부서의 부서코드, 평균급여 조회
  SELECT*
  FROM(SELECT DEPT_CODE,CEIL(AVG(SALARY)) 평균급여
       FROM EMPLOYEE
       GROUP BY DEPT_CODE
       ORDER BY 평균급여 DESC)
WHERE ROWNUM<=3;

--------------------------------------------------------------------------------
/*
6. WITH
서브쿼리에 이름을 붙여주고 인라인 뷰로 사용시 서브쿼리의 이름으로 FROM절에 기술

- 장점
같은서브쿼리가여러번 사용될 경우 중복 작성을 피할 수 있고 
실행속도도 빨라짐
*/
WITH TOPN_SAL1 AS(SELECT DEPT_CODE,CEIL(AVG(SALARY)) 평균급여
                  FROM EMPLOYEE
                  GROUP BY DEPT_CODE
                  ORDER BY 평균급여 DESC)
                  
SELECT*
FROM TOPN_SAL1
WHERE ROWNUM <= 5;

--------------------------------------------------------------------------------
/*
7. 순위 매기는 함수(WINDOW FUNCTION)
   RANK()OVER(정렬기준) | DENSE_RANK() OVER(정렬기준)
   -RANK() OVER(정렬기준) : 동일한 순위 이후의 등수를 동일한 인원 수 만큼 건너뛰고 순위 게산
                          EX) 공동 1순위가 2명이면 그 다음 순위는 3위  
   -DENSE_RANK()OVER(정렬기준) : 동일한 순위가 있어도 다음 등수는 무조건 1씩 증가
                               EX) 공동 1순위가 3명이면 그 다음 순위는 2위
   >> 두 함수는 무조건 SELECT 절에서만 사용 가능
*/
  --급여가 높은 순서대로 순위를 매겨서 사원명, 급여, 순위 조회
  SELECT EMP_NAME,SALARY,RANK()OVER(ORDER BY SALARY DESC) 순위
  FROM EMPLOYEE;
  
   SELECT EMP_NAME,SALARY,DENSE_RANK()OVER(ORDER BY SALARY DESC) 순위
  FROM EMPLOYEE;
  
  --급여가 상위 5위인 사원의 사원명,급여,순위 조회
  SELECT EMP_NAME,SALARY,RANK()OVER(ORDER BY SALARY DESC) 순위
  FROM EMPLOYEE;
 -- 오류 WHERE 순위 <= 5 실행순서 때문에
--WHERE RANK()OVER(ORDER BY SALARY DESC) < 5; --RANK함수는 SELECT 절에서만 사용할 수 있어서 오류발생

-->> 인라인 뷰를 쓸 수 밖에 없다
SELECT*
FROM(SELECT EMP_NAME,SALARY,RANK()OVER(ORDER BY SALARY DESC) 순위
    FROM EMPLOYEE)
WHERE 순위 <= 5;

--WITH로 사용
WITH TOPN_SAL5 AS(SELECT EMP_NAME,SALARY,RANK()OVER(ORDER BY SALARY DESC) 순위
    FROM EMPLOYEE)

SELECT 순위,EMP_NAME,SALARY
FROM TOPN_SAL5
WHERE 순위 <= 5 ;

--11.15 연습문제
-- 1. 70년대 생(1970~1979) 중 여자이면서 전씨인 사원의 이름과, 주민번호, 부서명, 직급 조회    
/*SELECT EMP_NAME,EMP_NO,DEPT_TITLE,JOB_NAME
FROM EMPLOYEE,DEPARTMENT,JOB
WHERE DEPT_CODE=DEPT_ID
AND JOB_CODE*/


/*--70년대생
SUBSTR(EMP_NO,1,2)>=70 AND SUBSTR(EMP_NO,1,2)<=79
--여자
SUBSTR(EMP_NO,8,1)=2

--전씨
EMP_NAME LIKE '전%'
*/
SELECT EMP_NAME,EMP_NO,DEPT_TITLE,JOB_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID)
JOIN JOB USING (JOB_CODE)
WHERE SUBSTR(EMP_NO,1,2)>=70 AND SUBSTR(EMP_NO,1,2)<=79
     AND SUBSTR(EMP_NO,8,1)=2
     AND EMP_NAME LIKE '전%';

-- 2. 나이가 가장 막내의 사원 코드, 사원 명, 나이, 부서 명, 직급 명 조회
SELECT       EMP_ID
            , EMP_NAME
            , EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM (TO_DATE(SUBSTR(EMP_NO,1,2), 'RR'))) 나이
            , DEPT_TITLE
            , JOB_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE)
WHERE EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM (TO_DATE(SUBSTR(EMP_NO,1,2), 'RR'))) =
(SELECT MIN(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM (TO_DATE(SUBSTR(EMP_NO,1,2), 'RR')))) FROM EMPLOYEE);
--나이 
--올해의 년도 추출
EXTRACT(YEAR FROM SYSDATE)-(EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO,1,2),'RR'))) 나이
--주민번호 년도 추출 
EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO,1,2),'RR')))
-- 3. 이름에 ‘하’가 들어가는 사원의 사원 코드, 사원 명, 직급명 조회
SELECT EMP_ID,EMP_NAME,JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE=J.JOB_CODE
      AND EMP_NAME LIKE'%하%';
-- 4. 부서 코드가 D5이거나 D6인 사원의 사원 명, 직급명, 부서 코드, 부서 명 조회
SELECT EMP_NAME,JOB_NAME,DEPT_CODE,DEPT_TITLE
FROM EMPLOYEE E,DEPARTMENT D,JOB J
WHERE DEPT_CODE=DEPT_ID
  AND E.JOB_CODE=J.JOB_CODE
  AND DEPT_CODE IN('D5','D6');
-- 5. 보너스를 받는 사원의 사원 명, 보너스, 부서 명, 지역 명 조회
SELECT EMP_NAME,BONUS,DEPT_TITLE,LOCAL_NAME
FROM EMPLOYEE E,DEPARTMENT D, LOCATION L
WHERE DEPT_CODE=DEPT_ID
  AND LOCATION_ID=LOCAL_CODE
  AND BONUS IS NOT NULL;
-- 6. 사원 명, 직급, 부서 명, 지역 명 조회
SELECT EMP_NAME,JOB_NAME,DEPT_TITLE,LOCAL_NAME
FROM EMPLOYEE E,DEPARTMENT E, JOB J, LOCATION L
WHERE DEPT_CODE=DEPT_ID
AND E.JOB_CODE=J.JOB_CODE
AND LOCATION_ID=LOCAL_CODE;
-- 7. 한국이나 일본에서 근무 중인 사원의 사원 명, 부서 명, 지역 명, 국가 명 조회 
SELECT EMP_NAME,DEPT_TITLE,LOCAL_NAME,NATIONAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID)
JOIN LOCATION ON(LOCATION_ID=LOCAL_CODE)
JOIN NATIONAL USING(NATIONAL_CODE)
WHERE NATIONAL_NAME IN('한국','일본');
-- 8. 하정연 사원과 같은 부서에서 일하는 사원의 이름 조회
SELECT EMP_NAME,DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE=(SELECT DEPT_CODE
                 FROM EMPLOYEE
                 WHERE EMP_NAME = '하정연');
-- 9. 보너스가 없고 직급 코드가 J4이거나 J7인 사원의 이름, 직급, 급여 조회 (NVL 이용)
SELECT EMP_NAME,JOB_NAME,SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE NVL(BONUS,0)=0
AND JOB_CODE IN('J4','J7');
-- 10. 퇴사 하지 않은 사람과 퇴사한 사람의 수 조회
SELECT ENT_YN, COUNT(*)
FROM EMPLOYEE
GROUP BY ENT_YN;
-- 11. 보너스 포함한 연봉이 높은 5명의 사번, 이름, 부서 명, 직급, 입사일, 순위 조회
SELECT EMP_ID,EMP_NAME,DEPT_TITLE,JOB_NAME,HIRE_DATE,순위
FROM (SELECT EMP_ID
            ,EMP_NAME
            ,DEPT_TITLE
            ,JOB_NAME
            ,HIRE_DATE
            ,SALARY*NVL(1+BONUS,1)*12
            ,RANK() OVER(ORDER BY(SALARY*NVL(1+BONUS,1)*12)DESC) 순위
      FROM EMPLOYEE 
      JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
      JOIN JOB USING(JOB_CODE))
WHERE 순위<=5;

-- 12. 부서 별 급여 합계가 전체 급여 총 합의 20%보다 많은 부서의 부서 명, 부서 별 급여 합계 조회
--	    12-1. JOIN과 HAVING 사용                
SELECT DEPT_TITLE,SUM(SALARY)
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) > (SELECT SUM(SALARY)*0.2
                      FROM EMPLOYEE);
--	    12-2. 인라인 뷰 사용      
SELECT *
FROM( SELECT DEPT_TITLE,SUM(SALARY)부서급여합
        FROM EMPLOYEE
        JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
        GROUP BY DEPT_TITLE)
WHERE 부서급여합 > (SELECT SUM(SALARY)*0.2
                       FROM EMPLOYEE);
--	    12-3. WITH 사용
WITH DEPTSUM AS (SELECT DEPT_TITLE,SUM(SALARY)부서급여합
                FROM EMPLOYEE
                JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
                GROUP BY DEPT_TITLE)
SELECT*
FROM DEPTSUM
WHERE 부서급여합 > (SELECT SUM(SALARY)*0.2
                       FROM EMPLOYEE);

-- 13. 부서 명과 부서 별 급여 합계 조회
SELECT DEPT_TITLE,SUM(SALARY)
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
GROUP BY DEPT_TITLE;

-- 14. WITH를 이용하여 급여 합과 급여 평균 조회
WITH SUM_SAL AS(SELECT (SUM(SALARY))FROM EMPLOYEE),
     AVG_SAL AS(SELECT CEIL(AVG(SALARY))FROM EMPLOYEE)
     
SELECT * FROM SUM_SAL
UNION


SELECT*FROM SUM_SAL
UNION
SELECT*FROM AVG_SAL;

  
  
  
  
  
  
  
  
  
  
  
  
  
  ------------ 연습문제

  --1. 70년대 생(1970~1979)중 여자이면서  전씨인 사원의 이름과, 주민번호, 부서명, 직급 조회
  SELECT EMP_NAME,EMP_NO,DEPT_TITLE,JOB_NAME
  FROM EMPLOYEE
  
  
  
  --2.나이가 가장 막내인 사원 코드,사원명,나이, 부서명, 직급 명 조회
 -- SELECT EMP_ID,EMP_NAME,
  
  
  --3.이름에 '하'가 들어가는 사원의 사원 코드, 사원명,직급 조회
  SELECT EMP_ID,EMP_NAME,JOB_NAME
  FROM EMPLOYEE
  
  
  AND EMP_NAME = '하';
  
  
  
  
  SELECT EMP_ID,EMP_NAME,DEPT_CODE,DEPT_TITLE,SALARY
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID)
WHERE SALARY>(SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '박정보');
                
  

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 