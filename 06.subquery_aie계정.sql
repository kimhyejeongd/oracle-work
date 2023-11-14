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
  
  ------------ 연습문제
  --1. 70년대 생(1970~1979)중 여자이면서  전씨인 사원의 이름과, 주민번호, 부서명, 직급 조회
  SELECT EMP_NAME,EMP_NO,DEPT_TITLE,JOB_NAME
  FROM EMPLOYEE,DEPARTMENT,JOB
  WHERE ;
  
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
                
  

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 