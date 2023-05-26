public with sharing class MapsController {
    @AuraEnabled
    public static Map<String, String> getDirections(String origin, String destination) {
        // Get the Google Maps API Key
        String apiKey = 'AIzaSyA0Ncg4bjphkJ3dheLKRMFE8h3ScboQgxM';  // replace with your Google Maps API Key

        // Initialize the vHash variable with Base64 encoded full name
        String vHash = EncodingUtil.base64Encode(Blob.valueOf('NikhilaKunku'));  // replace with your name
        
        // Callout to Google Maps API
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=' + origin + '&destinations=' + destination + '&key=' + apiKey);
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        // Process the response
        Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        List<Object> rows = (List<Object>) data.get('rows');
        Map<String, Object> elements = (Map<String, Object>) ((Map<String, Object>)rows.get(0)).get('elements');
        Map<String, Object> distance = (Map<String, Object>) elements.get('distance');
        Map<String, Object> duration = (Map<String, Object>) elements.get('duration');

        // Calculate the cost based on the distance and a fixed rate per mile
        Decimal cost = calculateCost((Integer) distance.get('value'));

        // Return the result
        return new Map<String, String> {
            'distance' => (String) distance.get('text'),
            'travelTime' => (String) duration.get('text'),
            'cost' => String.valueOf(cost)
        };
    }

    private static Decimal calculateCost(Integer distanceInMeters) {
        // Convert distance to miles
        Decimal distanceInMiles = distanceInMeters * 0.000621371;

        // Get the rate per mile from Custom Metadata Type
        // Assume the Custom Metadata Type is named "Transportation_Mode__mdt" and it has a field named "Rate_Per_Mile__c"
        Decimal ratePerMile = [SELECT Rate__c FROM Transporation_Mode__mdt WHERE Mode__c	 = 'Driving'].Rate__c;

        // Calculate the cost
        return distanceInMiles * ratePerMile;
    }
}
