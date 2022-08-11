//
//  PListDictionary PListNode.swift
//  PListKit • https://github.com/orchetect/PListKit
//

import Foundation

// MARK: - Top level class definition

// all subclasses adopt this

extension PList {
    /// `PList` path builder object to facilitate functional traversal of the underlying `PList` data storage.
    ///
    /// Do not instance this class directly. Instead, access the `.root` property on a `PList` object.
    ///
    /// At the end of the path, use the `.value` property to get or set the current node's value.
    ///
    /// ```
    /// let pl = PList()
    ///
    /// pl.root.string(key: "String") = "string value"
    /// let val = pl.root.string(key: "String") // "string value"
    /// ```
    /// It also allows for access to nested dictionaries.
    ///
    /// ```
    /// pl.root
    ///   .dict(key: "Dict")
    ///   .dict(key: "Nested Dict")
    ///   .string(key: "String")
    ///   .value
    /// ```
    ///
    public class PListNode {
        internal var parent: TreeNode?
        
        internal var type: NodeType?
        
        internal var key: String
        
        internal init(key: String, type: NodeType? = nil, parent: TreeNode?) {
            self.key = key
            self.type = type
            self.parent = parent
        }
        
        internal func getter(_ keys: [KeyNodeTypePair]? = nil) -> PListValue? {
            var _keys = keys ?? []
            
            if let type = type {
                _keys.append((key, type))
            }
            
            return parent?.getter(_keys)
        }
        
        internal func setter(
            _ keys: [KeyNodeTypePair]? = nil,
            value: PListValue?
        ) {
            var _keys = keys ?? []
            
            if let type = type {
                _keys.append((key, type))
            }
            
            parent?.setter(_keys, value: value)
        }
    }
}

extension PList.PListNode {
    /// Internal
    enum NodeType {
        case any
        
        case dictionary
        case array
        
        case string
        case int
        case double
        case bool
        case date
        case data
    }
    
    /// Internal
    typealias KeyNodeTypePair = (key: String, type: NodeType)
}

// MARK: - Nodes

extension PList.PListNode {
    public class TreeNode: PList.PListNode { }
    
    public class TreeDictionary: TreeNode {
        public func any(key: String) -> AnyKey {
            PList.PListNode.AnyKey(key: key, type: .any, parent: self)
        }
        
        public func dict(key: String) -> SubDictionary {
            PList.PListNode.SubDictionary(key: key, parent: self)
        }
        
        public func array(key: String) -> ArrayKey {
            PList.PListNode.ArrayKey(key: key, type: .array, parent: self)
        }
        
        public func string(key: String) -> StringKey {
            PList.PListNode.StringKey(key: key, type: .string, parent: self)
        }
        
        public func int(key: String) -> IntKey {
            PList.PListNode.IntKey(key: key, type: .int, parent: self)
        }
        
        public func double(key: String) -> DoubleKey {
            PList.PListNode.DoubleKey(key: key, type: .double, parent: self)
        }
        
        public func bool(key: String) -> BoolKey {
            PList.PListNode.BoolKey(key: key, type: .bool, parent: self)
        }
        
        public func date(key: String) -> DateKey {
            PList.PListNode.DateKey(key: key, type: .date, parent: self)
        }
        
        public func data(key: String) -> DataKey {
            PList.PListNode.DataKey(key: key, type: .data, parent: self)
        }
    }
}

// MARK: - Root

extension PList.PListNode {
    public class Root: PList.PListNode.TreeDictionary {
        internal weak var delegate: PList?
        
        internal init(delegate: PList? = nil) {
            self.delegate = delegate
            
            super.init(
                key: "",
                type: .dictionary,
                parent: nil
            )
        }
        
        public var value: PListDictionary {
            get {
                delegate?.storage ?? [:]
            }
            set {
                delegate?.storage = newValue
            }
        }
        
