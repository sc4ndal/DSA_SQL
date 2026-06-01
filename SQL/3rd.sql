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
seq_no INT PRIMARY KEY,		# --> 기본키
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
select row_number() over(order by population desc) as 'No.', 
code as '국가코드', concat(name, ' <', Continent, '>') as '국가<대륙>', 
region as '대륙내 지역', format(population, 0) as '인구' from country where population between 40000000 and 60000000;		# --> format(숫자, 0) -> 숫자를 3자리수마다 , 찍고 0으로 하면 상수로 끊음
# row_number() over(정렬식) 으로 정렬해서 번호 부여하고 마지막에 order by 로 정렬하면 order by 기준으로 정렬돼서 부여한 번호 엉망으로 됨

# Q. 2
select row_number() over(order by IndepYear) as 'No.' , Name as '국가명', 
concat(if(indepyear > 0, 'AD ', 'BC '), abs(indepyear)) as '개국년도' from country where indepyear is not null limit 10;

select row_number() over(order by indepyear) as 'No.', name as '국가명', 
concat(case 	when indepyear < 0 then 'BC '		# 0 보다 작으면 BC
						when indepyear > 0 then 'AD ' end, abs(indepyear)) as '개국년도' from country where indepyear is not null limit 10;		# abs는 절대값

# Q. 3
use youdb;
select * from box_office;

select  row_number() over(order by sale_amt desc) as 'No.', years as '제작년도', movie_name as '영화제목', 
date_format(release_date, '%Y-%b-%e') as '개봉일', concat(format(audience_num, 0), '명') as '관객수', 
concat(sale_amt div pow(10,8), '억') as '총매출'  from box_office where (year(release_date) = '2019') and (audience_num/pow(10,4) between 300 and 700 or sale_amt/pow(10, 8) between 180 and 500);

# Q. 4
select * from box_office where (years = 2014) and (year(release_date) between 2018 and 2019);

# Q. 5
use youDB;
select distinct movie_name as '영화', date_format(release_date, '%Y%m') as '개봉년월',  replace(director, ',', '/') as '감독그룹' from box_office where movie_name like '%:%' and director like '%,%' and date_format(release_date, '%Y%m') = 201711;
select distinct movie_name as '영화', date_format(release_date, '%Y%m') as '개봉년월',  replace(director, ',', '/') as '감독그룹' 
from box_office where extract(year_month from release_date) = 201711  	# extract 는 날짜 추출
and (movie_name like '%:%') and (director like '%,%' );

# Q. 6
# round -8로 상수 8번째 자리 반올림
# 6-1
select years as '제작년도', movie_name as '영화명', rep_country as '배포국가', date_format(release_date, '%Y%m') as '개봉년월', format(audience_num, 0) as '관객수', concat(round(sale_amt, -8) div 100000000, '억원') as '매출' from box_office where (years between 2018 and 2019) and (audience_num >= 10000000) and ((rep_country like '한국')or(rep_country like '미국')) order by audience_num desc;
# 6-2
select years as '제작년도', movie_name as '영화명', rep_country as '배포국가', 
date_format(release_date, '%Y%m') as '개봉년월', format(audience_num, 0) as '관객수', concat(round(sale_amt, -8) / pow(10, 8), '억원') 	# pow(10, 8) -> 10*8 제거
as '매출' from box_office where (years between 2018 and 2019) and (audience_num >= 10000000) and (rep_country in ('한국', '미국')) order by audience_num desc;

# Q. 7
use world;
desc city;
select * from city;
# with rollup 은 총 합계 출력
select countrycode as '국가코드', count(name) as '도시수' from city group by countrycode with rollup order by count(name) desc limit 15;
select countrycode as '국가코드', count(name) as '도시수' from city group by countrycode with rollup order by 2 desc limit 15;		# 2 번째 칼럼 기준 정렬

# Q. 8
select countrycode as 'CountryCode', count(name) as 'num of city' from city where population >= 2000000 group by countrycode having count(name) >=4 order by count(name) desc;

# Q. 9
use world;
select * from country;
select count(code) as '총국가수', (select count(code) from country where indepyear is null) as '독립년도가 없는 국가' , 
(select count(code) from country where indepyear is not null) as '독립년도가 있는 국가' from country;

select count(*) as '총 국가 수', count(*) - count(indepyear) as '독립년도가 없는 국가 수', 
sum(case when indepyear is not null then 1 else 0 end) as '독립년도가 있는 국가 수' 
     from country group by indepyear with rollup order by count(*) desc limit 1;

select count(indepyear) as '독립년도 있는 국가 수', 
      count(*) - count(indepyear) as '독립년도 없는 국가수'
from country;

# Q.10
use youDB;
select * from box_office;
desc box_office;

# 10-1
select year(release_date) as '년도', format(count(*), 0) as '년도별 개봉영화 수',
sum(case when quarter(release_date) in (1,2) then 1 else 0 end) as '상반기 개봉영화수',		# case when 값 then 있으면값 else 없으면값 end 문법 else 는 꼭 지정 안 해도 됨
sum(case when quarter(release_date) in (3,4) then 1 else 0 end) as '하반기 개봉영화수'
from box_office where year(release_date) between 2004 and 2013 
group by year(release_date) with rollup order by 1;		# year(release_date) 년도를 group by 로 묶고 with rollup 으로 총 합을 구하고 첫번째 컬럼을 기준으로 내림차순 정렬

