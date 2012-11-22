package Simple::Dict;

use 5.014002;
use strict;
use warnings;
use File::Spec;
use File::Slurp;

use Moose;

has [ 'dict_dir', 'dict_name', 'index' ] => (
    is  => 'rw',
    isa => 'Str',
);

has [ 'dict_file_fh', 'index_file_fh' ] => (
    is  => 'rw',
    isa => 'FileHandle',
);

sub BUILD {
    my $self     = shift;
    my $dict_dir = $self->dict_dir;
    my @files    = glob File::Spec->catdir( $dict_dir, "*" );
    my ($ifo_file)  = grep /.*?ifo$/,  @files;
    my ($idx_file)  = grep /.*?idx$/,  @files;
    my ($dict_file) = grep /.*?dict$/, @files;

    open my $dict_file_fh,  "<", $dict_file or die "can not open $dict_file";
    open my $index_file_fh, "<", $idx_file  or die "can not open $idx_file";
    $self->dict_file_fh($dict_file_fh);
    $self->index_file_fh($index_file_fh);

    #get the name of directionary
    my $info_content = read_file($ifo_file);
    $self->dict_name($1) if $info_content =~ /bookname=(.*?)\n/;

    $self->_get_index;
}

sub _get_index {
    my $self = shift;
    my $path = File::Spec->catdir( $self->dict_dir, "fast.index" );
    if ( -e $path ) {
        $self->index( scalar read_file($path) );
    }
    else {
        print "Making index for your new dictionary--"
          . $self->dict_name . ". It might take a few seconds.\n";
        my $big_str;
        open my $big_str_fd, ">", \$big_str;
        my $buf;
        while ( read $self->index_file_fh, $buf, 1 )
        {    #ineffective, but acceptable

           #.idx format(version 2.*):
           #   {{word}'\0'{32-bit(net order) offset}{32-bit(net order) length}}*
            if ( $buf eq "\0" ) {
                read $self->index_file_fh, $buf, 4;
                print $big_str_fd "###", unpack( "N", $buf );
                read $self->index_file_fh, $buf, 4;
                print $big_str_fd "###", unpack( "N", $buf );
                print $big_str_fd "\n";
                next;
            }
            print $big_str_fd $buf;
        }
        write_file( $path, $big_str );
        $self->index($big_str);
    }
}

sub search_word {
    my ( $self, $word ) = @_;
    if ( $self->index =~ /^($word)###(?<offset>\d+)###(?<len>\d+)/m ) {
        return $self->dict_name . "\n"
          . __get_dict( $self->dict_file_fh, $+{offset}, $+{len} );
    }
    else {
        return "";
    }
}

sub write_record {
    my ( $self, $word ) = @_;
    append_file( "dict.record", $word . "\n" );
}

sub get_hint {
    my ( $self, $sofar ) = @_;
    $self->index =~ /^(${$sofar?\$sofar:\"#"}\w+)#/gm;
}

sub __get_dict {
    my ( $dict_file, $offset, $length ) = @_;
    seek( $dict_file, $offset, 0 );
    my $buf;
    read( $dict_file, $buf, $length );
    return $buf;
}

1;
