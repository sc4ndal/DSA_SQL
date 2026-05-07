show databases;
use world;
show tables;
desc city;
desc country;

# 전 세계 도시수
select * from city;

# 1. 전 세계 도시는 총 몇개인가요?
select count(*) from city;	# 4079개로 추측 -> 중복 데이터 있을 수도 있음

# 2. 전 세계 국가는 총 몇개인가?
desc city;
select name, CountryCode from city;
select count(distinct CountryCode) from city;	#232개

# 3. 한국에 도시는 총 몇개의 도시가 있는지 확인하고 도시이름을 조회해 보세요.
desc city;
select count(distinct Name) as 도시개수 from city where CountryCode = 'KOR';
select Name from city where CountryCode = 'KOR';

# 4. 한국의 지역명이 “C”로 시작하는 지역의 도시 수는 몇개이고, 어떤 도시가 있는지 확인해 보세요.
select count(distinct Name) as 도시수 from city where CountryCode like 'KOR' && District like 'C%';
select Name, District from city where CountryCode like 'KOR' && District like 'C%';

select distinct District as 지역명 from city where CountryCode like 'KOR' and District like binary 'C%'; # binary 는 대소문자도 확인함
select count(distinct District) as 지역명 from city where CountryCode like 'KOR' and District like binary 'C%';

# 5. 한국의 지역명에서 2번째 글자가 “y”인 경우의 도시명은 어떤 도시들이 있나요?
select Name, District from city where CountryCode like 'KOR' && District like '_y%';
select count(Name) from city where CountryCode like 'KOR' && District like '_y%';

# 6. 전세계에서 도시의 인구가 300만명을 넘는 도시는 몇개가 있는지 확인하세요.
select count(name) from Country where population>=3000000;
select Name, population from Country where population>=3000000;

# 7. 한국에서 인구가 70만명 ~ 100만명 사이의 도시는 어딘지 확인하세요.
select Name, District, population from city where CountryCode like 'KOR' && 700000 <= population && population <= 1000000;
select countrycode as ctry, name, population from city where countrycode like 'KO%' && population between 700000 and 1000000;

# 8. 전 세계 도시이름 4번째 단어에 'j' 또는 ‘w’가 들어가는 도시 중에서 인구가 50만명이 넘는 도시의 도시명, 인구수, 국가코드명을 출력하세요.
select * from city;
select * from country;
select Name, population, CountryCode from city where (name like  '___j%' || name like '___w%') && population > 500000;		# or 보다 and 가 먼저 실행됨
select count(Name) from city where (name like  '___j%' || name like '___w%') && population > 500000;

# 서브 쿼리 : select ... from(select ... from ...);
select name, population, countrycode from city where name in(select name from city where name like '___j%' or name like '___w%') and population >= 500000;

# 9. 인구 수가 가장 많은 도시 5곳을 출력하시오.
select name, population from city order by population desc limit 5;		# ASC는 오름차순 DESC는 내림차순

# 10. 세계에서 특정 언어가 해당지역countrycountrylanguage에서 5% 미만으로 사용 되고 있지만, 공식적인 언어로 지정된 경우는 몇 건인가? 또한, 사용비율(Percentage) 기준으로 내림정렬 했을 경우, 상위 10개를 출력하세요 (countrylanguage 테이블 활용)
select * from countrylanguage;
select * from countrylanguage where percentage < 5 && IsOfficial like 'T' order by percentage desc limit 10;

# 11. 
/*
우리나라 도시 정보를 하기 요구사항에 맞도록 출력하세요.
1) 지역명을 기준으로 오름차순, 인구수를 기준으로 내림차순 출력
  - 출력되는 레코드의 번호도 함께 출력
2) 1)에서 출력된 내용을 기준으로 출력 순서 23번째 부터 10개를 출력하시오.
  - 출력되는 레코드의 번호도 함께 출력
*/

select * from city where countrycode = 'KOR' order by district asc, population;
select * from city where countrycode = 'KOR' order by district asc, population desc limit 10 offset 22;
# ==
select row_number() over(order by district asc, Population desc) as 번호, name as 도시명, district as 지역명, population as 인구수 from city where CountryCode='KOR';
select * from (select row_number() over(order by district asc, population desc) as 번호, name as 도시명, district as 지역명, population as 인구수 from city where CountryCode='KOR') t where 번호 between 23 and 32;

