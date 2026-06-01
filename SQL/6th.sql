# sub query

select @@autocommit;

# Q.2
use world;
select * from city;

select code '국가코드', name '국가명', GovernmentForm '정부형태', population '인구', 
LifeExpectancy '기대수명', (select count(name) from city where city.countrycode = country.code) '도시수'
from country
order by 도시수 desc limit 15;

# Q.3
use youDB;
select * from box_office;

SELECT 년도, 영화제목, 매출, 순위
FROM(SELECT DATE_FORMAT(release_date, '%Y') AS 년도, movie_name AS 영화제목, sale_amt AS 매출, ranks AS 순위 FROM box_office WHERE ranks = 1) t
WHERE 매출 >(SELECT AVG(sale_amt) FROM box_office WHERE ranks = 1) ORDER BY 년도 DESC;

SELECT *
FROM(SELECT DATE_FORMAT(release_date, '%Y') AS 년도, movie_name AS 영화제목, sale_amt AS 매출, ranks AS 순위 FROM box_office WHERE ranks = 1) t
WHERE 매출 >(SELECT AVG(sale_amt) FROM box_office WHERE ranks = 1) ORDER BY 년도 DESC;

SELECT bx1.years AS '년도', bx1.movie_name AS '영화제목', bx1.sale_amt AS '매출', bx1.ranks AS '순위'
FROM ( SELECT * FROM box_office WHERE ranks = 1) AS bx1   -- Inline View: box_office 테이블에서 순위가 1위인 영화들만 모아놓은 가상의 테이블
WHERE bx1.sale_amt > (SELECT AVG(sale_amt) FROM box_office WHERE ranks = 1) -- 서브쿼리: 1위 영화 전체의 평균 매출액을 계산
ORDER BY bx1.years DESC; -- 년도별 내림차순 정렬

# Q.4 안 되는거XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
select 년도, 
sum(case when t.quarter = 1 then t.sale_amt end) '1분기',
sum(case when t.quarter = 2 then t.sale_amt end) '2분기',
sum(case when t.quarter = 3 then t.sale_amt end) '3분기',
sum(case when t.quarter = 4 then t.sale_amt end) '4분기'
from (select date_format(release_date, '%Y') '년도', sale_amt, quarter(date_format(release_date, '%Y')) as 'quarter' from box_office where date_format(release_date, '%Y') in (2018, 2019) ) t
group by 년도 order by 년도;






