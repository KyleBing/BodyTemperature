//
//  TemperatureTableViewController.swift
//  BodyTemparature
//
//  Created by Kyle on 2020/2/10.
//  Copyright © 2020 Cyan Maple. All rights reserved.
//

import UIKit
import HealthKit

/// 获取 Health 中的体温数据
class TemperatureTableViewController: UITableViewController {
        
    // 存储查询到的数据
    private var temperatureSamples: Array<HKSample> = []
    private struct Colors {
        static let purple = UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 1)
        static let magenta = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1)
        static let orange = UIColor(red: 255/255, green: 149/255, blue: 0, alpha: 1)
        static let blue = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)
    }
    
    
    
    private var kit: HKHealthStore! {
        return HKHealthStore()
    }
    
    private let queryType = HKQuantityType.quantityType(forIdentifier: .bodyTemperature)!
    private let querySample = HKSampleType.quantityType(forIdentifier: .bodyTemperature)!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.title = "体温记录 - 3天"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "添加",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(buttonPressed))
        
        
        // 如果 iOS 11+ 显示大标题
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        
        if HKHealthStore.isHealthDataAvailable(){
            //  Write Authorize
            let queryTypeArray: Set<HKSampleType> = [queryType]
            //  Read Authorize
            let querySampleArray: Set<HKObjectType> = [querySample]
            kit.requestAuthorization(toShare: queryTypeArray, read: querySampleArray) { (success, error) in
                if success{
                    self.getTemperatureData()
                } else {
                    self.showAlert(title: "Fail", message: "Unable to access to Health App", buttonTitle: "OK")
                }
            }
        } else {
            // show alert
            showAlert(title: "Fail", message: "设备不支持使用健康", buttonTitle: "退出")
        }
    }
    
    
    @objc func buttonPressed() {
        performSegue(withIdentifier: "AddTemperature", sender: self)
    }
    
    
    
    func getTemperatureData(){
        
        
        // 时间查询条件对象
        let calendar = Calendar.current
        let dateNow = Date()
        var date3DaysAgoComponents = calendar.dateComponents([.year, .month, .day], from: dateNow)
        date3DaysAgoComponents.day = date3DaysAgoComponents.day! - 3
        let date3DaysAgo = calendar.date(from: date3DaysAgoComponents)!
        let timePredicate = HKQuery.predicateForSamples(withStart: date3DaysAgo,
                                                        end: dateNow,
                                                        options: .strictStartDate)

        // 创建查询对象
        let temperatureSampleQuery = HKSampleQuery(sampleType: querySample, // 要获取的类型对象
                                                   predicate: timePredicate, // 时间参数，为空时则不限制时间
                                                   limit: 100, // 获取数量限制
                                                   sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) // 获取到的数据排序方式
        { (query, results, error) in
            /// 获取到结果之后 results 是返回的 [HKSample]?
            if let samples = results {
                // 挨个插入到 tableView 中
                for sample in samples {
                    DispatchQueue.main.async {
                        self.temperatureSamples.append(sample)
                        self.tableView.insertRows(at: [IndexPath(row: self.temperatureSamples.firstIndex(of: sample)!, section:0)],
                                                  with: .fade   )
                    }
                }
            }
        }

        // 执行查询操作
        kit.execute(temperatureSampleQuery)
    }
    
    
    /// 自定义方法：输入 HKSample 相关参数
    func getTemperatureAndDate(sample: HKSample) -> (temperature: Double, date: Date, deviceName: String, appName: String) {
        let quantitySample = sample as! HKQuantitySample
        let date = sample.startDate
        let temperature = quantitySample.quantity.doubleValue(for: .degreeCelsius())
        let deviceName = sample.device?.name ?? "--"
        let appName = sample.sourceRevision.source.name
        return (temperature, date, deviceName, appName)
    }
        
    
    // MARK: - Table view
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "02-13"
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return temperatureSamples.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TemperatureCell", for: indexPath) as! TemperatureTableViewCell
        let sample = getTemperatureAndDate(sample: temperatureSamples[indexPath.row])
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier: "zh_CN")
        
        cell.labelTitle.text = String(sample.temperature)
        switch sample.temperature {
        case 35..<36: cell.labelTitle.textColor = Colors.blue
        case 36..<37: break
        case 37..<37.5: cell.labelTitle.textColor = Colors.magenta
        case 37.5..<38: cell.labelTitle.textColor = Colors.orange
        case 38...42: cell.labelTitle.textColor = Colors.purple
        default: break
        }
        cell.labelDate.text = dateFormatter.string(from: sample.date)
        cell.labelDevice.text = sample.deviceName
        cell.labelApp.text = sample.appName
        
        return cell
    }
    
    // delete
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionDelete = UIContextualAction(style: .destructive, title: "删除", handler: {(action, view, bool) in
            // delete in HealthKit
            let deletedObject = self.temperatureSamples[indexPath.row]
            self.kit.delete(deletedObject) { (success, error) in
                if success {
                    // delete in tableView
                    DispatchQueue.main.async {
                        self.temperatureSamples.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .left)
                    }
                } else {
                    self.showAlert(title: "失败", message: "删除失败", buttonTitle: "知道了")
                }
            }
           
        })
        let swipeConfig = UISwipeActionsConfiguration(actions: [actionDelete])
        return swipeConfig
    }
    
    
    
    
    // MARK: - Tool Methods - Alert
    func showAlert(title: String, message: String, buttonTitle: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: buttonTitle, style: .default, handler: { (action) in
        })
        alert.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Unwind segue
    @IBAction func unwindToTableViewController(_ unwindSegue: UIStoryboardSegue) {
        if let svc = unwindSegue.source as? AddTemperatureViewController{
            let temperature = Double(svc.textField.text!)!
            let quantity = HKQuantity(unit: .degreeCelsius(), doubleValue: temperature)
            let sample = HKQuantitySample(type: queryType,
                                          quantity: quantity,
                                          start: Date(),
                                          end: Date(),
                                          device: HKDevice.local(),
                                          metadata: [
                                            "app" : "体温",
                                            "version": Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
                                          ]
            )
            kit.save(sample) { (success, error) in
                if success {
                    // add to tableView
                    DispatchQueue.main.async {
                        self.temperatureSamples.insert(sample, at: 0)
                        self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .right)
                    }
                }
            }
        }
    }
}
    
