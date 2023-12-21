public class MetadataService {

    public static void createCustomMetadataField(String metadataTypeName, String fieldName, String fieldType) {
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.endpoint_x = 'callout:Metadata';
        
        // Set up custom metadata field
        MetadataService.CustomMetadata customMetadata = new MetadataService.CustomMetadata();
        customMetadata.fullName = metadataTypeName + '.' + fieldName;
        customMetadata.label = fieldName;
        customMetadata.type = fieldType;

        // Add the custom metadata field to the list
        MetadataService.SaveResult[] results = service.createMetadata(
            new MetadataService.Metadata[] { customMetadata }
        );

        // Check for errors in the results
        for (MetadataService.SaveResult result : results) {
            if (result.errors != null) {
                for (MetadataService.Error error : result.errors) {
                    System.debug('Error message: ' + error.message);
                }
            }
        }
    }

}
