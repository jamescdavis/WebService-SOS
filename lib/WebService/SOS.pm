package WWW::SOS;

use Moose;
use Moose::Util::TypeConstraints;
use namespace::autoclean;

use Carp qw(cluck);
use LWP::UserAgent;
use HTTP::Request::Common;
use URI::Escape;

use WWW::SOS::Response;

our $VERSION = '0.1';

# for extra debugging output
has 'debug' => (
    is      => 'ro',
    isa     => 'Bool',
    default => 0,
);

has 'ua' => (
    is         => 'ro',
    isa        => 'LWP::UserAgent',
    lazy_build => 1,
);

has 'server_url' => (
    is      => 'ro',
    isa     => 'Str',
    default => 'http://lighthouse.tamucc.edu/sos',
);

has 'method' => (
    is      => 'ro',
    isa     => enum([qw(post get)]),
    default => 'post',
);

sub _build_ua {
    my ($self) = @_;
    return LWP::UserAgent->new( agent => 'WWW::SOS/' . $VERSION );
}

sub _process_response {
    my $response = shift;

    unless ($response->is_success) {
        cluck("Error communicating with SOS server: ".$response->code." ".$response->message);
        return undef;
    }

    return WWW::SOS::Response->new( xml => $response->content );
}

sub GetCapabilities {
    my $self = shift;
    my $response;
    if ($self->{method} =~ /^get$/i) {
        my $request = $self->server_url."?request=GetCapabilities&service=SOS&version=1.0.0";
        print STDERR "GetCapabilities: GET $request\n" if $self->debug;
        $response = $self->ua->get($request);
    }
    else {
        my $message = '<?xml version="1.0" encoding="UTF-8"?>
<sos:GetCapabilities
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
   xsi:schemaLocation="http://schemas.opengis.net/sos/1.0.0/sosAll.xsd"
   xmlns:sos="http://www.opengis.net/sos/1.0"
   xmlns:gml="http://www.opengis.net/gml/3.2"
   xmlns:ogc="http://www.opengis.net/ogc"
   xmlns:om="http://www.opengis.net/om/1.0" service="SOS">
</sos:GetCapabilities>';
        print STDERR "GetCapabilities: POST\n$message\n" if $self->debug;
        $response = $self->ua->request(POST $self->server_url, Content_Type => 'text/xml', Content => $message);
    }

    return _process_response($response);
}

sub DescribeSensor {
    my ($self,$procedure) = @_;
    my $outputFormat = 'text/xml; subtype="sensorML/1.0.1"';
    my $response;
    if ($self->{method} =~ /^get$/i) {
        my $request = sprintf('%s?request=DescribeSensor&service=SOS&version=1.0.0&outputFormat=%s&procedure=%s',
                                    $self->server_url,
                                    uri_escape($outputFormat),
                                    uri_escape($procedure)
                                 );
        print STDERR "DescribeSensor: $request\n" if $self->debug;
        $response = $self->ua->get($request);
    }
    else {
        my $message = sprintf('<?xml version="1.0" encoding="UTF-8"?>
<DescribeSensor
    xmlns="http://www.opengis.net/sos/1.0"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.opengis.net/sos/1.0 http://schemas.opengis.net/sos/1.0.0/sosAll.xsd"
    service="SOS"
    outputFormat="text/xml;subtype=&quot;sensorML/1.0.1&quot;"
    version="1.0.0">
        <procedure>%s</procedure>
</DescribeSensor>',$procedure);
        print STDERR "DescribeSensor: POST\n$message\n" if $self->debug;
        $response = $self->ua->request(POST $self->server_url, Content_Type => 'text/xml', Content => $message);
    }

    return _process_response($response);
}

sub GetObservation {
    my ($self,$offering,$observedProperty,$beginTime,$endTime) = @_;
#    my $responseFormat = 'text/xml;schema="ioos/0.6.1"';
    my $responseFormat = 'text/xml; subtype="om/1.0.0"';
#    my $responseFormat = 'text/xml%3B+subtype="om/1.0.0"';
#    my $responseFormat = 'text/csv';
#    my $responseFormat = 'text/tab-separated-values';
#    my $responseFormat = 'blah';
    my $response;
    if ($self->{method} =~ /^get$/i) {
        my $request = sprintf('%s?request=GetObservation&service=SOS&version=1.0.0&responseFormat=%s&offering=%s&observedProperty=%s&eventTime=%s',
                                    $self->server_url,
                                    uri_escape($responseFormat),
                                    uri_escape($offering),
                                    uri_escape($observedProperty),
                                    uri_escape("$beginTime/$endTime")
                                 );
        print STDERR "GetObservation: $request\n" if $self->debug;
        $response = $self->ua->get($request);
    }
    else {
        my $message = sprintf('<?xml version="1.0" encoding="UTF-8"?>
<sos:GetObservation
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
   xsi:schemaLocation="http://schemas.opengis.net/sos/1.0.0/sosAll.xsd"
   xmlns:sos="http://www.opengis.net/sos/1.0"
   xmlns:gml="http://www.opengis.net/gml/3.2"
   xmlns:ogc="http://www.opengis.net/ogc"
   xmlns:om="http://www.opengis.net/om/1.0" service="SOS" version="1.0.0">
  <sos:offering>%s</sos:offering>
  <sos:observedProperty>%s</sos:observedProperty>
  <sos:responseFormat>%s</sos:responseFormat>
  <sos:eventTime>
    <ogc:TM_During>
      <ogc:PropertyName>om:samplingTime</ogc:PropertyName>
      <gml:TimePeriod>
        <gml:beginPosition>%s</gml:beginPosition>
        <gml:endPosition>%s</gml:endPosition>
      </gml:TimePeriod>
    </ogc:TM_During>
  </sos:eventTime>
  <result>
    <ogc:PropertyIsEqualTo>
        <ogc:PropertyName>VerticalDatum</ogc:PropertyName>
        <ogc:Literal>urn:ioos:def:datum:noaa::MLLW</ogc:Literal>
    </ogc:PropertyIsEqualTo>
  </result>
</sos:GetObservation>',$offering,$observedProperty,$responseFormat,$beginTime,$endTime);

#  <sos:observedProperty>http://mmisw.org/ont/cf/parameter/water_surface_height_above_reference_datum</sos:observedProperty>

        print STDERR "GetObservation: POST\n$message\n" if $self->debug;
        $response = $self->ua->request(POST $self->server_url, Content_Type => 'text/xml', Content => $message);
    }

    return _process_response($response);
}

__PACKAGE__->meta->make_immutable();

1;
