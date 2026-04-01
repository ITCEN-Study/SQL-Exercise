use edudb;
select * from emp;

-- QUESTION

-- 1. 모든 직원들 급여의 평균을 구한다. 
--        (소수점 이하 둘째자리까지만 나타내고 셋째자리 부터는 절삭한다)
-- 	전직원 급여 평균
--           -------------
--           2073.21
SELECT TRUNCATE(AVG(sal), 2) AS "전직원 급여 평균" FROM EMP;

-- 2. 모든 직원들이 받는 커미션의 합을 구한다.
--	커미션 합
--     -----------
--	 4330
SELECT SUM(COMM) AS "커미션 합" FROM EMP;

-- 3. 모든 직원들의 수를 구한다.
--	직원수
--   -----------
--	 14명
SELECT CONCAT(COUNT(*), "명") AS "직원 수" FROM EMP;

-- 4. 다음과 같이 커미션이 정해진 직원수와 부서가 정해진 직원수를 출력한다.

--	커미션이 정해진 직원수 	부서가 정해진 직원수
--	-----------------------------------------------
--	 6명                    		 13명
SELECT CONCAT(COUNT(COMM), "명") AS "커미션이 정해진 직원수" ,
		CONCAT(COUNT(DEPTNO), "명") AS "부서가 정해진 직원수"
        FROM EMP;


-- 5. 각 직무별로 급여합을 출력하되 급여합이 낮은 순으로 출력한다.

--	직무명	       총급여
--	----------------------------
-- 	CLERK             4150 
-- 	PRESIDENT       5000 
-- 	SALESMAN       5600 
-- 	ANALYST         6000 
-- 	MANAGER        8275 
SELECT JOB AS "직무명", SUM(SAL) AS "총급여"
		FROM EMP
		GROUP BY JOB
        ORDER BY SUM(sal) ASC;

-- 6. 각 부서에서 근무하는 직원들의 인원 명수를 알고싶다. 다음 형식으로 출력하는 SQL
--    을 작성한다 .(순서무관)

--	부서정보	직원수
--	----------------------------
--	미정           1명
-- 	10번 부서    3명
--	20번 부서    4명
--	30번 부서    6명
SELECT CASE WHEN DEPTNO IS NULL THEN "미정"
			ELSE CONCAT(DEPTNO, "번 부서")
            END AS "부서정보",
       CONCAT(COUNT(*), '명') AS "직원수"
       FROM EMP GROUP BY DEPTNO;

-- 7. 년도별로 몇명이 입사했는지 알고싶다. 다음 형식으로 출력하는 SQL
--    을 작성한다 . (많이 입사한 순으로 출력)
--	입사년도 	   입사직원수
--	----------------------------
--	1981년	   10명
--	1982년	   2명
--	1980년	   1명
--	1983년	   1명
SELECT  CONCAT(YEAR(HIREDATE), "년") AS "입사년도",
		CONCAT(COUNT(*), '명') AS "입사직원수"
	FROM EMP
	GROUP BY YEAR(hiredate)
	ORDER BY COUNT(*) DESC;



-- 8. 직무별 급여 총액을 출력하되, 직무가 'MANAGER'인 직원들은 제외한다. 
--   그리고 급여총액이 5000보다 큰 직급과 총급여만 출력한다.

--	직급명		         총액
--	----------------------------
--	SALESMAN          	5,600
--	 ANAYST	  	6,000
SELECT job AS "직급명", FORMAT(SUM(sal), 0) AS "총액"
FROM emp
WHERE job != 'MANAGER'
GROUP BY job
HAVING SUM(sal) > 5000;

-- 9. 30번 부서의 직무별 년봉의 평균을 검색한다.
-- 연봉계산은 급여+커미션(null이면 0으로 계산)이며 
-- 출력 양식은 소수점 이하 두 자리(반올림)까지 통일된 양식으로 출력한다.
--              직무       			평균급여
--              -------------------------------------
--              SALESMAN         		1600.00
--	  	MANAGER			2850.00
--	  	CLERK			950.00
SELECT job AS "직무", 
       ROUND(AVG(sal + IFNULL(comm, 0)), 2) AS "평균급여"
FROM emp
WHERE deptno = 30
GROUP BY job;

-- 10. 월별 입사인원을 다음 형식으로 출력하는 SQL 을 작성한다 . 
--     입사월별로 오름차순이며 입사인원이 2명 이상인 경우에만 출력한다.

--	입사월	  인원
--	------- -------
--	1	  2명
--	2 	  2명
--	4	  2명
--	9	  2명
--	10	  3명
SELECT MONTH(hiredate) AS "입사월",
       CONCAT(COUNT(*), '명') AS "인원"
FROM emp
GROUP BY MONTH(hiredate)
HAVING COUNT(*) >= 2
ORDER BY MONTH(hiredate) ASC;


-- 11. 직무별 급여의 합을 출력하는데 급여합이 5000을 초과하는 직무에 대해서만 출력한다.

--  직무              급여의 합 
-- --------------------------
-- SALESMAN      5600 
-- MANAGER       8275 
-- ANALYST        6000 
SELECT job AS "직무", SUM(sal) AS "급여의 합"
FROM emp
GROUP BY job
HAVING SUM(sal) > 5000;

-- 12. 1981년도에 입사한 직원들에 대해 직무별 급여합을 출력하는데 직무별 급여합이 3000을 초과하는 
--     경우에 대해서 직무별 급여합이 높은순으로 출력한다.

--   직무          급여합
--  -------------------------------------
-- MANAGER      8275 
-- SALESMAN     5600 
-- PRESIDENT    5000 
SELECT job AS "직무", SUM(sal) AS "급여합"
FROM emp
WHERE YEAR(hiredate) = 1981
GROUP BY job
HAVING SUM(sal) > 3000
ORDER BY SUM(sal) DESC;