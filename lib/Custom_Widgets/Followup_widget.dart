// ignore: file_names
import 'package:flutter/material.dart';
import '../constants/light_constants.dart';

class FollowUpWidget extends StatelessWidget {
  final Map<String, dynamic> followUpData;

  const FollowUpWidget({super.key, required this.followUpData});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          width: 10,
        ),
        const Icon(
          Icons.info,
          size: 40.0,
          color: periwinkleColor,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Center(
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  const TextSpan(
                    text: 'Mo follow-up kang ',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: periwinkleColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  TextSpan(
                    text: '${followUpData['physician'] ?? 'N/A'} ',
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: periwinkleColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(
                    text: 'sa',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: periwinkleColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  TextSpan(
                    text: ' ${followUpData['facility'] ?? 'N/A '} ',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                      color: periwinkleColor,
                    ),
                  ),
                  const TextSpan(
                    text: 'sa ',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: periwinkleColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const TextSpan(
                    text: 'umaabot nga ',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: periwinkleColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  TextSpan(
                    text: 'ika-${followUpData['day'] ?? 'N/A'} sa ${followUpData['month'] ?? 'N/A'} ${followUpData['year'] ?? 'N/A'}, ${followUpData['time'] ?? 'N/A'}',
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: periwinkleColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
