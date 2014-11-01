#!/usr/bin/perl -w

#developers contribution
#cumulative churn percentage in releases (SP)
#block / unblock code bellow for SP

use warnings;
use strict;

use DBI;
use Config::General;

my $config_path = shift @ARGV;

if (!defined $config_path) {
	$config_path = 'config';
}
die "Config file \'$config_path\' does not exist" unless (-e $config_path);

my %config =  Config::General::ParseConfig($config_path);

my $dbh_ref = DBI->connect("dbi:Pg:database=$config{db_name}", '', '', {AutoCommit => 1});

# ---- for SP ----
my $releases = $dbh_ref->prepare(q{
	select release from stable_releases;
});
my $churn_p_sp = $dbh_ref->prepare(q{
	select username, p_churn from (select username, (sum(churn)*100/(select sum(churn) from dev_area_sp where release=?)) as p_churn from dev_area_sp where release=? group by username order by p_churn desc) a;
});
my $insert = $dbh_ref->prepare(q{
	insert into cumul_contribution_sp (release, sum_devs, cumul_churn) values(?,?,?);
});

$releases->execute() or die;

while(my($release) = $releases->fetchrow_array){
	$churn_p_sp->execute($release, $release) or die;

	my $i=0;
	my $cumulChurnPercent = 0;

	print "devs | percent_contribution\n";
	while(my($author, $individualChurnPercent) = $churn_p_sp->fetchrow_array){
		$i++;

		$cumulChurnPercent = $cumulChurnPercent + $individualChurnPercent;
	
		# ---- for SP ----
		if($i <= 9){
			printf "$i | %.2f \n", ($_) for $cumulChurnPercent;
			$insert->execute($release, $i, $cumulChurnPercent);
		}else{
			if($i%10==0){
				printf "$i | %.2f \n", ($_) for $cumulChurnPercent;
				$insert->execute($release, $i, $cumulChurnPercent);
			}
		}
	}
}

$churn_p_sp->finish;
$insert->finish;
$dbh_ref->disconnect;

__END__
