last_two_weeks_churns <- read.table('/tmp/last_two_weeks_churns.rpt', sep = '|', header = T)
# first_four_weeks_churns <- read.table('/tmp/first_four_weeks_churns.rpt', sep = '|', header = T)


quantile(last_two_weeks_churns$churn, .90)
top_last_two_weeks_churns <- last_two_weeks_churns[last_two_weeks_churns$churn >= 55409.2, ]
summary(top_last_two_weeks_churns)

quantile(first_four_weeks_churns$churn, .90)
top_first_four_weeks_churns <- first_four_weeks_churns[first_four_weeks_churns$churn >= 44715.6, ]
summary(top_first_four_weeks_churns)


ks.test(top_first_four_weeks_churns, top_last_two_weeks_churns)
