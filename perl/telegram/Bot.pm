package Bot;

use strict;
use warnings;
use feature qw(say);
use HTTP::Request::Common qw(POST);
use LWP::UserAgent;
use JSON;

sub new {
    my ( $class, $token ) = @_;
    my $self = { token => $token, chat => {} };

    bless $self, $class;
    return $self;
}

sub _getPost {
    my ( $class, $token, $action, $options ) = @_;
    my $req;
    if ( defined $options ) {
        $req = POST "https://api.telegram.org/bot$token/$action", $options;
    }
    else {
        $req = POST "https://api.telegram.org/bot$token/$action";
    }

    my $ua  = LWP::UserAgent->new;
    my $api = $ua->request($req)->as_string;
    $api =~ s/.*?\{/\{/s;    # Limpiamos y solo dejamos el json
    return \$api;
}

sub getUpdates {
    my ($self) = @_;
    my $api = $self->_getPost( $self->{token}, 'getUpdates' );

    my @messages
        = $$api =~ m/(\{"update_id.*?\}\})/sg;    # dividimos en cada mensaje

    $messages[$#messages]
        =~ /.*?"chat":\{"id":(-?\d+).*?"date":(\d+).*?"text":"(.*?)"/s;

    # $1 = chat_id $2 = date $3 = text
    $self->{chat}->{$1} = { date => $2, text => $3, action => '' };
}

sub eval {
    my ($self) = @_;
    for ( keys %{ $self->{chat} } ) {
        use Data::Dumper;
        print Dumper($_);
        if ( !$self->{chat}->{$_}->{action} ) {
            my $text = $self->{chat}->{$_}->{text};
            if ($text =~ /^$/) {
                # body...
            }
            elsif ($text =~ /^$/) {
                # elsif...
            }
            else {
                # else...
            }

        }
    }

}

1;
