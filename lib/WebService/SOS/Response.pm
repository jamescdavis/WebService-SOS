package WWW::SOS::Response;
use XML::Rabbit::Root 0.1.0;

add_xpath_namespace 'ows' => 'http://www.opengis.net/ows/1.1';
#add_xpath_namespace 'ows' => 'http://www.opengis.net/ows';
#add_xpath_namespace 'om' => 'http://www.opengis.net/om/1.0';

#sub BUILD {
#    my ($self) = @_;
#    return if $self->is_success;
#    confess("SOS response error " . $self->exceptionCode . ": " . $self->exceptionText);
#}

has 'is_success' => (
    is         => 'ro',
    isa        => 'Bool',
    lazy_build => 1,
);

sub _build_is_success {
    my ($self) = @_;
    return if $self->exceptionCode ne '';
    return 1;
}

has_xpath_value 'exceptionCode' => '/ows:ExceptionReport/ows:Exception/@exceptionCode';
has_xpath_value       'locator' => '/ows:ExceptionReport/ows:Exception/@locator';
has_xpath_value 'exceptionText' => '/ows:ExceptionReport/ows:Exception/ows:ExceptionText';

has_xpath_object 'Capabilities' => '/sos:Capabilities' => 'WWW::SOS::Response::Capabilities';

has_xpath_object 'Observations' => '/om:ObservationCollection' => 'WWW::SOS::Response::Observations';

finalize_class();
