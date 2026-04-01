use edudb;
select * from emp;

-- QUESTION

-- [ course1 테이블과 course2 테이블을 가지고 문제 해결 - 1번, 2번 ]

-- 1. course1 을 수강하는 학생들과 course2 를 수강하는 학생들의 이름,  
--    나이를 출력하는데 나이가 적은 순으로 출력하시오.
--    단, 두 코스를 모두 수강하는 학생들의 정보는 한 번만 출력한다.
SELECT name, age FROM COURSE1 UNION SELECT NAME, AGE FROM COURSE2 ORDER BY AGE ASC;

-- name    age  
-- ------------
-- 희동이     6 
-- 짱구       7 
-- 둘리      10 
-- 또치      11 
-- 듀크      11 
-- 도우너    12 
-- 토토로    13 

-- 2. course1 을 수강하는 학생들과 course2 를 수강하는 학생들의 이름, 전화 번호 그리고 
--    나이를 출력하는데 나이가 많은 순으로 출력하시오.
--    단, 두 코스를 모두 수강하는 학생들의 정보를 중복해서 출력한다. 
SELECT NAME, PHONE, AGE FROM course1 UNION ALL SELECT NAME, PHONE, AGE FROM course2 ORDER BY AGE DESC;

-- name   phone        age 
-- --------------------------
-- 토토로 010-555-5555   13 
-- 도우너 010-333-3333   12 
-- 또치   010-222-2222   11 
-- 듀크   010-777-7777   11
-- 또치   010-222-2222   11 
-- 둘리   010-111-1111   10 
-- 둘리   010-111-1111   10 
-- 짱구   010-666-6666    7 
-- 희동이 010-444-4444    6 




-- 3. 직무별 그리고 입사년도별 직원들 수를 출력하는데 직무별 직원수(소합계)와 전체 직원수(전체 합계)도 
--    함께 출력한다.
SELECT IFNULL(job, '전체합계') AS "직무", 
       DATE_FORMAT(hiredate, '%Y') AS "입사년도", 
       COUNT(*) AS "직원수"
FROM emp
GROUP BY job, DATE_FORMAT(hiredate, '%Y') WITH ROLLUP;
-- 직무      	입사년도 	직원수
-- -----------------------------------------
-- ANALYST       	1981      1
-- ANALYST       	1982      1
-- ANALYST       	NULL      2
-- CLERK         	1980      1
-- CLERK         	1981      1
-- CLERK         	1982      1
-- CLERK         	1983      1
-- CLERK         	NULL      4
-- MANAGER       	1981      3
-- MANAGER       	NULL      3
-- PRESIDENT     	1981      1
-- PRESIDENT     	NULL      1
-- SALESMAN      	1981      4
-- SALESMAN      	NULL      4
-- NULL         	 NULL     14



-- [ emp 테이블 외에도 필요에 따라 dept, locations, salgrade 테이블을 가지고 문제 해결(JOIN) ]

-- 먼저 dept, locations, salgrade 테이블의 내용을 확인한다.
SELECT * FROM DEPT;
SELECT * FROM locations;
SELECT * FROM salgrade;

-- 4. RESEARCH 부서에서 근무하는 직원의 이름, 직무, 부서이름을 출력하시오.
SELECT e.ename as "이름", e.job as "직무", d.dname as "부서이름" FROM emp e JOIN dept d ON e.deptno = d.deptno WHERE d.dname = 'RESEARCH';

-- 이름         직무         	부서이름          
-- -------- --------- ------------------
-- SMITH CLERK   RESEARCH 
-- JONES MANAGER RESEARCH 
-- SCOTT ANALYST RESEARCH 
-- FORD  ANALYST RESEARCH 

-- 5. 이름에 'A'가 들어가는 직원들의 이름과 부서이름을 출력하시오.
SELECT e.ename as "이름", d.dname as "부서이름" FROM emp e JOIN dept d on e.deptno = d.deptno WHERE e.ename LIKE "%A%";

-- 이름        부서이름          
-- ------    --------------
-- ALLEN  SALES      
-- WARD   SALES      
-- MARTIN SALES     
-- BLAKE  SALES      
-- CLARK  ACCOUNTING 
-- JAMES  SALES

