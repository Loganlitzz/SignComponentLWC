import { LightningElement, api, track } from 'lwc';
import saveSignature from '@salesforce/apex/saveSignature.saveSignature';
import clearSavedSignature from '@salesforce/apex/clearSavedSignature.clearSavedSignature';

let canvas,ctx;
let mDown=false;
let currPos ={x: 0, y: 0};
let prePos ={x: 0, y: 0};
let contentDocumentIdList=[];

export default class SignatureCaptureLWC extends LightningElement {
    @api ContentDocumentID;
    @track hasRendered=true;
    @track hasDrawn=false;
    showspinner=false;
    isSelected = false;
    isSave="utility:save";
    isClear="Saved";
    variantState="brand";
    isDisabled=false;

    renderedCallback(){
        if(this.hasRendered){
            canvas = this.template.querySelector('canvas');
            canvas.addEventListener('mousedown',this.handleMousedown.bind(this));
            canvas.addEventListener('mouseup',this.handleMouseup.bind(this));
            canvas.addEventListener('mousemove',this.handleMousemove.bind(this));
            canvas.addEventListener('mouseout',this.handleMouseend.bind(this));
            ctx = canvas.getContext('2d');
            ctx.font = "20px Arial";
            ctx.fillStyle="silver";
            ctx.textAlign = "center";
            ctx.fillText("Sign Here",150, 60);
            ctx.imageSmoothingQuality='high';
            console.log("inside rendercallback = " + this.hasDrawn);
            canvas.addEventListener("onchange",function handleonChange(e){
            this.hasDrawn=true;
            this.ContentDocumentID="";
        });
        canvas.addEventListener("mousedown", function handleClick(e) {
            this.hasDrawn=true;
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            canvas.removeEventListener("mousedown", handleClick);
        });
        this.hasRendered=false;
        console.log("outside rendercallback = " + this.hasDrawn);

    }
    }

    handleMousedown(evt)
    {
        console.log("inside mousedown = " + this.hasDrawn);
        evt.preventDefault();
        mDown=true;
        this.getPos(evt);
    }
    handleMouseup(evt)
    {
        evt.preventDefault();
        mDown=false;
    }
    handleMousemove(evt){
        evt.preventDefault();
        if(mDown)
        {
            this.getPos(evt);
            this.draw();
        }
    }
    getPos(evt)
    {
        let cRect = canvas.getBoundingClientRect();
        prePos = currPos;
        currPos = { x: (evt.clientX - cRect.left), y: (evt.clientY - cRect.top)};
    }
    handleMouseend(evt)
    {
        evt.preventDefault();
        mDown = false;
    }
    draw()
    {
        this.hasDrawn=true;
        ctx.beginPath();
        ctx.moveTo(prePos.x, prePos.y);
        ctx.lineCap = 'round';
        ctx.lineWidth = 1.5;
        ctx.strokeStyle = "black";
        ctx.lineTo(currPos.x, currPos.y);
        ctx.closePath();
        ctx.stroke();
    }
    
    signatureClear()
    {
        this.hasDrawn=false;
        ctx.clearRect(0,0,canvas.width,canvas.height);
        ctx.font = "20px Arial";
        ctx.fillStyle="silver";
        ctx.textAlign = "center";
        ctx.fillText("Sign Here",150, 60);
        canvas.addEventListener("mousedown", function handleClick(e) {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        canvas.removeEventListener("mousedown", handleClick);
        });
        this.showspinner=true;
        clearSavedSignature({ListofContentDocumentIds: contentDocumentIdList})
        .then(result=>{
            this.showspinner=false;
        }).catch(error =>{
            this.showspinner=false;
            console.log(error);
        });
        console.log(contentDocumentIdList);
        this.ContentDocumentID="";
        this.isSave="utility:save";
        this.isClear="Save";
        this.variantState="Brand";
        this.isDisabled=false;
    }


    saveSignature(evt){
        if(this.hasDrawn){
        this.isSelected=true;
        let imageURL=canvas.toDataURL('image/png');
        let imageData = imageURL.replace(/^data:image\/(png|jpg);base64,/,"");
        this.showspinner=true;
        saveSignature({data: imageData})
        .then(result=>{
            this.ContentDocumentID=result;
            contentDocumentIdList.push(this.ContentDocumentID);
            console.log('returned value' + result);
            this.showspinner=false;
            this.hasDrawn=false;
            this.isSave="utility:check";
            this.variantState="success";
            this.isClear="Saved";
            this.isDisabled=true;
        })
        .catch(error =>{
            this.showspinner = false;
        })
    }
    else{
        alert('Please input signature Or Clear and Update the existing Signature.');
        this.hasDrawn=false;
    }
    }
}

