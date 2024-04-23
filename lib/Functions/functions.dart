import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:share_plus/share_plus.dart';

FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;


final String DynamicLink = 'https://fulladriver.page.link/requestdata';
final String Link = 'https://fulladriver.page.link/requestdata';
bool _isCreatingLink = false;

Future<void> _createDynamicLink(bool short,requestID) async {

  print('linnk');
  print(
      "https://www.fullapp.com/request?id=${requestID}");

  DynamicLinkParameters parameters = DynamicLinkParameters(
    uriPrefix: 'https://fulladriver.page.link',

    link: Uri.parse(
        "https://www.fullapp.com/request?id=${requestID}"),
    socialMetaTagParameters: SocialMetaTagParameters(
      title: "Share",
      // imageUrl: Uri.parse(
    ),
    androidParameters: const AndroidParameters(
      packageName: 'com.petra.fulla_user',
      minimumVersion: 0,
    ),
    iosParameters: const IOSParameters(
      bundleId: 'com.petra.fulla_user',
      minimumVersion: '0',
    ),
  );

  Uri url;
  if (short) {
    final ShortDynamicLink shortLink =
    await dynamicLinks.buildShortLink(parameters);
    url = shortLink.shortUrl;
    final result = await Share.shareWithResult(url.toString());

    if (result.status == ShareResultStatus.success) {

    }else{
      print('errroee1');

    }

  } else {
    url = await dynamicLinks.buildLink(parameters);
    final result = await Share.shareWithResult(url.toString());

    if (result.status == ShareResultStatus.success) {

    }else{
      print('errroee1');

    }
  }


}
