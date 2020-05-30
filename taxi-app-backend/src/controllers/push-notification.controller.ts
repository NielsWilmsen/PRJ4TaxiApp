// Uncomment these imports to begin using these cool features!

import {inject} from '@loopback/context';

import {get} from '@loopback/rest';
var apn = require('apn');
export class PushNotificationController {
  @get('pushNotification')
  newOrderNotification() {
    var options = {
      token: {
        key: "./AuthKey_MVJHJ8K8MU.p8",
        keyId: "MVJHJ8K8MU",
        teamId: "KH7BD93PMV"
      },
      production: false
    };

    var apnProvider = new apn.Provider(options);
    let deviceToken = "<270af1b0387f063902197148256ed82aea287f4878767d9bab5c29efd5eaa841>";
    var newOrderNotification = new apn.Notification();

    newOrderNotification.expiry = Math.floor(Date.now() / 1000) + 3600; // Expires 1 hour from now.
    newOrderNotification.badge = 3;
    newOrderNotification.sound = "ping.aiff";
    newOrderNotification.alert = "\uD83D\uDCE7 \u2709 There is a new order available";
    newOrderNotification.payload = {from: 'system',source: 'Some guy'};
    newOrderNotification.topic = "<nl.fontys.apps20.G10TaxiApp3154>";
    //apnProvider.send(note, deviceToken).then( (result) => {
    //  // see documentation for an explanation of result
    //});
    apnProvider.send(newOrderNotification, deviceToken);

  }
}
