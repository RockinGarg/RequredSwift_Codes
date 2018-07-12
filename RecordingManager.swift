//
//  RecordingManager.swift
//  VaDiApp
//
//  Created by IosDeveloper on 22/12/17.
//  Copyright © 2017 iOSDeveloper. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData


//MARK:- Global Struct
/**
 This Struct is used to manage all the Global Accessible Variables
 
 **It contains**
 * AVFoundation Declarations
 * Bool Values
 * String Values
 */
struct Manager
{
    ///Session ID
    static var sessionID : String = ""
    
    ///CurrentController
    static var currentController = UIViewController()
    
    //Required Objects - AVFoundation
    ///AVAudio Session
    static var recordingSession: AVAudioSession!
    
    ///AVAudio Recorder
    static var recorder: AVAudioRecorder?
    
    ///AVAudio Player
    static var player: AVAudioPlayer?
    
    ///Current Port Descriptoe
    static var currentAudioPort : currentAudioPortSet?
    
    //Bool Values
    ///Bool To check mic permission
    static var micAuthorised = Bool()
    
    ///Bool to check an audio is being played or not
    static var recordingalreadyPlayedStatus = Bool()
    
    //Timer - StartMainRecording
    static var meterTimer: Timer?
    
    //Peak Values Required
    ///Average Power for channel
    static var recorderApc0: Float = 0
    
    ///Peak Power for Channel
    static var recorderPeak0: Float = 0
    
    //Audio File Details
    ///Starting time of record
    static var startAudioTime = Date()
    
    ///Ending time of record
    static var endAudioTime = Date()
    
    ///Audio Name
    static var audioName : String = ""
    
    //Rio Interface
    ///Frequency
    static var FrequencyFromRio = Float()
    
    ///Sound Array
    static var sound_arr = [Float]()
}


//MARK:- Main Class
/**
 This class is created to handle all the required function to Record and Playback
 
 Perform Required Functions
 ==
 * Handle Rio Class
 * Start And Stop Recording
 * Start And Stop Playing Audio
 * Save and Reterive Function call from Core data
 */
class RecordingManager: NSObject
{
    //Create Shared Object to make Globally Accessible
    @objc static let shared = RecordingManager()
    
    //Static Variables
    static var lowPassResults: Double = 0.0
    static var maximumTimeLimit : Double = 0.0
    static var maximumSilenceTime : Double = 0.0
    
    //RioClass Object
    var rioInter : RIOInterface?
}

//MARK:- RIOInterfaceHandler
extension RecordingManager
{
    //MARK: Initialize Rio for First time
    /**
     This function is used to check that Rio class Instance is already created or not
     */
    func initializeRio()
    {
        //check for Instance is created or not
        if self.rioInter == nil
        {
            //if not create new
            self.rioInter = RIOInterface.sharedInstance()
        }
    }
}

//MARK:- Sound Array Required Functions
extension RecordingManager
{
    //MARK: Handle Sound Array Count
    /**
     This function is used to Handle All the response From Rio Class and use that Returned Frequency and add it in Sound array
     */
    func handleSoundArray()
    {
        //Set basic 40 values as zero
        if Manager.sound_arr.count == 0
        {
            for _ in 0..<40
            {
                Manager.sound_arr.append(0)
                //reload Frequency meter with Array showing baseline
            }
        }
        else
        {
            //reload Frequency meter with Array
        }
        
        //Add Values to Array
        if Manager.FrequencyFromRio > 0.0
        {
            //Shift Array to left to add two values
            self.shiftSoundArrayToLeft()
            
            RecordingManager.maximumSilenceTime = 0.0
            
            //if Freq is greater than 0
            //Add Average power Of channel Twice for Square Wave
            Manager.sound_arr.append(Manager.recorderApc0)
            Manager.sound_arr.append(Manager.recorderApc0)
        }
        else
        {
            RecordingManager.maximumSilenceTime += 0.10
            //Shift Array to left to add two values
            self.shiftSoundArrayToLeft()
            Manager.sound_arr.append(0)
            Manager.sound_arr.append(0)
        }
    }
    
