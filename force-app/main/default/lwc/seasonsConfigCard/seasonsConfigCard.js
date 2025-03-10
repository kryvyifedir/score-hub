import { LightningElement, wire  } from 'lwc';
import Toast from 'lightning/toast';
// APEX Controller methods
import getSeasonsConfig from '@salesforce/apex/SeasonsCardController.getSeasonsConfig';
import activateModifySeasons from '@salesforce/apex/SeasonsCardController.activateModifySeasons';
import deactivateSeasons from '@salesforce/apex/SeasonsCardController.deactivateSeasons';

//Custom Labels
import ConfigureSeasonsHeader from '@salesforce/label/c.ConfigureSeasonsHeader';
import SeasonFeatureHelpText from '@salesforce/label/c.SeasonFeatureHelpText';
import SeasonsCadenceConfigTitle from '@salesforce/label/c.SeasonsCadenceConfigTitle';
import SeasonsCadenceConfigPlaceholder from '@salesforce/label/c.SeasonsCadenceConfigPlaceholder';
import StartDateConfigTitle from '@salesforce/label/c.StartDateConfigTitle';
import SomethingWentWrongErrorTitle from '@salesforce/label/c.SomethingWentWrongErrorTitle';
import RetrieveSeasonConfigErrorMsg from '@salesforce/label/c.RetrieveSeasonConfigErrorMsg';
import MonthCadenceOption from '@salesforce/label/c.MonthCadenceOption';
import QuarterCadenceOption from '@salesforce/label/c.QuarterCadenceOption';
import YearCadenceOption from '@salesforce/label/c.YearCadenceOption';
import ActivateSeasonBtn from '@salesforce/label/c.ActivateSeasonBtn';
import ModifySeasonBtn from '@salesforce/label/c.ModifySeasonBtn';
import DeactivateSeasonBtn from '@salesforce/label/c.DeactivateSeasonBtn';
import ModifiedToastMsg from '@salesforce/label/c.ModifiedToastMsg';
import ModifiedToastHelpTxt from '@salesforce/label/c.ModifiedToastHelpTxt';
import ActivatedToastMsg from '@salesforce/label/c.ActivatedToastMsg';
import ActivatedToastHelpTxt from '@salesforce/label/c.ActivatedToastHelpTxt';
import ActivatedModifiedToastErrorMsg from '@salesforce/label/c.ActivatedModifiedToastErrorMsg';
import DeactivatedToastMsg from '@salesforce/label/c.DeactivatedToastMsg';
import DeactivatedToastHelpTxt from '@salesforce/label/c.DeactivatedToastHelpTxt';
import DeactivatedToastErrorMsg from '@salesforce/label/c.DeactivatedToastErrorMsg';
import StartDateConfigValidationMsg  from '@salesforce/label/c.StartDateConfigValidationMsg';

export default class SeasonsConfigCard extends LightningElement {
    labels = {
        ConfigureSeasonsHeader, SeasonFeatureHelpText, SeasonsCadenceConfigTitle, SeasonsCadenceConfigPlaceholder, StartDateConfigTitle, SomethingWentWrongErrorTitle, 
        RetrieveSeasonConfigErrorMsg, MonthCadenceOption, QuarterCadenceOption, YearCadenceOption, ActivateSeasonBtn, ModifySeasonBtn, DeactivateSeasonBtn, ModifiedToastMsg,
        ActivatedToastMsg, DeactivatedToastMsg, ModifiedToastHelpTxt, ActivatedToastHelpTxt, ActivatedModifiedToastErrorMsg, DeactivatedToastHelpTxt, DeactivatedToastErrorMsg,
        StartDateConfigValidationMsg
    };

    isConfigLoaded
    isModified
    isActive
    originalCadence
    selectedCadence
    originalDate
    selectedDate

    currentDateString = (new Date()).toISOString().split('T')[0];

    @wire(getSeasonsConfig)
    wiredSeasonsConfig({ data, error }) {
        if (data) {
            if (data.Success) {
                var result = data.Success;
                this.isActive = result.isActive
                this.originalCadence = result.cadence
                this.selectedCadence = result.cadence
                this.originalDate  = result.startDate
                this.selectedDate = result.startDate
                this.isConfigLoaded = true
            } else if (data.Error) {
                console.log(JSON.stringify(data.Error))
                Toast.show({
                    label: this.labels.SomethingWentWrongErrorTitle,
                    message: this.labels.RetrieveSeasonConfigErrorMsg,
                    variant: 'error'
                }, this)
            }
        } else if (error) {
            console.log(JSON.stringify(error))
            Toast.show({
                label: this.labels.SomethingWentWrongErrorTitle,
                message: this.labels.RetrieveSeasonConfigErrorMsg,
                variant: 'error'
            }, this)
        }
    }

