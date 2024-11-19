/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
public class SignatureComponentTests {

    @isTest
    static void saveSignature() {
        // TO DO: implement unit test
        Assert.isNotNull(saveSignature.saveSignature('dGhpcyBpcyB1bml0IHRlc3Q='));
    }
   @isTest
    static void clearSavedSignature(){
        ContentVersion cv = new ContentVersion();
            cv.PathOnClient = 'Sign - '+System.now().getTime()+'.png';
            cv.title= 'Sign - '+System.now().getTime()+'.png';
            cv.VersionData= EncodingUtil.base64Decode('dGhpcyBpcyB1bml0IHRlc3Q=');
            insert cv;
            Account acc = new Account();
            acc.name='Unit Test';
            insert acc;
            Id cdlid=[Select contentDocumentId From ContentVersion Where id=:cv.id].contentDocumentId;
            saveSignature.Input argument;
            argument = new saveSignature.Input();
        	argument.RecordId=acc.Id;
        	argument.ContentDocumentId=cdlid;
            List<String> cdl=new List<String>();
        	saveSignature.createContentDocumentLinkForSignature(new List<saveSignature.Input> {argument});
            
            cdl.add([Select contentDocumentId From ContentVersion Where id=:cv.id].contentDocumentId);
            clearSavedSignature.clearSavedSignature(cdl);
    }
}