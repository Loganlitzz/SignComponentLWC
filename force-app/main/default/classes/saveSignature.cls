public without sharing class saveSignature {
    @AuraEnabled(cacheable=false)
    public static string saveSignature(string data){
        try {
            ContentVersion cv = new ContentVersion();
            cv.PathOnClient = 'Sign - '+System.now().getTime()+'.png';
            cv.title= 'Sign - '+System.now().getTime()+'.png';
            cv.VersionData= EncodingUtil.base64Decode(data);
            insert cv;
            return [Select contentDocumentId From ContentVersion Where id=:cv.id].contentDocumentId;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @InvocableMethod(label='createContentDocumentLinkForSignature' description='This invocable method is used to attached Sign from signature component to record id')
    public static void createContentDocumentLinkForSignature(List<Input> inputs) {
        ContentDocumentLink cdl = new ContentDocumentLink();
        String relatedId,contentdocumentid;
        for(Input i: inputs)
        {
            relatedId=i.RecordId.toString();
            contentdocumentid=i.ContentDocumentId.toString();
        }
        cdl.ContentDocumentId = contentdocumentid;
        cdl.LinkedEntityId=relatedId;
        insert cdl;
    }
    
    public class Input{
        @InvocableVariable(label='Related Record ID' required = true)
        public Id RecordId;
        @InvocableVariable(label='ContentDocumentID' required = true)
        public Id ContentDocumentId;
        // @InvocableVariable(label='ContentDocument ID' required = true)
        // public Id ContentDocumentid;
    }
    
}