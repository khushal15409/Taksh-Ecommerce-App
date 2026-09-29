import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/paginated_products.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/product.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/product_variant.dart';
import 'package:taksh_e_commerce/features/product/domain/usecases/get_categories.dart';
import 'package:taksh_e_commerce/features/product/domain/usecases/get_ecommerce_product_details.dart';
import 'package:taksh_e_commerce/features/product/domain/usecases/get_express_products.dart';
import 'package:taksh_e_commerce/features/product/domain/usecases/get_product_details.dart';
import 'package:taksh_e_commerce/features/product/domain/usecases/get_products.dart';
import 'package:taksh_e_commerce/features/product/presentation/cubit/product_state.dart';

/// Cubit for managing product and category state
class ProductCubit extends Cubit<ProductState> {
  final GetCategories getCategories;
  final GetProducts getProducts;
  final GetProductDetails getProductDetails;
  final GetEcommerceProductDetails getEcommerceProductDetails;
  final GetExpressProducts getExpressProducts;

  ProductCubit({
    required this.getCategories,
    required this.getProducts,
    required this.getProductDetails,
    required this.getEcommerceProductDetails,
    required this.getExpressProducts,
  }) : super(const ProductInitial());

  /// Fetch all categories
  Future<void> fetchCategories({
    String deliveryType = 'standard_delivery',
  }) async {
    if (isClosed) return;
    emit(const CategoryLoading());

    final result = await getCategories(
      GetCategoriesParams(deliveryType: deliveryType),
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (categories) => emit(CategoryLoaded(categories)),
    );
  }

  /// Fetch products with optional filters
  Future<void> fetchProducts({
    int? categoryId,
    String? search,
    int page = 1,
    int limit = 10,
  }) async {
    print(
      '📦 ProductCubit: Fetching products for category: $categoryId, page: $page, limit: $limit, search: $search',
    );
    if (isClosed) return;
    emit(const ProductListLoading());

    final result = await getProducts(
      GetProductsParams(
        categoryId: categoryId,
        search: search,
        page: page,
        limit: limit,
      ),
    );

    if (isClosed) return;

    result.fold(
      (failure) {
        print('❌ ProductCubit: Error fetching products: ${failure.message}');
        emit(ProductError(failure.message));
      },
      (paginatedProducts) {
        print(
          '✅ ProductCubit: Products loaded - Count: ${paginatedProducts.products.length}, Total: ${paginatedProducts.total}',
        );
        emit(ProductListLoaded(paginatedProducts));
      },
    );
  }

  /// Fetch express products for a category (uses /express-30/products API)
  Future<void> fetchExpressProducts({
    required int categoryId,
    required double latitude,
    required double longitude,
    int page = 1,
  }) async {
    if (isClosed) return;
    emit(const ProductListLoading());

    final result = await getExpressProducts(
      GetExpressProductsParams(
        categoryId: categoryId,
        latitude: latitude,
        longitude: longitude,
        page: page,
      ),
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (response) {
        final paginatedProducts = PaginatedProducts(
          currentPage: response.currentPage,
          products: response.products,
          firstPageUrl: '',
          from: response.from,
          lastPage: response.lastPage,
          lastPageUrl: '',
          path: '',
          perPage: response.perPage,
          total: response.total,
          to: response.to,
          nextPageUrl:
              response.currentPage < response.lastPage ? 'next' : null,
        );
        emit(ProductListLoaded(paginatedProducts));
      },
    );
  }

  /// Fetch product details by ID
  Future<void> fetchProductDetails(int productId) async {
    if (isClosed) return;
    emit(const ProductDetailsLoading());

    final result = await getProductDetails(
      GetProductDetailsParams(productId: productId),
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (product) => emit(ProductDetailsLoaded(product)),
    );
  }

