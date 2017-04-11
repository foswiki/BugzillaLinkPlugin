# See bottom of file for default license and copyright information
# =========================
#

# =========================
package Foswiki::Plugins::BugzillaLinkPlugin;    # change the package name!!!

use strict;
use warnings;

our $VERSION           = '1.400';
our $RELEASE           = '10 Apr 2017';
our $SHORTDESCRIPTION  = 'Render links to Bugzilla repositories.';
our $NO_PREFS_IN_TOPIC = 1;

my $bugUrl;
my $bugImgUrl;
my $bugListUrl;
my $bugText;
my $milestoneBugListText;
my $keywordsBugListText;
my $myBugListText;
my $debug;

# =========================
sub initPlugin {
    my ( $topic, $web, $user, $installWeb ) = @_;

    # check for Plugins.pm versions
    if ( $Foswiki::Plugins::VERSION < 1 ) {
        &Foswiki::Func::writeWarning(
            "Version mismatch between BugzillaLinkPlugin and Plugins.pm");
        return 0;
    }

    # Get plugin preferences

    $bugUrl = &Foswiki::Func::getPreferencesValue("BUGZILLALINKPLUGIN_BUGURL")
      || "http://localhost/bugzilla/show_bug.cgi?id=";
    $bugImgUrl =
      &Foswiki::Func::getPreferencesValue("BUGZILLALINKPLUGIN_BUGIMGURL")
      || '%PUBURLPATH%/%SYSTEMWEB%/BugzillaLinkPlugin/bug.gif';
    $bugListUrl =
      &Foswiki::Func::getPreferencesValue("BUGZILLALINKPLUGIN_BUGLISTURL")
      || "http://localhost/bugzilla/buglist.cgi?";
    $bugText = &Foswiki::Func::getPreferencesValue("BUGZILLALINKPLUGIN_BUGTEXT")
      || "Bug #";
    $milestoneBugListText = &Foswiki::Func::getPreferencesValue(
        "BUGZILLALINKPLUGIN_MILESTONEBUGLISTTEXT")
      || "Buglist for Milestone ";
    $keywordsBugListText =
      &Foswiki::Func::getPreferencesValue(
        "BUGZILLALINKPLUGIN_KEYWORDBUGLISTTEXT")
      || "Buglist for keyword(s) ";
    $myBugListText =
      &Foswiki::Func::getPreferencesValue("BUGZILLALINKPLUGIN_MYBUGLISTTEXT")
      || "Buglist for user ";

    # Get plugin debug flag
    $debug = &Foswiki::Func::getPreferencesFlag("BUGZILLALINKPLUGIN_DEBUG");

    # Register the tag handlers:
    Foswiki::Func::registerTagHandler( 'BUG', \&_BugzillaShowBug );
    Foswiki::Func::registerTagHandler( 'BUGLISTMS',
        \&_BugzillaShowMilestoneBugList );
    Foswiki::Func::registerTagHandler( 'BUGLISTKEY',
        \&_BugzillaShowKeywordsBugList );
    Foswiki::Func::registerTagHandler( 'MYBUGS', \&_BugzillaShowMyBugList );

    # Plugin correctly initialized
    &Foswiki::Func::writeDebug(
"- Foswiki::Plugins::BugzillaLinkPlugin::initPlugin( $web.$topic ) is OK"
    ) if $debug;
    return 1;
}

sub _BugzillaShowBug {

    my $bugID = $_[1]->{_DEFAULT};
    ## display a bug img and the bugzilla url
    $bugID =~ s/\s*(\S*)\s*/$1/;
    return
      "<img src='$bugImgUrl' alt='bug' /> [[$bugUrl$bugID][$bugText$bugID]]";
}

sub _BugzillaShowMilestoneBugList {
    my $mID = $_[1]->{_DEFAULT};
    ## display a bug img and a bugzilla milesteone bug list
    $mID =~ s/\s*(\S*)\s*/$1/;
    return
        "<img src='$bugImgUrl' alt='bug' /> [[$bugListUrl"
      . "target_milestone="
      . $mID
      . "b&target_milestone=$mID][$milestoneBugListText $mID]]";
}

sub _BugzillaShowKeywordsBugList {
    my $keyWords = $_[1]->{_DEFAULT};

    # Determine if AND-type or OR-type search
    my $type = "allwords";
    $keyWords =~ s/\s*(\S*)\s*/$1/;
    my $keyWordsUse = $keyWords;
    if ( $_[0] =~ m/\w+,\w+/ ) {
        $type = "anywords";
        $keyWordsUse =~ s/,/+/;
    }
    return "<img src='$bugImgUrl' alt='bug' /> [[$bugListUrl"
      . "keywords_type=$type&keywords=$keyWordsUse][$keywordsBugListText \"$keyWords\"]]";
}

sub _BugzillaShowMyBugList {
    my $mID = $_[1]->{_DEFAULT};

    ## display a bug img and a bugzilla milesteone bug list
    return "<img src='$bugImgUrl' alt='bug' /> [[$bugListUrl"
      . "bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&email1=$mID&emailtype1=exact&emailassigned_to1=1&emailreporter1=1][$myBugListText $mID]]";
}
1;

__END__
Foswiki - The Free and Open Source Wiki, http://foswiki.org/

Copyright (C) 2008-2017 Foswiki Contributors. Foswiki Contributors
are listed in the AUTHORS file in the root of this distribution.
NOTE: Please extend that file, not this notice.

# Copyright (C) 2000-2001 Andrea Sterbini, a.sterbini@flashnet.it
# Copyright (C) 2001 Peter Thoeny, Peter@Thoeny.com

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version. For
more details read LICENSE in the root of this distribution.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

As per the GPL, removal of this notice is prohibited.