        override internal func getter(_ keys: [KeyNodeTypePair]? = nil) -> PListValue? {
            func recursiveGet(
                dictionary: PListDictionary?,
                pairs: [KeyNodeTypePair]
            ) -> PListValue? {
                var pairs = pairs
                
                guard let current = pairs.popLast() else { return nil }
                
                switch current.type {
                case .dictionary:
                    if !pairs.isEmpty {
                        return recursiveGet(
                            dictionary: dictionary?[dict: current.key],
                            pairs: pairs
                        )
                    } else {
                        return dictionary?[current.key]
                    }
                default:
                    return dictionary?[current.key]
                }
            }
            
            guard let dataStore = delegate?.storage else { return nil }
            
            guard keys != nil else { return nil }
            
            return recursiveGet(dictionary: dataStore, pairs: keys!)
        }
        
        override internal func setter(
            _ keys: [KeyNodeTypePair]? = nil,
            value: PListValue?
        ) {
            func recursiveSet(
                dictionary: PListDictionary,
                pairs: [KeyNodeTypePair]
            ) -> PListDictionary {
                var pairs = pairs
                
                var dictionary = dictionary
                
                guard let current = pairs.popLast() else {
                    // this should never happen but as a failsafe, just return the dictionary unchanged
                    return dictionary
                }
                
                switch current.type {
                case .dictionary:
                    if !pairs.isEmpty,
                       delegate?.createIntermediateDictionaries ?? false
                    {
                        if let newDict = dictionary[dictCreate: current.key] {
                            dictionary[dict: current.key] = recursiveSet(
                                dictionary: newDict,
                                pairs: pairs
                            )
                        }
                    } else {
                        // we're not allowed to create the non-existent dictionary, so do nothing
                    }
                default:
                    dictionary[current.key] = value
                }
                
                return dictionary
            }
            
            guard let dataStore = delegate?.storage else { return }
            
            guard keys != nil else { return }
            
            let newDataStore = recursiveSet(
                dictionary: dataStore,
                pairs: keys!
            )
            
            delegate?.storage = newDataStore
        }
    }
}

// MARK: - Sub-nodes

extension PList.PListNode {
    // subnode template
    
    public class SubDictionary: PList.PListNode.TreeDictionary {
        internal init(
            key: String,
            parent: PList.PListNode.TreeNode
        ) {
            super.init(
                key: key,
                type: .dictionary,
                parent: parent
            )
        }
        
        public var value: PListDictionary? {
            get {
                getter() as? PListDictionary
            }
            set {
                setter(value: newValue)
            }
        }
    }
}

// MARK: - Sub-values

// MARK: definition

extension PList.PListNode {
    public class SubValue: PList.PListNode {
        internal init(
            key: String,
            type: NodeType? = nil,
            parent: PList.PListNode.TreeDictionary
        ) {
            super.init(
                key: key,
                type: type,
                parent: parent
            )
        }
    }
}

// MARK: individual subclasses

extension PList.PListNode {
    public class AnyKey: SubValue {
        public var value: PListValue? {
            get {
                getter()
            }
            set {
                setter(value: newValue)
            }
        }
    }
    
    public class ArrayKey: SubValue {
        public var value: PListArray? {
            get {
                getter() as? PListArray
            }
            set {
                setter(value: newValue)
            }
        }
    }
    
    public class StringKey: SubValue {
        public var value: String? {
            get {
                getter() as? String
            }
            set {
                setter(value: newValue)
            }
        }
    }
    
    public class IntKey: SubValue {
        public var value: Int? {
            get {
                getter() as? Int
            }
            set {
                setter(value: newValue)
            }
        }
    }
    
    public class DoubleKey: SubValue {
        public var value: Double? {
            get {
                let getValue = getter()
                
                // try Double first
                if let tryDouble = getValue as? Double {
                    return tryDouble
                }
                
                // otherwise see if there is an Int that can be read as a Double
                if let tryInt = getValue as? Int {
                    guard let toDouble = Double(exactly: tryInt) else { return nil }
                    return toDouble
                }
                
                return nil
            }
            set {
                setter(value: newValue)
            }
        }
    }
    
    public class BoolKey: SubValue {
        public var value: Bool? {
            get {
                getter() as? Bool
            }
            set {
                setter(value: newValue)
            }
        }
    }
    
    public class DateKey: SubValue {
        public var value: Date? {
            get {
                getter() as? Date
            }
            set {
                setter(value: newValue)
            }
        }
    }
    
    public class DataKey: SubValue {
        public var value: Data? {
            get {
                getter() as? Data
            }
            set {
                setter(value: newValue)
            }
        }
    }
}
