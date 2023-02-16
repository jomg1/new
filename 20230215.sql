--INSERT ������ ���� Transaction
INSERT INTO departments
VALUES(70, 'Public Relations', 100, 1700);

SELECT *
FROM departments;

ROLLBACK;

SELECT *
FROM departments;

COMMIT;

--�ٸ� ���̺�� ROW ����
CREATE TABLE sales_reps
AS
SELECT employee_id id, last_name name, salary, commission_pct
FROM employees;

SELECT *
FROM sales_reps;

DELETE sales_reps;

--INSERT�� = > ġȯ���� ���
INSERT INTO departments (department_id, department_name, location_id)
VALUES (&department_id, '&department_name', &location);

SELECT *
FROM departments;

--UPDATE ������ Ȱ���� Transaction
UPDATE employees
SET salary = 7000;

SELECT *
FROM employees;

ROLLBACK;

UPDATE employees
SET salary = 7000
WHERE employee_id = 104;
--Transaction ����
ROLLBACK;

UPDATE employees
SET salary = salary*1.1
WHERE employee_id = 104;

ROLLBACK;

SELECT *
FROM employees;

--���������� �̿��� UPDATE
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

ROLLBACK;--�ѹ��� ����ϸ� ù��° ������Ʈ������ �ѹ��� ��.

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

--TABLE DELETE & TRUNCATE - ���̺� ������ ����

--TABLE���� DELETE => �����͸� ����
SELECT*
FROM sales_reps;

DELETE FROM sales_reps;
ROLLBACK;
--TABLE���� TRUNCATE => �����Ϳ� ������ �����ϴ� �������� ����
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
--���̺�, ��ü ��ȸ �� ���
SELECT table_name
FROM user_tables;

SELECT DISTINCT object_type
FROM user_objects; -- ������Ʈ �ȿ� ������� ��ü�� �����Ѵٸ� ��� ��

SELECT DISTINCT *
FROM user_objects;

SELECT DISTINCT *
FROM user_catalog;

--table ����
CREATE TABLE dept(
dept_no number(2),
dname varchar2(14),
loc varchar2(13),
create_date DATE DEFAULT sysdate);

desc dept;

INSERT INTO dept(dept_no, dname, loc)
VALUES(1,'��ġ','����');

CREATE TABLE dept30
AS
    SELECT employee_id, last_name, salary*12 AS "salary", hire_date
    FROM employees
    WHERE department_id = 50;
    
SELECT * FROM dept30;
DESC employees;

DESC dept30;

DROP TABLE dept; --table ����
DROP TABLE dept30;

--Column �߰�
ALTER TABLE dept30
ADD         (job VARCHAR2(20));

DESC dept30;

--����
ALTER TABLE dept30
MODIFY      (job NUMBER);

INSERT INTO dept30
VALUES(1, '��ġ', 2000, SYSDATE, 123);

ALTER TABLE dept30
MODIFY      (job VARCHAR2(40)); --�÷��� �����Ͱ� ������ ���� �Ұ���

DELETE FROM dept30
WHERE employee_id = 1;

--��(Column) ����
ALTER TABLE dept30
DROP COLUMN job;

DESC dept30;

ALTER TABLE dept30
SET UNUSED (hire_date);

ALTER TABLE dept30
DROP UNUSED COLUMNS;

SELECT*
FROM dept30;

--RENAME (��ü �̸� ����)
RENAME dept30 TO dept100;

SELECT*
FROM dept100;

--table �ڸ�Ʈ
COMMENT ON TABLE dept100
IS 'THIS IS DEPT100';
--table �ڸ�Ʈ ��ȸ
SELECT *
FROM all_tab_comments
WHERE LOWER(table_name) = 'dept100';

--�÷� �ڸ�Ʈ
COMMENT ON COLUMN dept100.employee_id
IS 'THIS IS EMPLOYEE_ID';
--�÷� �ڸ�Ʈ ��ȸ
SELECT *
FROM all_col_comments
WHERE LOWER(table_name) = 'dept100';

TRUNCATE TABLE dept100; --����, ������ ��� �����Ǿ� �ѹ� �ص� �����Ͱ� �� ������ ����

SELECT* FROM dept100;

ROLLBACK;

DROP TABLE dept100;

