use edudb;
select * from emp;
-- QUESTION

-- 1. 사원 테이블에서 사원이름을 소문자로 출력하고 컬럼명을 사원이름으로 설정하시오.
--              사원이름
--           ----------------
--                smith
select lower(ename) as '사원이름' from emp;

-- 2. 사원테이블에서 사원이름과 사원 이름의 두번째 글자부터 다섯번째까지, 앞에서 2개, 뒤에서 3개를
-- 출력하시오.
--                 사원이름    2-5문자   앞에서 2개     뒤에서 3개
--                  ---------------------------------------
--                  SMITH     MITH         SM               ITH
--		:	:             :                 :
select ename as '사원이름', substr(ename,2,4) as '2-5문자', substr(ename,1,2) as '앞에서 2개', substr(ename,-3) as '뒤에서 3개' from emp;

-- 3. 사원테이블의 사원 이름의 문자 개수를 출력하시오. 컬럼명은 '사원명 문자갯수'
--                 사원명 문자갯수
--                  ----------------
--                       5
--                       :		
select length(ename) as '사원명 문자갯수' from emp;

-- 4. 사원테이블에서 사원 이름의 앞 글자 하나와 마지막 글자 하나만 출력하되 
-- 모두 소문자로 각각 출력하시오.
--                    사원명    결과
-- 				-----------------
--  				SMITH   sh   
--                  ALLEN   an   
--                                :
select ename AS "사원명", LOWER(CONCAT(LEFT(ename, 1), RIGHT(ename, 1))) AS "결과" from emp;

-- 5. 3456.78을 반올림하여 소수점 아래 첫번째 자리 까지만 나타내시오.
select round(3456.78, 1);

-- 6. 월급에 50를 곱하고 백단위는 절삭하여 출력하는데 월급뒤에 '원'을 붙이고 
--    천단위마다 ','를 붙여서 출력한다.
-- 	계산 결과
--     ---------------
--      40,000원
-- 	80,000원
-- 	62,500원
--  	148,000원
--                :
SELECT CONCAT(FORMAT(TRUNCATE(sal * 50, -3), 0), '원') AS "계산 결과" FROM emp;

-- 7. 직원 이름과 커미션 설정 여부를 출력하는데 설정되었으면 커미션 값을
--    설정되지 않았으면 '미정'을 출력하시오.
-- 	 사원명	결과	
-- ---------------------------
-- --	SMITH	미정	
-- --	ALLEN	300
--                :	
select ename as '사원명', ifnull(cast(comm AS CHAR), '미정') as '결과' from emp;

-- 8. 직원 이름과 커미션 설정 여부를 출력하는데 설정되었으면 '설정됨'을 
--    설정되지 않았으면 '설정안됨'을 출력하시오.
--     사원명	결과	
-- ---------------------------
-- --	  SMITH	설정안됨	
-- --	  ALLEN	설정됨	
-- 	        :
select ename as '사원명', if(comm is not null , '설정됨', '설정안됨') as '결과' from emp;
    
-- 9. 직원 이름과 부서번호 그리고 부서번호에 따른 부서명을 출력하시오.
--    부서가 없는 직원은 '없당' 을 출력하시오.
--    (부서명 : 10 이면 'A 부서', 20 이면 'B 부서', 30 이면 'C 부서')
--    사원명	결과	
-- ---------------------------
-- --	 SMITH	B부서	
-- --	 ALLEN	C부서	
-- 	    :   
select ename as '사원명', case deptno when 10 then 'A 부서' when 20 then 'B 부서' when 30 then 'C 부서' else '없당' end as '결과' from emp;

-- 10. 사원테이블에서 이름의 첫글자가 A이고 마지막 글자가 N이 아닌 사원의
-- 이름을 출력하시오.

select ename from emp where ename like 'A%' and ename not like '%N';

-- 11. 직원의 이름,  급여, 연봉을 조회하는 질의를 작성하시오.
-- (단, 직원의 연봉은 200의 월 보너스를 포함하여 계산한다.)


--     이름              급여               연봉
-- -------------------------------------------------
-- 	SMITH             800                 12000
-- 	ALLEN            1600                21600
-- 	WARD             1250               17400
--     			:
select ename as '이름', sal as '급여', (sal + 200) * 12 AS '연봉' from emp;


-- 12.  다음과 같이 급여가 0~1000이면 'A', 1001~2000이면 'B', 2001~3000이면 'C', 
--            3001~4000이면 'D', 4001이상이면 'E'를 '코드'라는 열에 출력한다.

