import { LightningElement, api,wire} from 'lwc';
import getSignature from '@salesforce/apex/getSignature.getSignature';

export default class SignatureDisplay extends LightningElement {
    @api recordId;
    basedata;
    result;
    
        @wire(getSignature,{RecordId: '$recordId'})
        result({error,data}){
            this.basedata=data;
        }
    
}