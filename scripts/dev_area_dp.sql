create table dev_area_dp (
	username text not null,
	release text,
	path text,
	commits numeric,
	churn numeric,
	PRIMARY KEY (username, release, path)
);
CREATE INDEX dev_area_dp_release_idx ON dev_area_dp ((lower(release)));
CREATE INDEX dev_area_dp_author_idx ON dev_area_dp ((lower(username)));

insert into dev_area_dp 
select
	substring(gc.author from E'(.*)\\s') as author,
	dpc.release,
	gr.canonical,
	count(gc.commit) as commits,
	sum(gr.add+gr.remove) as churns
from 
	git_commit gc, git_revision gr, dp_commits dpc
where 
	gc.commit=gr.commit and gc.commit = dpc.commit
group by
	dpc.release, substring(gc.author from E'(.*)\\s'), gr.canonical;

update dev_area_dp set churn=0 where churn is null;
