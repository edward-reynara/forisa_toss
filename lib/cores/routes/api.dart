abstract class ApiRoutes {
  static const CHECK_VERSION = '/checkosversion';
  static const GET_LOOKUP = '/lookup/getlist';
  static const HOME_MENU = '/loginmenu';

  //Account
  static const AUTH_LOGIN = '/login';
  static const AUTH_USER_INFO = '/checkusertoken';
  static const AUTH_CHANGE_PASSWORD = '/changepwd';
  static const AUTH_BADGE_NOTIF = '/notifbadge';
  static const AUTH_CURRENT_PROGRESS = '/notifprogress';
  static const CHECK_NOTIFICATION_SUBSCRIBE = '/devicecheck';
  static const UPDATE_NOTIFICATION_SUBSCRIBE = '/deviceregister';

  //Place Autocomplete
  static const MAPS_PLACE_URL = "/lookup/google_placeautocomp";
  static const MAPS_PLACE_DETAILS_URL = "/lookup/google_placedetail";

  //Reseller
  static const RESELLER_LIST = '/reseller/getlist';
  static const RESELLER_CREATE = '/reseller/createnew';
  static const RESELLER_UPDATE = '/reseller/update';
  static const RESELLER_DATA = '/reseller/getinfo';

  //Product
  static const PRODUCT_SEARCH = '/sales/prdsearch';

  //Cart
  static const CART_DETAIL = '/sales/cartdetail';
  static const CART_REMOVE_ALL = '/sales/cartdeleteall';
  static const CART_UPDATE_RESELLER = '/sales/cartdetailupdres';
  static const CART_ADD_PRODUCT = '/sales/cartadd';
  static const CART_UPDATE_ITEM = '/sales/cartupdate';
  static const CART_REMOVE_ITEM = '/sales/cartdelete';
  static const CART_SUBMIT = '/sales/cartdetailsubmit';

  //Sales
  static const SALES_HISTORY = '/sales/slsinvhist';
  static const SALES_PENDING_APPROVAL = '/sales/slsinvpen';
  static const SALES_SUBMIT_APPROVAL = '/sales/slsinvpendetsave';
  static const SALES_CANCEL_APPROVAL = '/sales/slsinvanceldetsave';
  static const SALES_INVOICE_DETAIL = '/sales/slsinvdetail';
  static const SALES_INVOICE_DETAIL_LOG = '/sales/slsinvdetaillog';
  static const SALES_AREA_LOGIN = '/loginslsarea';

  //Sales Order
  static const SALES_ORDER_HISTORY = '/sales/sohist';
  static const SALES_ORDER_DETAIL = '/sales/sodetail';
  static const SALES_ORDER_DETAIL_LOG = '/sales/sodetaillog';
  static const SALES_ORDER_CANCEL_APPROVAL = '/sales/socanceldetsave';
  static const SALES_ORDER_APPROVAL = '/sales/sopendetsave';
  static const SALES_ORDER_PENDING = '/sales/sopen';

}