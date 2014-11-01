\set ECHO all

\o /tmp/last_two_weeks_churns.rpt
select sum(add+remove) as churn from dp_commits p, git_commit c, git_revision r, stable_releases sr where c.commit = p.commit and p.commit=r.commit and p.release=sr.release and author_dt between (sr.stab_start_date-interval '14' day) and (sr.stab_start_date) group by sr.release, date(author_dt);
\o

\o /tmp/first_four_weeks_churns.rpt
select sum(add+remove) as churn from dp_commits p, git_commit c, git_revision r, stable_releases sr where c.commit = p.commit and p.commit=r.commit and p.release=sr.release and author_dt between sr.start_date and (sr.stab_start_date-interval '14' day) group by sr.release, date(author_dt);
\o

