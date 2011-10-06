package WWW::SOS::Response::Capabilities;
use XML::Rabbit;

# Service Identification

has_xpath_value              Title => './ows:ServiceIdentification/ows:Title';
has_xpath_value           Abstract => './ows:ServiceIdentification/ows:Abstract';
has_xpath_value        ServiceType => './ows:ServiceIdentification/ows:ServiceType';
has_xpath_value ServiceTypeVersion => './ows:ServiceIdentification/ows:ServiceTypeVersion';
has_xpath_value               Fees => './ows:ServiceIdentification/ows:Fees';
has_xpath_value  AccessConstraints => './ows:ServiceIdentification/ows:AccessConstraints';
has_xpath_value_list      Keywords => './ows:ServiceIdentification/ows:Keywords/ows:Keyword';


# Service Provider Description

has_xpath_value          ProviderName => './ows:ServiceProvider/ows:ProviderName';
has_xpath_value          ProviderSite => './ows:ServiceProvider/ows:ProviderSite/@xlink:href';
has_xpath_value        IndividualName => './ows:ServiceProvider/ows:ServiceContact/ows:IndividualName';
has_xpath_value          PositionName => './ows:ServiceProvider/ows:ServiceContact/ows:PositionName';
has_xpath_value                 Voice => './ows:ServiceProvider/ows:ServiceContact/ows:ContactInfo/ows:Phone/ows:Voice';
has_xpath_value         DeliveryPoint => './ows:ServiceProvider/ows:ServiceContact/ows:ContactInfo/ows:Address/ows:DeliveryPoint';
has_xpath_value                  City => './ows:ServiceProvider/ows:ServiceContact/ows:ContactInfo/ows:Address/ows:City';
has_xpath_value    AdministrativeArea => './ows:ServiceProvider/ows:ServiceContact/ows:ContactInfo/ows:Address/ows:AdministrativeArea';
has_xpath_value            PostalCode => './ows:ServiceProvider/ows:ServiceContact/ows:ContactInfo/ows:Address/ows:PostalCode';
has_xpath_value               Country => './ows:ServiceProvider/ows:ServiceContact/ows:ContactInfo/ows:Address/ows:Country';
has_xpath_value ElectronicMailAddress => './ows:ServiceProvider/ows:ServiceContact/ows:ContactInfo/ows:Address/ows:ElectronicMailAddress';


# Operations Metadata

has_xpath_object_list Operations => './ows:OperationsMetadata/ows:Operation' => 'WWW::SOS::Response::Operation';


# Observation Offerings

has_xpath_object_list Offerings => './sos:Contents/sos:ObservationOfferingList/sos:ObservationOffering' => 'WWW::SOS::Response::Offering';


finalize_class();