--�⺻Ű(PK) �⺻�� ���� �����ϴ� ���̺� ����
DROP TABLE board;

CREATE TABLE dept(
                   deptno NUMBER(2) PRIMARY KEY, --�⺻ Ű
                   dname VARCHAR2(14),
                   loc VARCHAR2(13),
                   create_date DATE DEFAULT SYSDATE--�⺻���� ������ ��(Column)
                   );

INSERT INTO dept(deptno, dname)
VALUES (10, '��ȹ��'); --�⺻���� ������ ��(Column)�� �����Ͱ� �ڵ� �Է�

INSERT INTO dept
VALUES (20, '������', '����', '23/02/15');

COMMIT;

SELECT *
FROM dept;

--�������� ���������� �����ϴ� ���̺� ����
DROP TABLE emp;

CREATE TABLE emp(
empno NUMBER(6) PRIMARY KEY, --�⺻Ű ��������
ename VARCHAR2(25) NOT NULL, --NOT NULL ��������
email VARCHAR2(50) CONSTRAINT emp_mail_nn NOT NULL -- NOT NULL �������� + ���� ���� �̸� �ο�
                   CONSTRAINT emp_mail_uk UNIQUE, --UNIQUE ���� ���� + ���� ���� �̸� �ο�
phone_no CHAR(11) NOT NULL,
job VARCHAR2(20),
salary NUMBER(8) CHECK(salary>2000), --CHECK ���� ���� 2000���� ū �����Ͱ� ���;ƾ� �Է� ����
deptno NUMBER(4) REFERENCES dept(deptno)); --FOREIGN KEY ���� ����, dept table���� deptno��� Column�� �����ؼ� ������ �Է�.

--����..
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

--�������� ���� ��ųʸ� ���� ����
SELECT constraint_name, constraint_type, search_condition
FROM user_constraints
WHERE table_name = 'EMP';

--�÷����� �������� �˾ƺ��� (join Ȱ��)
SELECT cc.column_name, c.constraint_name
FROM user_constraints c JOIN user_cons_columns cc
ON (c.constraint_name = cc.constraint_name)
WHERE c.table_name = 'EMP';

--�ε��� Ȯ��(�����̸Ӹ�, ����ũ Ű �ε��� ����)
SELECT table_name, index_name
FROM user_indexes
WHERE table_name IN('DEPT', 'EMP');

--DML�� �����ϸ� �������� �׽�Ʈ�ϱ�
INSERT INTO emp
VALUES(null, '��ġ', 'ddoChiKim@naver.com', '01023456789', 'ȸ���', 3500, null);

DESC emp;

INSERT INTO emp
VALUES(1234, '��ġ', 'ddoChiKim@naver.com', '01023456789', 'ȸ���', 3500, null);

INSERT INTO emp
VALUES(1233, '��', 'heeeedong@naver.com', '01054359785', null, 1800, 20);

INSERT INTO emp
VALUES(1233, '��', 'heeeedong@naver.com', '01054359785', null, 7800, 20);

--INSERT INTO emp
--VALUES(1233, '��', 'heeeedong@naver.com', '01054359785', null, 7800, 100);
--���� ���� �� Ȯ���ؾ��� dept table�� deptno�� 10,20 ����

COMMIT;

SELECT *
FROM emp;

SELECT *
FROM dept;

--UPDATE
UPDATE emp
SET deptno = 10
WHERE empno = 1234;

--�������� �߰�
ALTER TABLE emp
ADD CONSTRAINT emp_job_uk UNIQUE(job);

INSERT INTO emp
VALUES(1200, '�浿', 'gildong@naver.com', '01054359785', 'ȸ���', 5400, 20);

ALTER TABLE emp
MODIFY(salary number NOT NULL);

--�������� ����
ALTER TABLE emp
DROP CONSTRAINT emp_job_uk;

--1) ������ ����
---> ���� ��ȣ, ���� ��, �ּ�, ����ó, ����
--��,
--1-1) ���� ��ȣ�� �ִ� 5��
--1-2) ���� �� �ִ� 10����
--1-3) �ּ� �ִ� 50����
--1-4) ����ó �ִ� 13����
--1-5) ���� 6�ڸ�, 1000�� �̻� �Է�

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
