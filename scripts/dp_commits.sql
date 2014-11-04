create table dp_commits (commit text, release text, author_date timestamp with time zone, primary key( commit ));

--make sure type field is defined in git_refs_tags table
insert into dp_commits select commit, substring(release from E'^(\\d+\\.\\d+)') as release, author_date from git_commit_release where release in ( select path from git_refs_tags where type is null );

