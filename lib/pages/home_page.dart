import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_state_mgmt/controllers/assets_controller.dart';
import 'package:getx_state_mgmt/pages/details_page.dart';
import 'package:getx_state_mgmt/utils.dart';
import 'package:getx_state_mgmt/widgets/add_asset_dialog.dart';

class HomePage extends StatelessWidget {
  AssetsController assetsController = Get.find<AssetsController>();
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar(context),
      body: _buildUI(context: context),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      title: const CircleAvatar(
        backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=12"),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Get.dialog(AddAssetDialog());
          },
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  _buildUI({required BuildContext context}) {
    return SafeArea(
      child: Obx(
        () => Column(
          children: [
            _portfolioValue(context: context),
            _trackedAssetsList(context: context),
          ],
        ),
      ),
    );
  }

  Widget _portfolioValue({required BuildContext context}) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height * 0.03,
      ),
      child: Center(
        child: Text.rich(
          textAlign: TextAlign.center,
          TextSpan(
            children: [
              const TextSpan(
                text: "\$",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text:
                    '${assetsController.getPortfolioValue().toStringAsFixed(2)}\n',
                style: const TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const TextSpan(
                text: "Portfolio value",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _trackedAssetsList({required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.only(
        left: MediaQuery.sizeOf(context).width * 0.03,
        right: MediaQuery.sizeOf(context).width * 0.03,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.05,
            child: Text(
              "Portfolio",
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.65,
            width: MediaQuery.sizeOf(context).width,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Get.to(() {
                      return DetailsPage(
                        coin: assetsController.getCoinData(
                          name: assetsController.trackedAssets[index].name!,
                        )!,
                      );
                    });
                  },
                  leading: Image.network(
                    getCryptoImageURl(
                        name: assetsController.trackedAssets[index].name!),
                  ),
                  title: Text(assetsController.trackedAssets[index].name!),
                  subtitle: Text(
                    'USD: ${assetsController.getAssetPrice(name: assetsController.trackedAssets[index].name!).toStringAsFixed(2)}',
                  ),
                  trailing: Text(
                    '${assetsController.trackedAssets[index].amount!}',
                  ),
                );
              },
              itemCount: assetsController.trackedAssets.length,
            ),
          ),
        ],
      ),
    );
  }
}
