import 'package:luca_play/core/service/chromecast_service.dart';
import 'package:luca_play/widgets/custom_loading.dart';
import 'package:luca_play/widgets/custom_typography.dart';
import 'package:luca_play/widgets/player.dart';
import 'package:cast/cast.dart';
import 'package:flutter/material.dart';

class CastDevicesModal extends StatefulWidget {
  CastDevicesModal({
    Key? key,
  }) : super(key: key);

  @override
  createState() => CastDevicesModalState();
}

class CastDevicesModalState extends State<CastDevicesModal> {
  CastDevicesModalState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: StreamBuilder<List<CastDevice>>(
        stream: CastDiscoveryService().stream,
        initialData: CastDiscoveryService().devices,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CustomLoading();
          }

          bool hasConnected = false;

          return Column(
            children: [
              CustomTypography(
                text: "DISPOSITIVOS",
                fontFamily: FontFamily.barlow_condensed,
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
                color: Colors.black,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ...snapshot.data!.map(
                (device) {
                  final bool isConnected =
                      ChromecastService.connectedDevice?.serviceName ==
                              device.serviceName &&
                          ChromecastService.session?.state ==
                              CastSessionState.connected;

                  if (isConnected) {
                    hasConnected = true;
                  }

                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: isConnected ? Colors.yellow : Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: ListTile(
                          title: Text(device.name),
                          onTap: () async {
                            await ChromecastService().connect(device);

                            Navigator.pop(context);
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  );
                },
              ).toList(),
              ...hasConnected ? [Player()] : [],
            ],
          );
        },
      ),
    );
  }
}
