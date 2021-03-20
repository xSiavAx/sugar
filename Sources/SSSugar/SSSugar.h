#import <Foundation/Foundation.h>

//! Project version number for SSSugar.
FOUNDATION_EXPORT double SSSugarVersionNumber;

//! Project version string for SSSugar.
FOUNDATION_EXPORT const unsigned char SSSugarVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <SSSugar/PublicHeader.h>

//TODO: Add architecture components (like Display, Adapter, State, Presenter) based on protocols

//TODO: Add AnyObject requirements to Updater and Mutator entity (cuz them will not work otherwise)

//TODO: To each sum operator (operator+) add minus operator and also += and -=
//TODO: Fix CGSize.extended(by size:)
//TODO: Add SSGroupExecutor and SSChainExecutor documentation
//TODO: Add default values '0' to 'extended' method inside CGSize extension

//TODO: Implements "Sugar" from UkrNet

//TODO: Move custom shuffle and shuffled from Array extension to more common protocol (it should be declared for range too, for example).

/*
 MARK: - Not Covered By Unit Tests

 ## Utils

 TODO: SSLinearCongruentialRandomizer
 TODO: SSProtectionViewHelper

 ### Data Synchronisation

 TODO: SSMarkerGenerating
 TODO: SSSingleEntityProcessing
 TODO: SSUpdater
 TODO: SSUpdate
 TODO: SSEntityRemoteMutator

 #### Example

 TODO: SSUETask
 TODO: SSUETaskUpdate
 TODO: SSUETaskUpdateReceiver
 TODO: SSUETaskUpdater
 TODO: SSUETaskObtainer
 TODO: SSUETaskProcessor
 TODO: SSUETaskDBMutator
 TODO: SSUETaskDBApi
 TODO: SSUETaskRemoteMutator
 TODO: TaskView
 TODO: ProcessorTester

 ### ViewStyles

 TODO: Styleable

 ### Collections Custom Select

 TODO: SSMarkbaleCollectionCellHelper
     - markViewPadding didSet
     - onLayoutSubviews()
     - marked setter
     - marking setter

 ## Extensions

 TODO: DispatchQueue
 TODO: UIDevice

 ### Utils

 #### Certificates Pinning

 TODO: SSAssetCertificateObtainer
 TODO: SSCertificatePinner
 TODO: URLSession

 ### Controllers

 TODO: UIViewController
     - rootController()

 ### Types

 TODO: String
 TODO: Dictionary
     - merge(\_\:)
     - merging(\_\:)
 TODO: Data

 ### Views

 TODO: UITableView
 TODO: UIButton
 TODO: UIView

 ## Classes

 TODO: SSAtomic

 ### Animators

 #### Show And Hide Animators

 TODO: SSViewShowHideByAlphaAnimator

 #### View Transition Animators

 TODO: SSScaleAndAlphaTransitionAnimator

 ### Decorators

 TODO: SSReleaseDecorator

 ### View Controllers

 TODO: SSRootViewController

 ### Views

 TODO: SSProgressView
 TODO: SSRootView
 TODO: SSActivityProtectionView
 TODO: SSTextField
 TODO: SSScrollContainerView
 TODO: SSSelectionMarkView
     - sizeThatFits(\_\:)
     - layoutSubviews()
     - imageViewSizesThatFits(\_\:)
     - init(coder:)
 TODO: SSWindow

 ### Data Base

 TODO: SSDataBase
 TODO: SSDataBaseConnection
 TODO: SSDataBaseStatement
 TODO: SSDataBaseStatementProcessor
 TODO: SSDataBaseSavePoint
 TODO: SSDataBaseStatementCache
 TODO: SSDataBaseTransaction
 TODO: SSDataBaseStatementCacheHolder
 TODO: SSDataBaseTransactionController
 TODO: SSEntityDBMutator
 TODO: SSBaseEntityUpdating

 #### Release Decorator Extensions

 TODO: SSReleaseDecorator

 #### Proxies

 TODO: SSDataBaseStatementProxing
 TODO: SSDataBaseSavePointProxing

 ## Protocols

 TODO: SSViewBlocking
 TODO: SSViewDelayedBlocking
 TODO: RandomNumberGenerator
 TODO: SSOnMainExecutor
 TODO: SSCopying

 ## Other

 TODO: log(\_\:tag\:file\:line\:funcName\:)
 TODO: NSLocalizedString(_:)
 TODO: pixelSize()

 MARK: - Without Documentation

 ## Utils

 ### Collections Custom Select

 TODO: SSCollectionViewMarkableControllerDelegate
 TODO: SSCollectionViewMarkable
     - cellForRow(at\:)
     - indexPathsForVisibleRows()
 TODO: SSCollectionViewCellMarkable
     - marking
     - marked
     - setMarking(\_\:animated\:)
     - setMarked(\_\:animated\:)

 ### View Styles

 TODO: Styleable
     - type

 ### Data Synchronisation

 TODO: SSEntityRemoteMutator
     - start(source\:)
     - stop()
 TODO: SSEntityDBMutator
     - start(source\:)
     - stop()
 TODO: SSMutatingEntitySource
     - entity(for\:)
 TODO: SSMarkerGenerating
     - newMarker
 TODO: SSMarkerGenerating
     - newMarker
 TODO: SSBaseEntityMutating
     - start(source\:)
     - stop()
 TODO: SSUpdaterEntitySource
     - entity(for\:)
 TODO: SSBaseEntityUpdating
     - delegate
     - receiversManager
     - start(source\:)
     - stop()
     - entity
     - start(source\:delegate\:)
 TODO: SSEntityObtainer
 TODO: SSEntityProcessing
 TODO: SSSingleEntityProcessing
 TODO: SSUpdater.Observer
     - tokens
     - receiver
     - converter
     - init(receiver\:converter\:)
 TODO: SSUpdater.UpdatesConverter

 #### Examples

 TODO: DB
 TODO: SSUETaskDBApi
 TODO: TaskView
 TODO: ProcessorTester
 TODO: SSUETaskRemoteMutator
 TODO: SSUETaskDBMutator
 TODO: SSUETaskMutator
     - increment(\_\:)
     - rename(new\:\_\:)
     - remove(\_\:)
 TODO: SSUETaskUpdaterDelegate
 TODO: SSUETaskUpdater
     - delegate
     - source
     - receiversManager
     - init(receiversManager\:)
 TODO: SSUETaskObtainer
 TODO: SSUETaskProcessor
 TODO: SSUETaskEditApi
 TODO: SSUETaskEditAsyncApi
 TODO: SSUETaskUpdateReceiver
     - taskReactions()
     - taskDidIncrementPages(\_\:)
     - taskDidRename(\_\:)
     - taskDidRemove(\_\:)
 TODO: mError
 TODO: SSUETask
     - init(copy\:)
     - description

 ## Extension

 TODO: DispatchQueue
     - execute(\_\:)

 ### Views

 TODO: UIButton
 TODO: UIView
 TODO: UITableView

 ### Containers

 TODO: Array
     - init(size:buildBlock:)
     - pick(at:)
 TODO: Dictionary
 TODO: ShuffleType
     - case names

 ### Types

 TODO: HexEncodingOptions
 TODO: CGPoint
 TODO: CGSize
     - extended(by\:)
     - extended(dx\:dy\:)
     - added(to\:vertically\:)
     - overloaded operators
 TODO: UIColor
     - init(red\:green:\blue\:)

 ### RandomNumberGenerator

 TODO: RandomNumberGeneratorLimitType
 TODO: RandomNumberGenerator
 TODO: Comparable

 ### Utils

 #### CertificatesPinning

 TODO: URLSession

 ## Classes

 TODO: SSChainExecutor
 TODO: SSGroupExecutor
 TODO: SSAtomic
     - value
     - init(\_\:)
     - mutate(\_\:)

 ### Views

 TODO: SSProgressView
 TODO: SSScrollContainerView
 TODO: SSWindow
 TODO: SSActivityProtectionView
 TODO: SSTextField
 TODO: SSSelectionMarkView

 ### ViewControllers

 TODO: SSRootView
 TODO: SSRootViewController

 ### Containers

 TODO: AutoMap

 ### DataBase

 TODO: SSDataBaseStatementProcessor
 TODO: SSDataBaseStatementCacheHolder
 TODO: SSDataBaseStatementCacheProtocol
 TODO: SSDataBaseStatementCache
 TODO: SSDataBaseQueryExecutor
 TODO: SSDataBaseTransaction
 TODO: SSDataBaseTransactionControllerProtocol
 TODO: SSDataBaseTransactionCreator
 TODO: SSDataBaseTransactionController
 TODO: SSDataBaseConnectionProtocol
 TODO: SSDataBaseConnection
 TODO: SSDataBaseStatementProtocol
 TODO: SSDataBaseSavePointProtocol
 TODO: SSDataBaseStatementCreator
 TODO: SSDataBaseProtocol
 TODO: SSDataBaseStatement
 TODO: SSDataBaseSavePoint
 TODO: SSDataBase

 #### Proxies

 TODO: SSDataBaseStatementProxing
 TODO: SSDataBaseStatementProxy
 TODO: SSDataBaseSavePointProxing
 TODO: SSDataBaseSavePointProxy

 #### Release Decorator Extensions

 TODO: SSReleaseDecorator

 ### Decorators

 TODO: SSReleaseDecorator

 ### Animators

 #### View Transition Animators

 TODO: SSScaleAndAlphaTransitionAnimator
     - init(duration\:minScale\:)
     - transition(from\:to\:by\:onFinish\:)
 TODO: SSViewTransitionAnimating
     - transition(from\:to\:by\:onFinish\:)

 ## Protocols

 TODO: SSExecutor
     - execute(\_\:)
 TODO: SSCopying
 TODO: SSCacheContainer
 TODO: SSTransacted
 TODO: SSReleasable

 ## Other

 TODO: log(\_\:tag\:file\:line\:funcName\:)
 TODO: NSLocalizedString(\_\:)
 TODO: pixelSize()
 */
