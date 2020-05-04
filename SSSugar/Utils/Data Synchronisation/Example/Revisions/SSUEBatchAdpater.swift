import Foundation

internal class SSUEBatchAdpater: SSDmBatchAdapting {
    typealias Change = SSModify
    typealias Request = SSModify
    
    let strategies = createStrategies()
    
    static func createStrategies() -> Strategies {
        var strategies = Strategies()
        
        strategies.merge(taskStrategies())
        
        return strategies
    }
    
    static func taskStrategies() -> Strategies {
        typealias Creator = Builder.Adapt<SSUETaskChangeAdapting>
        
        let increment = Creator.To<SSUETaskIncrementPagesChange>.strategy {(adapting, change) in
            adapting.adaptByIncrementPages(change:change)
        }
        let rename = Builder.Try<SSUETaskChangeAdapting, SSUETaskRenameChange>.strategy {(adapting, change) in
            adapting.adaptByRename(change: change)
        }
        let remove = Builder.Try<SSUETaskChangeAdapting, SSUETaskRemoveChange>.strategy {(adapting, change) in
            adapting.adaptByRemove(change: change)
        }
        return [increment.title : increment.adapt,
                rename.title : rename.adapt,
                remove.title : remove.adapt]
    }
}
