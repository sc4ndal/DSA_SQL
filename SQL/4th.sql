# Set & Join

# 테이블 생성
create table t1(no int, name char(20), java tinyint);
create table t2(no int, name char(20), java tinyint);

# DML : insert
select * from t1;
select * from t2;

insert into t1 values(1, '강경태', round(rand()*100,0));
insert into t1 values
row(2, '박시윤', round(rand()*100,0)),
row(3, '김태민', round(rand()*100,0)),
row(4, '이은희', round(rand()*100,0));

update t1 set java = 3 where no = 1;

insert into t2 values(9, '정휘원', round(rand()*100,0));
insert into t2 values
row(10, '정재윤', round(rand()*100,0)),
row(11, '허수연', round(rand()*100,0)),
row(12, '윤창호', round(rand()*100,0));

commit;
select * from t1;
select * from t2;

# DML : update
# 84 -> 100	# 이은희
update t1 set java = 100 where no = 4;

# 89 -> 91		# 허수연
update t2 set java = 91 where no = 11;

# 합집합
select * from t1
union all		# -> all 쓰면 중복값도 출력, 안 하면 중복값 제거
select * from t2;

# DDL : 테이블 카피 명령어
create table t3 as select * from t1 union select * from t2;
select * from t3;

# 교집합
select * from t1 where exists(select * from t3 where t1.no=t3.no);

# 차집합 (t1-t2)
select * from t1 where no not in (select no from t2);
# 차집합 (t2-t1)
select * from t2 where no not in (select no from t1);

select * from t1;		# 5개
select count(*) from t2;		# 4개
# Cartesian product(카테샨 조인, cross)
select count(*) from t1, t2;		#20개
select * from t1, t2;

use world;
# 국가코드(COUNTRY), 국가명(COUNTRY), 지역명(DISTRICT), 도시명(NANE), 인구 출력(POPULATION) JOIN
DESC CITY;
DESC COUNTRY;
select * from city;
select * from country;
select * from countrylanguage;
#CITY 필요값
SELECT COUNTRYCODE, NAME, DISTRICT, POPULATION FROM CITY;
# COUNTRY 필요값
SELECT CODE, NAME FROM COUNTRY;
#JOIN : CITY, COUNTRY
# -------------------------------------------------------------------------------------
# Q. 1
SELECT 
countrycode '국가코드', district '지역명', ct.name '도시명', ctry.name '국가명', ctry.population '국가인구', ct.population '도시인구'
FROM city ct, country ctry WHERE ct.countrycode= ctry.code;
# -------------------------------------------------------------------------------------
# Q. 2
select
ctry.name '국가명', language '사용언어', isofficial '공식언어유무', percentage '사용 비율'
from country ctry, countrylanguage lang where ctry.code = lang.countrycode;
# -------------------------------------------------------------------------------------
# Q. 3
select
ctry.name '국가명', count(ct.name) '도시수'
from country ctry, city ct where ctry.code = ct.countrycode group by ctry.name having count(ct.name) between 60 and 150 order by 2 desc;
# -------------------------------------------------------------------------------------
# Q. 4
# 1)
create table tt as
select
ctry.name '국가명', count(ct.name) '도시수'
from country ctry, city ct where ctry.code = ct.countrycode group by ctry.name having count(ct.name) between 60 and 150 order by 2 desc;

desc tt;
select 국가명, sum(도시수) '도시갯수' from tt group by 국가명 with rollup order by 2 desc;

# 2) <- 서브쿼리 감싸고 별칭을 줘야함.
select 국가명, sum(도시수) from
(select ctry.name '국가명', count(ct.name) '도시수'
from country ctry, city ct where ctry.code = ct.countrycode group by ctry.name having count(ct.name) between 60 and 150 order by 2 desc)
as t group by 국가명 with rollup order by 2 desc;

