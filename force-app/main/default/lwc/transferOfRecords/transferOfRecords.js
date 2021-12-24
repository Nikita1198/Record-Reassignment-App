import { wire, api, LightningElement, track} from 'lwc';
import updateRecord from '@salesforce/apex/SampleAuraController.getPiklistValues';
import takeRecord from '@salesforce/apex/SampleAuraController.getValues';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


const DELAY = 350;
export default class LWCWizard extends LightningElement {
 
    @track currentStep = '1';

    @track users;
    @track error;
    @api options = [];


    handleOnStepClick(event) {
        this.currentStep = event.target.value;
    }
 
    get isStepOne() {
        return this.currentStep === "1";
    }
 
    get isStepTwo() {
        return this.currentStep === "2";
    }
 
    get isStepThree() {
        return this.currentStep === "3";
    }
 
    get isEnableNext() {
        return this.currentStep != "3";
    }
 
    get isEnablePrev() {
        return this.currentStep != "1";
    }
 
    get isEnableFinish() {
        return this.currentStep === "3";
    }
 
    handleNext(){
        if(this.currentStep == "1"){

            if(this.toUserName !="" && this.fromUserName !="" ){

                console.log('Start');
                takeRecord({
                    fromUserId: this.fromUserId,
                }).then(result => {

                    if (result) {
                        const items = [];
                        for (let i = 1; i <= result.length; i++) {
                            items.push({
                                label: result[i],
                                value: result[i],
                            });
                        }
                        this.options.push(...items);
                        console.log('Stop');
                        this.currentStep = "2";
                    } else {
                        console.log('error with list');
                    }
                })
                .catch(error => {
                    this.error = error;
                    console.log('error: ', error);
                });
            }else if(this.toUserName == "" || this.fromUserName == "" ){
                const evt = new ShowToastEvent({
                    title: 'Error',
                    message: 'You must enter user name!',
                    variant: 'error',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);
            }
           
            
        }
        else if(this._selected == 'none' || this._selected == '' ){
            const evt = new ShowToastEvent({
                title: 'Error',
                message: 'At least one object record must be selected!',
                variant: 'error',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
        }else if(this._selected != 'none'){ 
            this.currentStep = "3";
        }
    }
 
    handlePrev(){
        if(this.currentStep == "3"){
            this.currentStep = "2";
        }
        else if(this.currentStep = "2"){
            this.currentStep = "1";
        }
        this.values =  this._selected;
    }


    handleFinish() {
        updateRecord({
            fromUserId: this.fromUserId,
            toUserId: this.toUserId,
            recordType: this._selected
        })
        .then(() => {
                const evt = new ShowToastEvent({
                    title: "Success",
                    message: "All records were reassigned!",
                    variant: "success",
                });
                this.dispatchEvent(evt);
                window.location.reload();
        })
        .catch((error) => {
            this.message = 'Error received: code' + error.errorCode + ', ' +
                'message ' + error.body.message;
        });
            
    }
   



    @track _selected = [];
    
   /* get options() {
        console.log('getOptions');
            this.listOpt.value = this.option;
            this.listOpt.label = this.option;
        return [
            { label: 'Task', value: 'Task' },
            { label: 'Contact', value: 'Contact' },
            { label: 'Event', value: 'Event' },
            { label: 'Lead', value: 'Lead' },
            { label: 'Opportunity', value: 'Opportunity' },
            { label: 'Account', value: 'Account' },
        ];
        return this.listOpt;
    }*/

    get selected() {
        return this._selected.length ? this._selected : 'none';
    }

    handleChange(e) {
        this._selected = e.detail.value;
    }




// NEW CONTROLLER

@track toUserName = ""; 
@track fromUserName = "";   
@track toUserId;  
@track fromUserId; 

   onFromUserSelection(event){  
   this.fromUserName = event.detail.selectedValue;  
   this.fromUserId = event.detail.selectedRecordId;  
   }  
  
   onToUserSelection(event){  
   this.toUserName = event.detail.selectedValue;  
   this.toUserId = event.detail.selectedRecordId;  
   }  


   //ERRORS
   showErrorToast() {
    const evt = new ShowToastEvent({
        title: 'Toast Error',
        message: 'Some unexpected error',
        variant: 'error',
        mode: 'dismissable'
    });
    this.dispatchEvent(evt);
    }

    showSuccessNotification() {
        const evt = new ShowToastEvent({
            title: "Success",
            message: "This is sample success message",
            variant: "success",
        });
        this.dispatchEvent(evt);
    }

}  



