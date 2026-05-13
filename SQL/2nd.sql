# 단일행 함수
/*
1) 나머지
div : 나누기 몫
mod, % : 나누기 나머지
*/ 
select 7/2, 7 div 4, 7 mod 4, 7%2;

/*
2) 주어진 값 기준 최소/최대, 반올림, 절삭
ceil : 주어진 값보다 큰 최소 정수
floor : 주어진 값보다 작은 최대 정수
round (값,반올림 위치) : 반올림, 양수(**.오른쪽방향), 음수(왼쪽방향.**)
*/
select ceil(5.146) as "x보다 큰 최소정수", --floor(5.146) as "x보다 작은 최대정수", round(5.146) as "5.146 반올림", round(5.146, 2) as "반올림: ***.00", round(5.146, -1) as "반올림: 0.***", truncate (5.146, 2) as "절삭: ***.00";

/*
3) 절대값, n승, 제곱근, 1/0/-1, 랜덤값
abs : 절대값
pow or power (x,y) : x 의 y 승
sqrt : 제곱근
sign : -1, 0, 1
rand(seed) : 난수값 리턴
*/
select abs(-20) as "절댓값", pow(4,3) as "4의 3승", sqrt(16) as "루트16", sign(-234) as "1/0/-1", rand() as "난수값", rand(23) as "seed 난수값";

/*
4) 로그와 자연상수 거듭제곱
pow(x,y) : x의 y승
log(x,y) : 밑이 x인 로그y
log2(y) : 밑이 2인 로그y
log10(y) 밑이 10인 로그y
log(y) : 밑이 e인 로그y
ln(100) : 밑이 e인 로그y
exp(x) : 자연상수 (e, Euler Number)의 x승
exp(n) as "e의 n승"
*/

select pow(2,12) as "2의 12승", log(2,4096) as "밑이 2인 로그 4096", log(4, 100) as "밑이 4인 로그100", log2(100) as "밑이 2인 로그10",
log10(100) as "밑이 10인 상용로그10", /*log(100) as "밑이 e인 로그100", */ln(100) as "밑이 e인 로그100", exp(1) as "자연상수 e의 1승", exp(100) as "자연상두 e의 100승";

/* 1) 문자길이, 문자열 붙이기, 대&소문자
length(str): 문자열의 크기 return
char_length(str): 문자의 갯수 return
concat(a, b): 문자열 연결
concat_ws(sep, a, b) : 문자열 연결, 첫번째 매개변수는 sep(구분자)
lower / Icase: 소문자
upper / ucase : 대문자 */

select version();
use world;
desc city;
select distinct CountryCode from city;
select length('jwc정'), char_length('jwc정');
select concat('정', '재', '완');
select concat('정', null, '완');
select concat_ws('--', '정', '재', '완');
select lower(name), lcase(name), upper(lower(name)), ucase(name) from city;

/* 2) 콤마(,), 문자열 위치
format(data, d): 숫자 3자리 마다 콤마(,)를 넣어 문자열 반환
d는 소숫점 이하 자리표기 여부
instr(data, 문자열): data에서 2번째 매개변수 문자열을 찾아 위치값 반환
locate(문자열, data, pos): data에서 pos부터 문자열을 찾아 위치값 반환
position(문자열 in data): data에서 문자열을 찾아 위치값 반환
*/

desc city;
select format(population, 1), population from city order by 2 desc;
select concat(name, countrycode) as c_name, instr(concat(name, countrycode), 'usa') as 'instr()' from city where countrycode = 'usa';
select locate('db', 'RDBs are mariaDB&mySQL', 3);
select position('db' in 'RDBs are mariaDB&mySQL');

/* 3) Lpad/Rpad, Ltrim/Rtrim
Lpad(data, n, 패딩문자): 총길이(n)에서 data를 제외한 공간을 패딩문자로 왼쪽 채움
Rpad(data, n, 패딩문자): 총길이(n)에서 data를 제외한 공간을 패딩문자로 오른쪽 채움
Ltrim(data): data trim
Rtrim(data): data trim
*/

select Lpad(name, 10, '#'), Rpad(name, 10, '#'), '   mySQL   ', Ltrim('   mySQL   '), Rtrim('	mySQL	') from city;

/* trim(data): 양쪽에서 한번에 공백제거
trim(both '특수문자' from data) : 양쪽에서 특수문자 한번에 제거
trim(leading '특수문자' from data): 왼쪽에서 특수문자 제거
trim(trailing '특수문자' from data): 오른쪽에서 특수문자 제거 */

