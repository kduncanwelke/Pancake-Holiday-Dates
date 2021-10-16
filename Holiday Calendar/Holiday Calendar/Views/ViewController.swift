//
//  ViewController.swift
//  Holiday Calendar
//
//  Created by Kate Duncan-Welke on 10/8/21.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate {

    // MARK: IBOutlets

    @IBOutlet weak var monthYear: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var showPickerButton: UIButton!
    @IBOutlet weak var monthYearPicker: UIPickerView!
    @IBOutlet weak var pickerView: UIView!

    @IBOutlet weak var loadingText: UILabel!
    @IBOutlet weak var networkLost: UILabel!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var tooFast: UIView!

    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var holidayDate: UILabel!
    @IBOutlet weak var holidayTable: UITableView!
    @IBOutlet weak var pancakeKitty: UIImageView!


    // MARK: Variables

    private let viewModel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(holidaysLoaded), name: NSNotification.Name(rawValue: "holidaysLoaded"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(networkFailed), name: NSNotification.Name(rawValue: "networkFail"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(updateCell), name: NSNotification.Name(rawValue: "updateCell"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(limitAlert), name: NSNotification.Name(rawValue: "limitAlert"), object: nil)

        collectionView.delegate = self
        collectionView.dataSource = self
        holidayTable.delegate = self
        holidayTable.dataSource = self
        monthYearPicker.delegate = self
        monthYearPicker.dataSource = self

        viewModel.startMonitoring()
        load()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // if device is rotated, recalculate cell size
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.layoutIfNeeded()
            self?.collectionView.reloadData()
        }
    }

    // MARK: Custom functions

    @objc func holidaysLoaded() {
        DispatchQueue.main.async { [weak self] in
            self?.hideLoadingFeedback()
            self?.details.isHidden = false
        }
    }

    @objc func networkFailed() {
        DispatchQueue.main.async { [weak self] in
            self?.hideLoadingFeedback()
            self?.networkLost.isHidden = false
            self?.reloadButton.isHidden = false
            self?.details.isHidden = true
            print("there was a networking error")
        }
    }

    @objc func updateCell() {
        DispatchQueue.main.async { [unowned self] in
            self.collectionView.reloadItems(at: [IndexPath(row: viewModel.getUpdateIndex(), section: 0)])
        }
    }

    @objc func limitAlert() {
        DispatchQueue.main.async { [weak self] in
            self?.showAlert(title: "Limit Reached", message: Errors.limitHit.localizedDescription)
        }
    }

    func load() {
        viewModel.getMonth()
        showLoadingFeedback()
        loadingText.isHidden = false
        networkLost.isHidden = true
        reloadButton.isHidden = true
        details.isHidden = true
        monthYear.text = viewModel.getMonthLabel()
    }

    func reload() {
        viewModel.getHolidays()
        showLoadingFeedback()
        networkLost.isHidden = true
        reloadButton.isHidden = true
        monthYear.text = viewModel.getMonthLabel()
    }

    func showLoadingFeedback() {
        if !viewModel.hasNetwork() {
            // handle case of no network
            loadingText.isHidden = true
            networkLost.isHidden = false
            reloadButton.isHidden = false
            details.isHidden = true
        } else if !viewModel.isLoading() {
            // handle not loading, aka incomplete load or already loaded
            print("not loading data")
            loadingText.isHidden = true
            networkLost.isHidden = true
            reloadButton.isHidden = false
            details.isHidden = false
        } else {
            activityIndicator.startAnimating()
            loadingText.isHidden = false
        }
    }

    func hideLoadingFeedback() {
        activityIndicator.stopAnimating()
        loadingText.isHidden = true
    }

    // MARK: IBActions

    @IBAction func backPressed(_ sender: UIButton) {
        // prevent month change if this month has not finished loading so data isn't partially loaded
        if viewModel.isLoading() {
            tooFast.popUp()
        } else {
            viewModel.goBack()
            showLoadingFeedback()
            monthYear.text = viewModel.getMonthLabel()
            collectionView.reloadData()
        }
    }

    @IBAction func forwardPressed(_ sender: UIButton) {
        // prevent month change if this month has not finished loading so data isn't partially loaded
        if viewModel.isLoading() {
            tooFast.popUp()
        } else {
            viewModel.goForward()
            showLoadingFeedback()
            monthYear.text = viewModel.getMonthLabel()
            collectionView.reloadData()
        }
    }

    @IBAction func changeMonthYear(_ sender: UIButton) {
        // set selection to current month/year
        monthYearPicker.selectRow(viewModel.setDefault(component: 0), inComponent: 0, animated: false)
        monthYearPicker.selectRow(viewModel.setDefault(component: 1), inComponent: 1, animated: false)
        
        if pickerView.isHidden {
            // open picker view, change arrow to up on button
            pickerView.display()
            showPickerButton.setImage(UIImage(systemName: "chevron.up.circle.fill"), for: .normal)
        } else {
            // close picker view, change arrow to down on button
            pickerView.hide()
            showPickerButton.setImage(UIImage(systemName: "chevron.down.circle.fill"), for: .normal)
        }
    }

    @IBAction func jumpToMonthYear(_ sender: UIButton) {
        // prevent month change if this month has not finished loading so data isn't partially loaded
        if viewModel.isLoading() {
            tooFast.popUp()
        } else {
            viewModel.performJump()
            pickerView.hide()
            showLoadingFeedback()
            monthYear.text = viewModel.getMonthLabel()
            collectionView.reloadData()
        }
    }

    @IBAction func reloadTapped(_ sender: UIButton) {
        reload()
    }

    @IBAction func kittySquished(_ sender: UILongPressGestureRecognizer) {
        // pancake kitty can be sqooshed using a long press
        // activity to reduce user impatience while awaiting rate limited api loads
        switch sender.state {
        case .began:
            pancakeKitty.sqoosh()
        case .ended:
            pancakeKitty.unsqoosh()
        default:
            return
        }
    }

    @IBAction func closePressed(_ sender: UIButton) {
        collectionView.isUserInteractionEnabled = true
        detailView.hide()
    }

    @IBAction func aboutPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "viewAbout", sender: Any?.self)
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        viewModel.getPickerCount()
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel.getRowsInComponent(component: component)
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        viewModel.getTitle(component: component, row: row)
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.setSelections(component: component, row: row)
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getDaysTotal()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarCollectionViewCell

        // set up calendar cell
        cell.dateLabel.text = viewModel.getDateLabel(index: indexPath.row)
        cell.backgroundColor = viewModel.getBackgroundColor(index: indexPath.row)
        cell.holidayDemarcation.alpha = viewModel.pancakeKittyOpacity(index: indexPath.row)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tappedCell = collectionView.cellForItem(at:indexPath) as! CalendarCollectionViewCell

        viewModel.setStringDate(index: indexPath.row)

        holidayDate.text = "\(viewModel.getDateDay()) \(viewModel.stringy())"
        holidayTable.reloadData()

        tappedCell.backgroundColor = Colors.orange

        if viewModel.getHolidayCountForDate() != 0 {
            // show holiday details when cell tapped
            detailView.display()

            // prevent taps when details are being shown, details must be closed first
            collectionView.isUserInteractionEnabled = false
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let tappedCell = collectionView.cellForItem(at:indexPath) as! CalendarCollectionViewCell

        // deselect visually
        tappedCell.backgroundColor = viewModel.getBackgroundColor(index: indexPath.row)
        collectionView.deselectItem(at: indexPath, animated: false)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // divide collectionview width by seven to create weeks
        let availableWidth = collectionView.frame.width
        let numColumns = 7
        let cellWidth = (availableWidth / CGFloat(numColumns)).rounded(.down)

        return CGSize(width: cellWidth, height: cellWidth)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getHolidayCountForDate()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! DetailTableViewCell

        // configure holiday table view cell
        cell.name.text = viewModel.getHolidayName(index: indexPath.row)
        cell.country.text = "Country: \(viewModel.getHolidayCountry(index: indexPath.row))"
        cell.type.text = "Type: \(viewModel.getHolidayType(index: indexPath.row))"

        return cell
    }
}