select (case when grouping(year(release_date)) = 1 then '총' else year(release_date) end) as '년도', format(count(*), 0) as '년도별 개봉영화 수',
sum(case when quarter(release_date) in (1,2) then 1 else 0 end) as '상반기 개봉영화수',
sum(case when quarter(release_date) in (3,4) then 1 else 0 end) as '하반기 개봉영화수'
from box_office where year(release_date) between 2004 and 2013 
group by year(release_date) with rollup order by 1;

# Q. 10-2
select year(release_date) as '년도', format(count(*), 0) as '년도별 개봉영화 수',
format(sum(case when dayname(release_date) = 'sunday' then 1 else 0 end), 0) as '일-개봉',
format(sum(case when dayname(release_date) = 'monday' then 1 else 0 end), 0)as '월-개봉',
format(sum(case when dayname(release_date) = 'tuesday' then 1 else 0 end), 0) as '화-개봉',
format(sum(case when dayname(release_date) = 'wednesday' then 1 else 0 end), 0) as '수-개봉',
format(sum(case when dayname(release_date) = 'thursday' then 1 else 0 end), 0) as '목-개봉',
format(sum(case when dayname(release_date) = 'friday' then 1 else 0 end), 0) as '금-개봉',
format(sum(case when dayname(release_date) = 'saturday' then 1 else 0 end), 0) as '토-개봉'
from box_office where year(release_date) between 2004 and 2013 
group by year(release_date) with rollup order by 1;

-- select sum(case when dayname(release_date) like (Friday) then 1 else 0 end) from box_office;

# Q. 11
select * from box_office;

select distributor as '배급사', 
count(*) as '총개봉수-2016',
concat(sum(sale_amt) div pow(10,8), '억') as '매출-2016',
sum(case when quarter(release_date) in (1) then 1 else 0 end ) as 'Q1',
sum(case when quarter(release_date) in (2) then 1 else 0 end ) as 'Q2',
sum(case when quarter(release_date) in (3) then 1 else 0 end ) as 'Q3',
sum(case when quarter(release_date) in (4) then 1 else 0 end ) as 'Q4'
from box_office where (year(release_date) = '2016') and sale_amt >= 200000000 group by distributor having sum(sale_amt) div pow(10,8) between 100 and 1500 order by sum(sale_amt) desc;

# Q. 12
select (case when grouping (movie_type) = 1 then '총계' else movie_type end) as '영화유형', concat(format(sum(sale_amt)/pow(10,8),0), '억') as '매출' from box_office
group by movie_type with rollup
order by sum(sale_amt) desc;

# Q. 13
use world;
select * from country;
# 13-1	면적 제일 큰 대륙
select continent '대륙', round(sum(surfacearea),0) '면적' from country group by continent order by sum(SurfaceArea) desc limit 1;
# 13-2	인구 제일 많은 대륙
select continent '대륙', concat(format(sum(population), 0),'명') '인구' from country group by continent order by sum(Population) desc limit 1;
# 13-3	국가 가장 많은 대륙
select continent '대륙', count(name) '국가수' from country group by continent order by count(name) desc limit 1;
# 13-4	인구 가장 적은 대륙
select continent '대륙', sum(population) '인구' from country group by continent order by sum(population) limit 1;

select distinct continent from country;

# Q. 14
use youDB;
select * from box_office;
select year(release_date) '년도', concat(format(sum(case when ranks <= 20 then sale_amt else 0 end)/pow(10,8),0), '억') '1~20위 매출', 
concat(format(sum(case when ranks > 20 then sale_amt else 0 end)/pow(10,8),0), '억') '나머지 매출', 		# 전체 매출 - (1~20위 매출)
format(count(case when ranks > 20 then 1 end), 0) '20위 이상 영화숫자' from box_office 
where year(release_date) between 2008 and 2018 group by year(release_date) order by 1;

# Q. 15
select year(release_date) '년도', format(sum(audience_num), 0) '총 관객수', 
format(sum(case when rep_country = '한국' then audience_num end), 0) '한국관객',
format(sum(case when rep_country = '미국' then audience_num end), 0) '미국관객',
format(sum(case when rep_country = '일본' then audience_num end), 0) '일본관객',
format(sum(case when rep_country = '영국' then audience_num end), 0) '영국관객',
format(sum(case when rep_country = '프랑스' then audience_num end), 0) '프랑스관객',
format(sum(case when rep_country = '독일' then audience_num end), 0) '독일관객'
 from box_office where year(release_date) between 2010 and 2019 group by year(release_date) order by 1 desc;

# Q. 16
select year(release_date) as '년도', count(*) as '관객 100만명 이상 영화수', 
sum(case rep_country when '한국' then 1 else 0 end) as '한국 횟수',
sum(case rep_country when '미국' then 1 else 0 end) as '미국 횟수'
-- sum(case rep_country when '일본' then 1 else 0 end) as '일본 횟수'
from box_office where year(release_date) between 2015 and 2019
and audience_num/pow(10,4) >= 100 group by year(release_date) order by 1;