# DATA DICTIONARY
show create table city;
/*
CREATE TABLE `city` (
   `ID` int NOT NULL AUTO_INCREMENT,
   `Name` char(35) NOT NULL DEFAULT '',
   `CountryCode` char(3) NOT NULL DEFAULT '',
   `District` char(20) NOT NULL DEFAULT '',
   `Population` int NOT NULL DEFAULT '0',
   PRIMARY KEY (`ID`),
   KEY `CountryCode` (`CountryCode`),
   CONSTRAINT `city_ibfk_1` FOREIGN KEY (`CountryCode`) REFERENCES `country` (`Code`)
 ) ENGINE=InnoDB AUTO_INCREMENT=4080 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
*/
show create table country;
/*
CREATE TABLE `country` (
   `Code` char(3) NOT NULL DEFAULT '',
   `Name` char(52) NOT NULL DEFAULT '',
   `Continent` enum('Asia','Europe','North America','Africa','Oceania','Antarctica','South America') NOT NULL DEFAULT 'Asia',
   `Region` char(26) NOT NULL DEFAULT '',
   `SurfaceArea` decimal(10,2) NOT NULL DEFAULT '0.00',
   `IndepYear` smallint DEFAULT NULL,
   `Population` int NOT NULL DEFAULT '0',
   `LifeExpectancy` decimal(3,1) DEFAULT NULL,
   `GNP` decimal(10,2) DEFAULT NULL,
   `GNPOld` decimal(10,2) DEFAULT NULL,
   `LocalName` char(45) NOT NULL DEFAULT '',
   `GovernmentForm` char(45) NOT NULL DEFAULT '',
   `HeadOfState` char(60) DEFAULT NULL,
   `Capital` int DEFAULT NULL,
   `Code2` char(2) NOT NULL DEFAULT '',
   PRIMARY KEY (`Code`)
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
 */
 show create table scit_tab;
 /*
CREATE TABLE `scit_tab` (
   `my_name` char(10) DEFAULT NULL,
   `my_team` int DEFAULT NULL
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
 */
 
 desc information_schema.KEY_COLUMN_USAGE;
 desc information_schema.TABLE_CONSTRAINTS;
 desc information_schema.REFERENTIAL_CONSTRAINTS;
 
 select * from information_schema.KEY_COLUMN_USAGE where CONSTRAINT_SCHEMA = 'WORLD';
 
 # 부모테이블 생성
 use youdb;
 drop table p_test;
 create table p_test(
		p_id int primary key auto_increment,
        p_name varchar(20) not null unique,
        p_age tinyint not null,		# 컬럼 레벨 제약조건
        
        check (22 <= p_age and p_age <= 37)		# 테이블 레벨 제약조건
 );

 # 자식테이블 생성
 drop table c_test;
 create table c_test(
		c_id int primary key,
        c_add varchar(20),
        
        constraint my_fk1 foreign key (c_id) references p_test(p_id)
 );
 
desc information_schema.KEY_COLUMN_USAGE;
desc information_schema.TABLE_CONSTRAINTS;
desc information_schema.REFERENTIAL_CONSTRAINTS;
 
select * from information_schema.KEY_COLUMN_USAGE where CONSTRAINT_SCHEMA = 'youdb';
select * from information_schema.TABLE_CONSTRAINTS where CONSTRAINT_SCHEMA = 'youdb';
select * from information_schema.REFERENTIAL_CONSTRAINTS where CONSTRAINT_SCHEMA = 'youdb';

select * from information_schema.KEY_COLUMN_USAGE, information_schema.TABLE_CONSTRAINTS, information_schema.REFERENTIAL_CONSTRAINTS;

desc p_test;
desc c_test;

# insert 부모
select * from p_test;
insert into p_test(p_name, p_age) values ('시윤', 30);	# 1
insert into p_test(p_name, p_age) values ('김상', 37);	# 2
insert into p_test values (11, '정식', 35);						# 11
insert into p_test(p_name, p_age) values ('노은', 22);	# 12
insert into p_test values (3, '태웅', 28);						# 3
insert into p_test(p_name, p_age) values ('미연', 25);	# 13
commit;

# insert 자식
desc c_test;
select * from c_test;
insert into c_test values(1, '부원동');
insert into c_test values(13, '중앙동');
insert into c_test values(11, '주거지없음');

select * from p_test p, c_test c where p.p_id = c.c_id;

# 부모삭제 시도
delete from p_test;
delete from p_test where p_id = 11;	# 정식 삭제

# 자식 먼저 삭제 -> 부모 삭제
delete from c_test where c_id = 11;
delete from p_test where p_id = 11;

select * from p_test;
select * from c_test;
