public class DialogFlowHelper {
    
    //This function receives the text input and forwards it to your dialogflow agent
    //Replace project name, key and session id according to your specific instance
    //You can use locale set on user and pass it to DialogFlow agent or use google translate API to detect language
    @invocableMethod
    public static List<IntentReturnWrapper> getIntentFromDialogFlow(List<string> textInput) {
        User currentUser = [SELECT LanguageLocaleKey FROM User where id =:userinfo.getUserId()];
        string sessionId = userinfo.getUserId();
        string key = '';
        string projectName = '';
        string currentuserLocale = currentUser.LanguageLocaleKey;
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:DialogFlow/v2/projects/'+projectName+'/agent/sessions/'+sessionId+':detectIntent?key='+key);
        req.setMethod('POST');
        req.setBody('{"queryInput":{"text":{"languageCode":"zh-TW","text":"'+textInput[0]+'"}}}');
        req.setHeader('Content-Type','application/json');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        DialogFlowHandler dFHandler = new DialogFlowHandler();
        
        return new List<IntentReturnWrapper>{dFHandler.parseResponse(res.getBody())};
    }
    
    public class IntentReturnWrapper {
        @InvocableVariable
        public string fulfillmentText;
        @InvocableVariable
        public boolean isFollowupRequired;
        
        public IntentReturnWrapper(string fulfillmentText,boolean isFollowupRequired) {
            this.fulfillmentText = fulfillmentText;
            this.isFollowupRequired = isFollowupRequired;
        }
    }
}