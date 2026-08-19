# BipCaseStudy

Teknik mulakat case study'si olarak gelistirilmis, messaging tarzinda urun katalog iOS uygulamasi. Clean Architecture prensipleri, offline-first veri stratejisi, moduler network katmani ve custom design system icermektedir. Ucuncu parti kutuphane kullanilmamistir.

## Ozellikler

- Grid layout ile urun listeleme ve pull-to-refresh
- Hero image ile urun detay sayfasi
- Core Data ile offline destek ve otomatik fallback
- Custom 2 katmanli image cache (NSCache + FileManager, TTL expiration)
- Coklu ortam konfigurasyonu (Debug, Development, Release)
- Lokalizasyona hazir altyapi

## Teknoloji

| Kategori | Teknoloji |
|----------|-----------|
| UI Framework | SwiftUI + UIKit bridge |
| Mimari | MVVM + Clean Architecture |
| Network | Custom `NetworkKit` SPM Package |
| Persistence | Core Data |
| Image Cache | NSCache + FileManager (2 katman) |
| Concurrency | Swift async/await |
| Dependency Management | Service Locator + Constructor Injection |
| Proje Uretimi | XcodeGen |
| Min. Deployment | iOS 16.0 |

## Proje Yapisi

```
BipCaseStudy/
├── Application/
│   ├── App/                          # AppDelegate, Configuration
│   ├── Data/
│   │   ├── Domain/
│   │   │   ├── Entities/             # Product, ProductDetail
│   │   │   ├── Repository/           # ProductRepository, DataSourceProtocol
│   │   │   └── UseCase/              # ProductUseCase
│   │   ├── Local/
│   │   │   ├── Cache/                # ImageCacheManager
│   │   │   ├── CoreData/             # CoreDataStack, CachableEntity
│   │   │   └── DataSource/           # ProductLocalDataSource, CDProduct
│   │   └── Remote/                   # ProductRemoteDataSource
│   └── Presentation/
│       ├── Scene/
│       │   ├── Splash/               # SplashPage, SplashViewModel
│       │   └── Product/              # List, Detail, ProductFactory
│       └── Shared/
│           ├── Base/                  # BaseViewModel, AppRouter, Alert System
│           └── Components/            # Text, Button, Image, NavigationBar
├── Configuration/                     # Debug/Dev/Release plist files
├── Resource/                          # Assets, Localizable.strings
└── Packages/
    └── NetworkKit/                    # Local SPM Package
        ├── Core/                      # NetworkClient, Endpoint, Config
        ├── Builder/                   # RequestBuilder
        ├── Handler/                   # ResponseHandler
        ├── Interceptor/               # RequestInterceptor (Chain of Responsibility)
        ├── Error/                     # Tiered error system
        ├── Session/                   # URLSession abstraction
        └── Manager/                   # HeaderManager
```

## Mimari ve Tasarim Kaliplari

### Clean Architecture Katmanlari

Proje, bagimliliklarin iceri dogru aktigi katmanli bir mimari izler:

```
┌─────────────────────────────────────────┐
│          Presentation Katmani           │
│     (Views, ViewModels, Components)     │
├─────────────────────────────────────────┤
│            Domain Katmani               │
│   (UseCases, Repository Protokolleri,   │
│          Entity Modelleri)              │
├─────────────────────────────────────────┤
│             Data Katmani                │
│  (Repository Impl, Remote/Local         │
│   DataSources, Core Data, Cache)        │
├─────────────────────────────────────────┤
│        Infrastructure Katmani           │
│       (NetworkKit SPM Package)          │
└─────────────────────────────────────────┘
```

### MVVM (Model-View-ViewModel)

ViewModel'ler `BaseViewModel`'den miras alir. `BaseViewModel`, tekrar kullanilabilir template method'lar sunar: `performTask`, `handleResult`, `handleError`. View'lar `@Published` property'leri ve `@ObservedObject` binding'leri uzerinden state'i observe eder.

```swift
// BaseViewModel template method'lari saglar
func performTask(showLoading: Bool = true, _ task: () async throws -> Void) async
func handleResult<T>(_ result: Result<T, NetworkError>, onSuccess:, onRetry:)

// Concrete ViewModel sadece kendi logic'ini implement eder
func loadProducts() async {
    await performTask(showLoading: products.isEmpty) { [weak self] in
        guard let self else { return }
        let result = await useCase.fetchProducts()
        handleResult(result, onSuccess: { self.products = $0 }, ...)
    }
}
```

### Protocol-Oriented Design

Her katman siniri bir protocol ile tanimlanir. Bu yaklasim, mock injection ile testability saglar ve Dependency Inversion prensibini uygular.