    //MARK: Delete First Two objects in soundArray
    /**
     This function is used to Shift the sound Array to left by deleting first two Values
     */
    func shiftSoundArrayToLeft()
    {
        Manager.sound_arr.remove(at: 0)
        Manager.sound_arr.remove(at: 1)
    }
}

//MARK:- Audio Recording
extension RecordingManager
{
    //MARK: Check for Microphone Permission
    /**
     This function is used to Check weather mic Permission is Granted or not for Recording
     */
    func CheckForPermission()
    {
        Manager.recordingSession = AVAudioSession.sharedInstance()
        do
        {
            try Manager.recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            Manager.recordingSession.requestRecordPermission({ (allowed) in
                if allowed
                {
                    Manager.micAuthorised = true
                }
                else
                {
                    Manager.micAuthorised = false
                }
            })
            DispatchQueue.main.async
                {
                //Reload Label text in Home screen
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateLabel"), object: nil)
            }
        }
        catch
        {
            print("Failed to set Category", error.localizedDescription)
        }
    }
    
    //MARK: Get Unique Name String for new File
    /**
     This function is used to get the new Name of Audio file to be stored
     - returns : Unique name of Audio File
     */
    func getUniqueName() -> String
    {
        let todaysDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy-HH:mm:ss"
        let DateInFormat:String = dateFormatter.string(from: todaysDate)
        return DateInFormat
    }
    
    //MARK: Start Initial Recording when button pressed
    /**
     This function is used to initialise the RIOInteface Class and Call Main Recording Function
     */
    func StartInitialRecordind()
    {
        self.rioInter?.sampleRate = 16000
        self.rioInter?.initializeAudioSession()
        self.rioInter?.startListening(self)
        RecordingManager.maximumTimeLimit = 0.00
        RecordingManager.maximumSilenceTime = 0.00
        self.startMainRecording()
    }
    
    //MARK: Start Recording
    /**
     This function is used to Start The Main REcording Session
     
     Perform Required Functions
     * Start Main Recording
     * File Splitting
     * detect Silence
     */
    func startMainRecording()
    {
        print("Main Recording session is created")
        
        //Get unique File Name
        Manager.audioName = getUniqueName()
        let AudioFileName = getDocumentsDirectory().appendingPathComponent("\(Manager.audioName).wav")
        print("New Path: \(AudioFileName)")
        
        //Status to Check Silence
        var statusForDetection = Float()
        
        //Recorder Settings
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 16000,
            AVNumberOfChannelsKey: 1,
            AVLinearPCMBitDepthKey: 16,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
            AVLinearPCMIsBigEndianKey: false,
            AVLinearPCMIsFloatKey: false,
            ]
        
