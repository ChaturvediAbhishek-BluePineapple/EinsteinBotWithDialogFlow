public class DialogFlowHandler {
    
    IntentResponse processedResponse;
    //This function gets the response and checks what action needs to be taken
    public DialogFlowHelper.IntentReturnWrapper parseResponse(string jsonResponse) {
        Map<string,Object> response = (Map<String,Object>)JSON.deserializeUntyped(jsonResponse);
        Map<string,Object> queryResults = (Map<string,Object>)response.get('queryResult');
        Map<string,Object> params = (Map<string,Object>)queryResults.get('parameters');
        boolean areRequiredParamteresPresent = false;
        if(queryResults.get('allRequiredParamsPresent') != null) {
            areRequiredParamteresPresent = (boolean)queryResults.get('allRequiredParamsPresent');
        }
        processedResponse = new IntentResponse((string)queryResults.get('action'),params,areRequiredParamteresPresent,(string)queryResults.get('fulfillmentText'));
        if(processedResponse.allRequiredParamsPresent) {
            return this.performAction();
        }
        return new DialogFlowHelper.IntentReturnWrapper((string)queryResults.get('fulfillmentText'),true);
    }
    
    //If all parameters are present, take an action based on the action name.
    //The following can be replaced by a framework according to requirement.
    public DialogFlowHelper.IntentReturnWrapper performAction() {
        switch on processedResponse.actionName {
            when 'getorderstatus' {
                return new DialogFlowHelper.IntentReturnWrapper(DialogFlowActions.getOrderStatus(String.valueOf(processedResponse.params.get('number')),processedResponse.fulfillmentText),false);
            } when 'getphonebyname' {
                return new DialogFlowHelper.IntentReturnWrapper(DialogFlowActions.getPhoneNumber(String.valueOf(processedResponse.params.get('given-name')),String.valueOf(processedResponse.params.get('last-name')),processedResponse.fulfillmentText),false);
            } when else {
                return new DialogFlowHelper.IntentReturnWrapper('Could Not Process your request',false);
            }
        }
    }

    public class IntentResponse {
        string actionName;
        Map<string,Object> params;
        boolean allRequiredParamsPresent;
        string fulfillmentText;
        
        public IntentResponse(string actionName,Map<string,Object> params,boolean allRequiredParamsPresent,string fulfillmentText) {
			this.actionName =actionName;
			this.params = params;
            this.allRequiredParamsPresent = allRequiredParamsPresent;
            this.fulfillmentText = fulfillmentText;
        }
    }
    
    public class Messages {
        Text text;
    }
    
    public class Text {
        List<string> text;
    }
}