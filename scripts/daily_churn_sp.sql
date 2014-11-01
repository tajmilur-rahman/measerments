create table daily_churn_sp (
	release text not null,
	churn_date timestamp with time zone,
	total_churn numeric,
	total_files numeric,
	PRIMARY KEY (release, churn_date)
);
insert into daily_churn_sp 
select
	release,
	date(spc.author_date),
	sum(gr.add+gr.remove) as churn,
	count(canonical) as files
from
	sp_commits spc,
	git_revision gr
where
	spc.commit=gr.commit and spc.author_date is not null
group by
	spc.release, date(spc.author_date)
order by
	date(spc.author_date);
