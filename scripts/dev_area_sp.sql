create table dev_area_sp (
	username text not null,
	release text,
	path text,
	commits numeric,
	churn numeric,
	PRIMARY KEY (username, release, path)
);
CREATE INDEX dev_area_sp_release_idx ON dev_area_sp ((lower(release)));
CREATE INDEX dev_area_sp_author_idx ON dev_area_sp ((lower(username)));

insert into dev_area_sp
select
	substring(gc.author from E'(.*)\\s') as author,
	spc.release,
	gr.canonical,
	count(gc.commit) as commits,
	sum(gr.add+gr.remove) as churns
from 
	git_commit gc, git_revision gr, sp_commits spc
where 
	gc.commit=gr.commit and gc.commit = spc.commit
group by
	spc.release, substring(gc.author from E'(.*)\\s'), gr.canonical;

update dev_area_sp set churn=0 where churn is null;
