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
    
    
    private var kit: HKHealthStore! {
        return HKHealthStore()
    }
    
    private let queryType = HKQuantityType.quantityType(forIdentifier: .bodyTemperature)!
    private let querySample = HKSampleType.quantityType(forIdentifier: .bodyTemperature)!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.title = "体温记录 top 10"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add",
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
        
        /*
        // 时间查询条件对象
        let calendar = Calendar.current
        let todayStart =  calendar.date(from: calendar.dateComponents([.year,.month,.day], from: Date()))
        let dayPredicate = HKQuery.predicateForSamples(withStart: todayStart,
                                                       end: Date(timeInterval: 24*60*60,since: todayStart!),
                                                       options: HKQueryOptions.strictStartDate) */

        // 创建查询对象
        let temperatureSampleQuery = HKSampleQuery(sampleType: querySample, // 要获取的类型对象
                                                   predicate: nil, // 时间参数，为空时则不限制时间
                                                   limit: 10, // 获取数量
                                                   sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) // 获取到的数据排序方式
        { (query, results, error) in
            /// 获取到结果之后 results 是返回的 [HKSample]?
            if let samples = results {
                // 挨个插入到 tableView 中
                for sample in samples {
                    DispatchQueue.main.async {
                        self.temperatureSamples.append(sample)
                        self.tableView.insertRows(at: [IndexPath(row: self.temperatureSamples.firstIndex(of: sample)!, section:0)],
                                                  with: .right   )
                    }
                }
            }
        }

        // 执行查询操作
        kit.execute(temperatureSampleQuery)
    }
    
    
    /// 自定义方法：输入 HKSample 输出 日期和温度
    func getTemperatureAndDate(sample: HKSample) -> (Date, Double) {
        let quantitySample = sample as! HKQuantitySample
        let date = sample.startDate
        let temperature = quantitySample.quantity.doubleValue(for: .degreeCelsius())
        return (date, temperature)
    }
        
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return temperatureSamples.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TemperatureCell", for: indexPath)
        let (date, temperature) = getTemperatureAndDate(sample: temperatureSamples[indexPath.row])
        cell.textLabel?.text = String(temperature)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "zh_CN")
        
        cell.detailTextLabel?.text = dateFormatter.string(from: date)
        return cell
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
                                            "app" : "BodyTemperature",
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
