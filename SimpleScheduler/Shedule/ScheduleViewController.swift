//
//  ScheduleViewController.swift
//  SimpleScheduler
//
//  Created by Dmitrii on 16/09/2017.
//  Copyright © 2017 DI. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    // MARK: - Properties
    private var vcDataModel: ScheduleDataModel!

    @IBOutlet var beginLabelDate: UILabel!
    @IBOutlet var beginBar: UIView!
    @IBOutlet var beginDatePicker: UIDatePicker!
    @IBOutlet var beginDatePickerHeight: NSLayoutConstraint!

    @IBOutlet var frequencyLabel: UILabel!
    @IBOutlet var frequencyBar: UIView!
    @IBOutlet var frequencyPicker: UIPickerView!
    @IBOutlet var frequencyPickerHeight: NSLayoutConstraint!

    @IBOutlet var endBar: UIView!
    @IBOutlet var endLabelDate: UILabel!
    @IBOutlet var endViewHeight: NSLayoutConstraint!
    @IBOutlet var endDatePicker: UIDatePicker!
    @IBOutlet var endDatePickerHeight: NSLayoutConstraint!

    let openPickerHeightConstant: CGFloat = 162.0
    let openBarHeightConstant: CGFloat = 62.0


    // MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
        adjustUI()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParentViewController {
            vcDataModel.saveEvent()
        }
    }


    // MARK: - Public
    func setDataSource(dataSource: DataSource) {
        vcDataModel = ScheduleDataModel(dataSource: dataSource)
    }

    func setEvent(event: Event?) {
        vcDataModel.setEvent(event: event)
    }


    // MARK: - Private
    private func reset() {
        beginDatePicker.minimumDate = Date()
        endDatePicker.minimumDate = Date()
        vcDataModel.reset()
    }

    private func adjustUI() {
        updateBeginSection()
        frequencyPicker.selectRow(
            vcDataModel.frequency.index(),
            inComponent: 0,
            animated: false
        )
        updateFrequencySection()
        updateEndSection()
    }

    private func updateBeginSection() {
        beginLabelDate.text = vcDataModel.beginDateFormatted()
    }

    private func updateFrequencySection() {
        frequencyLabel.text = vcDataModel.frequency.rawValue
    }

    private func updateEndSection() {
        if vcDataModel.frequency == .once {
            endViewHeight.constant = 0
        } else {
            endViewHeight.constant = openBarHeightConstant
            endDatePicker.date = vcDataModel.endDate
            endLabelDate.text = vcDataModel.endDateFormatted()
        }
    }

    private func changeBeginDatePickerState() {
        let resultConstant = (beginDatePickerHeight.constant > 0) ? 0 : openPickerHeightConstant
        beginDatePicker.alpha = (beginDatePickerHeight.constant > 0) ? 0 : 1
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.beginDatePickerHeight.constant = resultConstant
            strongSelf.view.layoutIfNeeded()
        }
    }

    private func changeEndDatePickerState() {
        let resultConstant = (endDatePickerHeight.constant > 0) ? 0 : openPickerHeightConstant
        endDatePicker.alpha = (endDatePickerHeight.constant > 0) ? 0 : 1
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.endDatePickerHeight.constant = resultConstant
            strongSelf.view.layoutIfNeeded()
        }
    }

    private func changeFrequencyPickerState() {
        let resultConstant = (frequencyPickerHeight.constant > 0) ? 0 : openPickerHeightConstant
        frequencyPicker.alpha = (frequencyPickerHeight.constant > 0) ? 0 : 1
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.frequencyPickerHeight.constant = resultConstant
            strongSelf.view.layoutIfNeeded()
        }
    }
    

    // MARK: - UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ScheduleFrequency.amountOfOptions()
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ScheduleFrequency.option(idx: row).rawValue
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedOption = ScheduleFrequency.option(idx: row)
        vcDataModel.setFrequency(frequency: selectedOption)
        endDatePicker.minimumDate = vcDataModel.endDate
        adjustUI()
        changeFrequencyPickerState()
    }


    // MARK: - Actions
    @IBAction private func beginBarTapped() {
        changeBeginDatePickerState()
    }

    @IBAction private func frequencyBarTapped() {
        changeFrequencyPickerState()
    }

    @IBAction private func endBarTapped() {
        changeEndDatePickerState()
    }

    @IBAction private func datePickerValueChanged(picker: UIDatePicker) {
        if picker == beginDatePicker {
            vcDataModel.setBeginDate(date: picker.date)
            endDatePicker.minimumDate = vcDataModel.endDate
            adjustUI()
            changeBeginDatePickerState()
        } else if picker == endDatePicker {
            vcDataModel.setEndDate(date: picker.date)
            adjustUI()
            changeEndDatePickerState()
        }
    }

    @IBAction private func clearButtonTapped() {
        reset()
        adjustUI()
    }
}