```
ProductDataSourceProtocol
    ├── ProductRemoteDataSource  (API'den veri ceker)
    └── ProductLocalDataSource   (Core Data'dan veri ceker)

ProductRepositoryProtocol
    └── ProductRepository        (remote + local orkestrasyon)

ProductUseCaseProtocol
    └── ProductUseCase           (business logic boundary)

NetworkClientProtocol
    └── NetworkClient            (HTTP islemleri)

NetworkSessionProtocol
    └── URLSessionAdapter        (URLSession wrapper)
```

Ayni `ProductDataSourceProtocol` interface'i hem remote hem local data source tarafindan implement edilir. Bu sayede repository, verinin nereden geldigine karsi agnostik kalir.

### Strategy Pattern

Birden fazla component, protocol conformance uzerinden behavior'i degistirmek icin Strategy pattern kullanir:

**Text Styling** — `TextStyleProvider` protocol ve concrete provider'lar:
```swift
protocol TextStyleProvider {
    var font: Font { get }
    var color: Color { get }
}

// Concrete strategies
struct LargeTitleProvider: TextStyleProvider { ... }
struct HeadlineProvider: TextStyleProvider { ... }
struct CaptionProvider: TextStyleProvider { ... }
struct PriceProvider: TextStyleProvider { ... }

// Kullanim: StyledText(provider: HeadlineProvider(), text: "Baslik")
```

**Parameter Encoding** — `ParameterEncoding` protocol:
```swift
protocol ParameterEncoding {
    func encode(_ parameters: [String: Any]) throws -> Data?
}

struct JSONEncoding: ParameterEncoding { ... }   // Request body
struct URLEncoding: ParameterEncoding { ... }    // Query string
```

**Button Variants** — `ButtonProviding` protocol:
```swift
protocol ButtonProviding {
    func createButton(config: BipButtonConfig) -> some View
}

struct BipPrimaryButtonProvider: ButtonProviding { ... }
struct BipSecondaryButtonProvider: ButtonProviding { ... }
struct BipOutlineButtonProvider: ButtonProviding { ... }
```

**Alert Provider'lar** — `BipAlertProviderProtocol`:
```swift
protocol BipAlertProviderProtocol {
    func createAlert() -> BipAlertModel
}

class BipErrorAlertProvider: BipBaseAlertProvider { ... }
class BipInfoAlertProvider: BipBaseAlertProvider { ... }
class BipSuccessAlertProvider: BipBaseAlertProvider { ... }
```

**Price Formatting** — `PriceFormatterProtocol`:
```swift
protocol PriceFormatterProtocol {
    func format(_ price: Double) -> String
}

struct DollarPriceFormatter: PriceFormatterProtocol { ... }
```

### Repository Pattern

`ProductRepository`, online ve offline senaryolari transparent sekilde yoneten unified bir data access interface sunar:

```
Online Akis:
  fetchProducts() → Remote API → Core Data'ya kaydet → Dondur

Online Akis (basarisiz):
  fetchProducts() → Remote basarisiz → Local'a fallback → Dondur

Offline Akis:
  fetchProducts() → Local Core Data → Dondur

Detay Cache-First:
  fetchProductDetail() → Local cache kontrol
    → Description var mi? → Cache'den dondur
    → Description yok mu? → Remote'dan cek → Kaydet → Dondur
```

### Factory Pattern

`ProductFactory`, tum dependency injection chain'ini merkezlestirir:

```
ProductFactory
  └── makeProductListVM()
        NetworkClient ─┐
        CoreDataStack ──┼─→ RemoteDataSource ─┐
        NetworkMonitor ─┘   LocalDataSource  ──┼─→ Repository → UseCase → ViewModel
                                               │
                                               └── NetworkMonitor
```

### Chain of Responsibility

NetworkKit'teki `RequestInterceptor` pipeline'i her request'i sirasiyla interceptor chain'den gecirir:

```swift
protocol RequestInterceptorProtocol {
    func intercept(_ request: URLRequest) async throws -> URLRequest
}

// Pipeline: Endpoint → RequestBuilder → [Interceptor₁ → Interceptor₂ → ...] → URLSession
for interceptor in interceptors {
    request = try await interceptor.intercept(request)
}
```

### Adapter Pattern

`AppRouter`, UIKit navigation ile SwiftUI view'lari `UIHostingController` kullanarak bridge eder:

```swift
func push<Content: View>(_ view: Content) {
    let hostingController = UIHostingController(rootView:
        AnyView(view.environmentObject(self))
    )
    navigationController.pushViewController(hostingController, animated: true)
}
```

### Service Locator + @Inject Property Wrapper

`ServiceLocator`, shared dependency'leri yonetir. Custom `@Inject` property wrapper ile declarative resolution saglanir:

```swift
// Kayit (AppDelegate icinde)
ServiceLocator.shared.register(CoreDataStack() as CoreDataStack)

// Property wrapper ile cozumleme
@Inject var coreDataStack: CoreDataStack
```

### Observer Pattern

Combine'in `@Published` ozelligi ile reactive state management:

```swift
// ViewModel state publish eder
@Published var pageState: PageState = .loading
@Published var products: [Product] = []

// View observe eder
BipPageView(viewModel: viewModel) {
    // pageState == .content oldugunda icerik renderlanir
}
```

`NetworkMonitor`, `NWPathMonitor` kullanarak connectivity durumunu `@Published` property ile publish eder.

## Mimari Kararlar ve Notlar

### Neden MVVM + Clean Architecture?
- **MVVM**, SwiftUI'nin `@Published` / `@ObservedObject` yapisina dogal olarak uyum saglar. ViewModel state'i publish eder, View observe eder — ekstra binding katmani gerekmez.
- **Clean Architecture** katmanlari (Data / Domain / Presentation) sayesinde network katmani degisse bile ViewModel'ler etkilenmez. UseCase katmani business logic'i izole eder.

### Neden UIKit + SwiftUI Hybrid?
- SwiftUI henuz tam `NavigationStack` kontrolu ve custom transition desteği sunmadigi icin, navigation yonetimi `UINavigationController` uzerinden yapildi.
- `AppRouter`, `UIHostingController` ile SwiftUI view'lari UIKit navigation stack'ine adapter eder. Bu sayede push/pop/present/dismiss tam kontrol altinda.
- Alert sistemi `UIPresentationController` ile custom dimming + animation saglar — SwiftUI'nin `.alert` modifier'i bu esnekligi sunmaz.

### Neden Local SPM Package (NetworkKit)?
- Network katmani ayri bir Swift Package olarak tasarlandi. Bu sayede **reusability** saglanir: baska bir projede ayni package kullanilabilir.
- Main app ile NetworkKit arasinda **compile-time boundary** olusur, katman ihlalleri derleme hatasina donusur.
- NetworkKit'in kendi test target'i vardir, bagimsiz test edilebilir.

### Neden 3rd Party Kutuphane Yok?
- Case study gereksinimleri geregi harici dependency kullanilmadi.
- Image cache (Kingfisher yerine), network layer (Alamofire yerine) ve DI (Swinject yerine) custom implement edildi.
- Bu yaklasim, underlying mekanizmalarin (NSCache, URLSession, FileManager) derinlemesine anlasildigini gosterir.

### SwiftUI Ozel Yapilar

| Yapi | Kullanim | Aciklama |
|------|----------|----------|
| `@Published` | ViewModel state | Combine-backed reactive property, View otomatik re-render eder |
| `@ObservedObject` | View ↔ ViewModel | ViewModel'in `ObservableObject` conformance'i ile binding |
| `@EnvironmentObject` | AppRouter | View hierarchy boyunca router erisimi, prop drilling yerine |
| `@ViewBuilder` | BasePageView | Conditional view composition, generic content closure |
| `.task(id:)` | BipImageView | View lifecycle'a bagli async is baslatma, id degisince cancel + restart |
| `.refreshable` | ProductListPage | Pull-to-refresh, `showLoading: false` ile loading state gosterilmez |
| `LazyVGrid` | ProductListPage | Memory-efficient grid layout, sadece gorunen cell'ler renderlanir |
| `AnyView` | AppRouter | Type-erased view, UIHostingController icin gerekli |

### Concurrency Yaklasimlari

| Yaklasim | Nerede | Neden |
|----------|--------|-------|
| `@MainActor` | BaseViewModel, AppRouter, BipAlertManager | UI state mutasyonlarinin main thread'de gerceklesmesi garanti edilir |
| `async/await` | Tum data flow | Callback hell yerine lineer, okunabilir asenkron kod |
| `[weak self]` in `Task` | ViewModel closure'lari | Retain cycle onleme — ViewModel dismiss edildiginde task leak olmaz |
| `NSLock` | ImageCacheManager | `activeTasks` dictionary'ye concurrent erisimde thread safety |
| `Task<UIImage?, Never>` | ImageCacheManager | Task coalescing — ayni URL icin tek download, sonuc paylasimi |
| `nonisolated` | NetworkLogger | Actor isolation'dan opt-out, `#if DEBUG` icinde serbest erisim |
| `@unchecked Sendable` | NetworkClient, Endpoint | Sendable conformance, internal thread safety garanti edildigi icin |

### Kullanilan Design Pattern'ler Ozet