-- --       이름        월급   코드 
-- --       -----------------------
--         SMITH    800      A    
--  	ALLEN   1600      B    
--  	WARD    1250     B  
-- 		:  
SELECT ename AS "이름", sal AS "월급", CASE WHEN sal BETWEEN 0 AND 1000 THEN 'A' WHEN sal BETWEEN 1001 AND 2000 THEN 'B' WHEN sal BETWEEN 2001 AND 3000 THEN 'C' WHEN sal BETWEEN 3001 AND 4000 THEN 'D'
ELSE 'E'  END AS "코드" FROM emp;

-- 13. 이름의 두번째 문자가 “A”인 모든 직원의 이름을 조회하는 질의를 작성하시오. (두 개의 SELECT 명령을 작성하는데 하나는 like 연산자를 다른 하나는 함수로 해결하시오)

--      ENAME
--     ----------
-- 	WARD 
-- 	MARTIN
-- 	JAMES
SELECT ename FROM emp WHERE ename LIKE '_A%';
SELECT ename FROM emp WHERE SUBSTR(ename, 2, 1) = 'A';

-- 14. 직원의 이름, 급여, 커미션, 연봉을 조회하는 질의를 작성하시오.
-- (단, 직원의 연봉은 (급여+커미션)*12 로 계산하는데 커미션이 정해지지 않은 직원은 0으로 계산한다.)


--     이름       급여     커미션       연봉
-- -------------------------------------------------
-- 	 SMITH      800      NULL      9600 
-- 	 ALLEN     1600     300        22800 
-- 	 WARD      1250     200        17400
--     			:
select ename as '이름', sal as '급여', comm as '커미션', (sal + IFNULL(comm, 0)) * 12 AS "연봉" from emp;

-- 15. 오늘날짜와 오늘날짜에서 10일을 더한 날짜를 출력하는 SQL 명령을 작성하시오.
SELECT CURDATE(), DATE_ADD(CURDATE(), INTERVAL 10 DAY);


-- 16. 현재 시간을 "....년 ..월 ..일 ..시 ..분" 으로 출력하는 SQL 명령을 작성하시오. 컬럼명은 "현재시간"으로 설정한다.
SELECT DATE_FORMAT(NOW(), '%Y년 %m월 %d일 %H시 %i분') AS "현재시간";

-- 17.   모든 직원의 이름과 현재까지의 입사기간을 월단위로 조회하는 SQL  명령을 작성하시오.
--   (이때, 입사기간에 해당하는 열별칭은 “MONTHS WORKED”로 하고,   
--  입사기간이 가장 큰 직원순(입사한지 오래된 순)으로 정렬한다.)
--  (결과는 테스트하는 날짜에 따라서 다름)
-- 출력예)
-- ENAME         MONTHS WORKED
-- ------------------------------
-- SMITH             543 
-- ALLEN             541 
--      :

SELECT ename, 
       PERIOD_DIFF(DATE_FORMAT(NOW(), '%Y%m'), DATE_FORMAT(hiredate, '%Y%m')) AS "MONTHS WORKED" 
FROM emp 
ORDER BY hiredate ASC;

-- 18. 사원테이블에서 사원이름과 사원들의 오늘 날짜까지의 근무일수를 구하는 SQL 명령을 작성하시오.
--  (결과는 테스트하는 날짜에 따라서 다름...ㅎ)
-- 사원이름   근무일수
-- -----------------------
-- SMITH     16540일  
-- ALLEN     16475일  
--       :
select ename as '사원이름', CONCAT(datediff(NOW(), hiredate), '일') as '근무일수' from emp;

-- 19. 1981년도에 입사한 직원들의 이름, 직무 그리고 입사일을 입사한 순으로 출력하는 SQL  명령을 작성하시오.
SELECT ename, job, hiredate 
FROM emp 
WHERE YEAR(hiredate) = 1981 
ORDER BY hiredate ASC;

-- 20. 내 생일을 기준으로 요일을 출력하는 SQL 명령을 작성하시오.(요일을 숫자로)
SELECT DAYOFWEEK('1999-12-25');

-- 21. 내 생일을 기준으로 요일을 출력하는 SQL 명령을 작성하시오.(요일을 요일명으로)
SELECT DAYNAME('1999-12-25');

-- 22. 현재를 기준으로 내가 태어난지 몇 개월 되었는지 알 수 있는 SQL 명령을 작성하시오.
SELECT PERIOD_DIFF(DATE_FORMAT(NOW(), '%Y%m'), DATE_FORMAT('1999-12-25', '%Y%m')) AS "몇 개월";