        //Handler
        do {
            //Activate session when required
            try Manager.recordingSession.setActive(true)
            
            //Start Recording With Audio File name
            Manager.recorder = try AVAudioRecorder(url: AudioFileName, settings: settings)
            Manager.recorder?.delegate = self
            Manager.recorder?.isMeteringEnabled = true
            
            //Recorder is Recording?
            if (Manager.recorder?.isRecording)!
            {
                //Yes //Control never Reach here //Created for Error Case
                if (self.rioInter != nil)
                {
                    self.rioInter?.sampleRate = 16000
                    self.rioInter?.initializeAudioSession()
                    self.rioInter?.startListening(self)
                }
            }
            else
            {
                //No case
                if !((self.rioInter?.isListning)!)
                {
                    if (self.rioInter?.isGraph_initialized)!
                    {
                        self.rioInter?.startProccessingGraph()
                    }
                    else
                    {
                        self.rioInter?.startListening(self)
                    }
                }
            }

            //Start Recording
            Manager.recorder?.prepareToRecord()
            Manager.recorder?.record()
            
            //To get audio starting time of recording
            Manager.startAudioTime = Date()
            
            //Tracking Metering values here only
            Manager.meterTimer = Timer.scheduledTimer(withTimeInterval: 0.10, repeats: true, block: { (timer: Timer) in
                
                //Update Recording Meter Values so we can track voice loudness
                if let recorder = Manager.recorder
                {
                    
                    ///Check do user is speaking in Mic for Specific time ?
                    if RecordingManager.maximumSilenceTime > 30.0
                    {
                        //Stop recording if user is silence for long time
                        self.finishRecording(success: true)
                        
                        ///Post Notification to End user Session automatically after setted Time
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "navigateNowEx"), object: nil)
                    }
                    
                    ///Check Maximum Time Limit ?
                    ///File Length time limit
                    if RecordingManager.maximumTimeLimit > 30.0
                    {
                        //Create new recording file after every Setted Time Seconds if user is continuously speaking
                        RecordingManager.maximumTimeLimit = 0.00
                        self.saveToCoreData(filename: "\(Manager.audioName).wav")
                        Manager.meterTimer?.invalidate()
                        self.startMainRecording()
                    }
                    
                    //Get Frequency From rio each second
                    Manager.FrequencyFromRio = (self.rioInter?.returnFrequency())!
                    
                    //Reload Frequency Meter Layouts Here
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
                    
                    //Start Metering Updates
                    recorder.updateMeters()
                    Manager.recorderApc0 = recorder.averagePower(forChannel: 0)
                    Manager.recorderPeak0 = recorder.peakPower(forChannel: 0)
                    
                    //Handle Sound Array to maintain 40 Values
                    self.handleSoundArray()
                    
                    //it’s converted to a 0-1 scale, where zero is complete quiet and one is full volume.
                    let ALPHA: Double = 0.05
                    let peakPowerForChannel = pow(Double(10), (0.05 * Double(Manager.recorderPeak0)))
                    RecordingManager.lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * RecordingManager.lowPassResults
                    
                    //Checks Used to detect Silence here
                    if(RecordingManager.lowPassResults > 0.08)
                    {
                        //mic blow is detected as per for distance
                        statusForDetection = 0.0
                        RecordingManager.maximumTimeLimit += 0.10
                        
                        ///Check Do Recorder is Recording ?
                        ///These checks are used for security Purpose So App don't crasg at any point
                        if !((Manager.recorder?.isRecording)!)
                        {
                            //save file created to core Data
                            self.saveToCoreData(filename: "\(Manager.audioName).wav")
                            
                            //Invalidate timer (AUGraph issue)
                            Manager.meterTimer?.invalidate()
                            
                            //record Again Created new File
                            self.startMainRecording()
                            
                            //Start Recording Again
                            Manager.recorder?.record()
                        }
                    }
                    else
                    {
                        //mic blow is not detected
                        //Update Value for Status is blow being detected or not
                        statusForDetection += 0.10
                        
                        //if blow is not Detected for 5 seconds
                        if statusForDetection > 5.0
                        {
                            //create a new Recording
                            statusForDetection = 0.0
                            RecordingManager.maximumTimeLimit = 0.00
                            //save file created to core Data
                            self.saveToCoreData(filename: "\(Manager.audioName).wav")
                            
                            //Invalidate timer (AUGraph issue)
                            Manager.meterTimer?.invalidate()
                            
                            //record Again Created new File
                            self.startMainRecording()
                            
                            //set initial time to again detect silence
                            RecordingManager.maximumTimeLimit = 0.01
                        }
                    }
                }
            })
        }
        catch
        {
            //Finish Recording with a Error
            print("Error Handling: \(error.localizedDescription)")
            self.finishRecording(success: false)
        }
    }
    
    //MARK: Finish Recording
    /**
     This function is used to Notify that Recording has been Stopped
     - parameter success : True if Recording is Stopped Manually, False if Recording Stopped because of an Error
     */
    func finishRecording(success: Bool)
    {
        //Invalidate all the required Processes
        Manager.meterTimer?.invalidate()
        self.rioInter?.stopListening()
        
        //Check is Reference nil ?
        if (self.rioInter != nil)
        {
            //if no
            //Un-Initialize Graphs
            if (self.rioInter?.isListning)!
            {
                self.rioInter?.stopListening()
            }
        }
        
        //Stop Recorder
        Manager.recorder?.stop()
        Manager.recorder = nil
        self.saveToCoreData(filename: "\(Manager.audioName).wav")
        
    }
}