-- 6. 직원이름과 그 직원이 속한 부서의 부서명, 그리고 급여를 
-- 출력하는데 급여가 3000이상인 직원을 출력하시오. 
SELECT e.ename AS "직원이름", d.dname AS "부서명", CONCAT(FORMAT(e.sal, 0), '원') AS "급여"
FROM emp e
JOIN dept d ON e.deptno = d.deptno
WHERE e.sal >= 3000;

-- 직원이름      부서명               급여
-- -------- -------------- --------------
-- SCOTT   	   RESEARCH	3,000원
-- KING	   ACCOUNTING	5,000원
-- FORD	   RESEARCH	3,000원

-- 7. 커미션이 책정된 직원들의 직원번호, 이름, 연봉, 연봉커미션,
-- 급여등급을 출력하되, 각각의 컬럼명을 '직원번호', '직원이름',
-- '연봉','실급여', '급여등급'으로 하여 출력하시오. 
-- 또한 실급여가 적은 순으로 출력하시오.
SELECT e.empno AS "직원번호", 
       e.ename AS "직원이름", 
       (e.sal * 12) AS "연봉", 
       (e.sal * 12 + IFNULL(e.comm, 0)) AS "실급여", 
       s.grade AS "급여등급"
FROM emp e
JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal
WHERE e.comm IS NOT NULL
ORDER BY 실급여 ASC;

--  직원번호 직원이름      연봉           실급여       급여등급
-- -------- ---------- ---------- --------------- ----------
--  7521 WARD             15000         15200          2
--  7654 MARTIN          15000         15300          2
--  7844 TURNER          18000         18000          3
--  7499	ALLEN	19200         19500	   3
--  7566 JONES    	       35700         35730         4 
--  7839 KING              60000         63500         5
                                         
-- 8. 부서번호가 10번인 직원들의 부서번호, 부서이름, 직원이름,
-- 급여, 급여등급을 출력하시오. 
SELECT e.deptno AS "부서번호", d.dname AS "부서이름", e.ename AS "직원이름", e.sal AS "급여", s.grade AS "급여등급"
FROM emp e JOIN dept d ON e.deptno = d.deptno JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal WHERE e.deptno = 10;

--   부서번호 부서이름           직원이름      급여           급여등급
-- -------- -------------- ---------- -------------- -------------
--      10 ACCOUNTING     CLARK            2450          4
--      10 ACCOUNTING     KING              5000          5
--      10 ACCOUNTING     MILLER           1300          2 

-- 9. 직무가 'SALESMAN'인 직원들의 직무와 그 직원이름, 그리고
-- 그 직원이 속한 부서 이름을 출력하시오. 
SELECT e.job AS "직무", e.ename AS "직원이름", d.dname AS "부서이름" FROM emp e JOIN dept d ON e.deptno = d.deptno
WHERE e.job = 'SALESMAN';

-- 직무          직원이름       부서이름          
-- ------- ---------- --------------
-- SALESMAN  TURNER     SALES         
-- SALESMAN  MARTIN     SALES         
-- SALESMAN  WARD       SALES         
-- SALESMAN  ALLEN       SALES 

-- 10. 부서번호가 10번, 20번인 직원들의 부서번호, 부서이름, 
-- 직원이름, 급여, 급여등급을 출력하시오. 그리고 그 출력된 
-- 결과물을 부서번호가 낮은 순으로, 급여가 많은 순으로 정렬하시오. (7개 행)
SELECT e.deptno AS "부서번호", d.dname AS "부서이름", e.ename AS "직원이름", e.sal AS 급여, s.grade AS "급여등급"
FROM emp e JOIN dept d ON e.deptno = d.deptno
JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal
WHERE e.deptno IN (10, 20) ORDER BY e.deptno ASC, e.sal DESC;

--   부서번호 부서이름              직원이름               급여       급여등급
-- -------- -------------- ---------- ---------- ------------ ----------
--    10 ACCOUNTING         KING                   5000          5
--    10 ACCOUNTING         CLARK                 2450          4
--    10 ACCOUNTING         MILLER                 1300          2
--    20 RESEARCH             SCOTT            	3000           4
--    20  RESEARCH    	     FORD       	        3000           4 
--    20  RESEARCH   	    JONES     	        2975           4 
--    20  RESEARCH    	    SMITH      	         800            1 
                                                 
