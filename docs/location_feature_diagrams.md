# Location Feature - Architecture Diagrams

## 1. Feature Layer Structure

```mermaid
graph TB
    subgraph Presentation Layer
        UI[UI Pages]
        BLoC[BLoC/Cubit]
        Widgets[Reusable Widgets]
    end
    
    subgraph Domain Layer
        Entities[Entities]
        UseCases[Use Cases]
        RepoInterface[Repository Interface]
    end
    
    subgraph Data Layer
        Models[Models]
        RepoImpl[Repository Implementation]
        LocalDS[Local DataSource]
        RemoteDS[Remote DataSource]
    end
    
    subgraph External
        Hive[(Hive DB)]
        API[REST API]
        Maps[Google Maps]
        Location[Geolocator]
    end
    
    UI --> BLoC
    BLoC --> UseCases
    UseCases --> RepoInterface
    RepoInterface --> RepoImpl
    RepoImpl --> LocalDS
    RepoImpl --> RemoteDS
    LocalDS --> Hive
    RemoteDS --> API
    UI --> Maps
    UseCases --> Location
```

## 2. Add Address Flow

```mermaid
sequenceDiagram
    participant User
    participant UI
    participant MapCubit
    participant AddressBloc
    participant UseCase
    participant Repository
    participant LocalDS
    participant RemoteDS
    participant API
    
    User->>UI: Tap "Add Address"
    UI->>MapCubit: Open Map
    MapCubit->>MapCubit: Get Current Location
    MapCubit-->>UI: Show Map with Pin
    
    User->>UI: Drag/Search Location
    UI->>MapCubit: Update Location
    MapCubit-->>UI: Update Pin & Address
    
    User->>UI: Confirm Location
    UI->>UI: Show Address Form
    User->>UI: Fill Details & Save
    
    UI->>AddressBloc: AddAddressEvent
    AddressBloc->>UseCase: Execute
    UseCase->>Repository: addAddress()
    
    Repository->>LocalDS: Save Locally (Optimistic)
    LocalDS-->>Repository: Success
    
    alt Online
        Repository->>RemoteDS: Sync to API
        RemoteDS->>API: POST /addresses
        API-->>RemoteDS: Address with ID
        RemoteDS-->>Repository: Success
        Repository->>LocalDS: Update with Server ID
    else Offline
        Repository-->>UseCase: Return Local Version
    end
    
    UseCase-->>AddressBloc: Success
    AddressBloc-->>UI: AddressOperationSuccess
    UI-->>User: Show Success Message
```

## 3. Load Addresses Flow

```mermaid
sequenceDiagram
    participant User
    participant UI
    participant AddressBloc
    participant UseCase
    participant Repository
    participant NetworkInfo
    participant RemoteDS
    participant LocalDS
    participant API
    participant Hive
    
    User->>UI: Open Address List
    UI->>AddressBloc: LoadAddresses
    AddressBloc->>UseCase: Execute
    UseCase->>Repository: getAddresses()
    
    Repository->>NetworkInfo: Check Connection
    
    alt Online
        NetworkInfo-->>Repository: Connected
        Repository->>RemoteDS: Fetch from API
        RemoteDS->>API: GET /addresses
        API-->>RemoteDS: Address List
        RemoteDS-->>Repository: Addresses
        Repository->>LocalDS: Cache Addresses
        LocalDS->>Hive: Store
        Repository-->>UseCase: Fresh Data
    else Offline
        NetworkInfo-->>Repository: No Connection
        Repository->>LocalDS: Get Cached
        LocalDS->>Hive: Retrieve
        Hive-->>LocalDS: Cached Addresses
        LocalDS-->>Repository: Cached Data
        Repository-->>UseCase: Cached Data
    end
    
    UseCase-->>AddressBloc: Addresses
    AddressBloc-->>UI: AddressesLoaded
    UI-->>User: Display List
```

## 4. Map Interaction Flow

