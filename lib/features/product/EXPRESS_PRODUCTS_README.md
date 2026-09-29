# Express Products Feature

## Overview
This feature allows fetching products based on the nearest fulfillment center using the user's location (latitude and longitude from their address).

## API Endpoint
```
POST /express-30/products
```

### Request Parameters
- `category_id` (required): Category ID to filter products
- `latitude` (required): User's latitude from address (8 decimal places)
- `longitude` (required): User's longitude from address (8 decimal places)

### Example Request
```bash
curl --location 'https://taksh-admin.takshallinone.in/api/express-30/products' \
--form 'category_id="2"' \
--form 'latitude="23.02250000"' \
--form 'longitude="72.57140000"'
```

### Response Structure
```json
{
  "success": true,
  "message": "express.products_loaded",
  "data": {
    "fulfillment_center": {
      "id": 1,
      "name": "Ahmedabad Fulfillment Center"
    },
    "products": [],
    "pagination": {
      "current_page": 1,
      "per_page": 30,
      "total": 0,
      "last_page": 1,
      "from": null,
      "to": null
    }
  }
}
```

## Architecture

### Domain Layer

#### Entities
1. **FulfillmentCenter** (`lib/features/product/domain/entities/fulfillment_center.dart`)
   - Represents a fulfillment center
   - Properties: `id`, `name`

2. **ExpressProductsResponse** (`lib/features/product/domain/entities/express_products_response.dart`)
   - Represents the complete response from the API
   - Properties:
     - `fulfillmentCenter`: The nearest fulfillment center
     - `products`: List of products
     - `currentPage`, `perPage`, `total`, `lastPage`: Pagination info
     - `from`, `to`: Range indicators
   - Helper methods:
     - `hasMorePages`: Check if more pages are available
     - `isEmpty`/`isNotEmpty`: Check product list status

#### Use Case
**GetExpressProducts** (`lib/features/product/domain/usecases/get_express_products.dart`)
- Fetches express products based on location
- Parameters:
  - `categoryId` (required)
  - `latitude` (required)
  - `longitude` (required)
  - `page` (default: 1)
  - `limit` (default: 30)

#### Repository Interface
**ProductRepository** (`lib/features/product/domain/repositories/product_repository.dart`)
- Added method: `getExpressProducts()`

### Data Layer

#### Models
1. **FulfillmentCenterModel** (`lib/features/product/data/models/fulfillment_center_model.dart`)
   - JSON serializable model for FulfillmentCenter
   - Auto-generated with `build_runner`

2. **ExpressProductsResponseModel** (`lib/features/product/data/models/express_products_response_model.dart`)
   - JSON serializable model for ExpressProductsResponse
   - Includes nested `PaginationData` model
   - Auto-generated with `build_runner`

#### Data Source
**ProductRemoteDataSource** (`lib/features/product/data/datasources/product_remote_datasource.dart`)
- Added method: `getExpressProducts()`
- Sends POST request with form data
- Returns `ExpressProductsResponseModel`

#### Repository Implementation
**ProductRepositoryImpl** (`lib/features/product/data/repositories/product_repository_impl.dart`)
- Implements `getExpressProducts()` method
- Handles network connectivity check
- Error handling for various exception types

## Usage

### Basic Usage
```dart
// Inject the use case
final getExpressProducts = GetExpressProducts(productRepository);

// Get location from address
final address = selectedAddress;
final latitude = address.location.latitude;
final longitude = address.location.longitude;

// Create parameters
final params = GetExpressProductsParams(
  categoryId: 2,
  latitude: latitude,
  longitude: longitude,
);

// Execute use case
final result = await getExpressProducts(params);

// Handle result
result.fold(
  (failure) => print('Error: ${failure.message}'),
  (response) {
    print('Fulfillment Center: ${response.fulfillmentCenter.name}');
    print('Products: ${response.products.length}');
  },
);
```

### With Pagination
```dart
final params = GetExpressProductsParams(
  categoryId: 2,
  latitude: 23.02250000,
  longitude: 72.57140000,
  page: 1,
  limit: 30,
);

final result = await getExpressProducts(params);

result.fold(
  (failure) => handleError(failure),
  (response) {
    displayProducts(response.products);
    
    if (response.hasMorePages) {
      // Load next page
      loadNextPage(response.currentPage + 1);
    }
  },
);
```

### Integration with Address Selection
```dart
// Listen to address changes
addressBloc.stream.listen((state) {
  if (state is AddressSelected) {
    final params = GetExpressProductsParams(
      categoryId: selectedCategoryId,
      latitude: state.address.location.latitude,
      longitude: state.address.location.longitude,
    );
    
    productBloc.add(LoadExpressProducts(params));
  }
});
```

## Files Created/Modified

### Created Files
1. `lib/features/product/domain/entities/fulfillment_center.dart`
2. `lib/features/product/domain/entities/express_products_response.dart`
3. `lib/features/product/data/models/fulfillment_center_model.dart`
4. `lib/features/product/data/models/fulfillment_center_model.g.dart` (generated)
5. `lib/features/product/data/models/express_products_response_model.dart`
6. `lib/features/product/data/models/express_products_response_model.g.dart` (generated)
7. `lib/features/product/domain/usecases/get_express_products.dart`
8. `lib/features/product/domain/usecases/get_express_products_usage_example.dart`
9. `lib/features/product/EXPRESS_PRODUCTS_README.md`

### Modified Files
1. `lib/features/product/domain/repositories/product_repository.dart`
2. `lib/features/product/data/repositories/product_repository_impl.dart`
3. `lib/features/product/data/datasources/product_remote_datasource.dart`
4. `lib/core/constants/api_constants.dart`

## Key Features

1. **Location-Based**: Products are fetched based on the nearest fulfillment center
2. **Address Integration**: Latitude and longitude come from the user's selected address
3. **Pagination Support**: Built-in pagination with configurable page size
4. **Fulfillment Center Info**: Response includes which fulfillment center is serving the request
5. **Clean Architecture**: Follows the existing project structure
6. **Error Handling**: Comprehensive error handling for network and server issues
7. **Type Safety**: Strongly typed with Dart entities and models

## Important Notes

1. The latitude and longitude must come from the user's address entity
2. The API determines the nearest fulfillment center automatically
3. An empty product list is a valid response (no products in that area)
4. Default pagination is 30 items per page
5. Form data is sent as POST request (not query parameters)
6. Coordinates are formatted to 8 decimal places for precision

## Next Steps

To use this feature in your app:

1. **Dependency Injection**: Register the use case in your DI container
2. **Bloc/Cubit**: Create events/methods to trigger the use case
3. **UI**: Display products with fulfillment center information
4. **Address Integration**: Connect with address selection flow
5. **Pagination**: Implement infinite scroll or load more functionality
6. **Error Handling**: Show appropriate error messages to users
7. **Loading States**: Add loading indicators during API calls

## Example Integration in Bloc

```dart
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetExpressProducts getExpressProducts;
  
  ProductBloc({required this.getExpressProducts}) : super(ProductInitial()) {
    on<LoadExpressProducts>(_onLoadExpressProducts);
  }
  
  Future<void> _onLoadExpressProducts(
    LoadExpressProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    
    final result = await getExpressProducts(event.params);
    
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (response) => emit(ExpressProductsLoaded(
        fulfillmentCenter: response.fulfillmentCenter,
        products: response.products,
        currentPage: response.currentPage,
        hasMorePages: response.hasMorePages,
      )),
    );
  }
}
```