  /// Fetch ecommerce product details by ID.
  ///
  /// [initialInStock] and [initialOutOfStockMessage] are optional values
  /// sourced from the product listing (e.g. home page cards). When the product
  /// details API does not explicitly return `in_stock` (i.e. it defaults to
  /// `true`), but the listing said the product is out of stock, the passed
  /// values are used as a reliable fallback so the details page always shows
  /// the correct stock state.
  Future<void> fetchEcommerceProductDetails(
    int productId, {
    bool? initialInStock,
    String? initialOutOfStockMessage,
  }) async {
    if (isClosed) return;
    emit(const ProductDetailsLoading());

    final result = await getEcommerceProductDetails(
      GetEcommerceProductDetailsParams(productId: productId),
    );

    if (isClosed) return;

    Product? fetchedProduct;
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (product) => fetchedProduct = product,
    );

    if (fetchedProduct == null || isClosed) {
      return;
    }

    var resolvedProduct = _applyListingStockFallback(
      fetchedProduct!,
      initialInStock: initialInStock,
      initialOutOfStockMessage: initialOutOfStockMessage,
    );

    if (_needsVariantStockResolution(resolvedProduct)) {
      final fallbackResult = await getProductDetails(
        GetProductDetailsParams(productId: productId),
      );

      if (isClosed) return;

      resolvedProduct = fallbackResult.fold(
        (_) => resolvedProduct,
        (fallbackProduct) => _mergeVariantStockInfo(
          primary: resolvedProduct,
          fallback: fallbackProduct,
          initialInStock: initialInStock,
          initialOutOfStockMessage: initialOutOfStockMessage,
        ),
      );
    }

    if (_needsVariantStockResolution(resolvedProduct)) {
      final catalogResult = await getProducts(
        GetProductsParams(search: resolvedProduct.name, limit: 20),
      );

      if (isClosed) return;

      resolvedProduct = catalogResult.fold(
        (_) => resolvedProduct,
        (paginatedProducts) {
          Product? catalogProduct;
          for (final product in paginatedProducts.products) {
            if (product.id == productId) {
              catalogProduct = product;
              break;
            }
          }

          if (catalogProduct == null) {
            return resolvedProduct;
          }

          return _mergeVariantStockInfo(
            primary: resolvedProduct,
            fallback: catalogProduct,
            initialInStock: initialInStock,
            initialOutOfStockMessage: initialOutOfStockMessage,
          );
        },
      );
    }

