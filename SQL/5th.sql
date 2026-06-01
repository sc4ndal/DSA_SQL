create TABLE WSPACE (
		WID int primary key,
        WNAME char(20) not null,
        WLOC char(10),
        WADDR varchar(30)
);
SET @@AUTO_INCREMENT_INCREMENT=1;		# 전체 auto_increament 증가 숫자 1로 설정
SELECT @@AUTO_INCREMENT_INCREMENT;		# 전체 auto_increament 증가 숫자 확인
ALTER TABLE WSPACE auto_increment = 1;		# wspace 의 auto_increament 증가 숫자 설정
SHOW CREATE TABLE WSPACE;

create table MyEmp(
		ID int primary key auto_increment,
        NAME char(20) not null,
        AGE tinyint not null,
        WID int,
        
        foreign key (WID) references WSPACE(WID) ,
        check(20<=AGE AND AGE <= 50)
);
desc wspace;
desc myemp;

# 부모 테이블 값 insert
insert into wspace () values (10, 'scit', '서울', '코엑스 4층') ;
insert into wspace () values (20, 'abcd', '부산', '부산 무역회관 2~3층') ;
insert into wspace () values (30, 'swdo', '도쿄', '도쿄 푸르덴셜 3층') ;

# 자식테이블 값 insert
insert into myemp(NAME, AGE, WID) value
('김', 20, 10),
('이', 30, 20),
('최', 40, 30),
('박', 50, 10),
('김', 40, 20);
commit;

select * from wspace;
select * from myemp;
# 전체 join
select * from myemp my left outer join wspace ws on my.wid = ws.wid;
select * from myemp m, wspace w where m.wid = w.wid;
# 특정 컬럼만 출력
select m.id '사원 No.', m.name '사원명', w.wname '부서명', w.waddr '부서위치' from myemp m, wspace w where m.wid = w.wid;

# view 생성	-> 원본 컬럼명을 숨길 수가 있다 or replace -> 수정 가능
create or replace view my_view as
select m.id '사원 No.', m.name '사원명', w.wname '부서명', w.waddr '부서위치' from myemp m, wspace w where m.wid = w.wid;
desc my_view;
select * from my_view;

# data dictionary 확인
desc information_schema.key_column_usage;
select * from information_schema.key_column_usage where CONSTRAINT_SCHEMA = 'youDB' and TABLE_NAME IN ('myemp', 'wspace');

# data dictionary 조회
# 어떤 dictionary가 있는지?
show tables from information_schema;		# -> 미추천
select found_rows();		# 79개

desc information_schema.tables;
select count(*) from information_schema.tables where table_schema = 'information_schema';		# 79개

select * from information_schema.APPLICABLE_ROLES;

select user(), database();

/*		스키마(schema)란? 동일한 정보의 묶음
		테이블명 : t1, t2, t3
        실제 DB에 저장되는 테이블명 : youDB.t1, youDB.t2, youDB.t3
*/

# 특정 딕셔너리 조회 / 제약조건(constarint)
# 제약조건에 대한 정보를 가지고 있는 딕셔너리? (딕셔너리 수 총 79개)
desc information_schema.tables;

select * from information_schema.tables		#		-> 추천
where table_schema = 'youdb'
and table_name like '%c_t%';

select * from information_schema.referential_constraints;
select * from information_schema.TABLE_CONSTRAINTS;

# 외래키 추가 옵션 TEST
use youDB;
select * from wspace;
select * from myemp;
select * from my_view;
desc myemp;

# 1-1. fk 옵션 : delete
alter table myemp drop constraint my;

# 1-2. 신규 fk 제약조건 생성(delete)
alter table myemp add constraint my_fk2 foreign key (wid) references wspace(wid)
on delete cascade;

# 1-3 부모 데이터 삭제 : 서울지점 임시 폐쇄
delete from wspace where wid = 10;
select * from wspace;
select * from myemp;
select * from my_view;
rollback;

# 1-1. fk 옵션 : null
alter table myemp drop constraint my_fk2;

# 1-2. 신규 fk 제약조건 생성(null)
alter table myemp add constraint my_fk2 foreign key (wid) references wspace(wid)
on delete set null;