//MARK:- Audio Player
extension RecordingManager
{
    //MARK: Play Recording at selected Index
    /**
     This function is used to Return the File URL in Document Directory
     - parameter fileName : File Name refer to Audio File name which is to be played
     - returns : Bool That file is Successfully played or not
     */
    func playRecording(fileName:String) -> Bool
    {
        var recordingPlayed = Bool()
        if Manager.recorder == nil
        {
            //Yes we can Play Sound
            recordingPlayed = true
            Manager.recordingalreadyPlayedStatus = true
            
            //Set player with audio File
            do
            {
                try Manager.player = AVAudioPlayer.init(contentsOf: returnPathAtSelectedIndex(fileName: fileName))
                //Set required delegates and Values
                
                Manager.player?.delegate = self
                Manager.player?.volume = 1.0
                Manager.player?.prepareToPlay()
                Manager.player?.play()
            }
            catch
            {
                print("Error while playing music: \(error.localizedDescription)")
            }
        }
        else
        {
            //Error Case
            recordingPlayed = false
            Manager.recorder = nil
            Manager.recordingalreadyPlayedStatus = false
        }
        return recordingPlayed
    }
}

//MARK:- For Document Directory
extension RecordingManager
{
    //MARK: Get path to Play Audio
    /**
     This function is used to Return the File URL in Document Directory
     - parameter fileName : File Name refer to Audio File name whose URL is to be Reterived
     - returns : URL of stored File
     */
    func returnPathAtSelectedIndex(fileName:String) -> URL
    {
        let path = NSURL(fileURLWithPath: String(describing: getDocumentsDirectory())).appendingPathComponent(fileName)
        print("Playing Audio Path:\(String(describing: path))")
        return path!
    }
    
    //MARK: Get Path for File to Store
    /**
     This function is used to get the URL in Document Directory
     - returns : URL without Any Folder Reference
     */
    func getDocumentsDirectory() -> URL
    {
        //Get Basic URL
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dataPath1 = documentsDirectory.appendingPathComponent("uandiRecordings")
        let dataPath = dataPath1.appendingPathComponent(Manager.sessionID)
        //Handler
        do
        {
            try FileManager.default.createDirectory(atPath: dataPath.path, withIntermediateDirectories: true, attributes: nil)
        }
        catch let error as NSError
        {
            print("Error creating directory: \(error.localizedDescription)")
        }
        return dataPath
    }
    
    
    //MARK: Get file size for reference
    /**
     This function is used to get the Size of stored file
     - returns : Size of File
     */
    func getFileSize() -> String
    {
        //Get File Name
        let fileName = self.returnPathAtSelectedIndex(fileName: "\(Manager.audioName).wav")
        let filePath = fileName.path
        var size = String()
        var fileSize : UInt64
        do
        {
            //return [FileAttributeKey : Any]
            let attr = try FileManager.default.attributesOfItem(atPath: filePath)
            fileSize = attr[FileAttributeKey.size] as! UInt64
            
            //if you convert to NSDictionary, you can get file size old way as well.
            let dict = attr as NSDictionary
            fileSize = dict.fileSize()
            size = String(fileSize)
        }
        catch
        {
            size = "0"
            print("+++++++++Error while getting size+++++++++++: \(error)")
        }
        return size
    }
    
    //MARK: Get list of Recording Available
    /**
     This function is used to get all the Available Recordings stored in a Session
     - returns : Array of Audio Names Stored in Session
     */
    func getListOfRecordingsAvailable() -> [String]
    {
        var fileNameArray = [String]()
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let myFilesPath = documentDirectoryPath.appending("/uandiRecordings")
        let files = FileManager.default.enumerator(atPath: myFilesPath)
        
        while let file = files?.nextObject()
        {
            //myfilesPath - Path
            //file - fileName
            fileNameArray.append(file as! String)
        }
        return fileNameArray
    }
    
