/**
 * Handler class for creating mock endpoints
 * @see http://blog.crmscience.com/2014/12/test-coverage-pattern-for-multi-callout.html
 * @see 
 * 
 */
@isTest 
public class Harvest_MockHandler implements HttpCalloutMock {
    
    //  Property and getter (semi init'd) to pair method --> endpoint --> List of responses
    private static 	Map<String, Map<String, List<MockResponse>>> ResponseMap;
    public static 	Map<String, Map<String, List<MockResponse>>> getResponseMap() {
        
        if (ResponseMap == null) {
            ResponseMap = New Map<String, Map<String, List<MockResponse>>>();
            
            //  For each setMethod() method type, pre-pop. w/ empty Map
            for (String method : New List<String>{'GET','PUT','POST','DELETE','HEAD','TRACE'})
                
                ResponseMap.put(method, New Map<String, List<MockResponse>>());
        }
        
        return ResponseMap;
    }
    
    //  Required respond() method for HttpCalloutMock
    public HttpResponse Respond(HttpRequest req) {

        Harvest_TestSetup.setupResponses();
       
        //  Property for returned response
        HttpResponse res = New HttpResponse();

        // gracefully send some mock response if everything else fails
            res.setStatusCode(200);
            res.setStatus('success');
            res.setBody('<?xml version="1.0" encoding="UTF-8"?><bogus></bogus>');
            res.setHeader('Location', req.getEndpoint());

        //  Ensure HttpRequest is valid
        if (req != null 
            && !String.isBlank(req.getMethod()) 
            && !String.isBlank(req.getEndPoint())) {
            
            //  Verify the Response Map contains the req's method and endpoint
            if (getResponseMap().containsKey(req.getMethod()) && 
                getResponseMap().get(req.getMethod()).containsKey(req.getEndpoint())
            ) {
                
                //  Instantiate a List of the method/endpoint's response bodies
                List<MockResponse> respList = getResponseMap().get(req.getMethod()).get(req.getEndpoint());
                //  If there's at least one, use it - otherwise, output an error
                if (!respList.isEmpty()) {
                    
                    //  Use the first in the List - might be called again or discarded
                    MockResponse r = respList[0];
                    
                    res.setBody(r.Body);
                    res.setStatus(r.Status);
                    res.setStatusCode(r.StatusCode);
                    res.setHeader('Location', req.getEndpoint());
                    
                    //  Unless provided true by test, remove the response so it isn't re-used
                    if (r.discard)
                        respList.remove(0);
                } 
                
                else {

                    system.debug('No responses for this method/endpoint');
                }
            } 
            
            else {
                system.debug('There was a problem with the prepared response Map');
            }
        } 
        
        else {
            
            system.debug('There was a problem with the Test Request:  ' + req);

        }
        
        return res;
    }
    
    //  Class to hold details of response from within test methods
    public class MockResponse {
        
        public String 	body { get; set; }
        public String 	status { get; set; }
        public integer 	statusCode { get; set; }
        public boolean 	discard { get; set; }
        
        public MockResponse(String body, String status, integer statusCode, boolean discard) {
            
            this.body = body;
            this.status = status;
            this.statusCode = statusCode;
            this.discard = discard;
        }
    }
    
    
}