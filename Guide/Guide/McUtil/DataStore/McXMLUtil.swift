//
//  McXMLUtil.swift
//  Guide
//
//  Created by dingmc on 16/2/2.
//  Copyright © 2016年 dingmc. All rights reserved.
//

import UIKit

struct XMLReaderOptions: OptionSetType {
    var rawValue:Int
    init(rawValue: Int) {
        self.rawValue = rawValue
    }
    static let XMLReaderOptionsProcessNamespaces = XMLReaderOptions(rawValue: 1 << 0)
    static let XMLReaderOptionsReportNamespacePrefixes = XMLReaderOptions(rawValue: 1 << 1)
    static let XMLReaderOptionsResolveExternalEntities = XMLReaderOptions(rawValue: 1 << 2)
}

class McXMLUtil: NSObject, NSXMLParserDelegate{
    
    var dictionaryStack: NSMutableArray = NSMutableArray()
    var textInProgress = NSMutableString()
    
//    + (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError **)error
//    {
//    XMLReader *reader = [[XMLReader alloc] initWithError:error];
//    NSDictionary *rootDictionary = [reader objectWithData:data options:0];
//    return rootDictionary;
//    }
//    
//    + (NSDictionary *)dictionaryForXMLString:(NSString *)string error:(NSError **)error
//    {
//    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
//    return [XMLReader dictionaryForXMLData:data error:error];
//    }
//    
//    + (NSDictionary *)dictionaryForXMLData:(NSData *)data options:(XMLReaderOptions)options error:(NSError **)error
//    {
//    XMLReader *reader = [[XMLReader alloc] initWithError:error];
//    NSDictionary *rootDictionary = [reader objectWithData:data options:options];
//    return rootDictionary;
//    }
//    
//    + (NSDictionary *)dictionaryForXMLString:(NSString *)string options:(XMLReaderOptions)options error:(NSError **)error
//    {
//    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
//    return [XMLReader dictionaryForXMLData:data options:options error:error];
//    }
    
    func getCurFile(){
        let path = NSBundle.mainBundle().pathForResource("p", ofType: "xml")
        let parser = NSXMLParser(contentsOfURL: NSURL(fileURLWithPath: path!))
        parser?.delegate = self
        print(parser?.parse())
    }
    
    func objectWithData(data: NSData, options: XMLReaderOptions)->NSDictionary?{
        self.dictionaryStack = NSMutableArray()
        self.textInProgress = NSMutableString()
        
        self.dictionaryStack.addObject(NSMutableDictionary())
        
        let parser = NSXMLParser(data: data)
        parser.shouldProcessNamespaces = options == .XMLReaderOptionsProcessNamespaces
        parser.shouldReportNamespacePrefixes = options == .XMLReaderOptionsReportNamespacePrefixes
        parser.shouldResolveExternalEntities = options == .XMLReaderOptionsResolveExternalEntities//
        parser.delegate = self
        if parser.parse(){
            return self.dictionaryStack.objectAtIndex(0) as? NSDictionary
        }
        return nil
    }
    
    //NSXMLParserDelegate....
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        let parentDict = self.dictionaryStack.lastObject
        let childDict = NSMutableDictionary()//...
        childDict.addEntriesFromDictionary(attributeDict)
        let existingValue = parentDict?.objectForKey(elementName)
        if existingValue != nil{
            var array: NSMutableArray!
            if existingValue!.isKindOfClass(NSMutableArray){
                array = existingValue as! NSMutableArray
            }else{
                array = NSMutableArray()
                array.addObject(childDict)
                parentDict?.setObject(array, forKey: elementName)
            }
            
            array.addObject(childDict)
        }else{
            parentDict?.setObject(childDict, forKey: elementName)
        }
        self.dictionaryStack.addObject(childDict)
    }
    
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        let dictInProgress = self.dictionaryStack.lastObject
        if self.textInProgress.length > 0{
            let trimmedString = self.textInProgress.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            dictInProgress?.setObject(trimmedString, forKey: "text")//...
            self.textInProgress = NSMutableString()
        }
        self.dictionaryStack.removeLastObject()
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        self.textInProgress.appendString(string)
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        print("error-->>")
        print(parseError)
    }
}
