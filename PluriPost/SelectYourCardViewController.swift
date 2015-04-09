//
//  SelectYourCardViewController.swift
//  PluriPost
//
//  Created by Marc Abousleiman on 4/6/15.
//  Copyright (c) 2015 PluriPost. All rights reserved.
//

import UIKit

class SelectYourCardViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
 
    @IBOutlet weak var occasionPicker: UIPickerView!
    @IBOutlet weak var recipientNameTextField: UITextField!
    
    var occasions : NSArray = ["Birthday","Congratulations","Get Well Soon","Thank You", "Christmas"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        occasionPicker.selectRow(occasions.count/2, inComponent: 0, animated: true)
    }

    override func viewDidAppear(animated: Bool) {
        //recipientNameTextField.becomeFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "categoryTransmitter") {
            let pickThemeController : PickThemeViewController = segue.destinationViewController as PickThemeViewController
            pickThemeController.categoryIndex = occasionPicker.selectedRowInComponent(0)
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return occasions.count
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return occasions[row] as NSString
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
