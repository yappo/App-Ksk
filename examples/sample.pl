package KskExample::Sample1;
use strict;
use warnings;

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

