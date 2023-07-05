@RestResource (urlMapping='/api/Webhooks/pushDetailsdemo/*')
global with sharing class webhookSubscriptionDemo {
    @HttpPost
    global static void handleNotification() { 

        try{
            RestRequest request = RestContext.request;
            RestResponse response=RestContext.response;
            String hashedval = request.headers.get('X-Hub-Signature-256');
            Blob b = request.requestBody;
            JSONParser parser = JSON.createParser(request.requestBody.toString());
            pusher ps;
            head_commit hc;
            String repo;
            while (parser.nextToken() != null){
                if (parser.getText() == 'pusher')
                {
                    System.debug('Inside Pusher');
                    parser.nextToken();
                    ps = (pusher)parser.readValueAs(pusher.class);
                    System.debug(ps);
                }
                if(parser.getText() == 'head_commit'){
                    System.debug('Inside Head Commit');
                    parser.nextToken();
                    hc = (head_commit)parser.readValueAs(head_commit.class);
                    System.debug(hc);
                }
                if (parser.getText() == 'full_name'){
                    System.debug('Inside Full Name');
                    parser.nextToken();
                    repo = parser.getText();
                    System.debug(repo);
                }

            }
            
            Push_Details_Demo__c pd = new Push_Details_Demo__c();
            pd.Committer_Name__c = ps!=null?ps.name:'';
            pd.Committer_Email__c = ps!=null?ps.email:'';
            pd.name = 'test';
			insert pd;
			response.statusCode = 200;
            response.responseBody = Blob.ValueOf(JSON.serialize(new SFDCResponse('Success','Processed Successfully')));
        }catch(Exception e){
            System.debug('Exception Happened: '+e.getMessage());
            } 
 
     }
     Public class SFDCResponse{
        String response;
        String message;
        public SFDCResponse(String resp, String msg){
            response = resp;
            message = msg;
        }
     }
     public class pusher{
        public String name;
        public String email;
        public pusher(String name, String email){
            name = name;
            email = email;
        }
     }
    public class head_commit{
        public String name;
        public String email;
        public head_commit(String name, String email){
            name = name;
            email = email;
        }
     }

}