-- 11. 사원들의 이름, 부서번호, 부서이름을 출력하시오. 
-- 단, 직원이 없는 부서도 출력하며 이경우 이름을 '없음'이라고 출력한다.     
-- 부서번호별로 정렬한다.
SELECT IFNULL(e.ename, '없음') AS "이름", 
       d.deptno AS "부서번호", 
       d.dname AS "부서이름"
FROM emp e
RIGHT JOIN dept d ON e.deptno = d.deptno
ORDER BY d.deptno ASC;

-- 이름               부서번호 부서이름          
-- -------- ---------- --------------
-- CLARK         10  ACCOUNTING 
-- KING          10  ACCOUNTING 
-- MILLER        10  ACCOUNTING 
-- SMITH         20  RESEARCH   
-- JONES         20  RESEARCH   
-- SCOTT         20  RESEARCH   
-- FORD          20  RESEARCH   
-- ALLEN         30  SALES      
-- WARD          30  SALES      
-- MARTIN        30  SALES      
-- BLAKE         30  SALES      
-- TURNER        30  SALES      
-- JAMES         30  SALES      
-- 없음          40  OPERATIONS 
-- 없음          50  INSA       

-- 12. 직원들의 이름, 부서번호, 부서이름을 출력하시오. 
-- 단, 아직 부서 배치를 못받은 직원도  출력하며 이경우 부서번호와 부서명은  null 로
-- 출력한다.  또한 직원들의 이름순으로 정렬한다. 
SELECT e.ename AS "이름", 
       e.deptno AS "부서번호", 
       d.dname AS "부서이름"
FROM emp e
LEFT JOIN dept d ON e.deptno = d.deptno
ORDER BY e.ename ASC;

-- 이름               부서번호     부서이름          
-- -------- ---------- ------------------------
-- ADAMS       NULL          	NULL       
-- ALLEN        30             	SALES      
-- BLAKE         30            	SALES  
-- CLARK         10  	ACCOUNTING 
--  FORD          20  	RESEARCH   
-- JAMES         30  	SALES      
-- JONES         20  	RESEARCH   
-- KING          10  	ACCOUNTING 
-- MARTIN        30  	SALES      
-- MILLER        10  	ACCOUNTING 
-- SCOTT         20  	RESEARCH   
-- SMITH         20  	RESEARCH   
-- TURNER        30  	SALES      
-- WARD          30  	SALES                              

-- 13. 커미션이 정해진 모든 직원의 이름, 커미션, 부서이름, 도시명을 출력하시오.
SELECT e.ename AS "직원명", e.comm AS "커미션", d.dname AS "부서명", l.city AS "도시명"
FROM emp e
JOIN dept d ON e.deptno = d.deptno
JOIN locations l ON d.locid = l.locid
WHERE e.comm IS NOT NULL;

-- 직원명 		커미션 	부서명     	도시명  
-- ---------------------------------------------------------------------
-- KING     		3500 	ACCOUNTING 	SEOUL   
-- JONES      	30 	RESEARCH   	DALLAS  
-- ALLEN     	300 	SALES      	CHICAGO 
-- WARD     	200 	SALES      	CHICAGO 
-- MARTIN   	300 	SALES      	CHICAGO 
-- TURNER      	0 	SALES      	CHICAGO 

-- 14. DALLAS에서 근무하는 사원의 이름,  급여, 등급을 출력하시오.
SELECT e.ename AS "이름", 
       e.sal AS "급여", 
       s.grade AS "등급"
FROM emp e
JOIN dept d ON e.deptno = d.deptno
JOIN locations l ON d.loc_code = l.loc_code
JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal
WHERE l.city = 'DALLAS';

-- 이름         급여             등급          
-- -------- --------- --------------
-- SMITH      800             1      
-- JONES      2975           4   
-- SCOTT     3000	           4
-- FORD       3000           4     

