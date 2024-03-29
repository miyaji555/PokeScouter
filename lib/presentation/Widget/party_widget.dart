import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:poke_scouter/constants/text_style.dart';
import 'package:poke_scouter/domain/firebase/party.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PartyWidget extends HookConsumerWidget {
  const PartyWidget(this.party, this.selected, {super.key});

  final Party party;
  final bool selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (party.partyNameList.isEmpty) {
      return const SizedBox();
    }

    return Card(
      shape: selected
          ? const RoundedRectangleBorder(
              side: BorderSide(color: Color(0xFF808000), width: 2.0),
              borderRadius: BorderRadius.all(
                Radius.circular(12.0),
              ),
            )
          : null,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(party.name),
                Text(
                  party.createdAt.dateTime.toString(),
                  style: textStyleGreySmall,
                )
              ],
            ),
            Wrap(
              children: party.partyNameList
                  .map((name) => Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                        child: Text(
                          name,
                          style: textStylePlain,
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