| Pattern | Uygulama | Dosya |
|---------|----------|-------|
| **MVVM** | BaseViewModel → ProductListVM / ProductDetailVM | `BaseViewModel.swift`, `ProductListVM.swift` |
| **Repository** | Online/offline transparent data access | `ProductRepository.swift` |
| **Strategy** | TextStyleProvider, ParameterEncoding, ButtonProviding, AlertProvider, PriceFormatter | `TextStyleProvider.swift`, `ParameterEncoding.swift` |
| **Factory** | ProductFactory DI chain | `ProductFactory.swift` |
| **Template Method** | BaseViewModel.performTask / handleResult | `BaseViewModel.swift` |
| **Adapter** | UIHostingController SwiftUI-UIKit bridge | `AppRouter.swift` |
| **Chain of Responsibility** | RequestInterceptor pipeline | `RequestInterceptor.swift` |
| **Observer** | @Published + Combine | `BaseViewModel.swift`, `NetworkMonitor.swift` |
| **Service Locator** | ServiceLocator.shared + @Inject | `ServiceLocator.swift` |
| **Singleton** | AppRouter.shared, ServiceLocator.shared | `AppRouter.swift`, `ServiceLocator.swift` |
| **Protocol-Oriented Design** | Her katman sinirinda protocol-first yaklasim | 30+ protocol |
| **Composition over Inheritance** | BasePageView → BipPageView (composition) | `BipPageView.swift` |

### SOLID Prensipleri

| Prensip | Projeden Ornek |
|---------|---------------|
| **Single Responsibility** | `RequestBuilder` sadece request olusturur, `ResponseHandler` sadece response parse eder, `NetworkClient` sadece orkestrasyon yapar |
| **Open/Closed** | Yeni bir `TextStyleProvider` eklemek icin mevcut kodu degistirmeye gerek yok — yeni struct olusturup protocol'u implement etmek yeterli |
| **Liskov Substitution** | `ProductRemoteDataSource` ve `ProductLocalDataSource` ayni `ProductDataSourceProtocol`'u implement eder, repository hangisini kullandigini bilmez |
| **Interface Segregation** | `AppRouterProtocol` uc ayri protocol'e ayrilmistir: `NavigationHandling`, `PresentationHandling`, `RootHandling` |
| **Dependency Inversion** | ViewModel, concrete `ProductRepository` yerine `ProductUseCaseProtocol`'a bagimlidir. High-level module, low-level module'e degil abstraction'a bagimlidir |

## Offline Stratejisi

Uygulama offline-first yaklasim uygular:

1. **Online basari** → Veri API'den cekilir, Core Data'ya kaydedilir, sonra dondurulur
2. **Online basarisizlik** → Core Data'daki yerel cache'e otomatik fallback
3. **Offline** → Network denemeden dogrudan Core Data'dan servis edilir
4. **Detay cache-first** → API cagrisindan once yerel cache kontrol edilir; sadece cache'deki kayit eksik detay iceriyorsa (description yoksa) remote'dan cekilir

## Image Cache Sistemi

Ucuncu parti kutuphane kullanmadan custom 2 katmanli image cache:

```
Request → Memory Cache (NSCache)
            ├── HIT  → UIImage dondur
            └── MISS → Disk Cache (FileManager)
                         ├── HIT  → Yukle, memory'ye kaydet, dondur
                         └── MISS → Network'den indir
                                     → Memory + disk'e kaydet
                                     → UIImage dondur
```

- **Task coalescing**: Ayni URL icin es zamanli istekler tek bir download task'i paylasir (NSLock + dictionary)
- **TTL expiration**: Disk cache kayitlari yapilandiriabilir sure sonunda sona erer, baslatmada temizleme yapilir
- **Cache key**: CryptoKit ile URL string'inin SHA1 hash'i

## Test

**70 unit test**, iki hedef uzerinde:

| Hedef | Test Sayisi | Kapsam |
|-------|-------------|--------|
| BipCaseStudyTests | 53 | Repository (online/offline akislar), DataSources, UseCase, ViewModels, CoreData, ImageCache, PriceFormatter, ServiceLocator, NetworkMonitor |
| NetworkKitTests | 17 | NetworkClient, RequestBuilder, ResponseHandler |

Tum testler, harici test framework'u kullanmadan protokol tabanli mock injection ile calisir.

## Kurulum ve Calistirma

```bash
# Xcode projesini olustur (XcodeGen gerektirir)
xcodegen generate

# Xcode'da ac
open BipCaseStudy.xcodeproj

# Testleri calistir
xcodebuild test -scheme BipCaseStudy-Debug \
  -destination 'platform=iOS Simulator,name=iPhone 16'
```

## Gereksinimler

- Xcode 15.0+
- iOS 16.0+
- Swift 5.9+