-- 15. 사원들의 이름, 부서번호, 부서명을 출력하시오. 
-- 단, 직원이 없는 부서도 출력하며 이경우 직원 이름을 '누구?'라고
-- 출력한다. 아직 부서 배치를 못받은 직원도  출력하며 부서 번호와 부서 이름을
-- '어디?' 이라고 출력한다.     (16행)
-- 부서명을 기준으로 정렬한다.
(SELECT IFNULL(e.ename, '누구?') AS "직원명", 
        IFNULL(CAST(d.deptno AS CHAR), '어디?') AS "부서번호", 
        IFNULL(d.dname, '어디?') AS "부서명"
 FROM emp e LEFT JOIN dept d ON e.deptno = d.deptno)
UNION
(SELECT IFNULL(e.ename, '누구?') AS "직원명", 
        IFNULL(CAST(d.deptno AS CHAR), '어디?') AS "부서번호", 
        IFNULL(d.dname, '어디?') AS "부서명"
 FROM emp e RIGHT JOIN dept d ON e.deptno = d.deptno)
ORDER BY 부서명 ASC;

-- 직원명   부서번호   부서명    
-- --------------------------------
-- CLARK  10      ACCOUNTING
-- KING   10       ACCOUNTING
-- MILLER 10       ACCOUNTING
-- 누구?  50        INSA      
-- 누구?  40        OPERATIONS
-- SMITH  20       RESEARCH  
-- JONES  20       RESEARCH  
-- SCOTT  20       RESEARCH  
-- FORD   20       RESEARCH  
-- ALLEN  30       SALES     
-- WARD   30       SALES     
-- MARTIN 30       SALES     
-- BLAKE  30       SALES     
-- TURNER 30       SALES     
-- JAMES  30       SALES     
-- ADAMS  어디?    어디?     


-- 16. 'CHICAGO' 에서 근무하는 직원들의 이름, 입사일, 급여를 출력한다.
--      (서브쿼리로 해결한다.)
SELECT ename, hiredate, sal 
FROM emp 
WHERE deptno IN (
    SELECT deptno 
    FROM dept 
    WHERE loc_code = (SELECT loc_code FROM locations WHERE city = 'CHICAGO')
);
-- ename   hiredate    sal  
--------------------------------
-- ALLEN   1981-02-20  1600 
-- WARD    1981-02-22  1250 
-- MARTIN  1981-09-28  1250 
-- BLAKE   1981-04-01  2850 
-- TURNER  1981-09-08  1500 
-- JAMES   1981-10-03   950 


-- 17. 'CHICAGO' 에서 근무하는 직원들의 이름, 입사일, 부서명을 출력한다.
--      (조인로 해결한다.)
SELECT e.ename, 
       e.hiredate, 
       d.dname
FROM emp e
JOIN dept d ON e.deptno = d.deptno
JOIN locations l ON d.loc_code = l.loc_code
WHERE l.city = 'CHICAGO';
-- ename   hiredate    dname 
-------------------------------------
-- ALLEN   1981-02-20  SALES 
-- WARD    1981-02-22  SALES 
-- MARTIN  1981-09-28  SALES 
-- BLAKE   1981-04-01  SALES 
-- TURNER  1981-09-08  SALES 
-- JAMES   1981-10-03  SALES 



-- 18. 'DALLAS' 에서 근무하는 직원들의 이름, 연봉, 부서명을 연봉이 큰 순으로 출력하는데
--      연봉의 계산은 (급여커미션)12  을 적용하는데 커미션이 정해지지않은 직원은 0으로 계산한다.
     
-- 이름   연봉   부서명   
------------------------
-- JONES  36060  RESEARCH 
-- SCOTT  36000  RESEARCH 
-- FORD   36000  RESEARCH 
-- SMITH   9600  RESEARCH 
SELECT e.ename AS "이름", 
       (e.sal + IFNULL(e.comm, 0)) * 12 AS "연봉", 
       d.dname AS "부서명"
FROM emp e
JOIN dept d ON e.deptno = d.deptno
JOIN locations l ON d.loc_code = l.loc_code
WHERE l.city = 'DALLAS'
ORDER BY 연봉 DESC;

-- 19 도시명 'SEOUL' 에서 근무중인 직원들의 인원을 출력하시오.
SELECT CONCAT(COUNT(*), '명') AS "인원수"
FROM emp e
JOIN dept d ON e.deptno = d.deptno
JOIN locations l ON d.loc_code = l.loc_code
WHERE l.city = 'SEOUL';
-- 인원수 
--------
--  3명    