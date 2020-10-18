class Constants {
  //Order String Constants
  static const rupeeSymbol = '\u20B9';
  static const revenue = 'REVENUE';
  static const orders = 'ORDERS';
  static const today = 'TODAY';
  static const deliveryDateChanged = 'Delivery date changed to';
  static const expectedDelivery = 'Expected delivery';
  static const deliverdOn = 'Delivered on';

  //STORE SCREEN CONSTANTS
  static const ADD_PRODUCT_BTN = 'ADD PRODUCT';
  static const ADD_CATEGORY_BTN = 'ADD CATEGORY';
  static const STORE_TABS = ['Products', 'Categories'];

  //SELLER BASE URL
  static const SELLER_BASE_URL = '/api/seller/';

  //ORDER
  static const String AGGREGATED_ORDERS_INFORMATION =
      '$SELLER_BASE_URL/orders/aggregate';

  static const String ORDER_BYDATE_APARTMENT = '$SELLER_BASE_URL/orders';

  static const String DELIVERY_DELAYED =
      '$SELLER_BASE_URL/orders/delivery/delayed';

  static const String ORDER_DELIVERY_STATUS_SET =
      '$SELLER_BASE_URL/orders/delivery/status';

  static const String CANCEL_ORDER = '$SELLER_BASE_URL/orders/cancel';

  //DELIVERY
  static const String DELIVERY_BY_DATE = '$SELLER_BASE_URL/orders/delivery';

  //APARTMENT
  static const String GET_APARTMENT = '$SELLER_BASE_URL/apartments';

  //CATEGORY
  static const String GET_ALL_CATEGORY = '$SELLER_BASE_URL/categories';
  static const String DELETE_CATEGORY = '$SELLER_BASE_URL/categories';
  static const String ADD_CATEGORIES = '$SELLER_BASE_URL/categories';

  //PRODUCTS
  static const String GET_ALL_PRODUCTS = '$SELLER_BASE_URL/products';
  static const String ADD_PRODUCT = '$SELLER_BASE_URL/products';

  //PROFIle
  static const String GET_STORE_DETAILS = '$SELLER_BASE_URL/profile/contact';
  static const UPDATE_STORE_DETAILS = '$SELLER_BASE_URL/profile/contact';

  static const String GET_BUSINESS_DETAILS =
      '$SELLER_BASE_URL/profile/business';
  static const String UPDATE_BUSINESS_INFROMATION =
      '$SELLER_BASE_URL/profile/business';

  //AUTH
  static const String SIGNIN_WITH_PIN = '$SELLER_BASE_URL/auth/signin/pin';
  static const String GET_OTP = '$SELLER_BASE_URL/auth/otp';
  static const String VERIFY_OTP = '$SELLER_BASE_URL/auth/otp/verify';
  static const String UPDATE_PIN = '$SELLER_BASE_URL/auth/pin';
  static const String SIGNUP = '$SELLER_BASE_URL/auth/signup';

  //ImageService Url
  static const String IMAGE_PRESIGNED_URL = '/api/services/imageurls/png';
}
