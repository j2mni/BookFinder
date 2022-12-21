//
//  MainTableViewController.swift
//  BookFinderWithCodableEx
//
//  Created by j2mni on 2022/10/24.
//

import UIKit

class MainTableViewController: UITableViewController {
    let apiKey = "KakaoAK fd1de8e87ad9675ebe9cda904b18e4c1"
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var btnPrev: UIBarButtonItem!
    @IBOutlet weak var btnNext: UIBarButtonItem!
    var books:[Book] = []
    var page = 1
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 120
        searchBar.delegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func search(with query:String?, page:Int){
        guard let query = query else { return }
        let str = "https://dapi.kakao.com/v3/search/book?query=\(query)&page=\(page)"
        // URL -> URLRequest -> URLSession -> session.dataTask -> handler(data) -> codable -> Result Data -> ResultData.documents -> books:[Book] -> tableView.reload()
        // 쿼리에 한글이 들어갈 수 있어서 PercentEncoding으로 바꿔줌
        if let strURL = str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: strURL){
            var request = URLRequest(url: url)
            request.addValue(apiKey, forHTTPHeaderField: "Authorization")
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let data = data else { return }
                if let result = try? JSONDecoder().decode(ResultData.self, from:data){
                    self.books = result.documents
                    DispatchQueue.main.async { // 메인 스레드로 보내기
                        self.tableView.reloadData()
                        self.btnNext.isEnabled = !result.meta.is_end
                    }
                }
            }
            task.resume() // 작업을 실행해라
        }
        btnPrev.isEnabled = page > 1
    }

    
    @IBAction func actNext(_ sender: Any) {
        page += 1
        search(with: searchBar.text, page: page)
    }
    
    @IBAction func actPrev(_ sender: Any) {
        page -= 1
        search(with: searchBar.text, page: page)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return books.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookcell", for: indexPath)
        let book = books[indexPath.row]
        let imageVIew = cell.viewWithTag(1) as? UIImageView
        if let url = URL(string: book.thumbnail) {
            let request = URLRequest(url: url)
            let session = URLSession.shared
            session.dataTask(with: request) { data, _, errer in
                if let data = data{
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        imageVIew?.image = image
                    }
                }
            }.resume()
        }
        
        
        let lblAuthors = cell.viewWithTag(3) as? UILabel
//        let authors = book.authors
        lblAuthors?.text = book.authors.joined(separator: ", ")
        
        let lblTitle = cell.viewWithTag(2) as? UILabel
        lblTitle?.text = book.title
        
        let lblPublisher = cell.viewWithTag(4) as? UILabel
        lblPublisher?.text = book.publisher
        
        let lblPrice = cell.viewWithTag(5) as? UILabel
        lblPrice?.text = "\(book.price)"
        
        
        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail"{
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let book = self.books[indexPath.row]
            let vc = segue.destination as? DetailViewController
            vc?.strURL = book.url
        }
    }
    

}

extension MainTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        page = 1
        search(with: searchBar.text, page: page)
        searchBar.resignFirstResponder()
    }
}
