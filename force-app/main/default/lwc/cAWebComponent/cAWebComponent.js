import { LightningElement, track } from 'lwc';
import getDirections from '@salesforce/apex/MapsController.getDirections';

export default class MyMapLWC extends LightningElement {
    @track origin = '';
    @track destination = '';
    @track result;

    handleOriginChange(event) {
        this.origin = event.target.value;
    }

    handleDestinationChange(event) {
        this.destination = event.target.value;
    }

    getDirections() {
        getDirections({ origin: this.origin, destination: this.destination })
        .then(result => {
            this.result = result;
        })
        .catch(error => {
            // handle error
        });
    }
}
