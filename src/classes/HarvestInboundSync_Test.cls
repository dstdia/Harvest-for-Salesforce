@isTest
private class HarvestInboundSync_Test {
    
    private static Harvest_TestUtil.HarvestTester ht;
    
    static {
        system.debug('$$$CALLING STATIC$$$');
        ht = new Harvest_TestUtil.HarvestTester();
    } 

    @testSetup
    private static void setup() {

        Harvest_TestSetup.init();
    }
    
    @isTest
    static void testInboundSync() {

        Test.setMock(HttpCalloutMock.class, new Harvest_MockHandler());
        Test.startTest();
        
        HarvestInboundSyncController.sync();
        
        Test.stopTest();
    }
    
    
    @isTest
    static void testScheduler() {
        
        Test.setMock(HttpCalloutMock.class, new Harvest_MockHandler());
        Test.startTest();
        String jobId = System.schedule('testBasicScheduledApex', '0 0 0 3 9 ? 2022', new HarvestInboundSync());
        Test.stopTest();
    }
}