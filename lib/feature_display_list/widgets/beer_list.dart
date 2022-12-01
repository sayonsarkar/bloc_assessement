import 'package:bloc_assessment/feature_display_list/models/model.dart';
import 'package:flutter/material.dart';

class BeerListItem extends StatelessWidget {
  final BeerModel beer;

  const BeerListItem(this.beer, {super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(beer.name),
      subtitle: Text(beer.tagline),
      childrenPadding: const EdgeInsets.all(16),
      leading: Container(
        margin: const EdgeInsets.only(top: 8),
        child: Text(beer.id.toString()),
      ),
      children: [
        Text(
          beer.description,
          textAlign: TextAlign.justify,
        ),
        const SizedBox(height: 20),
        beer.imageUrl.isEmpty
            ? Container()
            : Image.network(
                beer.imageUrl,
                loadingBuilder: (context, widget, imageChunkEvent) {
                  return imageChunkEvent == null
                      ? widget
                      : const CircularProgressIndicator();
                },
                height: 300,
              ),
      ],
    );
  }
}
