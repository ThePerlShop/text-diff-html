package Text::Diff::HTML;

# $Id: HTML.pm 1932 2005-08-08 17:17:03Z theory $

use strict;
use vars qw(@ISA $VERSION);
use HTML::Entities;
use Text::Diff (); # Just to be safe.

$VERSION = '0.01';
@ISA = qw(Text::Diff::Unified);

sub file_header {
    return '<span class="fileheader">'
           . encode_entities(shift->SUPER::file_header(@_))
           . '</span>';
}

sub hunk_header {
    return '<span class="hunkheader">'
           . encode_entities(shift->SUPER::hunk_header(@_))
           . '</span>';
}

sub hunk_footer {
    return '<span class="hunkfooter">'
           . encode_entities(shift->SUPER::hunk_footer(@_))
           . '</span>';
}

sub file_footer {
    return '<span class="filefooter">'
           . encode_entities(shift->SUPER::file_footer(@_))
           . '</span>';
}

# Each of the items in $seqs is an array reference. The first one has the
# contents of the first file and the second has the contents of the second
# file, all broken into hunks. $ops is an array reference of array references,
# one corresponding to each of the hunks in the sequences.
#
# The contents of each op in $ops tell us what to do with each hunk. Each op
# can have up to four items:
#
# 0: The index of the relevant hunk in the first file sequence.
# 1: The index of the relevant hunk in the second file sequence.
# 2: The opcode for the hunk, either '+', '-', or ' '.
# 3: A flag; not sure what this is, doesn't seem to apply to unified diffs.
#
# So what we do is figure out which op we have and output the relevant span
# tag if it is different from the last op. Then we select the hunk from second
# sequence (SEQ_B_IDX) if it's '+' and the first sequence (SEQ_A_IDX)
# otherwise, and then output the opcode and the hunk.

use constant OPCODE    => 2; # "-", " ", "+"
use constant SEQ_A_IDX => 0;
use constant SEQ_B_IDX => 1;

my %code_map = (
    '+' => 'ins',
    '-' => 'del',
    ' ' => 'ctx',
);

sub hunk {
    shift;
    my $seqs = [ shift, shift ];
    my $ops  = shift;
    return unless @$ops;

    # Start the span tag for the first opcode.
    my $last = $ops->[0][ OPCODE ];
    my $hunk = qq{<span class="$code_map{ $last }">};

    # Output each line of the hunk.
    while (my $op = shift @$ops) {
        my $opcode = $op->[OPCODE];
        my $class  = $code_map{$opcode} or next;

        # Close the last span and start a new one for a new opcode.
        if ($opcode ne $last) {
            $last = $opcode;
            $hunk .= qq{</span><span class="$class">};
        }

        # Output the appropriate line.
        my $idx = $opcode ne '+' ? SEQ_A_IDX : SEQ_B_IDX;
        $hunk .= encode_entities("$opcode " . $seqs->[$idx][$op->[$idx]]);
    }

    return $hunk . '</span>';
}

1;
__END__

##############################################################################

=begin comment

Fake-out Module::Build. Delete if it ever changes to support =head1 headers
other than all uppercase.

=head1 NAME

Text::Diff::HTML - HTML format for Text::Diff::Unified

=end comment

=head1 Name

Text::Diff::HTML - HTML format for Text::Diff::Unified

=head1 Synopsis

    use Text::Diff;

    my $diff = diff "file1.txt", "file2.txt", { STYLE => 'Text::Diff::HTML' };
    my $diff = diff \$string1,   \$string2,   { STYLE => 'Text::Diff::HTML' };
    my $diff = diff \*FH1,       \*FH2,       { STYLE => 'Text::Diff::HTML' };
    my $diff = diff \&reader1,   \&reader2,   { STYLE => 'Text::Diff::HTML' };
    my $diff = diff \@records1,  \@records2,  { STYLE => 'Text::Diff::HTML' };
    my $diff = diff \@records1,  "file.txt",  { STYLE => 'Text::Diff::HTML' };

=head1 Description

This class subclasses Text::Diff::Unified, a formatting class provided by the
L<Text::Diff|Text::Diff> module, to add HTML markup to the unified diff
format. Each line of the diff has its characters properly encoded for HTML,
and is appropriately marked up with a C<< <span> >> tag. Each span tag has a
class, defined as follows:

=over

=item fileheader

The header section for the files being C<diff>ed, usually something like:

  --- in.txt	Thu Sep  1 12:51:03 2005
  +++ out.txt	Thu Sep  1 12:52:12 2005

=item hunkheader

Header for a diff hunk. The hunk header is usually something like:

  @@ -1,5 +1,7 @@

=item cx

Context around the important part of a C<diff> hunk. These are contents that
have I<not> changed between the files being C<diff>ed.

=item ins

An insertion line, starting with C<+>.

=item del

An deletion line, starting with C<->.

=item hunkfooter

The footer section of a hunk; contains no contents.

=item filefooter

The footer section of a file; contains no contents.

=back

You may do whatever you like with these classes; I highly recommend that you
style them using CSS. You'll find an example CSS file in the C<eg> directory
in the Text-Diff-HTML distribution. You will also likely want to wrap the
output of your diff in C<< <pre> >> tags.

=head1 Bugs

Please send bug reports to <bug-text-diff-html@rt.cpan.org>.

=head1 Authors

=begin comment

Fake-out Module::Build. Delete if it ever changes to support =head1 headers
other than all uppercase.

=head1 AUTHOR

=end comment

David Wheeler <david@kineticode.com>

=head1 Copyright and License

Copyright (c) 2005 Kineticode, Inc. All Rights Reserved.

This module is free software; you can redistribute it and/or modify it under the
same terms as Perl itself.

=cut
