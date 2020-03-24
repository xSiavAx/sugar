import XCTest

@testable import SSSugar

#warning("Tests for AutoMap")

//    Тесты с сетом
//
//    [Done] Инициализация с картой. С обычной кратой. С пустой картой. С картой с пустыми контейнерами.
//    [Done] Содержание. В пустом контейнере, с нужным ключем без элемента, без нужного ключа с элементом, с нужным ключем с нужным элементом.
//    [Done]    Добавление контейнера. В пустую карту. В непустую карту. В карту содержащую ключ.
//    Добавление. В пустую автокарту. С новым ключем. С существующим ключем. Добавление в разном порядке.
//    Замена контейнера. Обычная замена. Пустым контейнером. По ключу которого не было.
//    Удаление контейнера. По существующему ключу. По ключу, которого нет.
//    Удаление элемента. По ключу котрого нет. По существующему ключу без элемента. По существующему ключу.
//    Удаление всех элментов. С пустой карты. С наполненной карты.
//    [Done] subscript get. Получение контейнера по ключу. Получение контейнера по ключу которого нет.
//    [Done] subscript set. subscript set. Перезапись. Перезапись пустым контейнером. Перезапись nil. Добавление. Добавление пустого. Добавление nil.
//
//    Тесты с массивом
//
//    Получение елемента. По ключу и индексу. По ключу которого нет. По индексу которого нет. По ключу и индексу которых нет.
//    Вставка. Вставка по ключу которого нет. С индексом в начале. С индексом в конце. С индексом в средине. С индексом которого нет.
//    Обновление. По ключу и индексу. По ключу которого нет. По индексу которого нет. По ключу и индексу которых нет.
//    Удаление. По ключу и индексу. По ключу которого нет. По индексу которого нет. По ключу и индеку которых нет.
//    Множественное удаление. С ключами и ндексами. С ключами которые частично есть. С ключами которых нет вовсе. С индексами которых нет.
//    subscript. get. По ключу и индексу. По ключу которого нет. По индексу которого нет. По ключу и индексу которых нет.
//    subscript. set. По ключу и индексу. По ключу которого нет. По индексу которого нет. По ключу и индексу которых нет.

//    Изменение! Поведение карты теперь разное для контейнеров типа InsertbaleCollection и ReplacableCollection учесть это в уже написанных тестах и тестах будующих
//    Изменение! Добавился метод isEmpty, добавить тестов для него
    
//    Проверить доступность методов AutoMap как составляющую импортированного фреймворка (public)

struct AutoMapTestHelper {
    
    struct DefaultItem {
        var key: String
        var array: [Int]
        var set: Set<Int> {
            Set(array)
        }
    }
    
    let evens = DefaultItem(key: "evens", array: [0, 2, 4])
    let odds = DefaultItem(key: "odds", array: [1, 3, 5])
    let key = DefaultItem(key: "key", array: [0, 1, 2, 3])
    let insertion = DefaultItem(key: "insertion", array: [1, 2, 3])
    let replace = DefaultItem(key: "replace", array: [100, 200, 300])
    var mapItems: [DefaultItem] {
        [evens, odds, key]
    }
    var replacedMapItems: [DefaultItem] {
        [evens, odds, DefaultItem(key: key.key, array: replace.array)]
    }
    
    func makeSetMap(with items: [DefaultItem]) -> [String : Set<Int>] {
        var map = [String: Set<Int>]()
        
        items.forEach { map[$0.key] = $0.set }
        
        return map
    }
    
    func makeSetMap() -> [String : Set<Int>] {
        makeSetMap(with: mapItems)
    }
    
    func makeArrayMap() -> [String : [Int]] {
        var map = [String : [Int]]()
        
        mapItems.forEach { map[$0.key] = $0.array }
        
        return map
    }
    
    func checkWith<Container : ReplaceableCollection & Equatable>(_ automap: AutoMap<String, Container>, _ dict: [String : Container]) {
        XCTAssertEqual(automap.keys, dict.keys)
        
        for key in automap.keys {
            XCTAssertEqual(automap[key], dict[key])
        }
    }
    
}
