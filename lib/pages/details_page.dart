import 'package:flutter/material.dart';
import 'package:getx_state_mgmt/models/coin_data.dart';
import 'package:getx_state_mgmt/utils.dart';

class DetailsPage extends StatelessWidget {
  final CoinData coin;
  const DetailsPage({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _buildUI(context: context),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      title: Text(this.coin.name!),
      centerTitle: true,
    );
  }

  Widget _buildUI({required BuildContext context}) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width * 0.02,
        ),
        child: Column(
          children: [
            _assetPrice(context: context),
            _assetInfo(context: context),
          ],
        ),
      ),
    );
  }

  Widget _assetPrice({required BuildContext context}) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.1,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Image.network(
              getCryptoImageURl(name: coin.name!),
            ),
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text:
                      "\$${coin.values?.uSD?.price?.toStringAsFixed(2) ?? 0}\n",
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                TextSpan(
                  text:
                      "${coin.values?.uSD?.percentChange24h?.toStringAsFixed(2) ?? 0}%",
                  style: TextStyle(
                    fontSize: 15,
                    color: coin.values!.uSD!.percentChange24h! < 0
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _assetInfo({required BuildContext context}) {
    return Expanded(
      child: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.9,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        children: [
          _infoCard(
            title: "Circulating supply",
            subtitle: coin.circulatingSupply.toString(),
          ),
          _infoCard(
            title: "Maximum supply",
            subtitle: coin.maxSupply.toString(),
          ),
          _infoCard(
            title: "Total supply",
            subtitle: coin.totalSupply.toString(),
          )
        ],
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required String subtitle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title),
          Text(subtitle),
        ],
      ),
    );
  }
}
