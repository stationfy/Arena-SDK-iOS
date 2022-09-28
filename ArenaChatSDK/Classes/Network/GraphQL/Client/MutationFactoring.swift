import Apollo
import Foundation

protocol OperationFactoring {
    associatedtype T: GraphQLOperation
    var operation: T { get }
}
