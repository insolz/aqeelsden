//
//  CommonMethods.swift
//  NeighboorhoodDriver
//
//  Created by Aqeel on 22/01/2018.
//  Copyright © 2018 Yamsol. All rights reserved.
//

import Foundation


func keyboardWasShown(notification:NSNotification)
{
    self.scrollView.isScrollEnabled = true
    let info = notification.userInfo!
    var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
    keyboardFrame = self.scrollView.convert(keyboardFrame, to: nil)
    var contentInset1:UIEdgeInsets = self.scrollView.contentInset
    contentInset1.bottom = (keyboardFrame.size.height)
    self.scrollView.contentInset = contentInset1
}

func textFieldShouldReturn(_ textField: UITextField) -> Bool
{
    self.view.endEditing(true)
    
    return true
}
func keyboardWillBeHidden()
{
    self.scrollView.setContentOffset(.zero, animated: false)
    //self.scrollView.isScrollEnabled = false
}
