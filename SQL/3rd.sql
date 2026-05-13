# 다행함수 (그룹함수)

select user(), database();

# 1. 데이터베이스 생성
create database if not exists youDB;		-- youDB 가 없으면 생성
use youDB;

# 2. 테이블 생성
create table m_emp(
		p_id int primary key,			-- not null, unique
		p_name char(20) not null,	-- not null, 중복 ok
		p_age tinyint not null,		-- not null , 중복 ok
        p_number varchar(20) default '없음'	-- null ok, 없으면 없음이라고 표시
);
desc m_emp;

# 3. DML : 데이터 key-in
# insert into m_emp(컬럼명, ...) values(data, ...);
insert into m_emp values(1, '강경태', 33, default);
insert into m_emp values(10, '강경태', 33, default);
insert into m_emp values (2, '김태민', 41, '010-1234-1234');
insert into m_emp values (3, '이은희', 18, '010-9876-2566');
insert into m_emp values(4, '정재윤', 61, default);
insert into m_emp values(5, '허수연', 20, default);
insert into m_emp values(6, '문창호', 63, '010-1209-8807');
#rollback;
#commit;

select * from m_emp;

# 4. DQL
select @@autocommit; # 0이면 autocommit이 아님

# 이름과 연령대만 조회
select p_name as 이름, concat((p_age div 10) * 10, '대') as 연령대 from m_emp;
select p_name as 이름, concat(truncate(p_age, -1), '대') as 연령대 from m_emp;
select p_name,		case
							when p_age between 10 and 19 then '10대'
							when p_age between 20 and 29 then '20대'
							when p_age between 30 and 39 then '30대'
							when p_age between 40 and 49 then '40대'
							when p_age between 50 and 59 then '50대'
							when p_age between 60 and 69 then '60대'
							else '70대 이상' end as '연령대' from m_emp;
                            
create table box_office (
seq_no INT PRIMARY KEY,
years SMALLINT,
ranks INT,
movie_name VARCHAR(200),
release_date DATETIME,
sale_amt DOUBLE,
share_rate DOUBLE,
audience_num INT,
screen_num SMALLINT,
showing_count INT,
rep_country VARCHAR(50),
countries VARCHAR(100),
distributor VARCHAR(300),
movie_type VARCHAR(100),
genre VARCHAR(100),
director VARCHAR(1000) );

desc box_office;

select count(*) from box_office;

use world;
desc country;
select * from country;

# Q. 1
select row_number() over(order by population desc) as 'No.', code as '국가코드', concat(name, '<', Continent, '>') as '국가<대륙>', region as '대륙내 지역', format(population, 0) as '인구' from country where population between 40000000 and 60000000;
# Q. 2
select row_number() over(order by IndepYear) as 'No.' , Name as '국가명', concat(if(indepyear > 0, 'AD ', 'BC '), abs(indepyear)) as '개국년도' from country where indepyear is not null limit 10;

# Q. 3
use youdb;
select * from box_office;
select  row_number() over(order by sale_amt desc) as 'No.', years as '제작년도', movie_name as '영화제목', date_format(release_date, '%Y-%b-%e') as '개봉일', concat(format(audience_num, 0), '명') as '관객수', concat(left(sale_amt, 3), '억') as '총매출'  from box_office where (years = 2019) and (audience_num between 3000000 and 7000000 or sale_amt between 18000000000 and 50000000000);

# Q. 4
select * from box_office where years = 2014 and date_format(release_date, '%Y') between 2018 and 2019;
# Q. 5
select distinct movie_name as '영화', date_format(release_date, '%Y%m') as '개봉년월',  replace(director, ',', '/') as '감독그룹' from box_office where date_format(release_date, '%Y%m') = 201711 and movie_name like '%:%' and director like '%,%';

# Q. 6
select years as '제작년도', movie_name as '영화명', rep_country as '배포국가', date_format(release_date, '%Y%m') as '개봉년월' from box_office where (years between 2018 and 2019) and (audience_num > 10000000) and ((rep_country like '한국')or(rep_country like '미국'));
