Measurements
============
(Measurement tools / scripts for different studies for sharing publicly)

Work Title: Release stabilization on Linux and Chrome

==Extract Data from Git==
# Create a config file in internal\_tools/git_extract/config/
# Run internal\_tools/git\_extract/git_extract.sql
# Run internal\_tools/git\_extract/git_extract.pl
# Run internal\_tools/git\_extract/git_path.pl
# Run internal\_tools/git\_extract/git\_paths_canonical.pl

==PROCESS DEVELOPMENT DATA==
# Get rid off the big commits made by bots for non-development purpose
# Get rid off the non-development commits, commits made for non-source files
# Create table stable_releases, store the stable releases there
# Set stable release durations in stable_releases table
# Create table git\_commit\_release
# Run git\_dag.pl to traverse the git tree to collect commits targetting to a release. This will store information into git\_commit\_release table
# Lag/Transit time information:


