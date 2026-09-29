// Example usage of GetExpressProducts use case
//
// This use case fetches products based on the nearest fulfillment center
// using the provided latitude and longitude from the user's address.
//
// API Endpoint: POST /express-30/products
//
// Request Parameters:
// - category_id: The category ID to filter products
// - latitude: User's latitude from address
// - longitude: User's longitude from address
//
// Response Structure:
// {
//   "success": true,
//   "message": "express.products_loaded",
//   "data": {
//     "fulfillment_center": {
//       "id": 1,
//       "name": "Ahmedabad Fulfillment Center"
//     },
//     "products": [...],
//     "pagination": {
//       "current_page": 1,
//       "per_page": 30,
//       "total": 0,
//       "last_page": 1,
//       "from": null,
//       "to": null
//     }
//   }
// }

// Example 1: Basic usage with address location
void exampleBasicUsage() async {
  // Assuming you have the use case injected
  // final getExpressProducts = GetExpressProducts(productRepository);
  
  // Get latitude and longitude from the selected address
  // final address = addressBloc.state.selectedAddress;
  // final latitude = address.location.latitude;
  // final longitude = address.location.longitude;
  
  // Create params
  // final params = GetExpressProductsParams(
  //   categoryId: 2,
  //   latitude: 23.02250000,
  //   longitude: 72.57140000,
  // );
  
  // Call the use case
  // final result = await getExpressProducts(params);
  
  // Handle the result
  // result.fold(
  //   (failure) {
  //     // Handle error
  //     print('Error: ${failure.message}');
  //   },
  //   (response) {
  //     // Success - use the data
  //     print('Fulfillment Center: ${response.fulfillmentCenter.name}');
  //     print('Products count: ${response.products.length}');
  //     print('Total products: ${response.total}');
  //     
  //     // Display products
  //     for (final product in response.products) {
  //       print('Product: ${product.name}');
  //     }
  //   },
  // );
}

// Example 2: Usage with pagination
void exampleWithPagination() async {
  // Load first page
  // final params = GetExpressProductsParams(
  //   categoryId: 2,
  //   latitude: 23.02250000,
  //   longitude: 72.57140000,
  //   page: 1,
  //   limit: 30,
  // );
  
  // final result = await getExpressProducts(params);
  
  // result.fold(
  //   (failure) => print('Error: ${failure.message}'),
  //   (response) {
  //     // Check if there are more pages
  //     if (response.hasMorePages) {
  //       print('More pages available');
  //       // Load next page
  //       final nextPageParams = GetExpressProductsParams(
  //         categoryId: 2,
  //         latitude: 23.02250000,
  //         longitude: 72.57140000,
  //         page: response.currentPage + 1,
  //         limit: 30,
  //       );
  //       // Call again with nextPageParams
  //     }
  //   },
  // );
}

// Example 3: Usage in a Bloc/Cubit
class ProductBloc {
  // final GetExpressProducts getExpressProducts;
  
  // ProductBloc({required this.getExpressProducts});
  
  void loadExpressProducts({
    required int categoryId,
    required double latitude,
    required double longitude,
  }) async {
    // emit(ProductLoading());
    
    // final params = GetExpressProductsParams(
    //   categoryId: categoryId,
    //   latitude: latitude,
    //   longitude: longitude,
    // );
    
    // final result = await getExpressProducts(params);
    
    // result.fold(
    //   (failure) => emit(ProductError(failure.message)),
    //   (response) => emit(ProductLoaded(
    //     fulfillmentCenter: response.fulfillmentCenter,
    //     products: response.products,
    //     hasMorePages: response.hasMorePages,
    //   )),
    // );
  }
}

// Example 4: Using with Address entity
void exampleWithAddressEntity() async {
  // Assuming you have an Address entity with location
  // final Address selectedAddress = ...;
  
  // final params = GetExpressProductsParams.fromLocation(
  //   categoryId: 2,
  //   latitude: selectedAddress.location.latitude,
  //   longitude: selectedAddress.location.longitude,
  // );
  
  // final result = await getExpressProducts(params);
  // Handle result...
}

// Example 5: Integration with address selection
void exampleAddressIntegration() async {
  // Listen to address changes and fetch products
  // addressBloc.stream.listen((addressState) {
  //   if (addressState is AddressSelected) {
  //     final address = addressState.address;
  //     
  //     // Fetch express products for the selected address
  //     final params = GetExpressProductsParams(
  //       categoryId: selectedCategoryId,
  //       latitude: address.location.latitude,
  //       longitude: address.location.longitude,
  //     );
  //     
  //     productBloc.add(LoadExpressProducts(params));
  //   }
  // });
}

// Example 6: Error handling
void exampleErrorHandling() async {
  // final result = await getExpressProducts(params);
  
  // result.fold(
  //   (failure) {
  //     if (failure is NetworkFailure) {
  //       // Handle network error
  //       showSnackbar('No internet connection');
  //     } else if (failure is ServerFailure) {
  //       // Handle server error
  //       showSnackbar('Server error: ${failure.message}');
  //     } else {
  //       // Handle other errors
  //       showSnackbar('An error occurred');
  //     }
  //   },
  //   (response) {
  //     // Check if products are empty
  //     if (response.isEmpty) {
  //       showEmptyState('No products available in your area');
  //     } else {
  //       displayProducts(response.products);
  //     }
  //   },
  // );
}

// Key Points:
//
// 1. The latitude and longitude should come from the user's selected address
// 2. The API returns the nearest fulfillment center based on the coordinates
// 3. Products are filtered by category_id
// 4. Default pagination is 30 items per page
// 5. The response includes fulfillment center information
// 6. Empty product list is valid (no products available in that area)
// 7. Always handle network and server failures
// 8. Use the hasMorePages property to implement pagination
