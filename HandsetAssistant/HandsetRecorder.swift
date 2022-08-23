//
//  HandsetAssistant.swift
//  handset-assistant-ios-framework
//
//  Created by Isambard Poulson on 09/03/2021.
//

import Foundation
import CoreTelephony
import UIKit

public class HandsetRecorder
{
    let kHuqTimeDate: String = "HuqTimeDate";
    let kHuqSDKVersion: String = "HuqSDKVersion";
    let kHuqIID: String = "HuqIID";
    let kHuqIFA: String = "HuqIFA";
    let kHuqSrcOS: String = "HuqSrcOS";
    let kHuqKey: String = "HuqKey";
    let kHuqBundleId: String = "HuqBundleId";
    let kHuqDeviceName: String = "HuqDeviceName";
    let kHuqDeviceModel: String = "HuqDeviceModel";
    let kHuqDeviceManufacturer: String = "HuqDeviceManufacturer";
    let kHuqSimCode: String = "HuqSimCode";
    let kHuqCarrierName: String = "HuqCarrierName";
    let kHuqCountry: String = "HuqCountry";
    let kHuqLanguage: String = "HuqLanguage";
    let kHuqEventType: String = "HuqEventType";
    let kHuqDisplayWidth: String = "HuqDisplayWidth";
    let kHuqDisplayHeight: String = "HuqDisplayHeight";
    
    let kHuqEndpoint: String = "https://api.huqindustries.co.uk/analyse/";
    let kHuqAPIVersion: String = "1.2";
    
    let huqIIDPreference: String = "huqIID";
    let huqAPIKeyPreference: String = "huqAPIKey";
    
    let huqDeviceInformationEvent: String = "HuqDeviceInformationEvent";
    let sdkVersion: String = "iOS_handset_1.0.4";
    
    let huqDefaultsNamespace: String = "HuqDefaults";
    
    private var observer: NSObjectProtocol?
    
    public static let shared = HandsetRecorder()
    
    private init()
    {
    }
    
    public func startRecording(apiKey: String)
    {
        if let huqDefaults: UserDefaults = UserDefaults.init(suiteName: huqDefaultsNamespace)
        {
            huqDefaults.set(apiKey, forKey: huqAPIKeyPreference)
            if huqDefaults.string(forKey: huqIIDPreference) == nil
            {
                huqDefaults.set(UUID().uuidString, forKey: huqIIDPreference)
            }
        }
        
        postData()
        
        if observer != nil
        {
            NotificationCenter.default.removeObserver(observer!)
        }
        
        observer = NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { notification in
            self.postData()
        }
    }
    
    public func stopRecording()
    {
        if observer != nil
        {
            NotificationCenter.default.removeObserver(observer!)
        }
    }
    
    private func postData()
    {
        let parameterDictionary: NSMutableDictionary = NSMutableDictionary()
        parameterDictionary[kHuqEventType] = huqDeviceInformationEvent
        parameterDictionary[kHuqSDKVersion] = sdkVersion
        
        // ids
        if let huqDefaults: UserDefaults = UserDefaults.init(suiteName: huqDefaultsNamespace)
        {
            parameterDictionary[kHuqKey] = huqDefaults.string(forKey: huqAPIKeyPreference)
            parameterDictionary[kHuqIID] = huqDefaults.string(forKey: huqIIDPreference)
        }
        
        //date
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = .current
        parameterDictionary[kHuqTimeDate] = formatter.string(from: Date())
        
        // carrier
        let networkInfo: CTTelephonyNetworkInfo  = CTTelephonyNetworkInfo()
        if #available(iOS 12.0, *) {
            if let carrier: CTCarrier = networkInfo.serviceSubscriberCellularProviders?.first?.value
            {
                if let carrierName: String = carrier.carrierName
                {
                    parameterDictionary[kHuqCarrierName] = carrierName
                }
                
                if carrier.mobileNetworkCode != nil && carrier.mobileCountryCode != nil
                {
                    parameterDictionary[kHuqSimCode] = carrier.mobileNetworkCode! + carrier.mobileCountryCode!
                }
            }
        } else {
            // Fallback on earlier versions
        }
        
        // device model
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let deviceModel = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        parameterDictionary[kHuqDeviceModel] = deviceModel
        parameterDictionary[kHuqDeviceManufacturer] = "Apple"
        
        // os
        let device: UIDevice = UIDevice()
        parameterDictionary[kHuqSrcOS] = device.systemName + "_" + device.systemVersion
        parameterDictionary[kHuqDeviceName] = device.name
        
        // bundle
        parameterDictionary[kHuqBundleId] = Bundle.main.bundleIdentifier
        
        // locale
        if let languageString: String = Locale.current.languageCode
        {
            parameterDictionary[kHuqLanguage] = languageString
        }
        if let localeString: String = Locale.current.regionCode
        {
            parameterDictionary[kHuqCountry] = localeString
        }
        
        // screen
        let screenSize: CGRect = UIScreen.main.bounds
        parameterDictionary[kHuqDisplayWidth] = screenSize.width
        parameterDictionary[kHuqDisplayHeight] = screenSize.height
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
            return
        }
        
        if let url = URL(string: kHuqEndpoint + kHuqAPIVersion)
        {
            var request = URLRequest(url: url)
            request.httpBody = httpBody
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = "POST"
            
            let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
                guard data != nil else { return }
            }
            task.resume()
        }
    }
}
