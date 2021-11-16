import { wire, api, LightningElement, track} from 'lwc';

import getOppty from '@salesforce/apex/ManagingRecords.getOppty';
import getAcc from '@salesforce/apex/ManagingRecords.getAcc';
import getEven from '@salesforce/apex/ManagingRecords.getEven';
import getTask from '@salesforce/apex/ManagingRecords.getTask';
import getContact from '@salesforce/apex/ManagingRecords.getContact';
import getLead from '@salesforce/apex/ManagingRecords.getLead';

import updateOppty from '@salesforce/apex/ManagingRecords.updateOppty';


import { updateRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';

import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import findRecords from "@salesforce/apex/LwcLookupController.findRecords"; 
import { ShowToastEvent } from 'lightning/platformShowToastEvent';



const DELAY = 350;
export default class LWCWizard extends LightningElement {
 
    @track currentStep = '1';

    @track users;
    @track error;


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
            this.currentStep = "2";
        }
        else if(this._selected == 'none' || this._selected == '' ){
            const evt = new ShowToastEvent({
                title: 'Error',
                message: 'At least one object record must be selected!',
                variant: 'error',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);}
        else if(this._selected != 'none'){ 
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


    @wire(getOppty, { fromUser: '$fromUserId' }) opptiesOver;
    @wire(getAcc, { fromUser: '$fromUserId' }) accountsOver;
    @wire(getEven, { fromUser: '$fromUserId' }) eventsOver;
    @wire(getTask, { fromUser: '$fromUserId' }) taskOver;
    @wire(getContact, { fromUser: '$fromUserId' }) contactOver;
    @wire(getLead, { fromUser: '$fromUserId' }) leadOver;

    async handleFinish(e) {
        updateOppty({
            fromUser: this.fromUserId,
            toUser: this.toUserId,
            objectsName: this._selected
        })
        .then(() => {
            refreshApex(this.opptiesOver, this.accountsOver,this.eventsOver,this.taskOver, this.contactOver,this.leadOver)
            .then(() => {
                const evt = new ShowToastEvent({
                    title: "Success",
                    message: "All records were reassigned!",
                    variant: "success",
                });
                this.dispatchEvent(evt);
            });
        })
        .catch((error) => {
            this.message = 'Error received: code' + error.errorCode + ', ' +
                'message ' + error.body.message;
        });
            
    }
   



    @track _selected = [];
    

    get options() {
        return [
            { label: 'Task', value: 'Task' },
            { label: 'Contact', value: 'Contact' },
            { label: 'Event', value: 'Event' },
            { label: 'Lead', value: 'Lead' },
            { label: 'Opportunity', value: 'Opportunity' },
            { label: 'Account', value: 'Account' },
        ];
        
    }

    get selected() {
        return this._selected.length ? this._selected : 'none';
    }

    handleChange(e) {
        this._selected = e.detail.value;
    }




// NEW CONTROLLER

@track toUserName; 
@track fromUserName;   
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



