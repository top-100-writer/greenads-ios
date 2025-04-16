# GreenAdsSDK iOS
GreenAdsSDK обеспечивает возможность показа рекламных баннеров в iOS приложениях.

SDK архив: 

## Подключение
### Swift Package Manager
1. В Xcode откройте свой проект и перейдите на вкладку Package Dependencies.
2. Нажмите на "+" для добавления нового пакета и укажите URL репозитория: https://github.com/top-100-writer/greenads-ios в нем находится `Package.swift`
3. Выберете версию пакета и настройте правило обновления. Добавьте пакет в свой проект.
4. После добавления, пакет должен появиться в Package Dependencies, а также в Project Navigator.

### Manually
1. [Скачайте](https://github.com/top-100-writer/greenads-ios/releases/download/1.0.1/GreenAdsSDK.xcframework.zip) актуальную версию SDK.
2. Распакуйте скачанный Zip-архив, внутри должен быть GreenAdsSDK.xcframework.
3. Откройте в Xcode свой проект и в Project Navigator выберите ваш проект.
4. Выберите Target, в котором хотите использовать SDK.
5. Для данного Target во вкладке General перейдите к разделу Frameworks, Libraries, and Embedded Content.
6. Нажмите "+" (Add Item) и добавьте в свой проект SDK, выбрав скачанный ранее и распакованный GreenAdsSDK.xcframework.


## Баннеры (UIKit)
### Inline

``GAInlineBannerView`` - визуальный компонент, дочерний класс `UIView`, который может быть добавлен на экран приложения.

Для показа баннеров в своем приложении необходимо при помощи ``GAFactory`` создать экземпляр класса ``GAInlineBannerView``.

При создания экземпляра ``GAInlineBannerView`` необходимо указать его конфигурацию ``GAInlineBannerInputModel``, а также при необходимости размер через ``GASize``. Поддерживаются средующие форматы: адаптиванный (ширина по `superview`, высота - 250) и фиксированный 300x250.

Отслеживать события баннера можно через присвоение свойства баннера `delegate`, удовлетворяющего ``GAInlineBannerViewDelegate``.

После того, как экземпляр ``GAInlineBannerView`` будет создан и добавлен в иерархию отображения, возможно инициировать обновление содержимого рекламного объявления:

```swift
let banner: GAInlineBannerView = GAFactory.createInlineBanner(with: inputModel, size: size)
view.addSubview(banner)
banner.delegate = self
banner.loadAd()
```

### Sticky

``GAStickyBannerView`` - визуальный компонент, дочерний класс `UIView`, который может быть добавлен на экран приложения.

Для показа баннеров в своем приложении необходимо при помощи ``GAFactory`` создать экземпляр класса ``GAStickyBannerView``.

При создания экземпляра ``GAStickyBannerView`` необходимо указать его конфигурацию ``GAStickyBannerInputModel``, а также при необходимости его размер через ``GASize``. Поддерживаются средующие форматы: адаптиванный (ширина по `superview`, высота - 50) и фиксированный 320x50.

Отслеживать события баннера можно через присвоение свойства баннера `delegate`, удовлетворяющего ``GAStickyBannerViewDelegate``.

После того, как экземпляр ``GAStickyBannerView`` будет создан, необходимо добавить его в иерархию отображения. Помимо системных методов, в рамках SDK реализованы типичные методы добавления таких баннеров сверху и снизу `superview`. 

После добавления баннера в иерархию, возможно инициировать обновление содержимого рекламного объявления:

```swift
let banner: GAStickyBannerView = GAFactory.createStickyBanner(with: inputModel, size: size)
banner.displayAtBottom(in: view)
banner.delegate = self
banner.loadAd()
```

### Interstitial

Для показа полноэкранного рекламного объявления его сначала необходимо загрузить при помощи ``GAInterstitialAdLoader``. Загрузка происходит в соответствии с конфигурацией ``GAAdRequestConfiguration``.

Поддерживаются различные методы загрузки: как при помощи `delegate`, так и при помощи Swift Concurrency.

В случае успешной загрузки вы получите экземпляр ``GAInterstitialAd``, с помощью которого можно вызвать показ полноэкранного рекламного объявления:

```swift
func interstitialAdLoader(_ adLoader: GAInterstitialAdLoader, didLoad interstitialAd: GAInterstitialAd) {
    interstitialAd.show(from: self)
}
```

## Баннеры (SwiftUI)
### Inline
Для показа этого типа баннера в своем приложении добавьте в `body` экземпляр ``GAInlineView``.

При создания экземпляра ``GAInlineView`` необходимо указать его конфигурацию ``GAInlineBannerInputModel``, а также при необходимости его размер через ``GASize``. Поддерживаются средующие форматы: адаптиванный (ширина по `superview`, высота - 250) и фиксированный 300x250.

Отслеживать события типа `Error` баннера можно через передачу замыкания при его инициализации:

```swift
GAInlineView(
    inputModel: inputModel,
    size: size
) { error in
    ...
}
```

### Sticky

Для показа этого типа баннера в своем приложении добавьте в `body` экземпляр ``GAStickyView``.

При создания экземпляра ``GAStickyView`` необходимо указать его конфигурацию ``GAStickyBannerInputModel`` (``GAStickyBannerInputModel/blockId`` и ``GAStickyBannerInputModel/padId``), а также при необходимости его размер через ``GASize``. Поддерживаются средующие форматы: адаптиванный (ширина по `superview`, высота - 50) и фиксированный 320x50.

Отслеживать события типа `Error` баннера можно через передачу замыкания при его инициализации:

```swift
GAStickyView(
    inputModel: inputModel,
    size: size
) { error in
    ...
}
```

### Interstitial

Для показа этого типа баннера в своем приложении, внутри `body` вызовите один из методов `View`, реализованных в рамках SDK.

Первый метод показывает полноэкранный баннер только после загрузки, для осуществления которой в параметры метода передается экземпляр загрузочного конфигурационного файла ``GAAdRequestConfiguration`` (по аналогии с UIKit).

Второй метод не осуществляет загрузку, так как в качестве одного из параметров принимает предгазруженную заранее (при помощи ``GAInterstitialAdLoader``) модель рекламного объявления в виде экземпляра ``GAInterstitialAd``. 

Отслеживать события типа ``GAInterstitialCoverEvent`` баннера можно через передачу замыкания при его инициализации:

```
@State private var isPresented: Bool = false

var body: some View {
    ContentView()
        .gaInterstitialCover(isPresented: $isPresented, ad: ad) { event in 
            ...
        }
}
```