    //MARK: Clear all saved recordings
    /**
     This function is used to Clear all the Available Recordings stored in a Session
     */
    func clearAllFilesFromTempDirectory()
    {
        let fileManager = FileManager.default
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let tempDirPath = dirPath.appending("/uandiRecordings/\(Manager.sessionID)")
        
        do {
            let folderPath = tempDirPath
            let paths = try fileManager.contentsOfDirectory(atPath: tempDirPath)
            for path in paths
            {
                try fileManager.removeItem(atPath: "\(folderPath)/\(path)")
            }
        }
        catch let error as NSError
        {
            print(error.localizedDescription)
        }
    }
}

//MARK:- Core Data Handler
extension RecordingManager
{
    //MARK: Date Formatted
    /**
     This function is used to return the date in a format
     - returns : Formatted Date Such as - 01/01/2018
     */
    func returnDateFormat()->String
    {
        let TodayDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: TodayDate)
    }
    
    //MARK: Get Common Context for Core Data
    /**
     This function get the current CGContext
     - returns : Context of Audio Detail to store data in Core Data
     */
    func getContext() -> AudioDetail
    {
        // Create an instance of the service.
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.persistentContainer.viewContext
        
        //get Context from Class created
        let AudioService = AudioDetail(context: context)
        return AudioService
    }
    
    //MARK: Save File To Core Data
    /**
     This function Take name of audio file and calls Function to save it in Core data
     - parameter filename: Audio File Name
     */
    func saveToCoreData(filename:String)
    {
        Manager.endAudioTime = Date()
        let interval = Manager.endAudioTime.timeIntervalSince(Manager.startAudioTime)
        let AudioService = self.getContext()
        let fileSize = self.getFileSize()
        _ = AudioService.create(fileName: filename, duration: String.init(format: "%.2f", interval), uploadedStatus: "False", fileId: "Not Used Yet",fileSize: fileSize, sessionID: Manager.sessionID, date: returnDateFormat())
    }
}

//MARK:- Audio Recorder Delegate
extension RecordingManager: AVAudioRecorderDelegate
{
    //MARK: Audio Recorder Finish Recording
    /**
     Called by the system when a recording is stopped or has finished due to reaching its time limit.
     - parameter player: Recorder instance
     - parameter flag: Bool player is running or not successfully
     */
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool)
    {
        print("AudioManager Finish Recording")
    }
    
    //MARK: Audio Recorder error occur while Recording
    /**
     Called when an audio recorder encounters an encoding error during recording.
     - parameter recorder: Recorder instance
     - parameter flag: Bool player is running or not successfully
     */
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?)
    {
        print("Encoding Error: \(String(describing: error?.localizedDescription))")
    }
}

//MARK:- Audio Player Delegates
extension RecordingManager: AVAudioPlayerDelegate
{
    //MARK: Audio Player Finishes Playing audio
    /**
     Called when a sound has finished playing.
     - parameter player: player instance
     - parameter flag: Bool player is running or not successfully
     */
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StoppedPlaying"), object: nil)
        player.stop()
        Manager.player?.stop()
        Manager.recordingalreadyPlayedStatus = false
        print("Finish Playing")
    }
    
    //MARK: Audio Player error occur while Playing
    /**
     Called when an audio player encounters a decoding error during playback.
     - parameter player: player instance
     - parameter error: Error if occurs
     */
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer,error: Error?)
    {
        print("Encoding Error: \(String(describing: error?.localizedDescription))")
    }
    
}

//MARK:- Custom Functions
extension RecordingManager
{
    //MARK: BasicAlert
    /**
     This function is used to Show a basic alert message
     - parameter title: Main Title
     - parameter message: Main Message
     - parameter view: View Controller object
     - returns: Alert
     */

