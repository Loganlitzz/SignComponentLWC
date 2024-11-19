public without sharing class getSignature {
    @AuraEnabled
    public Static String getSignature(String Recordid) {
        List<ContentDocumentLink> img=[Select ContentDocument.Id,ContentDocument.FileExtension, ContentDocument.LatestPublishedVersion.Title, ContentDocument.LatestPublishedVersion.VersionData,ContentDocument.LatestPublishedVersionId From ContentDocumentLink Where LinkedEntityId=:Recordid Limit 1];
        if(!img.isEmpty())
        {
            ContentDocumentLink cdl=img[0];
            string cid='/sfc/servlet.shepherd/document/version/'+cdl.ContentDocument.LatestPublishedVersionId;
            String base64Data='data:image/' + cdl.ContentDocument.FileExtension + ';charset=utf-8;base64, ';
            base64Data+=EncodingUtil.base64Encode(cdl.ContentDocument.LatestPublishedVersion.VersionData);
            return cid;
        }
        return 'Sign Not Provided.';
    }
}