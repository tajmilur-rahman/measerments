create table daily_churn_dp (
	release text not null,
	churn_date timestamp with time zone,
	total_churn numeric,
	total_files numeric,
	PRIMARY KEY (release, churn_date)
);
insert into daily_churn_dp 
select
	release,
	date(dpc.author_date),
	sum(gr.add+gr.remove) as churn,
	count(canonical) as files
from
	dp_commits dpc,
	git_revision gr 
where
	dpc.commit=gr.commit  and dpc.author_date is not null
group by
	dpc.release, date(dpc.author_date)
order by
	date(dpc.author_date);