    func BasicAlert(_ title : String, message : String, view:UIViewController)
    {
        let alert = UIAlertController(title:title, message:  message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
}

//MARK: Frequency Meter class
/**
 This class is created to Handle All the required Drawing in a UIview
 */
class FrequencyMeter: UIView
{    
    ///Sttaic Declaration
    let SOUND_METER_COUNT = 40
    
    ///Maximum Height of Wave
    let maximumHeightOfWave : CGFloat = 50
    
    ///Bool to Check do we need to Display Graph ?
    var isDisplayingGraph : Bool = false
    
    //Draw Rect func
    /**
     This function is used to Draw Shapes in UIView
     */
    override func draw(_ rect: CGRect)
    {
        ///Draw Waves
        drawLines()
    }
    
    //Initailizng frame
    /**
     This function is used to Set the Frame
     */
    init(frame: CGRect, shape: Int)
    {
        ///Set Frame
        super.init(frame: frame)
    }
    
    //Coder for Frequency meter
    /**
     This function is used Encode i.e Save Data
     */
    required init?(coder aDecoder: NSCoder)
    {
        ///Initialise Coder
        super.init(coder: aDecoder)
    }
    
    //Draw waveForm here
    /**
     This function Handle The Drawing in UIView
     */
    func drawLines()
    {
        
        //Set basic 40 values as zero
        if Manager.sound_arr.count == 0
        {
            for _ in 0..<40
            {
                //reload Frequency meter with Array showing baseline
                Manager.sound_arr.append(0)
            }
        }
        
        ///1 - Get Context
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        ///2 - Begin Path To Draw
        ctx.beginPath()
        
        ///Move to a base point
        ctx.move(to: CGPoint(x: 0, y: (frame.height)/2))
        
        ///Set Baseline - Empty Centered Line
        let baseLine : Int = Int(frame.size.height/2);
        
        ///Multiplier - TO draw Positive and negative Wave
        var multiplier : Int = 1
        
        ///Set Length of Wave
        let maxLengthOfWave : Int = Int((frame.size.height*33)/100)
        let maxValueOfMeter : Int = Int((frame.size.height*47)/100)
        
        ///Main Handler
        for x in stride(from: SOUND_METER_COUNT-1, through: 0, by: -1)
        {
            multiplier = x%2 == 0 ? 1 : -1
            
            let index : NSInteger = x
            
            let value : Int = Int(Manager.sound_arr[index])
            let secondEq : Int = ((maxValueOfMeter * (maxLengthOfWave - abs(value))) / maxLengthOfWave)
            var y : CGFloat = CGFloat(baseLine + secondEq * multiplier)
            
            ///Simplifying Equations
            let plusParam : CGFloat = round((round(frame.size.height)*96)/100)+1
            let minusParam : CGFloat = round((round(frame.size.height)*96)/100)-1
            
            ///Set BaseLine
            if y == plusParam || (y==round((round(frame.size.height)*96)/100)) || (y<=6) || y == minusParam
            {
                y = CGFloat(baseLine)
            }
            
            ///Divide SCreen Width in Equal parts and Draw Y
            if x == SOUND_METER_COUNT - 1
            {
                ctx.move(to: CGPoint(x: CGFloat(x) * (frame.size.width / CGFloat(SOUND_METER_COUNT)) + frame.origin.x + 10, y: y))
                ctx.addLine(to: CGPoint(x: CGFloat(x) * (frame.size.width / CGFloat(SOUND_METER_COUNT)) + frame.origin.x + 7, y: y))
            }
            else
            {
                ctx.addLine(to: CGPoint(x: CGFloat(x) * (frame.size.width / CGFloat(SOUND_METER_COUNT)) + frame.origin.x + 10, y: y))
                ctx.addLine(to: CGPoint(x: CGFloat(x) * (frame.size.width / CGFloat(SOUND_METER_COUNT)) + frame.origin.x + 7, y: y))
            }
        }
        
        ///Set Paramateres
        if (isDisplayingGraph)
        {
            ctx.setStrokeColor(UIColor.init(red: 237/255, green: 73/255, blue: 69/255, alpha: 1.0).cgColor)
        }
        else
        {
            ctx.setStrokeColor(UIColor.init(red: 237/255, green: 73/255, blue: 69/255, alpha: 0.0).cgColor)
        }
        
        ctx.setLineJoin(CGLineJoin.round)
        ctx.setLineWidth(1.2)
        ctx.strokePath()
    }
    
}

