drop table if exists stable_releases;
create table stable_releases(
	release text,
	start_date timestamp with time zone,
	end_date timestamp with time zone,
	days float not null default 0
);


--measure dp length and sp lengths
alter table stable_releases add column dp_length numeric;
alter table stable_releases add column sp_length numeric;
alter table stable_releases add column release_date timestamp with time zone;

update stable_releases set start_date = st_dt from (select min(date) st_dt from git_refs_tags where path~E'^MAJOR.0') a where release~E'^MAJOR.0';

update stable_releases set end_date = en_dt from (select max(date) en_dt from git_refs_tags where path~E'^MAJOR.0' and type='stable') a where release~E'^MAJOR.0';

update stable_releases set days = round(extract(epoch from (end_date - start_date))/86400);

alter table stable_releases add column stab_start_date timestamp with time zone;

update stable_releases sr set stab_start_date = date from (select substring(sr.release from E'^(\\d+\\.\\d+)') as release, t.date from git_refs_tags t, stable_releases sr where t.path=sr.stab_starts_at order by date) a where a.release=sr.release;


update stable_releases set dp_length = round( extract(epoch from (stab_start_date-start_date))/86400 );
update stable_releases set sp_length = round( extract(epoch from (end_date-stab_start_date))/86400 );

update stable_releases set days = (dp_length+sp_length);

update stable_releases set release_date='DATE 23:59:59-05' where release='RELEASE';
--
