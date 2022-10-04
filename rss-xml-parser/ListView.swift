//
//  ListView.swift
//  rss-xml-parser
//
//  Created by Fabian on 13.09.22.
//

import SwiftUI
import SWXMLHash

//Identifiable class for List
class Item: Identifiable
{
    var title = ""
    var url = ""
    var pubDate = Date()
}

struct ListView: View {
    
    @State var channelName = ""
    @State var channelURL = ""
    @State var imageURL = ""
    @State var newsItems = [Item]()
    
    @State private var testURL : String = ""
    
    var body: some View {
        VStack{
            HStack {
                TextField(
                    "URL",
                    text: $testURL
                    )
/*                .onSubmit {
                    validate(name: testURL)
                }
  */
                Button(action: loadData) {
                    Label("Load Data", systemImage: "gobackward")
                }
            }.buttonStyle(.bordered)
            //Channel Information
            //Text("\(channelName)")
            //    .font(.system(size: 16))
            //    .bold()
            //Text("\(channelURL)")
            
            //List of News Items
            List(newsItems){ item in
                VStack(alignment: .leading){
                    Text("\(item.title)")
                        .bold()
                    Text(displayDate(date: item.pubDate))
                        .italic()
                        .font(.system(size: 14))
                }
                .onTapGesture {
                    UIApplication.shared.open(URL(string: item.url)!)
                }
            }
        }
    }
    
    func loadData(){
        //let url = NSURL(string: "https://rss.nytimes.com/services/xml/rss/nyt/Europe.xml")
        
        let urlArray = [NSURL(string: testURL)]
                
        urlArray.forEach { test in
        
        let task = URLSession.shared.dataTask(with: test! as URL) {(data, response, error) in
                if data != nil
                {
                    let feed=NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                    let xml = XMLHash.parse(feed)
                    
                    channelName = xml["rss"]["channel"]["title"].element!.text
                    channelURL = xml["rss"]["channel"]["link"].element!.text
                    //imageURL = xml["rss"]["channel"]["image"]["url"].element!.text

                    for elem in xml["rss"]["channel"]["item"].all
                    {
                        let item = Item()
                        item.title = elem["title"].element!.text
                        item.url = elem["link"].element!.text
                        item.pubDate = cleanDate(date: elem["pubDate"].element!.text)
                        newsItems.append(item)
                        
                        //Sort the news items by publication date
                        newsItems = newsItems.sorted{$0.pubDate.compare($1.pubDate) == .orderedDescending}
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func cleanDate(date: String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        
        return dateFormatter.date(from:date) ?? Date()
    }
    
    func displayDate(date: Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy HH:mm"
        return dateFormatter.string(from:date)
    }
}


struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}

