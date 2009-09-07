package KskExample::AnyEvent;
use strict;
use warnings;

use Plack::Impl::AnyEvent;

sub ksk_init {
    +{
        psgi_setup => sub {
            my $handler = shift;

            my $ae1 = Plack::Impl::AnyEvent->new(port => 18081);
            $ae1->psgi_app($handler);
            $ae1->run;

            my $ae2 = Plack::Impl::AnyEvent->new(port => 18082);
            $ae2->psgi_app($handler);
            $ae2->run;
        },
        run_finalizer => sub {
            AnyEvent->condvar->recv;
        },
    };
}

sub handler {
    my($class, $ksk, $req) = @_;

    my $body = qq{
<h1>Welcome To Ksk World.</h1>

you request uri is @{ [ $req->uri ] }.<br />
};
    my $res = $ksk->psgi_response_class->new({ status => 200, body => $body });
    $res->header( 'content-type' => 'text/html' );
    $res;
}

1;

