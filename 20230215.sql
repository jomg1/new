--INSERT 문장을 통한 Transaction
INSERT INTO departments
VALUES(70, 'Public Relations', 100, 1700);

SELECT *
FROM departments;

ROLLBACK;

SELECT *
FROM departments;

COMMIT;

--다른 테이블로 ROW 복사
CREATE TABLE sales_reps
AS
SELECT employee_id id, last_name name, salary, commission_pct
FROM employees;

SELECT *
FROM sales_reps;

DELETE sales_reps;

--INSERT문 = > 치환변수 사용
INSERT INTO departments (department_id, department_name, location_id)
VALUES (&department_id, '&department_name', &location);

SELECT *
FROM departments;

--UPDATE 문장을 활용한 Transaction
UPDATE employees
SET salary = 7000;

SELECT *
FROM employees;

ROLLBACK;

UPDATE employees
SET salary = 7000
WHERE employee_id = 104;
--Transaction 종료
ROLLBACK;

UPDATE employees
SET salary = salary*1.1
WHERE employee_id = 104;

ROLLBACK;

SELECT *
FROM employees;

--서브쿼리를 이용한 UPDATE
UPDATE employees
SET job_id = (
               SELECT job_id
               FROM employees
               WHERE employee_id = 205),
    salary = (
               SELECT salary
               FROM employees
               WHERE employee_id = 205)
WHERE employee_id = 124;

UPDATE employees
SET department_id = 
                    (
                      SELECT department_id
                      FROM departments
                      WHERE department_name LIKE '%Public%')
WHERE employee_id = 206;

SELECT * FROM employees;
SELECT * FROM departments;

ROLLBACK;--롤백을 사용하면 첫번째 업데이트문부터 롤백이 됨.

--DELETE
DELETE FROM departments
WHERE department_name = 'Finance';

DELETE FROM employees
WHERE department_id =
                      (
                        SELECT department_id
                        FROM departments
                        WHERE department_name LIKE '%Public%');

ROLLBACK;

--TABLE DELETE & TRUNCATE - 테이블 데이터 삭제

--TABLE에서 DELETE => 데이터만 삭제
SELECT*
FROM sales_reps;

DELETE FROM sales_reps;
ROLLBACK;
--TABLE에서 TRUNCATE => 데이터와 데이터 보관하는 공간까지 삭제
TRUNCATE TABLE sales_reps;

INSERT INTO sales_reps
SELECT employee_id, last_name, salary, commission_pct
FROM employees
WHERE job_id LIKE '%REP%';

COMMIT;

DELETE FROM sales_reps
WHERE employee_id = 174;

SAVEPOINT spl;

DELETE FROM sales_reps
WHERE employee_id = 202;

ROLLBACK to spl;

ROLLBACK;
--테이블, 객체 조회 시 사용
SELECT table_name
FROM user_tables;

SELECT DISTINCT object_type
FROM user_objects; -- 오브젝트 안에 만들어진 객체가 존재한다면 출력 됨

SELECT DISTINCT *
FROM user_objects;

SELECT DISTINCT *
FROM user_catalog;

--table 생성
CREATE TABLE dept(
dept_no number(2),
dname varchar2(14),
loc varchar2(13),
create_date DATE DEFAULT sysdate);

desc dept;

INSERT INTO dept(dept_no, dname, loc)
VALUES(1,'또치','예담');

CREATE TABLE dept30
AS
    SELECT employee_id, last_name, salary*12 AS "salary", hire_date
    FROM employees
    WHERE department_id = 50;
    
SELECT * FROM dept30;
DESC employees;

DESC dept30;

DROP TABLE dept; --table 삭제
DROP TABLE dept30;

--Column 추가
ALTER TABLE dept30
ADD         (job VARCHAR2(20));

DESC dept30;

--수정
ALTER TABLE dept30
MODIFY      (job NUMBER);

INSERT INTO dept30
VALUES(1, '또치', 2000, SYSDATE, 123);

ALTER TABLE dept30
MODIFY      (job VARCHAR2(40)); --컬럼에 데이터가 있으면 수정 불가능

DELETE FROM dept30
WHERE employee_id = 1;

--열(Column) 삭제
ALTER TABLE dept30
DROP COLUMN job;

DESC dept30;

ALTER TABLE dept30
SET UNUSED (hire_date);

ALTER TABLE dept30
DROP UNUSED COLUMNS;

SELECT*
FROM dept30;

--RENAME (객체 이름 변경)
RENAME dept30 TO dept100;

SELECT*
FROM dept100;

--table 코멘트
COMMENT ON TABLE dept100
IS 'THIS IS DEPT100';
--table 코멘트 조회
SELECT *
FROM all_tab_comments
WHERE LOWER(table_name) = 'dept100';

--컬럼 코멘트
COMMENT ON COLUMN dept100.employee_id
IS 'THIS IS EMPLOYEE_ID';
--컬럼 코멘트 조회
SELECT *
FROM all_col_comments
WHERE LOWER(table_name) = 'dept100';

TRUNCATE TABLE dept100; --공간, 데이터 모두 삭제되어 롤백 해도 데이터가 들어갈 공간이 없음

SELECT* FROM dept100;

ROLLBACK;

DROP TABLE dept100;

--기본키(PK) 기본값 열을 포함하는 테이블 생성
DROP TABLE board;