    emit(ProductDetailsLoaded(resolvedProduct));
  }

  Product _applyListingStockFallback(
    Product product, {
    bool? initialInStock,
    String? initialOutOfStockMessage,
  }) {
    if (initialInStock == false && product.inStock == true) {
      return product.copyWithStockStatus(
        inStock: false,
        outOfStockMessage:
            product.outOfStockMessage ?? initialOutOfStockMessage,
      );
    }

    return product;
  }

  bool _needsVariantStockResolution(Product product) {
    final variants = product.variants;
    if (variants == null || variants.isEmpty) return false;

    final activeVariants = variants.where((variant) => variant.isActive).toList();
    if (activeVariants.isEmpty) return false;

    return activeVariants.any((variant) => !variant.hasStockInfo);
  }

  Product _mergeVariantStockInfo({
    required Product primary,
    required Product fallback,
    bool? initialInStock,
    String? initialOutOfStockMessage,
  }) {
    final primaryVariants = primary.variants;
    final fallbackVariants = fallback.variants;

    List<ProductVariant>? mergedVariants;
    if ((primaryVariants == null || primaryVariants.isEmpty) &&
        fallbackVariants != null &&
        fallbackVariants.isNotEmpty) {
      mergedVariants = fallbackVariants;
    } else if (primaryVariants != null && primaryVariants.isNotEmpty) {
      final fallbackById = <int, ProductVariant>{
        for (final variant in fallbackVariants ?? const <ProductVariant>[])
          variant.id: variant,
      };
      final fallbackBySku = <String, ProductVariant>{
        for (final variant in fallbackVariants ?? const <ProductVariant>[])
          if (variant.sku.trim().isNotEmpty) variant.sku.trim(): variant,
      };

      mergedVariants = primaryVariants.map((variant) {
        if (variant.hasStockInfo) {
          return variant;
        }

        final fallbackVariant =
            fallbackById[variant.id] ?? fallbackBySku[variant.sku.trim()];
        if (fallbackVariant == null) {
          return variant;
        }

        return ProductVariant(
          id: variant.id,
          productId: variant.productId,
          sku: variant.sku,
          price: variant.price,
          salePrice: variant.salePrice,
          weight: variant.weight ?? fallbackVariant.weight,
          length: variant.length ?? fallbackVariant.length,
          width: variant.width ?? fallbackVariant.width,
          height: variant.height ?? fallbackVariant.height,
          status: variant.status.isNotEmpty ? variant.status : fallbackVariant.status,
          createdAt: variant.createdAt ?? fallbackVariant.createdAt,
          updatedAt: variant.updatedAt ?? fallbackVariant.updatedAt,
          variantAttributes:
              variant.variantAttributes != null &&
                  variant.variantAttributes!.isNotEmpty
              ? variant.variantAttributes
              : fallbackVariant.variantAttributes,
          images: variant.images != null && variant.images!.isNotEmpty
              ? variant.images
              : fallbackVariant.images,
          inStock: fallbackVariant.hasStockInfo
              ? fallbackVariant.inStock
              : variant.inStock,
          outOfStockMessage:
              fallbackVariant.outOfStockMessage ?? variant.outOfStockMessage,
          hasStockInfo: fallbackVariant.hasStockInfo || variant.hasStockInfo,
        );
      }).toList();
    }

    final resolvedVariants = mergedVariants ?? primaryVariants ?? fallbackVariants;
    final activeVariants =
        resolvedVariants?.where((variant) => variant.isActive).toList() ??
        const <ProductVariant>[];
    final hasResolvedStockForAllActive =
        activeVariants.isNotEmpty &&
        activeVariants.every((variant) => variant.hasStockInfo);
    final resolvedInStock = hasResolvedStockForAllActive
        ? activeVariants.any((variant) => variant.isAvailableForSale)
        : primary.inStock;
    final resolvedOutOfStockMessage = hasResolvedStockForAllActive &&
            !resolvedInStock
        ? activeVariants
                .map((variant) => variant.outOfStockMessage)
                .firstWhere(
                  (message) => message != null && message.trim().isNotEmpty,
                  orElse: () => primary.outOfStockMessage,
                ) ??
            primary.outOfStockMessage ??
            fallback.outOfStockMessage ??
            initialOutOfStockMessage
        : primary.outOfStockMessage ?? fallback.outOfStockMessage;

    return _applyListingStockFallback(
      Product(
        id: primary.id,
        categoryId: primary.categoryId,
        brandId: primary.brandId,
        fulfillmentCenterId: primary.fulfillmentCenterId,
        name: primary.name,
        slug: primary.slug,
        description: primary.description ?? fallback.description,
        shortDescription: primary.shortDescription ?? fallback.shortDescription,
        status: primary.status,
        isTrending: primary.isTrending,
        isLatest: primary.isLatest,
        isExpress30: primary.isExpress30,
        createdAt: primary.createdAt,
        updatedAt: primary.updatedAt,
        brand: primary.brand ?? fallback.brand,
        category: primary.category ?? fallback.category,
        variants: resolvedVariants,
        images: primary.images != null && primary.images!.isNotEmpty
            ? primary.images
            : fallback.images,
        ratingSummary: primary.ratingSummary ?? fallback.ratingSummary,
        reviews: primary.reviews ?? fallback.reviews,
        questionsAnswers: primary.questionsAnswers ?? fallback.questionsAnswers,
        originalPrice: primary.originalPrice ?? fallback.originalPrice,
        salePrice: primary.salePrice ?? fallback.salePrice,
        discountLabel: primary.discountLabel ?? fallback.discountLabel,
        saleId: primary.saleId ?? fallback.saleId,
        inStock: resolvedInStock,
        outOfStockMessage: resolvedOutOfStockMessage,
      ),
      initialInStock: initialInStock,
      initialOutOfStockMessage: initialOutOfStockMessage,
    );
  }
}
