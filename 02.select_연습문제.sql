--------------------------------------------------------------------------------------------------
/*
    <ORDER BY 절>
    - 정렬
    - SELECT문 가장 마지막 줄에 작성, 실행순서 또한 맨마지막에 실행
    
    [표현법]
    SELECT 컬럼, 컬럼, ....
    FROM 테이블명
    WHERE 조건식
    ORDER BY 정렬기준이 되는 컬럼명 | 별칭 | 컬럼순번[ ASC | DESC ] | [NULLS FIRST | NULLS LAST]
    
    * ASC : 오름차순 정렬(생략시 기본값)
    * DESC : 내림차순 정렬
    
    * NULLS FIRST : 정렬하고자하는 컬럼값에 NULL이 있는 경우 해당 데이터를 맨 앞에 배치(생략시 DESC일때의 기본값)
    * NULLS LAST : 정렬하고자하는 컬럼값에 NULL이 있는 경우 해당 데이터를 맨 뒤에 배치(생략시 ASC일때의 기본값)
*/
-- 보너스로 정렬
SELECT EMP_NAME, BONUS, SALARY
FROM employee
-- ORDER BY BONUS;  -- 오름차순 기본값 NULL이 끝에 옴
-- ORDER BY BONUS ASC;
-- ORDER BY BONUS NULLS FIRST;
-- ORDER BY BONUS DESC;  -- 내림차순은 반드시 DESC기술, NULL은 맨 앞에 옴
ORDER BY BONUS DESC, SALARY;        -- 기준 여러개 가능

-- 전 사원의 사원명, 연봉조회(연봉의 내림차순 정렬 조회)