```mermaid
stateDiagram-v2
    [*] --> MapInitial
    MapInitial --> MapLoading: Request Location
    MapLoading --> MapLocationSelected: Location Found
    MapLoading --> MapError: Permission Denied
    
    MapLocationSelected --> MapLoading: Search Places
    MapLoading --> MapSearchResults: Results Found
    MapSearchResults --> MapLocationSelected: Select Place
    
    MapLocationSelected --> MapLoading: Drag Map
    MapLoading --> MapLocationSelected: New Location
    
    MapLocationSelected --> [*]: Confirm Location
    MapError --> MapInitial: Retry
```

## 5. Data Sync Strategy

```mermaid
graph LR
    subgraph User Action
        A[Add/Update/Delete]
    end
    
    subgraph Local First
        B[Save to Hive]
        C[Update UI]
    end
    
    subgraph Background Sync
        D{Network?}
        E[Queue for Sync]
        F[Sync to API]
        G[Update Local with Server Response]
    end
    
    A --> B
    B --> C
    B --> D
    D -->|Online| F
    D -->|Offline| E
    F --> G
    E -.->|When Online| F
```

## 6. BLoC State Management

```mermaid
stateDiagram-v2
    [*] --> AddressInitial
    AddressInitial --> AddressLoading: LoadAddresses
    AddressLoading --> AddressesLoaded: Success
    AddressLoading --> AddressError: Failure
    
    AddressesLoaded --> AddressLoading: AddAddress
    AddressesLoaded --> AddressLoading: UpdateAddress
    AddressesLoaded --> AddressLoading: DeleteAddress
    AddressesLoaded --> AddressLoading: SetDefault
    
    AddressLoading --> AddressOperationSuccess: Success
    AddressLoading --> AddressError: Failure
    
    AddressOperationSuccess --> AddressLoading: Reload
    AddressError --> AddressesLoaded: Retry
```

## 7. Component Dependencies

```mermaid
graph TB
    subgraph UI Components
        AddressList[AddressListPage]
        AddAddress[AddAddressPage]
        MapPicker[MapPickerPage]
        AddressCard[AddressCard Widget]
        MapWidget[MapWidget]
        SearchBar[LocationSearchBar]
    end
    
    subgraph State Management
        AddressBloc[AddressBloc]
        MapCubit[MapCubit]
    end
    
    subgraph Business Logic
        GetAddresses[GetAddresses UseCase]
        AddAddressUC[AddAddress UseCase]
        SearchPlaces[SearchPlaces UseCase]
        GetLocation[GetCurrentLocation UseCase]
    end
    
    AddressList --> AddressBloc
    AddressList --> AddressCard
    AddAddress --> AddressBloc
    AddAddress --> MapPicker
    MapPicker --> MapCubit
    MapPicker --> MapWidget
    MapPicker --> SearchBar
    
    AddressBloc --> GetAddresses
    AddressBloc --> AddAddressUC
    MapCubit --> SearchPlaces
    MapCubit --> GetLocation
```

## 8. Error Handling Flow

```mermaid
graph TD
    A[User Action] --> B{Try Operation}
    B -->|Success| C[Update State]
    B -->|Network Error| D{Has Cache?}
    B -->|Permission Error| E[Request Permission]
    B -->|Validation Error| F[Show Form Error]
    B -->|API Error| G[Show Error Dialog]
    
    D -->|Yes| H[Use Cached Data]
    D -->|No| I[Show Empty State]
    
    E -->|Granted| B
    E -->|Denied| J[Show Manual Entry]
    
    F --> K[User Corrects]
    K --> B
    
    G --> L{Retry?}
    L -->|Yes| B
    L -->|No| M[Cancel]
    
    H --> N[Show Offline Banner]
    C --> O[Success Feedback]
```

## 9. Database Schema

