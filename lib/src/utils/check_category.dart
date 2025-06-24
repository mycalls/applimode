// features
import 'package:applimode_app/src/features/admin_settings/domain/app_main_category.dart';

MainCategory checkCategory(List<MainCategory> categoryList, int category) {
  return category > categoryList.length - 1
      ? categoryList[0]
      : categoryList[category];
}
