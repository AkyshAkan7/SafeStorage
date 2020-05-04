//
//  MonthPickerView.swift
//  SafeStorage
//
//  Created by Akan Akysh on 4/29/20.
//  Copyright © 2020 AkyshAkan. All rights reserved.
//

import UIKit

class MonthPickerView: UIPickerView {
    
    var monthPickerDelegate: MonthDelegate?
    
    let months = ["1 месяц", "2 месяца", "3 месяца",
                  "4 месяца", "5 месяцев", "6 месяцев",
                  "7 месяцев", "8 месяцев", "9 месяцев",
                  "10 месяцев", "11 месяцев", "12 месяцев"]

    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        dataSource = self
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MonthPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return months.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let row = months[row]
        return row
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedValue = months[row] as String
        monthPickerDelegate?.setMonth(month: selectedValue)
    }
}
