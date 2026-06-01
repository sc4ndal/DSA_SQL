use world;

select * from country;
select * from city;
select * from countrylanguage;
# 1
select name '국가명', indepyear '독립년도', format(population,0) '인구' from country where population > 10000000 and indepyear > 1960 order by 국가명;
# 2
select countryCode 'Code', (select name from country where country.code = countrycode) 'Name', count(select cl.language from countrylanguage)'공식 언어수' from countrylanguage cl where (countrycode like 'A%' or countrycode like 'B%') group by code;