# 1-3 부모 데이터 삭제 : 서울지점 임시 폐쇄
delete from wspace where wid = 10;
select * from wspace;
select * from myemp;
select * from my_view;
rollback;

use world;
select TABLE_name from information_schema.tables where table_schema = 'information_schema';
select * from information_schema.tables where table_schema = 'information_schema';
select * from information_schema.key_column_usage;
select * from information_schema.tables;
# select * from information_schema where table_schema = 

# Q. 1
select distinct kcu.table_name as '테이블명', kcu.COLUMN_NAME as '컬럼명', kcu.CONSTRAINT_NAME as '제약조건명', 
CONSTRAINT_TYPE as '제약조건타입' , kcu.REFERENCED_TABLE_NAME as '참조테이블명', kcu.REFERENCED_COLUMN_NAME as '참조컬럼명'
from information_schema.Key_column_usage kcu, information_schema.table_constraints tc
where kcu.table_schema = 'world' and kcu.constraint_name = tc.constraint_name order by 1;

select * from information_schema.key_column_usage kcu where table_schema = 'world';

select * from information_schema.table_constraints;
select * from information_schema.Key_column_usage;

# Q. 2
use world;
select ci.name as '도시명', ci.population as '도시인구', ci.district as '지역명(도)', cl.language as '언어',
cl.percentage as '언어사용비율', co.name as '국가명', co.code as '국가코드', co.region as '국가위치', co.continent as '대륙명'
from city ci, country co, countrylanguage cl where ci.countrycode = co.code and co.code = cl.countrycode and
ci.population >= 5000000 and cl.percentage >= 50 and co.continent in ('North America', 'Europe', 'Asia')
order by ci.population desc;

select * from countrylanguage;

# Q. 3
select row_number() over(order by count(distinct co.code) desc) 'No.', 
co.continent '대륙', count(distinct co.name) '국가수', count(ci.name) '도시수' from country co left outer join city ci
on co.code = ci.countrycode group by Continent;

# Q. 4
select * from countrylanguage;
select * from country;
select distinct continent '대륙', isofficial '언어 여부' from country, countrylanguage where isofficial = 'F';

#===================================================================================================
#답?
use world;

# 제약 조건에 참여한 정확한 컬럼명과 참조 대상
desc information_schema.key_column_usage;

# 테이블에 걸린 제약조건의 종류와 이름
desc information_schema.table_constraints;

select * from information_schema.key_column_usage;

# Q.1
select distinct kc.TABLE_NAME as '테이블명', COLUMN_NAME as '컬럼명', kc.CONSTRAINT_NAME as '제약조건명',
CONSTRAINT_TYPE as '제약조건명', REFERENCED_TABLE_NAME as '참조테이블명', REFERENCED_COLUMN_NAME as '참조컬럼명'
from information_schema.key_column_usage kc, information_schema.table_constraints tc
where kc.constraint_schema  = 'world'
and kc.constraint_name = tc.constraint_name order by 1;

# Q.2 
desc country;
select * from country;
select distinct ct.name '도시명', ct.population '도시인구', district '지역명(도)', language '언어', percentage '언어-사용비율', co.name '국가명',
co.code '국가코드', co.region '국가위치', co.continent '대륙명'
from city ct, country co, countrylanguage cl where ct.countrycode = co.code and co.code = cl.countrycode
and (ct.population >= 5000000) and (percentage >= 50.0) and (continent in ('North America', 'Europe', 'Asia')) order by 도시인구 desc;

# Q.3 대륙별 국가수와 도시수 현황
desc country;
desc city;

select row_number() over(order by count(distinct cr.name) desc) 'No.' , 
continent '대륙', count(distinct cr.name) '국가수', count(ct.name) '도시수'
from country cr left join city ct on cr.code = ct.countrycode group by 대륙;

# Q.4 사용하는 언어가 없는 국가 확인
select * from countrylanguage;

select cr.name '국가명', cr.continent '대륙명', count(cl.language) '사용언어갯수'
from country cr left outer join countrylanguage cl
on cr.code = cl.countrycode group by 국가명, 대륙명 having 사용언어갯수 = 0;






