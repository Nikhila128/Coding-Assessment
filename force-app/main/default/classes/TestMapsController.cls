@isTest
public class TestMapsController {
    @isTest static void testGetDirections() {
        // Mock the HTTP callout
        Test.setMock(HttpCalloutMock.class, new MapsCalloutMock());

        // Call the method to test
        Map<String, String> result = MapsController.getDirections('1600 Amphitheatre Parkway, Mountain View, CA', '1 Infinite Loop, Cupertino, CA');

        // Verify the result
        System.assertEquals('10.0 mi', result.get('distance'));
        System.assertEquals('30 mins', result.get('travelTime'));
        System.assertEquals('5.00', result.get('cost'));
    }

    public class MapsCalloutMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"rows": [{"elements": [{"distance": {"value": 16093.4, "text": "10.0 mi"}, "duration": {"value": 1800, "text": "30 mins"}}]}]}');
            res.setStatusCode(200);
            return res;
        }
    }
}