select ' **mySQL## ', length('  **mySQL##  '), trim(' **mySQL## '), length(trim(' **mySQL## ')), trim(leading '*' from trim(' **mySQL## ')) as 'left_trim',
trim(trailing '#' from trim(' **mySQL## ')) as 'right_trim', trim(both '?' from '?????mySQL?????') as 'both_trim';

/* 4) 필요한 문자열 잘라내기
left(str, n): 왼쪽에서 str을 n개 만큼 자르기
right(str, n): 오른쪽에서 str을 n개 만큼 자르기
substr(str, pos, n):
str을 pos위치에서 n개 만큼 자르기
#mid, substring
n 값을 지정하지 않으면, 데이터의 끝까지 자름
*/

desc city;
select * from city limit 5;
select concat(countrycode, name), left(concat(countrycode, name), 3), substr(concat(countrycode, name), 4) from city limit 10;

/* 5) 반복, 변경 등
repeat(str, n): str을 n회 반복
replace(str, a, b): str에서 a를 b로 변경
reverse(str): str 순서를 반대로
strcmp(str1, str2): 0(str1 = str2), 1 (str1 > str2), -1(str1 < str2)
*/

select repeat('korea', 3) as "반복", replace('myKOREA', 'my', 'our') as "값대체", reverse('korea') as "문자역순", strcmp('korea', 'rok') as "비교1",
/* ascii('k'), ascii('r'), ascii('a'), */strcmp('korea', 'a republic of korea') as "비교2", strcmp('korea', 'korea') as "비교3";

# Q1. 단일행 함수
select concat(replace(countrycode, 'JPN', 'KOREA'), ':', name) as 'R.O.K' from city where countrycode = 'JPN';
#concat_ws ('사이에 넣을 문자', 문자1, 문자2)
select replace(concat_ws(':', countrycode, name), 'JPN', 'KOREA' ) as 'R.O.K'from city where CountryCode = 'JPN';
select concat_ws(':', replace(countrycode, 'JPN', 'KOREA'), name) as 'R.O.K' from city where countrycode = 'JPN';

#case

#DDL : 테이블 생성
create table scit_tab(
				my_name char(10),
				my_team int(5)
);

# 한번에 여러 값 넣기
insert into scit_tab values
('김', 1),
('이', 2),
('최', 3),
('박', 4),
('홍', 5);

# 테이블 삭제
drop table scit_tab;

# 테이블 구조 확인
desc scit_tab;

#  테이블 값 확인
select * from scit_tab;

# DML : 데이터 insert 
insert into scit_tab values('김', 1);
insert into scit_tab values('이', 2);
insert into scit_tab values('최', 3);
insert into scit_tab values('박', 4);
insert into scit_tab values('홍', 5);

# TCL
# 트랜잭션 확정
commit;
# insert 초기화
rollback;

# DQL
desc scit_tab;
select my_name, my_team from scit_tab;

select my_name, case my_team 	when 1 then '1조'
													when 2 then '2조'
													when 3 then '3조'
													else '우리반 아님' end as TEAM
from scit_tab;

/* =========================================================
   1번: 현재 시간 및 날짜 조회 함수
   ========================================================= */
/* CURTIME(), CURRENT_TIME : 현재 '시간'만 반환 (형식: HH:MM:SS) */
/* NOW(), CURRENT_TIMESTAMP : 현재 시스템의 '날짜와 시간'을 모두 반환 (형식: YYYY-MM-DD HH:MM:SS) */
/* YEAR, QUARTER, MONTH, DAY : 날짜 데이터에서 각각 연도, 분기(1~4), 월(1~12), 일(1~31)을 숫자로 추출 */
/* DAYNAME : 해당 날짜의 요일 이름(예: Monday, Tuesday 등)을 영어로 반환 */
/* TIME : 날짜/시간 데이터에서 시간(HH:MM:SS) 부분만 따로 분리하여 추출 */
/* DAYOFYEAR : 해당 연도의 1월 1일부터 경과된 일수(1~366)를 반환 */
/* DAYOFMONTH : 해당 월의 몇 번째 날인지(1~31) 일자를 반환 (DAY()와 동일) */
/* DAYOFWEEK : 주간 요일 순서를 숫자로 반환 (1:일요일, 2:월요일, ..., 7:토요일) */
/* WEEKOFYEAR : 해당 날짜가 일 년 중 몇 번째 주(Week)에 해당하는지 반환 */
/* LAST_DAY : 해당 날짜가 속한 달의 마지막 날짜를 반환 (해당 월이 28, 30, 31일 중 언제 끝나는지 확인 시 유용) */
/* =========================================================
   2번: 날짜 계산 및 특정 단위 추출
   ========================================================= */
