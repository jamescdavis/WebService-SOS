package WWW::SOS::Response::Operation;
use XML::Rabbit;

has_xpath_value name => './@name';
has_xpath_value Get => './ows:DCP/ows:HTTP/ows:Get/@xlink:href';
has_xpath_value Post => './ows:DCP/ows:HTTP/ows:Post/@xlink:href';
has_xpath_object_list Parameters => './ows:Parameter' => 'WWW::SOS::Response::Parameter';

finalize_class();
