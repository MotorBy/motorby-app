class GetInsuranceProduct {
  int? statusCode;
  String? message;
  Payload? payload;

  GetInsuranceProduct({
    this.statusCode,
    this.message,
    this.payload,
  });

  factory GetInsuranceProduct.fromJson(Map<String, dynamic> json) => GetInsuranceProduct(
    statusCode: json["statusCode"],
    message: json["message"],
    payload: json["payload"] == null ? null : Payload.fromJson(json["payload"]),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "message": message,
    "payload": payload?.toJson(),
  };
}

class Payload {
  String? id;
  String? name;
  String? keyBenefits;
  String? fullBenefits;
  String? inspectableStatus;
  String? description;
  dynamic meta;
  dynamic isAvailableToDistributors;
  bool? isAvailableForBatchPurchase;
  List<dynamic>? priceData;
  int? variant;
  String? prefix;
  String? routeName;
  bool? renewable;
  bool? claimable;
  bool? inspectable;
  bool? certificateable;
  String? price;
  String? totalGrossPremium;
  String? providerPrice;
  String? markedupPrice;
  String? mcaCommission;
  String? distributorCommission;
  String? productDiscount;
  String? distributorDiscount;
  bool? isDynamicPricing;
  bool? isSpecial;
  bool? isComputedPricing;
  bool? isPriceRange;
  bool? active;
  String? coverPeriod;
  int? stabilityPercentageTestMode;
  int? stabilityPercentageLiveMode;
  String? howItWorks;
  String? howToClaim;
  String? businessHowItWorks;
  dynamic businessHowToClaim;
  dynamic document;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  String? productCategoryId;
  String? providerId;
  Provider? provider;
  ProductCategory? productCategory;

  Payload({
    this.id,
    this.name,
    this.keyBenefits,
    this.fullBenefits,
    this.inspectableStatus,
    this.description,
    this.meta,
    this.isAvailableToDistributors,
    this.isAvailableForBatchPurchase,
    this.priceData,
    this.variant,
    this.prefix,
    this.routeName,
    this.renewable,
    this.claimable,
    this.inspectable,
    this.certificateable,
    this.price,
    this.totalGrossPremium,
    this.providerPrice,
    this.markedupPrice,
    this.mcaCommission,
    this.distributorCommission,
    this.productDiscount,
    this.distributorDiscount,
    this.isDynamicPricing,
    this.isSpecial,
    this.isComputedPricing,
    this.isPriceRange,
    this.active,
    this.coverPeriod,
    this.stabilityPercentageTestMode,
    this.stabilityPercentageLiveMode,
    this.howItWorks,
    this.howToClaim,
    this.businessHowItWorks,
    this.businessHowToClaim,
    this.document,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.productCategoryId,
    this.providerId,
    this.provider,
    this.productCategory,
  });

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
    id: json["id"],
    name: json["name"],
    keyBenefits: json["key_benefits"],
    fullBenefits: json["full_benefits"],
    inspectableStatus: json["inspectable_status"],
    description: json["description"],
    meta: json["meta"],
    isAvailableToDistributors: json["is_available_to_distributors"],
    isAvailableForBatchPurchase: json["is_available_for_batch_purchase"],
    priceData: json["price_data"] == null ? [] : List<dynamic>.from(json["price_data"]!.map((x) => x)),
    variant: json["variant"],
    prefix: json["prefix"],
    routeName: json["route_name"],
    renewable: json["renewable"],
    claimable: json["claimable"],
    inspectable: json["inspectable"],
    certificateable: json["certificateable"],
    price: json["price"],
    totalGrossPremium: json["total_gross_premium"],
    providerPrice: json["provider_price"],
    markedupPrice: json["markedup_price"],
    mcaCommission: json["mca_commission"],
    distributorCommission: json["distributor_commission"],
    productDiscount: json["product_discount"],
    distributorDiscount: json["distributor_discount"],
    isDynamicPricing: json["is_dynamic_pricing"],
    isSpecial: json["is_special"],
    isComputedPricing: json["is_computed_pricing"],
    isPriceRange: json["is_price_range"],
    active: json["active"],
    coverPeriod: json["cover_period"],
    //stabilityPercentageTestMode: json["stability_percentage_test_mode"],
    //stabilityPercentageLiveMode: json["stability_percentage_live_mode"],
    howItWorks: json["how_it_works"],
    howToClaim: json["how_to_claim"],
    businessHowItWorks: json["business_how_it_works"],
    businessHowToClaim: json["business_how_to_claim"],
    document: json["document"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    productCategoryId: json["product_category_id"],
    providerId: json["provider_id"],
    provider: json["provider"] == null ? null : Provider.fromJson(json["provider"]),
    productCategory: json["productCategory"] == null ? null : ProductCategory.fromJson(json["productCategory"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "key_benefits": keyBenefits,
    "full_benefits": fullBenefits,
    "inspectable_status": inspectableStatus,
    "description": description,
    "meta": meta,
    "is_available_to_distributors": isAvailableToDistributors,
    "is_available_for_batch_purchase": isAvailableForBatchPurchase,
    "price_data": priceData == null ? [] : List<dynamic>.from(priceData!.map((x) => x)),
    "variant": variant,
    "prefix": prefix,
    "route_name": routeName,
    "renewable": renewable,
    "claimable": claimable,
    "inspectable": inspectable,
    "certificateable": certificateable,
    "price": price,
    "total_gross_premium": totalGrossPremium,
    "provider_price": providerPrice,
    "markedup_price": markedupPrice,
    "mca_commission": mcaCommission,
    "distributor_commission": distributorCommission,
    "product_discount": productDiscount,
    "distributor_discount": distributorDiscount,
    "is_dynamic_pricing": isDynamicPricing,
    "is_special": isSpecial,
    "is_computed_pricing": isComputedPricing,
    "is_price_range": isPriceRange,
    "active": active,
    "cover_period": coverPeriod,
    "stability_percentage_test_mode": stabilityPercentageTestMode,
    "stability_percentage_live_mode": stabilityPercentageLiveMode,
    "how_it_works": howItWorks,
    "how_to_claim": howToClaim,
    "business_how_it_works": businessHowItWorks,
    "business_how_to_claim": businessHowToClaim,
    "document": document,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "product_category_id": productCategoryId,
    "provider_id": providerId,
    "provider": provider?.toJson(),
    "productCategory": productCategory?.toJson(),
  };
}

class ProductCategory {
  String? name;
  String? id;

  ProductCategory({
    this.name,
    this.id,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) => ProductCategory(
    name: json["name"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
  };
}

class Provider {
  String? companyName;
  String? id;

  Provider({
    this.companyName,
    this.id,
  });

  factory Provider.fromJson(Map<String, dynamic> json) => Provider(
    companyName: json["company_name"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "company_name": companyName,
    "id": id,
  };
}