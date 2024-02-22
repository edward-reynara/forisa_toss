import 'package:get/get.dart';
import '../../ui/pages/HomePage.dart';
import '../../ui/pages/LoginPage.dart';
import '../../ui/pages/NotFoundPage.dart';
import '../../ui/pages/OnBoardingPage.dart';
import '../../ui/pages/SplashScreenPage.dart';
import '../bindings/binding_init.dart';
part './routes.dart';

class CorePages {
  static final GetPage unknownPage =
      GetPage(name: Routes.UNKNOWN, page: () => NotFoundPage());

  static final pages = <GetPage>[
    GetPage(
        name: Routes.INITIAL,
        page: () => SplashScreenPage(),
        binding: SplashBinding()),
    GetPage(
      name: Routes.HOME,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
        name: Routes.ONBOARDING_PAGE,
        page: () => OnboardingPage(),
        binding: OnboardingBinding()),
    GetPage(
      name: Routes.LOGIN_PAGE,
      page: () => LoginPage(),
      binding: AuthBinding(),
    ),
    // GetPage(
    //   name: Routes.NEWUPDATE_PAGE,
    //   page: () => NewUpdatePage(),
    // ),
    // //Reseller
    // GetPage(
    //   name: Routes.RESELLER_PAGE,
    //   page: () => ResellerPage(),
    // ),
    // GetPage(
    //   name: Routes.RESELLER_CREATE_PAGE,
    //   page: () => ResellerCreatePage(),
    // ),
    // GetPage(
    //   name: Routes.RESELLER_EDIT_PAGE,
    //   page: () => ResellerEditPage(),
    // ),
    // GetPage(
    //   name: Routes.RESELLER_VIEW_PAGE,
    //   page: () => ResellerViewPage(),
    // ),
    // GetPage(
    //   name: Routes.RESELLER_SEARCH_PAGE,
    //   page: () => ResellerSearchPage(),
    // ),
    // GetPage(
    //     name: Routes.MAIN_LAYOUT,
    //     page: () => MainLayout(),
    //     binding: HomeBinding()),
    // GetPage(
    //   name: Routes.PRODUCT_SEARCH_PAGE,
    //   page: () => ProductSearchPage(),
    // ),
    // GetPage(
    //   name: Routes.CART_PAGE,
    //   page: () => CartPage(),
    //   binding: CartBinding(),
    // ),
    // GetPage(
    //   name: Routes.SUB_MENU,
    //   page: () => SubmenuPage(),
    // ),
    // GetPage(
    //   name: Routes.SALES_HISTORY,
    //   page: () => SalesHistoryPage(),
    // ),
    // GetPage(
    //   name: Routes.SALES_LOGIN_AREA,
    //   page: () => SalesAreapage(),
    // ),
    // GetPage(
    //   name: Routes.SALES_INVOICE_DETAIL,
    //   page: () => SalesInvoiceDetailPage(),
    // ),
    // GetPage(
    //   name: Routes.SALES_APPROVAL,
    //   page: () => SalesApprovalPage(),
    // ),
    // GetPage(
    //   name: Routes.MAP_PAGE,
    //   page: () => MapsPage(),
    // ),
    // GetPage(
    //   name: Routes.CHANGE_PASSWORD_PAGE,
    //   page: () => ChangePasswordPage(),
    // ),
    // GetPage(
    //   name: Routes.APPROVAL_LOG,
    //   page: () => ApprovalLogPage(),
    // ),
    // GetPage(
    //   name: Routes.SALES_ORDER_HISTORY,
    //   page: () => SalesOrderHistoryPage(),
    // ),
    // GetPage(
    //   name: Routes.SALES_ORDER_DETAIL,
    //   page: () => SalesOrderDetailPage(),
    // ),
    // GetPage(
    //   name: Routes.SALES_ORDER_APPROVAL,
    //   page: () => SalesOrderPendingPage(),
    // ),
  ];
}
