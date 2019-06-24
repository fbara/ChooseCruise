//
//  IntentHandler.swift
//  Extension
//
//  Created by Frank Bara on 6/24/19.
//  Copyright © 2019 BaraLabs. All rights reserved.
//

import Intents
import UIKit

class IntentHandler: INExtension, INRidesharingDomainHandling {
    
    // MARK: - Custom Functions
    
    
    // MARK: - Ride Sharing Delegates
    
    func resolvePickupLocation(for intent: INRequestRideIntent, with completion: @escaping (INPlacemarkResolutionResult) -> Void) {
        let result: INPlacemarkResolutionResult
        
        if let requestedLocation = intent.pickupLocation {
            // we have a valid pick up location – return success!
            result = INPlacemarkResolutionResult.success(with: requestedLocation)
        } else {
            // no pick up location yet; mark this as outstanding
            result = INPlacemarkResolutionResult.needsValue()
        }
        
        completion(result)
    }
    
    func resolveDropOffLocation(for intent: INRequestRideIntent, with completion: @escaping (INPlacemarkResolutionResult) -> Void) {
        let result: INPlacemarkResolutionResult
        
        if let requestedLocation = intent.dropOffLocation {
            // we have a valid pick up location – return success!
            result = INPlacemarkResolutionResult.success(with: requestedLocation)
        } else {
            // no pick up location yet; mark this as outstanding
            result = INPlacemarkResolutionResult.needsValue()
        }
        
        completion(result)
    }
    
    func handle(intent: INListRideOptionsIntent, completion: @escaping (INListRideOptionsIntentResponse) -> Void) {
        let result = INListRideOptionsIntentResponse(code: .success, userActivity: nil)
        
        // fake the response; this would normally come from a server
        let mini = INRideOption(name: "Mini Cooper", estimatedPickupDate: Date(timeIntervalSinceNow: 1000))
        let rav4 = INRideOption(name: "Toyota Rav4", estimatedPickupDate: Date(timeIntervalSinceNow: 800))
        let ferrari = INRideOption(name: "Ferrari F30", estimatedPickupDate: Date(timeIntervalSinceNow: 300))
        ferrari.disclaimerMessage = "This will get you there quicker!"
        mini.disclaimerMessage = "Disclaimer message!"
        
        result.expirationDate = Date(timeIntervalSinceNow: 3600)
        result.rideOptions = [mini, rav4, ferrari]
        
        completion(result)
    }
    
    func handle(intent: INRequestRideIntent, completion: @escaping (INRequestRideIntentResponse) -> Void) {
        let result = INRequestRideIntentResponse(code: .success, userActivity: nil)
        let status = INRideStatus()
        
        // this is our internal value that identifies the ride uniquely in our back-end system
        status.rideIdentifier = "abc123"
        
        // give it the pick up and drop off location we already agreed with the user
        status.pickupLocation = intent.pickupLocation
        status.dropOffLocation = intent.dropOffLocation
        
        // mark it as confirmed – we will deliver a ride
        status.phase = INRidePhase.confirmed
        
        // say we'll be there in a few minutes
        status.estimatedPickupDate = Date(timeIntervalSinceNow: 60)
        
        // create a new vehicle and configure it fully
        let vehicle = INRideVehicle()
        
        // workaround: load the car image into UIImage, convert that into PNG data, then create an INImage out of that
        vehicle.mapAnnotationImage = INImage(named: "car")
        // set the vehicle's current location to wherever the user wants to go – this ought to at least place it a little way away for testing purposes
        vehicle.location = intent.dropOffLocation!.location
        
        // now that we have configured the vehicle fully, assign it all at once to status.vehicle
        status.vehicle = vehicle
        
        // attach our finished INRideStatus object to the result
        result.rideStatus = status
        
        completion(result)
        
    }
    
    func handle(intent: INGetRideStatusIntent, completion: @escaping (INGetRideStatusIntentResponse) -> Void) {
        // gets called whenever the user asks where their ride is, and it’s down to you to connect to your server, get the current location of their ride, and send it back.
        // just say 'success' for now.
        let result = INGetRideStatusIntentResponse(code: .success, userActivity: nil)
        completion(result)
    }
    
    func startSendingUpdates(for intent: INGetRideStatusIntent, to observer: INGetRideStatusIntentResponseObserver) {
        
    }
    
    func stopSendingUpdates(for intent: INGetRideStatusIntent) {
        
    }
    
    func handle(cancelRide intent: INCancelRideIntent, completion: @escaping (INCancelRideIntentResponse) -> Void) {
        let result = INCancelRideIntentResponse(code: .success, userActivity: nil)
        completion(result)
    }
    
    func handle(sendRideFeedback sendRideFeedbackintent: INSendRideFeedbackIntent, completion: @escaping (INSendRideFeedbackIntentResponse) -> Void) {
        let result = INSendRideFeedbackIntentResponse(code: .success, userActivity: nil)
        completion(result)
    }
    
    
    

}