```mermaid
erDiagram
    ADDRESS {
        string id PK
        string userId FK
        int type
        string customLabel
        double latitude
        double longitude
        string formattedAddress
        string addressLine1
        string addressLine2
        string landmark
        string instructions
        bool isDefault
        datetime createdAt
        datetime updatedAt
    }
    
    USER {
        string id PK
        string name
        string phone
    }
    
    USER ||--o{ ADDRESS : has
```

## 10. API Integration

```mermaid
sequenceDiagram
    participant App
    participant ApiClient
    participant Interceptor
    participant Server
    
    App->>ApiClient: Request with Data
    ApiClient->>Interceptor: Add Auth Token
    Interceptor->>Server: HTTP Request
    
    alt Success Response
        Server-->>Interceptor: 200 OK
        Interceptor-->>ApiClient: Response Data
        ApiClient-->>App: Success Result
    else Auth Error
        Server-->>Interceptor: 401 Unauthorized
        Interceptor->>Server: Refresh Token
        Server-->>Interceptor: New Token
        Interceptor->>Server: Retry Request
        Server-->>Interceptor: 200 OK
        Interceptor-->>ApiClient: Response Data
        ApiClient-->>App: Success Result
    else Server Error
        Server-->>Interceptor: 500 Error
        Interceptor-->>ApiClient: Error
        ApiClient-->>App: Failure Result
    end
```

## 11. Permission Flow

```mermaid
graph TD
    A[Request Location] --> B{Permission Status}
    B -->|Granted| C[Get Location]
    B -->|Denied| D[Show Rationale]
    B -->|Permanently Denied| E[Show Settings Dialog]
    
    D --> F{User Accepts?}
    F -->|Yes| G[Request Again]
    F -->|No| H[Manual Entry]
    
    G --> B
    E --> I{Open Settings?}
    I -->|Yes| J[Open App Settings]
    I -->|No| H
    
    C --> K[Show on Map]
```

## 12. Offline Sync Queue

```mermaid
graph LR
    A[User Action] --> B[Save Locally]
    B --> C{Online?}
    C -->|Yes| D[Sync Immediately]
    C -->|No| E[Add to Queue]
    
    E --> F[Monitor Network]
    F -->|Connected| G[Process Queue]
    G --> H[Sync Items]
    H --> I{Success?}
    I -->|Yes| J[Remove from Queue]
    I -->|No| K[Retry Later]
    
    D --> L[Update Local]
    J --> L
```

---

## Key Design Decisions

### 1. Offline-First Architecture
- **Why**: Ensures app works without internet
- **How**: Save to local DB first, sync in background
- **Benefit**: Better UX, faster response times

### 2. BLoC Pattern
- **Why**: Separates business logic from UI
- **How**: Events trigger use cases, states update UI
- **Benefit**: Testable, maintainable, reactive

### 3. Clean Architecture
- **Why**: Separation of concerns, testability
- **How**: Domain → Data → Presentation layers
- **Benefit**: Easy to modify, scale, and test

### 4. Hive for Local Storage
- **Why**: Fast, lightweight, type-safe
- **How**: Store addresses with adapters
- **Benefit**: Better than SQLite for this use case

### 5. Repository Pattern
- **Why**: Abstract data sources
- **How**: Single interface, multiple implementations
- **Benefit**: Easy to swap data sources, mock for testing

---

## Performance Optimizations

1. **Lazy Loading**: Load map only when needed
2. **Debouncing**: Search queries debounced by 300ms
3. **Caching**: Cache map tiles and geocoding results
4. **Pagination**: Load addresses in batches if many
5. **Optimistic Updates**: Update UI before API response
6. **Background Sync**: Sync in background when online

---

## Security Measures

1. **API Key Protection**: Store in environment variables
2. **Token Management**: Refresh tokens automatically
3. **Input Validation**: Validate all user inputs
4. **Encrypted Storage**: Encrypt sensitive data in Hive
5. **Permission Handling**: Request minimal permissions
6. **Rate Limiting**: Prevent API abuse

---

These diagrams provide a comprehensive visual guide to understanding the location feature architecture and its implementation details.