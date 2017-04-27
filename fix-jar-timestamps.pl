#!/usr/bin/perl -w
#
# Copyright (C) 2017 Mike Miller
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Fix the timestamps of the members of one or more JAR files.
#
# This program was inspired by strip-nondeterminism by Andrew Ayer.

use Archive::Zip qw(:CONSTANTS :ERROR_CODES);
use Getopt::Long;

sub parse_command_line
{
  my $opt_help = 0;
  my $opt_timestamp = -1;
  my $env_timestamp = -1;

  my $result = GetOptions ("timestamp=i" => \$opt_timestamp,
                           "help" => \$opt_help);

  if (! $result or $opt_help)
    {
      warn "Usage: fix-jar-timestamps.pl [--timestamp=N] JARFILE ...";
      exit (1);
    }

  if (exists ($ENV{'SOURCE_DATE_EPOCH'}) and $ENV{'SOURCE_DATE_EPOCH'} =~ /^[0-9]+$/)
    {
      $env_timestamp = 0 + $ENV{'SOURCE_DATE_EPOCH'};
    }

  my $timestamp = 0;
  if ($opt_timestamp >= 0)
    {
      $timestamp = $opt_timestamp;
    }
  elsif ($env_timestamp >= 0)
    {
      $timestamp = $env_timestamp;
    }
  else
    {
      $timestamp = time ();
    }

  return ($timestamp, @ARGV);
}

sub fix_jar_file
{
  my ($jar_file, $timestamp) = @_;

  my $zip = Archive::Zip->new ();
  if ($zip->read ($jar_file) != AZ_OK)
    {
      die "fix-jar-timestamps.pl: error reading file $_";
    }

  my @filenames = sort {$a cmp $b} $zip->memberNames ();
  foreach my $filename (@filenames)
  {
    my $member = $zip->removeMember ($filename);
    $zip->addMember ($member);
    $member->setLastModFileDateTimeFromUnix ($timestamp);
  }
  $zip->overwrite ();
}

sub main
{
  my ($timestamp, @jar_files) = parse_command_line ();
  foreach (@jar_files)
    {
      fix_jar_file ($_, $timestamp);
    }
}

main ();
