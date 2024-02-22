part of './pages.dart';

abstract class Routes {
  static const INITIAL = '/';
  static const HOME = '/home';
  static const MAIN_LAYOUT = '/main';
  static const UNKNOWN = '/notfound';
  static const FULLSCREEN_IMAGE = '/fullscreen_image';
  static const SUB_MENU = '/submenu';
  static const MAP_PAGE = '/map';
  static const APPROVAL_LOG = '/approvallog';

  static const ONBOARDING_PAGE = '/onboarding';
  static const LOGIN_PAGE = '/login';
  static const CHANGE_PASSWORD_PAGE = '/changepassword';
  static const NEWUPDATE_PAGE = '/newupdate';

  static const RESELLER_PAGE = '/reseller';
  static const RESELLER_CREATE_PAGE = '/reseller/create';
  static const RESELLER_EDIT_PAGE = '/reseller/edit';
  static const RESELLER_VIEW_PAGE = '/reseller/view';
  static const RESELLER_SEARCH_PAGE = '/reseller/search';


  static const PRODUCT_SEARCH_PAGE = '/product/search';
  static const CART_PAGE = '/shopcart';

  static const SALES_HISTORY = '/trxhistory';
  static const SALES_APPROVAL = '/trxapproval';
  static const SALES_LOGIN_AREA = '/loginslsarea';
  static const SALES_INVOICE_DETAIL = '/sales/invoicedetail';

  static const SALES_ORDER_HISTORY = '/sohistory';
  static const SALES_ORDER_DETAIL = '/sodetail';
  static const SALES_ORDER_APPROVAL = '/soapproval';
}