/* DATE_ADD, ADDDATE : 특정 날짜에 원하는 시간 간격(1년, 15일 등)을 더함 */
/* DATE_SUB, SUBDATE : 특정 날짜에서 원하는 시간 간격(2개월, 10일 등)을 뺌 */
/* EXTRACT : 날짜에서 특정 단위(연도월, 연도 등)를 지정하여 숫자로만 추출 */
/* DATEDIFF : 두 날짜 사이의 일수 차이를 계산 (결과값 = 날짜1 - 날짜2) */
/* =========================================================
   3번: 날짜 포맷 및 형식 변환
   ========================================================= */
/* DATE_FORMAT : 날짜 데이터를 지정한 기호 형식의 문자로 변환 
   - %Y: 4자리 연도 / %y: 2자리 연도
   - %M: 월 이름 / %b: 짧은 월 이름 / %m: 2자리 숫자 월 / %c: 1자리 숫자 월
   - %d: 2자리 숫자 일 / %e: 1자리 숫자 일 / %j: 연중 일수(001~366)
   - %H: 24시간제 시간 / %h 또는 %I: 12시간제 시간 / %i: 분 / %s: 초 / %p: AM 또는 PM
   - %T: 24시간 형식 시간(hh:mm:ss) / %r: 12시간 형식 시간(hh:mm:ss AM/PM)
   - %W: 요일 이름 / %w: 요일 숫자(0:일~6:토)
   - %U: 일요일 시작 기준 주차 / %u: 월요일 시작 기준 주차 */
/* STR_TO_DATE : 날짜 형식으로 된 문자열(Text)을 실제 날짜(DATE) 타입 데이터로 변환 */
/* MAKEDATE : 특정 연도와 그 해의 n번째 날짜 숫자를 조합하여 날짜 데이터를 생성 */
/* SYSDATE() : 함수가 호출되는 시점의 실제 시간을 매번 새롭게 측정 (실행 중 대기 시간이 있으면 그 차이가 반영됨) */
/* NOW() : 쿼리문이 처음 시작된 시점의 시간을 결과 전체에 고정하여 출력 (대기 시간이 있어도 모든 행의 시간이 동일함) */
/* =========================================================
   4번: 데이터 타입 변환 함수 (CAST & CONVERT)
   ========================================================= */
/* CAST(값 AS 타입) : 특정 데이터를 강제로 원하는 데이터 타입으로 변환 
   - 변환 가능 타입: CHAR(문자), SIGNED(부호 있는 정수), UNSIGNED(부호 없는 정수), DECIMAL(실수), DATE(날짜), DATETIME(날짜+시간) 등 */
/* CONVERT(값, 타입) : CAST와 기능은 동일하며, 'AS' 대신 '쉼표(,)'를 사용하여 타입을 지정함 */

# Q.2 단일행 함수
#1. 
select lpad(floor(rand()*1000),3,'0') as '난수 3자리';
select concat(truncate(rand() *10, 0),truncate(rand() *10, 0),truncate(rand() *10, 0)) as '난수 3자리';

#2.
select concat_ws(' : ',countrycode,name,district) as '\'한미일\'에서 인구 top10 도시명', concat(format(population, 0),'명') as 인구 from city where (CountryCode = 'KOR' || CountryCode = 'USA' || CountryCode = 'JPN') order by population desc limit 10;
select concat_ws(' : ',countrycode,name,district) as '\'한미일\'에서 인구 top10 도시명', concat(format(population, 0),'명') as 인구 from city where countrycode in ('KOR','USA','JPN') order by population desc limit 10;
#concat(countrycode,':',name,':',district)

#3.
CREATE TABLE city_info (
    city_info VARCHAR(100)
);

select * from city_info;

INSERT INTO city_info (city_info) VALUES
('ZWEHarare 1410000'),
('ZWEBulawayo 621742'),
('ZWEChitungwiza 274912'),
('ZWEMount Darwin 164362'),
('ZWEMutare 131367'),
('ZWEGweru 128037'),
('ZMBLusaka 1317000'),
('ZMBNdola 329200'),
('ZMBKitwe 288600'),
('ZMBKabwe 154300'),
('ZMBChingola 142400'),
('ZMBMufulira 123900'),
('ZMBLuanshya 118100'),
('ZAFCape Town 2352121');

select city_info, left(city_info, 3) as 국가코드, REGEXP_SUBSTR(city_info, '[0-9]+') as '인구'  from city_info;

create table t_city
select concat(countrycode, name, ' ', population) as city_info from city order by countrycode desc, population desc limit 30;
desc t_city;
select * from t_city;
select city_info, left(city_info, 3) as 국가코드, regexp_substr(city_info, '[0-9]+') as '인구' from t_city;

#4.
select now() as '특정날짜', last_day(now()) as '특정날짜의 마지막일', dayname(last_day(now())) as '요일';