    get cadenceOptions() {
        return [
            { label: this.labels.MonthCadenceOption, value: 'month' },
            { label: this.labels.QuarterCadenceOption, value: 'quarter' },
            { label: this.labels.YearCadenceOption, value: 'year' },
        ]
    }

    get buttonState() {
        var buttonState = {}
        if (!this.isActive || this.isModified) {
            buttonState.label = !this.isActive ? this.labels.ActivateSeasonBtn : this.labels.ModifySeasonBtn
            buttonState.variant = 'brand'
            buttonState.disabled = !this.isActive && this.selectedDate <= this.currentDateString
        } else {
            buttonState.label = this.labels.DeactivateSeasonBtn
            buttonState.variant = 'destructive'
            buttonState.disabled = false
        }

        return buttonState
    }

    get dateValidity() {
        return false;
    }

    get startDateDisabled() {
        return this.isActive && this.originalDate <= this.currentDateString
    }

    get cadenceDisabled() {
        return this.isActive && this.originalDate <= this.currentDateString
    }

    async handleClick(event) {
        if (!this.isActive || this.isModified) {
            this.handleActivateModify()
        } else {
            this.handleDeactivate()
        }
    }

    async handleActivateModify() {
        try {
            var result = await activateModifySeasons({ cadence: this.selectedCadence, startDate: this.selectedDate });
            if (result.Success) {
                Toast.show({
                    label: this.isActive ? this.labels.ModifiedToastMsg : this.labels.ActivatedToastMsg,
                    message: this.isActive ? this.labels.ModifiedToastHelpTxt : this.labels.ActivatedToastHelpTxt,
                    variant: 'success'
                }, this)
                this.originalCadence = this.selectedCadence
                this.originalDate = this.selectedDate
                this.isActive = true;
                this.isModified = false;
            } else if (result.Error) {
                console.log(JSON.stringify(data.Error))
                Toast.show({
                    label: this.labels.SomethingWentWrongErrorTitle,
                    message: this.labels.ActivatedModifiedToastErrorMsg,
                    variant: 'error'
                }, this)
            }
        } catch (error) {
            console.log(JSON.stringify(error))
            Toast.show({
                label: this.labels.SomethingWentWrongErrorTitle,
                message: this.labels.ActivatedModifiedToastErrorMsg,
                variant: 'error'
            }, this)
        }
    }

    async handleDeactivate() {
        try {
            var result = await deactivateSeasons();
            if (result.Success) {
                Toast.show({
                    label: this.labels.DeactivatedToastMsg,
                    message: this.labels.DeactivatedToastHelpTxt,
                    variant: 'success'
                }, this)
                this.isActive = false;
            } else if (result.Error) {
                console.log(JSON.stringify(data.Error))
                Toast.show({
                    label: this.labels.SomethingWentWrongErrorTitle,
                    message: this.labels.DeactivatedToastErrorMsg,
                    variant: 'error'
                }, this)
            }
        } catch (error) {
            console.log(JSON.stringify(error))
            Toast.show({
                label: this.labels.SomethingWentWrongErrorTitle,
                message: this.labels.DeactivatedToastErrorMsg,
                variant: 'error'
            }, this)
        }
    }

    handleCadenceChange(event) {
        this.selectedCadence = event.detail.value
        this.isModifiedCheck()
    }

    handleDateChange(event) {
        this.selectedDate = event.detail.value
        var dateCmp = this.template.querySelector('.startDate');
        if (this.selectedDate <= this.currentDateString) {
            dateCmp.setCustomValidity('Season start date is expected to be in the future')
        } else {
            dateCmp.setCustomValidity('')
        }
        dateCmp.reportValidity()
        this.isModifiedCheck()
    }

    isModifiedCheck() {
        if (this.selectedCadence !== this.originalCadence || 
            this.selectedDate !== this.originalDate) {
            this.isModified = true
        } else {
            this.isModified = false
        }
    }
}