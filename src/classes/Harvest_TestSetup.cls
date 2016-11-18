public class Harvest_TestSetup {

	public static void init() {

		HArvest__c settings = new Harvest__c();

		settings.Create_Harvest_Project_Automatically__c = true;
        settings.Delete_Client_In_Harvest__c = true;
        settings.SSL__c = true;
        settings.Subdomain__c = 'somesubdomain';
        settings.Username__c = 'foo';
        settings.Password__c = 'toolkittesting';
        settings.Name = 'Harvest (Organisation)';
        
        upsert settings Name; 

		setupResponses();
	}



	public static void setupResponses() {

		Harvest_MockHandler.getResponseMap().get('GET').put(
          'https://somesubdomain.harvestapp.com/account/who_am_i',
            new List<Harvest_MockHandler.MockResponse> {
                new Harvest_MockHandler.MockResponse((String) Harvest_TestUtil.whoAmIResponse, 'success', 200, false)
            }
        );

        Harvest_MockHandler.getResponseMap().get('GET').put(
          'https://somesubdomain.harvestapp.com/clients/',
            new List<Harvest_MockHandler.MockResponse> {
                new Harvest_MockHandler.MockResponse(Harvest_TestUtil.getClientsResponse, 'success', 200, false)
            }
        );

        Harvest_MockHandler.getResponseMap().get('GET').put(
          'https://somesubdomain.harvestapp.com/contacts/',
            new List<Harvest_MockHandler.MockResponse> {
                new Harvest_MockHandler.MockResponse(Harvest_TestUtil.getContactsResponse, 'success', 200, false)
            }
        );

        Harvest_MockHandler.getResponseMap().get('GET').put(
          'https://somesubdomain.harvestapp.com/people/',
            new List<Harvest_MockHandler.MockResponse> {
                new Harvest_MockHandler.MockResponse(Harvest_TestUtil.getUsersResponse, 'success', 200, false)
            }
        );

        Harvest_MockHandler.getResponseMap().get('GET').put(
          'https://somesubdomain.harvestapp.com/projects/',
            new List<Harvest_MockHandler.MockResponse> {
                new Harvest_MockHandler.MockResponse(Harvest_TestUtil.getProjectsResponse, 'success', 200, false)
            }
        );

        

        Harvest_MockHandler.getResponseMap().get('GET').put(
          'https://somesubdomain.harvestapp.com/tasks/',
            new List<Harvest_MockHandler.MockResponse> {
                new Harvest_MockHandler.MockResponse(Harvest_TestUtil.getTasksResponse, 'success', 200, false)
            }
        );

        Harvest_MockHandler.getResponseMap().get('GET').put(
          'https://somesubdomain.harvestapp.com/task/1',
            new List<Harvest_MockHandler.MockResponse> {
                new Harvest_MockHandler.MockResponse(Harvest_TestUtil.getTaskResponse, 'success', 200, false)
            }
        );
	}
}