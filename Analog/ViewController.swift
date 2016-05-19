
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var analogClock: BEMAnalogClockView!
    
    var flag = 0
    
    var data = [String]()
    
    var timer = NSTimer()
    
    var r = 0
    
    @IBOutlet weak var timePicker: UIPickerView!
    
    var overlayOnPicker:UIView = UIView(frame: CGRectMake(1, 101 , 163, 35))
    
    @IBOutlet weak var button: UIButton!
    
    @IBAction func startTimer(sender: AnyObject) {
        
        if flag == 0{
            flag = 1
            button.setImage(UIImage(named: "stop"), forState: .Normal)
            timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true)
            resetButton.setImage(UIImage(named: "lap"), forState: .Normal)
        }
        else{
            timer.invalidate()
            button.setImage(UIImage(named: "start"), forState: .Normal)
            flag = 0
            resetButton.setImage(UIImage(named: "reset"), forState: .Normal)
        }
    }
    
    @IBOutlet weak var resetButton: UIButton!
    
    @IBAction func lap(sender: AnyObject) {
        
        if flag == 0{
            analogClock.minutes = 0
            analogClock.seconds = 0
            analogClock.reloadClock()
            data.removeAll()
            timePicker.hidden = true
            overlayOnPicker.hidden = true
            timePicker.reloadAllComponents()
        }
        else{
            timePicker.hidden = false
            overlayOnPicker.hidden = false
            
            var h = 0
            if analogClock.hours != 12{
                h = analogClock.hours
            }
            
            if analogClock.minutes < 10 && analogClock.seconds < 10{
                data.insert("0\(h):0\(analogClock.minutes):0\(analogClock.seconds)", atIndex: 0)
            }
            else if analogClock.minutes < 10 && analogClock.seconds > 9{
                data.insert("0\(h):0\(analogClock.minutes):\(analogClock.seconds)", atIndex: 0)
            }
            else if analogClock.minutes > 9 && analogClock.seconds < 10{
                data.insert("0\(h):\(analogClock.minutes):0\(analogClock.seconds)", atIndex: 0)
            }
            else{
                data.insert("0\(h):\(analogClock.minutes):\(analogClock.seconds)", atIndex: 0)
            }
            timePicker.reloadAllComponents()
        }
        
    }
    
    func update(){
        
        r += 1
        
        if r == 10{
            analogClock.seconds += 1
            if analogClock.seconds == 60 {
                analogClock.seconds = 0
                analogClock.minutes += 1
            }
            
            if analogClock.minutes == 60{
                analogClock.minutes = 0
                analogClock.hours += 1
            }
            
            analogClock.updateTimeAnimated(true)
            analogClock.reloadClock()
            r = 0
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        analogClock.faceBackgroundColor = UIColor.clearColor()
        analogClock.minuteHandColor = UIColor.grayColor()
        analogClock.secondHandColor = UIColor.grayColor()
        analogClock.hourHandColor = UIColor.grayColor()
        analogClock.secondHandLength = 60.0
        analogClock.minuteHandLength = 50.0
        analogClock.hourHandLength = 40.0
        analogClock.minuteHandOffsideLength = 15.0
        analogClock.secondHandOffsideLength = 15.0
        analogClock.hours = 0
        analogClock.minutes = 0
        analogClock.seconds = 0
        
        overlayOnPicker.backgroundColor = UIColor.grayColor()
        overlayOnPicker.alpha = 0.2
        timePicker.addSubview(overlayOnPicker)
        timePicker.hidden = true
        overlayOnPicker.hidden = true
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        timePicker.reloadAllComponents()
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView
    {
        let pickerLabel = UILabel()
        pickerLabel.text = data[row]
        if pickerView.selectedRowInComponent(0) < row{
            pickerLabel.font = UIFont(name: "AndaleMono", size: 24-CGFloat(row-pickerView.selectedRowInComponent(0))*2)
        }
        else if pickerView.selectedRowInComponent(0) == row{
            pickerLabel.font = UIFont(name: "AndaleMono", size: 24)
        }
        else{
            pickerLabel.font = UIFont(name: "AndaleMono", size: 24-CGFloat(pickerView.selectedRowInComponent(0)-row)*2)
        }
        pickerLabel.textAlignment = NSTextAlignment.Center
        return pickerLabel
    }
    
}

