//
//  ViewController.swift
//  FreeCourses
//
//  Created by jollen@jollen.org on 2014/7/14.
//  Copyright (c) 2014 Mokoversity. All rights reserved.
//


import UIKit

enum CellData {
    case DescriptiveCell(title: String, organizer: String, url: String)
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSURLConnectionDelegate {
    
    // 宣告存放資料的陣列
    var recipes: [CellData] = []
    
    @IBOutlet
    var tableView: UITableView?
    
    var data: NSMutableData = NSMutableData()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        startConnection()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startConnection() {
        var restAPI: String = "http://freecourses.tw/1/post"
        var url: NSURL = NSURL(string: restAPI)
        var request: NSURLRequest = NSURLRequest(URL: url)
        var connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: true)
        
        println("start download")
    }
    
    // 事件
    @IBAction
    func rightBarButtonItemClicked(sender : AnyObject) {
        println("refresh")
    }
    
    // -- NSURLConnectionDelegate protocol
    
    // 開始新的 request
    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        // Recieved a new request, clear out the data object
        println("new request")
    }
    
    // -- NSURLConnectionDelegate protocol
    
    // 下載中
    func connection(connection: NSURLConnection!, didReceiveData dataReceived: NSData!) {
        println("downloading")
        self.data.appendData(dataReceived)
    }
    
    // 下載完成
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        var error: NSError?
        let jsonDictionary = NSJSONSerialization.JSONObjectWithData(self.data, options: NSJSONReadingOptions.MutableContainers, error: &error) as Dictionary<String, AnyObject>
        
        println("finished")
        
        let posts: AnyObject? = jsonDictionary["data"]
        let collection = posts! as Array<Dictionary<String, AnyObject>>
        
        for post in collection {
            let title: AnyObject? = post["title"]
            let organizer: AnyObject? = post["organizer"]
            let url: AnyObject? = post["url"]
            let startDate: AnyObject? = post["startDate"]
            let typeTags: AnyObject? = post["typeTags"]

            let cell: CellData = .DescriptiveCell(title: title as String, organizer: organizer as String, url: url as String)
            
            self.recipes.append(cell)
        }
        
        self.tableView?.reloadData()
    }
    
    // -- UITableViewDelegate
    
    // 回報所有行數 (Rows)
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.recipes.count
    }
    
    // 載入指定的 Row
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell = UITableViewCell(style:UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        var row:Int = indexPath.row as Int
        var data = self.recipes[row]
        
        switch(data) {
        case .DescriptiveCell(var title, var description, var url):
            cell.textLabel.text = title
            cell.detailTextLabel.text = description
        }
        
        println("Loading row \(row)")
        
        return cell
    }
    
    // 選擇一個 Row
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let alert = UIAlertView()
        let row = indexPath.row as Int
        var data = self.recipes[indexPath.row]
        
        switch(data) {
        case .DescriptiveCell(var title, var description, var url):
            alert.title = "課程"
            alert.message = "\(title)"
        }
        
        alert.addButtonWithTitle("OK")
        alert.show()
    }
    
    // 刪除一個 Row
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!){
        println("delete row")
    }
}