CREATE TABLE dept(
                   deptno NUMBER(2) PRIMARY KEY, --기본 키
                   dname VARCHAR2(14),
                   loc VARCHAR2(13),
                   create_date DATE DEFAULT SYSDATE--기본값을 겨지는 열(Column)
                   );

INSERT INTO dept(deptno, dname)
VALUES (10, '기획부'); --기본값을 가지는 열(Column)에 데이터가 자동 입력

INSERT INTO dept
VALUES (20, '영업부', '서울', '23/02/15');

COMMIT;

SELECT *
FROM dept;

--여러가지 제약조건을 포함하는 테이블 생성
DROP TABLE emp;

CREATE TABLE emp(
empno NUMBER(6) PRIMARY KEY, --기본키 제약조건
ename VARCHAR2(25) NOT NULL, --NOT NULL 제약조건
email VARCHAR2(50) CONSTRAINT emp_mail_nn NOT NULL -- NOT NULL 제약조건 + 제약 조건 이름 부여
                   CONSTRAINT emp_mail_uk UNIQUE, --UNIQUE 제약 조건 + 제약 조건 이름 부여
phone_no CHAR(11) NOT NULL,
job VARCHAR2(20),
salary NUMBER(8) CHECK(salary>2000), --CHECK 제약 조건 2000보다 큰 데이터가 들어와아야 입력 가능
deptno NUMBER(4) REFERENCES dept(deptno)); --FOREIGN KEY 제약 조건, dept table에서 deptno라는 Column을 참조해서 데이터 입력.

--오류..
--CREATE TABLE emp(
----COLUMN LEVEL CONSTRAINT
--empno NUMBER(6) ,
--ename VARCHAR2(25) CONSTRAINT emp_ename_nn NOT NULL,
--email VARCHAR2(50)CONSTRAINT emp_email_nn  NOT NULL, 
--phone_no CHAR(11) NOT NULL,
--job VARCHAR2(20),
--salary NUMBER(8), 
--deptno NUMBER(4),
----TABLE LEVEL CONSTARINT
--CONSTRAINT emp_empno_pk PRIMARY KEY(empno),
--CONSTRAINT emp_email_uk UNIQUE(email),
--CONSTRAINT emp_salary_ck CHECK(salary>2000),
--CONSTRAINT emp_deptno_fk FOREIGN KEY (deptno)
--REFERENCES dept(deptno)
--);

--제약조건 관련 딕셔너리 정보 보기
SELECT constraint_name, constraint_type, search_condition
FROM user_constraints
WHERE table_name = 'EMP';

--컬럼별로 제약조건 알아보기 (join 활용)
SELECT cc.column_name, c.constraint_name
FROM user_constraints c JOIN user_cons_columns cc
ON (c.constraint_name = cc.constraint_name)
WHERE c.table_name = 'EMP';

--인덱스 확인(프라이머리, 유니크 키 인덱스 존재)
SELECT table_name, index_name
FROM user_indexes
WHERE table_name IN('DEPT', 'EMP');

--DML을 수행하며 제약조건 테스트하기
INSERT INTO emp
VALUES(null, '또치', 'ddoChiKim@naver.com', '01023456789', '회사원', 3500, null);

DESC emp;

INSERT INTO emp
VALUES(1234, '또치', 'ddoChiKim@naver.com', '01023456789', '회사원', 3500, null);

INSERT INTO emp
VALUES(1233, '희동', 'heeeedong@naver.com', '01054359785', null, 1800, 20);

INSERT INTO emp
VALUES(1233, '희동', 'heeeedong@naver.com', '01054359785', null, 7800, 20);

--INSERT INTO emp
--VALUES(1233, '희동', 'heeeedong@naver.com', '01054359785', null, 7800, 100);
--참조 관계 값 확인해야함 dept table의 deptno는 10,20 뿐임

COMMIT;

SELECT *
FROM emp;

SELECT *
FROM dept;

--UPDATE
UPDATE emp
SET deptno = 10
WHERE empno = 1234;

--제약조건 추가
ALTER TABLE emp
ADD CONSTRAINT emp_job_uk UNIQUE(job);

INSERT INTO emp
VALUES(1200, '길동', 'gildong@naver.com', '01054359785', '회사원', 5400, 20);

ALTER TABLE emp
MODIFY(salary number NOT NULL);

--제약조건 삭제
ALTER TABLE emp
DROP CONSTRAINT emp_job_uk;

--1) 슈퍼의 정보
---> 가게 번호, 가게 명, 주소, 연락처, 매출
--단,
--1-1) 가게 번호는 최대 5개
--1-2) 가게 명 최대 10글자
--1-3) 주소 최대 50글자
--1-4) 연락처 최대 13글자
--1-5) 매출 6자리, 1000원 이상 입력

CREATE TABLE superinfo(
                        supno NUMBER, 
                        supname VARCHAR2(30),
                        adress VARCHAR2(150),
                        tel NUMBER(13),
                        sales NUMBER(6) CHECK(sales>1000)
                   );

CREATE TABLE productinfo(
                          prdno NUMBER(4),
                          prdname CHAR(30),
                          price NUMBER(5,0) CHECK(price>100)
                          how ,
                          supno NUMBER REFERENCES superinfo(supno));
